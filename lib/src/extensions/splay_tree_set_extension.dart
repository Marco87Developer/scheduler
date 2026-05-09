import 'dart:collection';

/// Compares two [Iterable]s of [Comparable] elements lexicographically.
///
/// Iterates both sequences in lock-step and returns the comparison result of
/// the first pair of elements that differs. Returns `0` if all paired elements
/// are equal.
///
int _compareIterables<T extends Comparable<T>>(
  final Iterable<T> a,
  final Iterable<T> b,
) {
  final Iterator<T> ai = a.iterator;
  final Iterator<T> bi = b.iterator;
  while (ai.moveNext() && bi.moveNext()) {
    final int elementComparison = ai.current.compareTo(bi.current);
    if (elementComparison != 0) {
      return elementComparison;
    }
  }
  return 0;
}

/// A [SplayTreeSet] extension that provides methods for comparing them
/// lexicographically.
///
extension SplayTreeSetExtension<T extends Comparable<T>> on SplayTreeSet<T> {
  /// Compares this [SplayTreeSet] with [other] lexicographically.
  ///
  int compareTo(final SplayTreeSet<T> other) {
    if (identical(this, other)) {
      return 0;
    }
    return switch ((isEmpty, other.isEmpty)) {
      (true, true) => 0,
      (true, false) => -1,
      (false, true) => 1,
      _ => _compareIterables(this, other),
    };
  }

  /// Compares this [SplayTreeSet] with [other] lexicographically, but starting
  /// from the last element.
  ///
  int compareToReversed(final SplayTreeSet<T> other) {
    if (identical(this, other)) {
      return 0;
    }
    return switch ((isEmpty, other.isEmpty)) {
      (true, true) => 0,
      (true, false) => -1,
      (false, true) => 1,
      _ => _compareIterables(toList().reversed, other.toList().reversed),
    };
  }
}
