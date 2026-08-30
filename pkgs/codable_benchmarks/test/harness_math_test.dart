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

    test('calculateGeometricMean computes multiplicative central tendency', () {
      check(calculateGeometricMean([])).equals(0.0);
      check(calculateGeometricMean([42.0])).equals(42.0);
      check((calculateGeometricMean([100.0, 100.0, 100.0]) - 100.0).abs())
          .isLessThan(1e-9);
      check((calculateGeometricMean([2.0, 8.0]) - 4.0).abs()).isLessThan(1e-9);
      check((calculateGeometricMean([10.0, 100.0, 1000.0]) - 100.0).abs())
          .isLessThan(1e-9);
    });

    test(
      'calculateWelchDegreesOfFreedom computes Satterthwaite approximation',
      () {
        // Equal variances and sample sizes reduce to
        // pooled df = n1 + n2 - 2 = 18
        final dfEqual = calculateWelchDegreesOfFreedom(
          s1: 2.0,
          n1: 10,
          s2: 2.0,
          n2: 10,
        );
        check(dfEqual).equals(18.0);

        // Unequal variances: s1 = 1, n1 = 10, s2 = 5, n2 = 20
        final dfUnequal = calculateWelchDegreesOfFreedom(
          s1: 1.0,
          n1: 10,
          s2: 5.0,
          n2: 20,
        );
        check(dfUnequal).isGreaterThan(19.0);
        check(dfUnequal).isLessThan(28.0);
      },
    );

    test(
      'calculateDeltaMethodPercentageStandardError scales variance by ratio',
      () {
        // Baseline 100 ms ± 10 ms (N=20), Candidate 50 ms ± 5 ms (N=20) (2x)
        final sePct = calculateDeltaMethodPercentageStandardError(
          meanX: 100.0,
          sX: 10.0,
          nX: 20,
          meanY: 50.0,
          sY: 5.0,
          nY: 20,
        );
        check(sePct).isGreaterThan(0.0);
        check(sePct).isLessThan(10.0);
      },
    );

    test(
      'compareDistributions evaluates two-sample significance and bounds',
      () {
        // Clear significant speedup
        final sigSpeedup = compareDistributions(
          meanX: 100.0,
          sX: 2.0,
          nX: 20,
          meanY: 50.0,
          sY: 2.0,
          nY: 20,
        );
        check(sigSpeedup.isSignificant).isTrue();
        check(sigSpeedup.deltaPercentage).equals(-50.0);
        check(sigSpeedup.tStatistic).isGreaterThan(sigSpeedup.tCritical);
        check(sigSpeedup.ciUpperPercentage).isLessThan(0.0); // CI excludes zero

        // Clear non-significant noise (overlapping distributions)
        final nonSig = compareDistributions(
          meanX: 100.0,
          sX: 10.0,
          nX: 20,
          meanY: 100.2,
          sY: 10.0,
          nY: 20,
        );
        check(nonSig.isSignificant).isFalse();
        check(nonSig.tStatistic).isLessThan(nonSig.tCritical);
        check(nonSig.ciLowerPercentage).isLessThan(0.0);
        check(nonSig.ciUpperPercentage).isGreaterThan(0.0); // CI contains zero
      },
    );
  });
}
