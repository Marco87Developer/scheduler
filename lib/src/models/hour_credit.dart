import 'dart:collection';

import 'package:meta/meta.dart';
import 'package:scheduler/src/exceptions/exception_messages.dart';
import 'package:scheduler/src/helpers/iterable_helpers.dart';

/// The hour credit.
///
@immutable
class HourCredit(
  /// The description.
  final String description,

  /// The number of hours of the hour credit.
  final int hours, {
  Iterable<String>? tags,
}) implements Comparable<HourCredit> {
  /// Constructs a new [HourCredit] instance from a [formattedString].
  ///
  /// The string has the form `<description>|<hours>` or
  /// `<description>|<hours>|<tags>`, where `<tags>` is a comma-separated list.
  /// Whitespace around every part is ignored, and empty tags are dropped. The
  /// description and the tags must not contain the pipe character.
  ///
  /// Throws a [FormatException] if the string does not have two or three
  /// segments or if the hours are not an integer. Use [tryParse] to get `null`
  /// instead of an exception.
  factory parse(String formattedString) =>
      tryParse(formattedString) ??
      (throw FormatException(
        parseFormatExceptionMessage(className, formattedString),
        formattedString,
      ));

  /// The name of the class.
  static const String className = 'HourCredit';

  /// The unmodifiable, alphabetically sorted tags set associated with the hour
  /// credit.
  final Set<String> tags = UnmodifiableSetView<String>(
    SplayTreeSet<String>.of(tags ?? const <String>[]),
  );

  @override
  @useResult
  int get hashCode => Object.hash(description, hours, Object.hashAll(tags));

  /// Whether this hour credit comes before the [other].
  @useResult
  bool operator <(HourCredit other) => compareTo(other) < 0;

  /// Whether this hour credit comes before or is equal to the [other].
  @useResult
  bool operator <=(HourCredit other) => compareTo(other) <= 0;

  @override
  @useResult
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HourCredit &&
          hours == other.hours &&
          description == other.description &&
          elementCompareIterables(tags, other.tags) == 0);

  /// Whether this service year starts after the [other].
  @useResult
  bool operator >(HourCredit other) => compareTo(other) > 0;

  /// Whether this service year starts after or at the same time as the
  /// [other].
  @useResult
  bool operator >=(HourCredit other) => compareTo(other) >= 0;

  @override
  @useResult
  int compareTo(HourCredit other) {
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
    return hours.compareTo(other.hours);
  }

  @override
  @useResult
  String toString() => tags.isEmpty
      ? '$description|$hours'
      : '$description|$hours|${tags.join(',')}';

  /// Parses [formattedString] like [HourCredit.parse], but returns `null`
  /// instead of throwing when it is not a valid hour credit.
  @useResult
  static HourCredit? tryParse(String formattedString) {
    if (formattedString.trim().split('|')
        case [
          final String description,
          final String hours,
          ...final List<String> rest,
        ]
        when rest.length <= 1) {
      if (int.tryParse(hours.trim()) case final int parsedHours) {
        return HourCredit(
          description.trim(),
          parsedHours,
          tags: rest.firstOrNull
              ?.split(',')
              .map((tag) => tag.trim())
              .where((tag) => tag.isNotEmpty),
        );
      }
    }
    return null;
  }
}
