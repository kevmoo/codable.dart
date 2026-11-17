import 'dart:convert';
import 'dart:typed_data';

/// A memory-pooling chunk accumulator for chunked JSON decoding.
///
/// Restores `dart2wasm` `U8List` TFA monomorphism by avoiding
/// `BytesBuilder.takeBytes()`, and eliminates geometric buffer doublings
/// while preserving peak RSS compliance.
final class ScratchByteAccumulator {
  static const int _initialCapacity = 64 * 1024; // 64 KB initial capacity
  static const int _maxPooledCapacity = 4 * 1024 * 1024; // 4 MB pool cap
  static Uint8List? _pooledBuffer;

  late Uint8List _buffer;
  int _length = 0;

  ScratchByteAccumulator() {
    final pooled = _pooledBuffer;
    if (pooled != null) {
      _buffer = pooled;
      _pooledBuffer = null;
    } else {
      _buffer = Uint8List(_initialCapacity);
    }
  }

  void addSlice(List<int> chunk, int start, int end) {
    if (start >= end) return;
    final required = _length + (end - start);
    _ensureCapacity(required);
    _buffer.setRange(_length, required, chunk, start);
    _length = required;
  }

  void add(List<int> chunk) {
    addSlice(chunk, 0, chunk.length);
  }

  void _ensureCapacity(int required) {
    if (required <= _buffer.length) return;
    var newCapacity = _buffer.isEmpty ? _initialCapacity : _buffer.length * 2;
    while (newCapacity < required) {
      newCapacity *= 2;
    }
    final newBuffer = Uint8List(newCapacity);
    newBuffer.setRange(0, _length, _buffer);
    _buffer = newBuffer;
  }

  Uint8List takeBytes() {
    final result = Uint8List.sublistView(_buffer, 0, _length);
    _length = 0;
    return result;
  }

  void release({required bool canPool}) {
    _length = 0;
    if (canPool && _buffer.length <= _maxPooledCapacity) {
      _pooledBuffer = _buffer;
    }
    // Eagerly release our reference to the buffer if it is too large or
    // escaped.
    if (!canPool || _buffer.length > _maxPooledCapacity) {
      _buffer = Uint8List(0);
    }
  }
}

/// Chunked UTF-8 byte sink shared across streaming and JS JSON decoders.
final class ChunkedCodableDecoderSink<T> extends ByteConversionSinkBase {
  final Sink<T> _sink;
  final (T, {bool canPool}) Function(Uint8List bytes) _decodeBytes;
  final ScratchByteAccumulator _accumulator = ScratchByteAccumulator();
  bool _isClosed = false;

  ChunkedCodableDecoderSink(this._sink, this._decodeBytes);

  @override
  void add(List<int> chunk) {
    if (_isClosed) {
      throw StateError('Cannot add to a closed sink');
    }
    _accumulator.add(chunk);
  }

  @override
  void addSlice(List<int> chunk, int start, int end, bool isLast) {
    if (_isClosed) {
      throw StateError('Cannot addSlice to a closed sink');
    }
    RangeError.checkValidRange(start, end, chunk.length);
    if (start < end) {
      _accumulator.addSlice(chunk, start, end);
    }
    if (isLast) {
      close();
    }
  }

  @override
  void close() {
    if (_isClosed) return;
    _isClosed = true;
    final bytes = _accumulator.takeBytes();
    var canPool = false;
    final T decoded;
    try {
      final result = _decodeBytes(bytes);
      decoded = result.$1;
      canPool = result.canPool;
    } finally {
      _accumulator.release(canPool: canPool);
    }
    _sink.add(decoded);
    _sink.close();
  }
}
