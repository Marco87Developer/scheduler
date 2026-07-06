import 'dart:collection';

import 'package:meta/meta.dart';
import 'package:scheduler/src/exceptions/exception_messages.dart';
import 'package:scheduler/src/helpers/iterable_helpers.dart';

/// The hour credit.
///
@immutable
class HourCredit implements Comparable<HourCredit> {
  /// Constructs a new [HourCredit] instance.
  ///
  HourCredit(this.description, this.hours, {final Iterable<String>? tags})
    : tags = UnmodifiableSetView<String>(
        SplayTreeSet<String>.of(tags ?? const <String>[]),
      );

  /// Constructs a new [HourCredit] instance from a [formattedString].
  ///
  factory HourCredit.parse(final String formattedString) {
    final FormatException invalid = FormatException(
      parseFormatExceptionMessage(className, formattedString),
      formattedString,
    );
    final String trimmed = formattedString.trim();
    final List<String> properties = trimmed.split('|');
    try {
      return switch (properties) {
        [final String d, final String h] => HourCredit(
          d.trim(),
          int.parse(h.trim()),
        ),
        [final String d, final String h, final String t] => HourCredit(
          d.trim(),
          int.parse(h.trim()),
          tags: t
              .split(',')
              .map((final String tag) => tag.trim())
              .where((final String tag) => tag.isNotEmpty),
        ),
        _ => throw invalid,
      };
    } on Exception {
      throw invalid;
    }
  }

  /// The name of the class.
  static const String className = 'HourCredit';

  /// The number of hours of the hour credit.
  final int hours;

  /// The description.
  final String description;

  /// The tags associated with the hour credit, sorted alphabetically.
  final Set<String> tags;

  @override
  int get hashCode => Object.hash(description, hours, Object.hashAll(tags));

  /// Returns if this hour credit comes before the [other].
  ///
  bool operator <(final HourCredit other) => compareTo(other) < 0;

  /// Returns if this hour credit comes before or is equal to the [other].
  ///
  bool operator <=(final HourCredit other) => compareTo(other) <= 0;

  @override
  bool operator ==(final Object other) =>
      identical(this, other) || other is HourCredit && compareTo(other) == 0;

  /// Returns if this service year starts after the [other].
  ///
  bool operator >(final HourCredit other) => compareTo(other) > 0;

  /// Returns if this service year starts after or at the same time as the
  /// [other].
  ///
  bool operator >=(final HourCredit other) => compareTo(other) >= 0;

  @override
  int compareTo(final HourCredit other) {
    if (identical(this, other)) {
      return 0;
    }
    int comparison = elementCompareIterables(tags, other.tags);
    if (comparison != 0) {
      return comparison;
    }
    comparison = description.compareTo(other.description);
    if (comparison != 0) {
      return comparison;
    }
    comparison = hours.compareTo(other.hours);
    if (comparison != 0) {
      return comparison;
    }
    return 0;
  }

  @override
  String toString() => tags.isEmpty
      ? '$description|$hours'
      : '$description|$hours|${tags.join(',')}';
}
