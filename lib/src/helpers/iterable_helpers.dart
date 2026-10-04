import 'package:meta/meta.dart';

/// Compares two [Iterable]s of [Comparable] elements lexicographically.
///
/// Iterates both sequences in lock-step and returns the comparison result of
/// the first pair of elements that differs. Returns `0` if all paired elements
/// are equal.
@useResult
int elementCompareIterables<T extends Comparable<T>>(
  Iterable<T> a,
  Iterable<T> b,
) => identical(a, b) ? 0 : _elementComparison<T>(a, b);

/// Compares two [Iterable]s of [Comparable] elements from end to start.
///
/// Iterates both sequences in reverse order and returns the comparison
/// result of the first pair of elements that differs.
///
/// If all evaluated elements are equal but the iterables have different
/// lengths, the longer iterable is considered greater.
///
/// Returns:
///
/// * `1` if [a] is greater.
/// * `-1` if [b] is greater.
/// * `0` if both iterables are identical in elements and length.
@useResult
int elementCompareIterablesReversed<T extends Comparable<T>>(
  Iterable<T> a,
  Iterable<T> b,
) {
  if (identical(a, b)) {
    return 0;
  }
  final List<T> aList = a is List<T> ? a : a.toList(growable: false);
  final List<T> bList = b is List<T> ? b : b.toList(growable: false);
  int aIdx = aList.length - 1;
  int bIdx = bList.length - 1;
  while (aIdx >= 0 && bIdx >= 0) {
    final int comp = aList[aIdx].compareTo(bList[bIdx]);
    if (comp != 0) {
      return comp;
    }
    aIdx--;
    bIdx--;
  }
  if (aIdx >= 0) {
    return 1;
  }
  if (bIdx >= 0) {
    return -1;
  }
  return 0;
}

/// Compares the elements of two [Iterable]s sequentially.
///
/// Iterates through [a] and [b] simultaneously. It returns the result of the 1º
/// non-zero comparison between corresponding elements.
///
/// If all evaluated elements are equal, but the iterables have different
/// lengths, the longer iterable is considered greater.
///
/// Returns:
///
/// * `1` if [a] is longer.
/// * `-1` if [b] is longer.
/// * `0` if both iterables are identical in elements and length.
@useResult
int _elementComparison<T extends Comparable<T>>(Iterable<T> a, Iterable<T> b) {
  if (a is List<T> && b is List<T>) {
    final int aLen = a.length;
    final int bLen = b.length;
    final minLen = aLen < bLen ? aLen : bLen;
    for (var i = 0; i < minLen; i++) {
      final int comp = a[i].compareTo(b[i]);
      if (comp != 0) {
        return comp;
      }
    }
    if (aLen > bLen) {
      return 1;
    }
    if (aLen < bLen) {
      return -1;
    }
    return 0;
  }
  final Iterator<T> ai = a.iterator;
  final Iterator<T> bi = b.iterator;
  while (ai.moveNext()) {
    if (!bi.moveNext()) {
      return 1;
    }
    final int comp = ai.current.compareTo(bi.current);
    if (comp != 0) {
      return comp;
    }
  }
  if (bi.moveNext()) {
    return -1;
  }
  return 0;
}
