import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:scheduler/src/exceptions/exception_messages.dart';
import 'package:scheduler/src/extensions/date_time_extension.dart';
import 'package:scheduler/src/helpers/from_map_helpers.dart';

const String _endKey = 'end';
const String _startKey = 'start';
const String _titleKey = 'title';

/// A service assignment.
///
/// An assignment is a task that is assigned to one or more persons. It has a
/// [title], a [start] and an [end].
///
/// Assignments are ordered by [title], then by [start], then by [end].
/// Equality is consistent with that order: two assignments are equal if they
/// have the same [title] and denote the same moments, whether the dates are
/// in UTC or local time.
@immutable
class Assignment({
  /// The end date and time.
  required DateTime end,

  /// The start date and time.
  required DateTime start,

  /// The title that identifies the type of this assignment.
  required final String title,
}) implements Comparable<Assignment> {
  /// Constructs a new [Assignment] instance based on [json].
  factory fromJson(String json) {
    final Object? decoded;
    final invalid = FormatException(
      fromJsonFormatExceptionMessage(className, json),
      json,
    );
    try {
      decoded = jsonDecode(json);
    } on FormatException {
      throw invalid;
    }
    return switch (decoded) {
      final Map<String, Object?> map => Assignment.fromMap(map),
      _ => throw invalid,
    };
  }

  /// Constructs a new [Assignment] instance based on [map].
  new fromMap(Map<String, Object?> map)
    : this(
        title: parseString(className: className, map: map, key: _titleKey),
        start: parseClass(
          className: className,
          map: map,
          key: _startKey,
          parser: DateTime.parse,
        ),
        end: parseClass(
          className: className,
          map: map,
          key: _endKey,
          parser: DateTime.parse,
        ),
      );

  /// Constructs a new [Assignment] instance from a [formattedString].
  ///
  /// The string has the form `<title>|<start>|<end>`, where the dates are in
  /// ISO 8601 format. Whitespace around the whole string is ignored, and the
  /// title must not contain the pipe character.
  ///
  /// Throws a [FormatException] if the string does not have exactly three
  /// segments or if a date cannot be parsed. Use [tryParse] to get `null`
  /// instead of an exception.
  factory parse(String formattedString) =>
      tryParse(formattedString) ??
      (throw FormatException(
        parseFormatExceptionMessage(className, formattedString),
        formattedString,
      ));

  /// The name of the class.
  static const String className = 'Assignment';

  /// The end date and time.
  final DateTime end = maxDateTime(start, end);

  /// The start date and time.
  final DateTime start = minDateTime(start, end);

  @override
  @useResult
  int get hashCode => Object.hash(title, start, end);

  /// Whether this assignment comes before the [other].
  @useResult
  bool operator <(Assignment other) => compareTo(other) < 0;

  /// Whether this assignment comes before or is equal to the [other].
  @useResult
  bool operator <=(Assignment other) => compareTo(other) <= 0;

  @override
  @useResult
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Assignment &&
          end == other.end &&
          start == other.start &&
          title == other.title);

  /// Whether this assignment comes after the [other].
  @useResult
  bool operator >(Assignment other) => compareTo(other) > 0;

  /// Whether this assignment comes after or is equal to the [other].
  @useResult
  bool operator >=(Assignment other) => compareTo(other) >= 0;

  @override
  @useResult
  int compareTo(Assignment other) {
    if (identical(this, other)) {
      return 0;
    }
    int comparison = title.compareTo(other.title);
    if (comparison != 0) {
      return comparison;
    }
    comparison = start.compareTo(other.start);
    if (comparison != 0) {
      return comparison;
    }
    return end.compareTo(other.end);
  }

  /// Creates a copy of this [Assignment] instance, but with the given fields
  /// replaced with the new values.
  ///
  /// If the resulting start comes after the resulting end, they are swapped.
  @useResult
  Assignment copyWith({String? title, DateTime? start, DateTime? end}) =>
      Assignment(
        title: title ?? this.title,
        start: start ?? this.start,
        end: end ?? this.end,
      );

  /// Returns a JSON string representing this instance of [Assignment].
  @useResult
  String toJson() => jsonEncode(toMap());

  /// Returns a map representing this instance of [Assignment].
  @useResult
  Map<String, Object?> toMap() => <String, Object?>{
    _titleKey: title,
    _startKey: start.toIso8601String(),
    _endKey: end.toIso8601String(),
  };

  @override
  @useResult
  String toString() =>
      '$title|${start.toIso8601String()}|${end.toIso8601String()}';

  /// Parses [formattedString] like [Assignment.parse], but returns `null`
  /// instead of throwing when it is not a valid assignment.
  @useResult
  static Assignment? tryParse(String formattedString) {
    if (formattedString.trim().split('|') case [
      final String title,
      final String start,
      final String end,
    ]) {
      if ((DateTime.tryParse(start), DateTime.tryParse(end)) case (
        final DateTime startDate,
        final DateTime endDate,
      )) {
        return Assignment(title: title, start: startDate, end: endDate);
      }
    }
    return null;
  }
}
