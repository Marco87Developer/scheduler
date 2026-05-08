import 'dart:collection';

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
    if (isEmpty && other.isEmpty) {
      return 0;
    }
    if (isEmpty) {
      return -1;
    }
    if (other.isEmpty) {
      return 1;
    }
    final Iterator<T> thisIterator = iterator;
    final Iterator<T> otherIterator = other.iterator;
    while (thisIterator.moveNext() && otherIterator.moveNext()) {
      final int elementComparison = thisIterator.current.compareTo(
        otherIterator.current,
      );
      if (elementComparison != 0) {
        return elementComparison;
      }
    }
    return 0;
  }

  /// Compares this [SplayTreeSet] with [other] lexicographically, but starting
  /// from the last element.
  ///
  int compareToReversed(final SplayTreeSet<T> other) {
    if (identical(this, other)) {
      return 0;
    }
    if (isEmpty && other.isEmpty) {
      return 0;
    }
    if (isEmpty) {
      return -1;
    }
    if (other.isEmpty) {
      return 1;
    }
    final Iterator<T> thisIterator = toList().reversed.iterator;
    final Iterator<T> otherIterator = other.toList().reversed.iterator;
    while (thisIterator.moveNext() && otherIterator.moveNext()) {
      final int elementComparison = thisIterator.current.compareTo(
        otherIterator.current,
      );
      if (elementComparison != 0) {
        return elementComparison;
      }
    }
    return 0;
  }
}
