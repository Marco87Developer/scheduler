/// Compares two [Iterable]s of [Comparable] elements lexicographically.
///
/// Iterates both sequences in lock-step and returns the comparison result of
/// the first pair of elements that differs. Returns `0` if all paired elements
/// are equal.
///
int elementCompareIterables<T extends Comparable<T>>(
  final Iterable<T> a,
  final Iterable<T> b,
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
///
int elementCompareIterablesReversed<T extends Comparable<T>>(
  final Iterable<T> a,
  final Iterable<T> b,
) {
  if (identical(a, b)) {
    return 0;
  }
  final Iterable<T> aReversed =
      (a is List<T> ? a : a.toList(growable: false)).reversed;
  final Iterable<T> bReversed =
      (b is List<T> ? b : b.toList(growable: false)).reversed;
  return _elementComparison<T>(aReversed, bReversed);
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
///
int _elementComparison<T extends Comparable<T>>(
  final Iterable<T> a,
  final Iterable<T> b,
) {
  final Iterator<T> ai = a.iterator;
  final Iterator<T> bi = b.iterator;
  bool aHasNext = ai.moveNext();
  bool bHasNext = bi.moveNext();
  while (aHasNext && bHasNext) {
    final int elementComparison = ai.current.compareTo(bi.current);
    if (elementComparison != 0) {
      return elementComparison;
    }
    aHasNext = ai.moveNext();
    bHasNext = bi.moveNext();
  }
  if (aHasNext) {
    return 1;
  }
  if (bHasNext) {
    return -1;
  }
  return 0;
}
