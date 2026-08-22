// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math' as math;

/// Critical values for Student's t-distribution at two-sided alpha = 0.05 (95% confidence).
/// Indexed by degrees of freedom (df = n - 1), capped at df = 120.
const List<double> _tTable95 = [
  0.0, // df = 0 (unused)
  12.706, // df = 1
  4.303, // df = 2
  3.182, // df = 3
  2.776, // df = 4
  2.571, // df = 5
  2.447, // df = 6
  2.365, // df = 7
  2.306, // df = 8
  2.262, // df = 9
  2.228, // df = 10
  2.201, // df = 11
  2.179, // df = 12
  2.160, // df = 13
  2.145, // df = 14
  2.131, // df = 15
  2.120, // df = 16
  2.110, // df = 17
  2.101, // df = 18
  2.093, // df = 19
  2.086, // df = 20
  2.080, // df = 21
  2.074, // df = 22
  2.069, // df = 23
  2.064, // df = 24
  2.060, // df = 25
  2.056, // df = 26
  2.052, // df = 27
  2.048, // df = 28
  2.045, // df = 29
  2.042, // df = 30
];

/// Returns the critical Student's t-value for 95% confidence given [degreesOfFreedom].
double getStudentTCriticalValue(int degreesOfFreedom) {
  if (degreesOfFreedom <= 0) return 1.96;
  if (degreesOfFreedom < _tTable95.length) {
    return _tTable95[degreesOfFreedom];
  }
  if (degreesOfFreedom <= 60) return 2.000;
  if (degreesOfFreedom <= 120) return 1.980;
  return 1.960;
}

/// Calculates the arithmetic mean of [data].
double calculateMean(List<double> data) {
  if (data.isEmpty) return 0.0;
  var sum = 0.0;
  for (var i = 0; i < data.length; i++) {
    sum += data[i];
  }
  return sum / data.length;
}

/// Calculates the median of a sorted or unsorted list [data].
double calculateMedian(List<double> data) {
  if (data.isEmpty) return 0.0;
  final sorted = List<double>.from(data)..sort();
  final middle = sorted.length ~/ 2;
  if (sorted.length.isOdd) {
    return sorted[middle];
  } else {
    return (sorted[middle - 1] + sorted[middle]) / 2.0;
  }
}

/// Calculates the sample standard deviation of [data] given its [mean].
double calculateStdDev(List<double> data, double mean) {
  if (data.length < 2) return 0.0;
  var sumSquaredDiff = 0.0;
  for (var i = 0; i < data.length; i++) {
    final diff = data[i] - mean;
    sumSquaredDiff += diff * diff;
  }
  return math.sqrt(sumSquaredDiff / (data.length - 1));
}

/// Calculates the Median Absolute Deviation (MAD) of [data] given its [median].
double calculateMAD(List<double> data, double median) {
  if (data.isEmpty) return 0.0;
  final absDeviations = <double>[];
  for (var i = 0; i < data.length; i++) {
    absDeviations.add((data[i] - median).abs());
  }
  return calculateMedian(absDeviations);
}

/// Calculates the Interquartile Range (IQR) of [data].
double calculateIQR(List<double> data) {
  if (data.length < 4) return 0.0;
  final sorted = List<double>.from(data)..sort();
  final q1 = calculatePercentile(sorted, 0.25);
  final q3 = calculatePercentile(sorted, 0.75);
  return q3 - q1;
}

/// Calculates the [percentile] (0.0 to 1.0) of a sorted list [sortedData].
double calculatePercentile(List<double> sortedData, double percentile) {
  if (sortedData.isEmpty) return 0.0;
  if (sortedData.length == 1) return sortedData.first;
  final index = percentile * (sortedData.length - 1);
  final lower = index.floor();
  final upper = index.ceil();
  final weight = index - lower;
  if (lower == upper) return sortedData[lower];
  return sortedData[lower] * (1.0 - weight) + sortedData[upper] * weight;
}

/// Trims [trimPercentage] from both top and bottom extremes of [data].
List<double> trimWindow(List<double> data, double trimPercentage) {
  if (data.length < 4 || trimPercentage <= 0.0) {
    return List<double>.from(data);
  }
  final sorted = List<double>.from(data)..sort();
  final trimCount = (sorted.length * trimPercentage).floor();
  if (trimCount * 2 >= sorted.length) {
    return sorted;
  }
  return sorted.sublist(trimCount, sorted.length - trimCount);
}

/// Estimates Gaussian RBF kernel bandwidth (sigma) using the median pairwise distance heuristic.
double estimateSigma(List<double> window) {
  if (window.length < 2) return 1.0;
  final distances = <double>[];
  for (var i = 0; i < window.length; i++) {
    for (var j = i + 1; j < window.length; j++) {
      final d = (window[i] - window[j]).abs();
      if (d > 0.0) {
        distances.add(d);
      }
    }
  }
  if (distances.isEmpty) return 0.0;
  return calculateMedian(distances);
}

/// Calculates Maximum Mean Discrepancy (MMD) between empirical windows [X] and [Y].
///
/// Applies a relative [medianFloor] to [sigma] to prevent kernel collapse when sample
/// variance is near zero.
double calculateMMD(
  List<double> X,
  List<double> Y,
  double sigma, {
  double medianFloor = 0.0,
}) {
  final n = X.length;
  final m = Y.length;
  if (n == 0 || m == 0) return 0.0;

  // Relative floor prevents Dirac delta explosion when samples are bit-exact identical
  final minFloor = medianFloor > 0.0 ? medianFloor * 0.01 : 1e-4;
  final effectiveSigma = math.max(sigma, minFloor);
  final s2 = 2.0 * math.max(effectiveSigma * effectiveSigma, 1e-9);

  var kXX = 0.0;
  for (var i = 0; i < n; i++) {
    for (var j = 0; j < n; j++) {
      final diff = X[i] - X[j];
      kXX += math.exp(-(diff * diff) / s2);
    }
  }
  kXX /= (n * n);

  var kYY = 0.0;
  for (var i = 0; i < m; i++) {
    for (var j = 0; j < m; j++) {
      final diff = Y[i] - Y[j];
      kYY += math.exp(-(diff * diff) / s2);
    }
  }
  kYY /= (m * m);

  var kXY = 0.0;
  for (var i = 0; i < n; i++) {
    for (var j = 0; j < m; j++) {
      final diff = X[i] - Y[j];
      kXY += math.exp(-(diff * diff) / s2);
    }
  }
  kXY /= (n * m);

  final mmdSquared = kXX - 2.0 * kXY + kYY;
  return mmdSquared > 0.0 ? math.sqrt(mmdSquared) : 0.0;
}

/// Checks if the Standard Error of the Mean (SEM) normalized 95% confidence interval
/// is within [targetRelativeError].
bool checkSEM(List<double> data, {double targetRelativeError = 0.05}) {
  if (data.length < 3) return false;
  final mean = calculateMean(data);
  if (mean <= 0.0) return true;
  final stdDev = calculateStdDev(data, mean);
  final sem = stdDev / math.sqrt(data.length);
  final df = data.length - 1;
  final tCrit = getStudentTCriticalValue(df);
  final marginOfError = tCrit * sem;
  return (marginOfError / mean) <= targetRelativeError;
}
