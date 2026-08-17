/// Lexical token types for JSON pull parsing.
library;

/// Represents lexical JSON token boundaries returned by pull readers.
enum JsonTokenType {
  none,
  beginObject,
  endObject,
  beginArray,
  endArray,
  propertyName,
  string,
  number,
  boolean,
  nullValue,
  endOfDocument,
}
