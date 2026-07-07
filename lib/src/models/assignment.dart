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
@immutable
class Assignment implements Comparable<Assignment> {
  /// Constructs a new [Assignment] instance.
  ///
  Assignment({
    required this.title,
    required final DateTime start,
    required final DateTime end,
  }) : start = minDateTime(start, end),
       end = maxDateTime(start, end);

  /// Constructs a new [Assignment] instance based on [json].
  ///
  factory Assignment.fromJson(final String json) {
    final Object? decoded;
    final FormatException invalid = FormatException(
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
  ///
  Assignment.fromMap(final Map<String, Object?> map)
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
  factory Assignment.parse(final String formattedString) {
    final String trimmed = formattedString.trim();
    final List<String> strings = trimmed.split('|');
    final FormatException invalid = FormatException(
      parseFormatExceptionMessage(className, formattedString),
      formattedString,
    );
    if (strings case [
      final String title,
      final String start,
      final String end,
    ]) {
      try {
        return Assignment(
          title: title,
          start: DateTime.parse(start),
          end: DateTime.parse(end),
        );
      } on FormatException {
        throw invalid;
      }
    }
    throw invalid;
  }

  /// The name of the class.
  static const String className = 'Assignment';

  /// The end date and time.
  final DateTime end;

  /// The start date and time.
  final DateTime start;

  /// The title that identifies the type of this assignment.
  final String title;

  @override
  int get hashCode => Object.hash(title, start, end);

  /// Returns if this assignment comes before the [other].
  ///
  bool operator <(final Assignment other) => compareTo(other) < 0;

  /// Returns if this assignment comes before or is equal to the [other].
  ///
  bool operator <=(final Assignment other) => compareTo(other) <= 0;

  @override
  bool operator ==(final Object other) =>
      identical(this, other) || (other is Assignment && compareTo(other) == 0);

  /// Returns if this assignment comes after the [other].
  ///
  bool operator >(final Assignment other) => compareTo(other) > 0;

  /// Returns if this assignment comes after or is equal to the [other].
  ///
  bool operator >=(final Assignment other) => compareTo(other) >= 0;

  @override
  int compareTo(final Assignment other) {
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
  Assignment copyWith({
    final String? title,
    final DateTime? start,
    final DateTime? end,
  }) => Assignment(
    title: title ?? this.title,
    start: start ?? this.start,
    end: end ?? this.end,
  );

  /// Returns a JSON string representing this instance of [Assignment].
  ///
  String toJson() => jsonEncode(toMap());

  /// Returns a map representing this instance of [Assignment].
  ///
  Map<String, Object?> toMap() => <String, Object?>{
    _titleKey: title,
    _startKey: start.toIso8601String(),
    _endKey: end.toIso8601String(),
  };

  @override
  String toString() =>
      '$title|${start.toIso8601String()}|${end.toIso8601String()}';
}
