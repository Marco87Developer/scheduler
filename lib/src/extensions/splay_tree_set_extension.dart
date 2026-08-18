import 'dart:collection';

import 'package:scheduler/src/helpers/iterable_helpers.dart';

/// A [SplayTreeSet] extension that provides methods for comparing them
/// lexicographically.
///
extension SplayTreeSetExtension<T extends Comparable<T>> on SplayTreeSet<T> {
  /// Compares this [SplayTreeSet] with [other] lexicographically.
  ///
  int compareTo(SplayTreeSet<T> other) => elementCompareIterables(this, other);

  /// Compares this [SplayTreeSet] with [other] lexicographically, but starting
  /// from the last element.
  ///
  int compareToReversed(SplayTreeSet<T> other) =>
      elementCompareIterablesReversed(this, other);
}
