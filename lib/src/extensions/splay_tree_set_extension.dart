import 'dart:collection';

import 'package:meta/meta.dart';
import 'package:scheduler/src/helpers/iterable_helpers.dart';

/// Provides lexicographical comparison methods for [SplayTreeSet].
extension SplayTreeSetExtension<T extends Comparable<T>> on SplayTreeSet<T> {
  /// Compares this [SplayTreeSet] with [other] lexicographically.
  @useResult
  int compareTo(SplayTreeSet<T> other) => elementCompareIterables(this, other);

  /// Compares this [SplayTreeSet] with [other] lexicographically, starting from
  /// the last element.
  @useResult
  int compareToReversed(SplayTreeSet<T> other) =>
      elementCompareIterablesReversed(this, other);
}
