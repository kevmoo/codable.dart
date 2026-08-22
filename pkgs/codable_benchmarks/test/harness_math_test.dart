// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:checks/checks.dart';
import 'package:codable_benchmarks/harness.dart';
import 'package:test/test.dart';

void main() {
  group('Harness Math & KBSSD Tests', () {
    test('calculateMean and calculateMedian', () {
      final data = [10.0, 20.0, 30.0, 40.0, 50.0];
      check(calculateMean(data)).equals(30.0);
      check(calculateMedian(data)).equals(30.0);

      final evenData = [10.0, 20.0, 30.0, 40.0];
      check(calculateMean(evenData)).equals(25.0);
      check(calculateMedian(evenData)).equals(25.0);
    });

    test('calculateStdDev, calculateMAD, and calculateIQR', () {
      final data = [
        10.0,
        12.0,
        14.0,
        16.0,
        18.0,
        20.0,
        100.0,
      ]; // Outlier at 100
      final mean = calculateMean(data);
      final stdDev = calculateStdDev(data, mean);
      final median = calculateMedian(data);
      final mad = calculateMAD(data, median);
      final iqr = calculateIQR(data);

      check(stdDev).isGreaterThan(0.0);
      check(mad).isLessThan(stdDev); // MAD is robust against the outlier
      check(iqr).isGreaterThan(0.0);
    });

    test('getStudentTCriticalValue', () {
      check(getStudentTCriticalValue(1)).equals(12.706);
      check(getStudentTCriticalValue(14)).equals(2.145);
      check(getStudentTCriticalValue(30)).equals(2.042);
      check(getStudentTCriticalValue(150)).equals(1.960);
    });

    test('trimWindow removes extremes', () {
      final data = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0];
      final trimmed = trimWindow(data, 0.10);
      check(trimmed.length).equals(8);
      check(trimmed.first).equals(2.0);
      check(trimmed.last).equals(9.0);
    });

    test('calculateMMD handles zero-variance without bandwidth collapse', () {
      // Two identical constant series representing perfectly stable AOT runs
      final X = [5.0, 5.0, 5.0, 5.0, 5.0];
      final Y = [5.0, 5.0, 5.0, 5.0, 5.0];
      final sigma = estimateSigma(X + Y);
      check(sigma).equals(0.0); // Raw sample sigma is 0.0

      final mmd = calculateMMD(X, Y, sigma, medianFloor: 5.0);
      check(mmd).equals(0.0); // Must be zero, not 1.414!
    });

    test('calculateMMD distinguishes shifted distributions', () {
      final X = [10.0, 10.1, 9.9, 10.0, 10.2];
      final Y = [20.0, 20.1, 19.9, 20.0, 20.2];
      final sigma = estimateSigma(X + Y);
      final mmd = calculateMMD(X, Y, sigma, medianFloor: 15.0);
      check(mmd).isGreaterThan(0.5);
    });

    test('checkSEM evaluates relative error threshold', () {
      final stable = [100.0, 100.1, 99.9, 100.0, 100.2];
      check(checkSEM(stable, targetRelativeError: 0.05)).isTrue();

      final noisy = [10.0, 50.0, 100.0, 20.0, 80.0];
      check(checkSEM(noisy, targetRelativeError: 0.05)).isFalse();
    });

    test('Blackhole zero-cost sink accepts arbitrary values', () {
      blackhole(42);
      blackhole('test string');
      blackhole([1, 2, 3]);
      blackhole({'key': 'value'});
      Blackhole.preventDCE();
    });
  });
}
