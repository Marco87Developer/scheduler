import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:scheduler/src/enums/day_of_week.dart';
import 'package:scheduler/src/exceptions/exception_messages.dart';
import 'package:scheduler/src/helpers/from_map_helpers.dart';
import 'package:scheduler/src/models/time.dart';

const String _dayKey = 'day';
const String _endKey = 'end';
const String _startKey = 'start';

/// A weekly availability.
///
@immutable
class WeeklyAvailability implements Comparable<WeeklyAvailability> {
  /// Constructs a new [WeeklyAvailability] instance from the two given dates.
  ///
  /// If [end] is earlier than [start], the two values are silently swapped so
  /// that [start] is always before or coincides with [end].
  ///
  const WeeklyAvailability(this.day, final Time start, final Time end)
    : start = start < end ? start : end,
      end = end >= start ? end : start;

  /// Constructs a new [WeeklyAvailability] instance based on [json] string.
  ///
  /// Throws [FormatException] if [json] is not valid JSON or does not represent
  /// a `Map<String, Object?>` with the expected keys.
  ///
  factory WeeklyAvailability.fromJson(final String json) {
    final FormatException invalid = FormatException(
      fromJsonFormatExceptionMessage(className, json),
      json,
    );
    try {
      final Object? decoded = jsonDecode(json);
      if (decoded case final Map<String, Object?> map) {
        return WeeklyAvailability.fromMap(map);
      }
    } on Exception {
      throw invalid;
    }
    throw invalid;
  }

  /// Constructs a new [WeeklyAvailability] instance based on [map].
  ///
  /// Throws [FormatException] if any required key is absent or has an
  /// incompatible type.
  ///
  WeeklyAvailability.fromMap(final Map<String, Object?> map)
    : this(
        parseClass<DayOfWeek, String>(
          className: className,
          map: map,
          key: _dayKey,
          parser: DayOfWeek.parse,
        ),
        parseClass<Time, String>(
          className: className,
          map: map,
          key: _startKey,
          parser: Time.parse,
        ),
        parseClass<Time, String>(
          className: className,
          map: map,
          key: _endKey,
          parser: Time.parse,
        ),
      );

  /// Constructs a new [WeeklyAvailability] instance from a pipe-delimited
  /// [formattedString] of the form `<day>|<start>|<end>`.
  ///
  /// Throws [FormatException] if the string does not have exactly three
  /// pipe-separated segments or any segment cannot be parsed.
  ///
  factory WeeklyAvailability.parse(final String formattedString) {
    final FormatException invalid = FormatException(
      parseFormatExceptionMessage(className, formattedString),
      formattedString,
    );
    final List<String> parts = formattedString.split('|');
    if (parts case [final String day, final String start, final String end]) {
      try {
        return WeeklyAvailability(
          DayOfWeek.parse(day),
          Time.parse(start),
          Time.parse(end),
        );
      } on Exception {
        throw invalid;
      }
    }
    throw invalid;
  }

  /// The name of the class.
  static const String className = 'WeeklyAvailability';

  /// The day of the week.
  final DayOfWeek day;

  /// The end time.
  final Time end;

  /// The start time.
  final Time start;

  @override
  int get hashCode => Object.hash(day, start, end);

  /// Returns if this weekly availability comes before the [other].
  ///
  bool operator <(covariant final WeeklyAvailability other) =>
      compareTo(other) < 0;

  /// Returns if this weekly availability comes before the or is equal to the
  /// [other].
  ///
  bool operator <=(covariant final WeeklyAvailability other) =>
      compareTo(other) <= 0;

  @override
  bool operator ==(covariant final WeeklyAvailability other) =>
      identical(this, other) || compareTo(other) == 0;

  /// Returns if this weekly availability comes after the [other].
  ///
  bool operator >(covariant final WeeklyAvailability other) =>
      compareTo(other) > 0;

  /// Returns if this weekly availability comes after the or is equal to the
  /// [other].
  ///
  bool operator >=(covariant final WeeklyAvailability other) =>
      compareTo(other) >= 0;

  @override
  int compareTo(covariant final WeeklyAvailability other) {
    if (identical(this, other)) {
      return 0;
    }
    final int byDay = day.compareTo(other.day);
    if (byDay != 0) {
      return byDay;
    }
    final int byStart = start.compareTo(other.start);
    if (byStart != 0) {
      return byStart;
    }
    return end.compareTo(other.end);
  }

  /// Creates a copy of this [WeeklyAvailability] instance, but with the given
  /// fields replaced with the new values.
  ///
  WeeklyAvailability copyWith({
    final DayOfWeek? day,
    final Time? end,
    final Time? start,
  }) =>
      WeeklyAvailability(day ?? this.day, start ?? this.start, end ?? this.end);

  /// Returns a JSON string representing this instance of [WeeklyAvailability].
  ///
  String toJson() => jsonEncode(toMap());

  /// Returns a map representing this instance of [WeeklyAvailability].
  ///
  Map<String, Object?> toMap() => <String, Object?>{
    _dayKey: day.toString(),
    _endKey: end.toString(),
    _startKey: start.toString(),
  };

  @override
  String toString() => '$day|$start|$end';
}
