import 'dart:collection';
import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:scheduler/src/exceptions/exception_messages.dart';
import 'package:scheduler/src/extensions/date_time_extension.dart';
import 'package:scheduler/src/helpers/from_map_helpers.dart';

const String _endKey = 'end';
const String _startKey = 'start';

/// A date time range.
///
/// A date time range is a range of dates and times. It has a [start] and an
/// [end]. The [start] must be before the [end]. If the [start] is after the
/// [end], they are swapped.
///
/// The [start] and [end] dates are inclusive.
@immutable
class DateTimeRange._(
  /// The start (inclusive).
  final DateTime start,

  /// The end (inclusive).
  final DateTime end,
) implements Comparable<DateTimeRange> {
  /// Constructs a new [DateTimeRange] instance from the two given dates.
  ///
  /// Performs a single comparison to put the dates in order.
  factory(DateTime dt1, DateTime dt2) =>
      dt1.isBefore(dt2) ? DateTimeRange._(dt1, dt2) : DateTimeRange._(dt2, dt1);

  /// Constructs a new [DateTimeRange] instance based on [json].
  ///
  /// Throws a [FormatException] if [json] is not valid JSON or does not
  /// represent a map with valid `start` and `end` values.
  factory fromJson(String json) {
    try {
      final Object? decoded = jsonDecode(json);
      if (decoded case final Map<String, Object?> map) {
        return DateTimeRange.fromMap(map);
      }
    } on FormatException {
      throw FormatException(
        fromJsonFormatExceptionMessage(className, json),
        json,
      );
    }
    throw FormatException(
      fromJsonFormatExceptionMessage(className, json),
      json,
    );
  }

  /// Constructs a new [DateTimeRange] instance based on [map].
  ///
  /// Throws a [FormatException] if a key is absent or its value is not a
  /// parseable date string.
  factory fromMap(Map<String, Object?> map) => DateTimeRange(
    parseClass<DateTime, String>(
      className: className,
      map: map,
      key: _startKey,
      parser: DateTime.parse,
    ),
    parseClass<DateTime, String>(
      className: className,
      map: map,
      key: _endKey,
      parser: DateTime.parse,
    ),
  );

  /// Constructs a new [DateTimeRange] instance from a [formattedString] of the
  /// form `<start>|<end>`, where both dates are in ISO 8601 format.
  ///
  /// Whitespace around the whole string is ignored.
  ///
  /// Throws a [FormatException] if [formattedString] is not valid. Use
  /// [tryParse] to get `null` instead of an exception.
  factory parse(String formattedString) =>
      tryParse(formattedString) ??
      (throw FormatException(
        parseFormatExceptionMessage(className, formattedString),
        formattedString,
      ));

  /// The name of the class.
  static const String className = 'DateTimeRange';

  /// The duration of this range.
  @useResult
  Duration get duration => end.difference(start);

  @override
  @useResult
  int get hashCode =>
      Object.hash(end.microsecondsSinceEpoch, start.microsecondsSinceEpoch);

  /// Whether this range denotes a single moment.
  @useResult
  bool get isInstant => start.isAtSameMomentAs(end);

  /// Whether the [start] of this date time range is before the start of the
  /// [other] date time range. Or whether, in the case where the two starts are
  /// the same, the [end] of this date time range is before the end of the
  /// [other] date time range.
  @useResult
  bool operator <(DateTimeRange other) => compareTo(other) < 0;

  /// Whether the [start] of this date time range is before the start of the
  /// [other] date time range. Or whether, in the case where the two starts are
  /// the same, the [end] of this date time range is before or coincides with
  /// the end of the [other] date time range.
  @useResult
  bool operator <=(DateTimeRange other) => compareTo(other) <= 0;

  @override
  @useResult
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DateTimeRange && compareTo(other) == 0);

  /// Whether the [start] of this date time range is after the start of the
  /// [other] date time range. Or whether, in the case where the two starts are
  /// the same, the [end] of this date time range is after the end of the
  /// [other] date time range.
  @useResult
  bool operator >(DateTimeRange other) => compareTo(other) > 0;

  /// Whether the [start] of this date time range is after the start of the
  /// [other] date time range. Or whether, in the case where the two starts are
  /// the same, the [end] of this date time range is after or coincides with the
  /// end of the [other] date time range.
  @useResult
  bool operator >=(DateTimeRange other) => compareTo(other) >= 0;

  @override
  @useResult
  int compareTo(DateTimeRange other) {
    if (identical(this, other)) {
      return 0;
    }
    return switch (start.compareTo(other.start)) {
      0 => end.compareTo(other.end),
      final int result => result,
    };
  }

  /// Whether [moment] lies within this range, bounds included.
  @useResult
  bool contains(DateTime moment) =>
      moment.isAfterOrAtSameMomentAs(start) &&
      moment.isBeforeOrAtSameMomentAs(end);

  /// Whether [other] lies entirely within this range, bounds included.
  @useResult
  bool containsRange(DateTimeRange other) =>
      start.isBeforeOrAtSameMomentAs(other.start) &&
      end.isAfterOrAtSameMomentAs(other.end);

  /// Creates a copy of this [DateTimeRange] instance, but with the given fields
  /// replaced with the new values.
  ///
  /// If the resulting start comes after the resulting end, they are swapped.
  @useResult
  DateTimeRange copyWith({DateTime? end, DateTime? start}) =>
      DateTimeRange(start ?? this.start, end ?? this.end);

  /// Whether this date time range ends before or on the start of the [other].
  @useResult
  bool endsBeforeOrAtStart(DateTimeRange other) => !end.isAfter(other.start);

  /// Whether this date time range ends before the start of the [other].
  @useResult
  bool endsBeforeStart(DateTimeRange other) => end.isBefore(other.start);

  /// Returns the part shared with the [other], or `null` if the two ranges
  /// neither overlap nor touch.
  ///
  /// Ranges that only touch share a single moment, so the result is an
  /// instant.
  @useResult
  DateTimeRange? intersection(DateTimeRange other) {
    final DateTime shared = maxDateTime(start, other.start);
    final DateTime sharedEnd = minDateTime(end, other.end);
    return shared.isAfter(sharedEnd)
        ? null
        : DateTimeRange._(shared, sharedEnd);
  }

  /// Whether this date time range overlaps with or touches the [other].
  @useResult
  bool overlapsOrTouches(DateTimeRange other) =>
      !(start.isAfter(other.end) || end.isBefore(other.start));

  /// Whether this date time range starts after the end of the [other].
  @useResult
  bool startsAfterEnds(DateTimeRange other) => start.isAfter(other.end);

  /// Whether this date time range starts after or on the end of the [other].
  @useResult
  bool startsAfterOrAtEnd(DateTimeRange other) => !start.isBefore(other.end);

  /// Returns a JSON string representing this instance of [DateTimeRange].
  @useResult
  String toJson() => jsonEncode(toMap());

  /// Returns a map representing this instance of [DateTimeRange].
  @useResult
  Map<String, Object?> toMap() => <String, Object?>{
    _endKey: end.toIso8601String(),
    _startKey: start.toIso8601String(),
  };

  @override
  @useResult
  String toString() => '${start.toIso8601String()}|${end.toIso8601String()}';

  /// Whether any two ranges in [ranges] overlap or touch.
  ///
  /// Because [ranges] is sorted, only neighboring ranges need to be checked.
  @useResult
  static bool areThereOverlaps(SplayTreeSet<DateTimeRange> ranges) {
    if (ranges.length < 2) {
      return false;
    } else {
      /// An [Iterator] gives efficient sequential access, without the
      /// logarithmic cost of [elementAt].
      final Iterator<DateTimeRange> iterator = ranges.iterator..moveNext();
      DateTimeRange previous = iterator.current;
      while (iterator.moveNext()) {
        final DateTimeRange current = iterator.current;
        if (!current.start.isAfter(previous.end)) {
          return true;
        }
        previous = current;
      }
      return false;
    }
  }

  /// Joins two [DateTimeRange]s, merging them if they overlap or touch.
  ///
  /// If [dtr1] and [dtr2] overlap or touch, the result contains a single range
  /// that spans from the earliest start to the latest end. Otherwise, the
  /// result contains both ranges, unmerged.
  ///
  /// The result is ordered according to [DateTimeRange.compareTo].
  @useResult
  static SplayTreeSet<DateTimeRange> join(
    DateTimeRange dtr1,
    DateTimeRange dtr2,
  ) {
    if (dtr1.overlapsOrTouches(dtr2)) {
      return SplayTreeSet<DateTimeRange>()..add(
        DateTimeRange._(
          minDateTime(dtr1.start, dtr2.start),
          maxDateTime(dtr1.end, dtr2.end),
        ),
      );
    }
    return SplayTreeSet<DateTimeRange>()
      ..add(dtr1)
      ..add(dtr2);
  }

  /// Merges overlapping or adjacent ranges into a consolidated set.
  ///
  /// Takes a collection of [DateTimeRange] objects and combines them if they
  /// overlap or are immediately adjacent to each other. Returns a
  /// [SplayTreeSet] containing the merged ranges in ascending order.
  ///
  /// Returns an empty set if no ranges are provided.
  @useResult
  static SplayTreeSet<DateTimeRange> merge(Iterable<DateTimeRange> ranges) {
    if (ranges.isEmpty) {
      return SplayTreeSet<DateTimeRange>();
    }
    final sorted = List<DateTimeRange>.of(ranges)..sort();
    final merged = SplayTreeSet<DateTimeRange>();
    DateTimeRange current = sorted.first;
    for (var i = 1; i < sorted.length; i++) {
      final DateTimeRange next = sorted[i];
      if (current.overlapsOrTouches(next)) {
        current = DateTimeRange._(
          current.start,
          maxDateTime(current.end, next.end),
        );
      } else {
        merged.add(current);
        current = next;
      }
    }
    merged.add(current);
    return merged;
  }

  /// Parses [formattedString] like [DateTimeRange.parse], but returns `null`
  /// instead of throwing when it is not a valid range.
  @useResult
  static DateTimeRange? tryParse(String formattedString) {
    if (formattedString.trim().split('|') case [
      final String start,
      final String end,
    ]) {
      if ((DateTime.tryParse(start), DateTime.tryParse(end)) case (
        final DateTime start,
        final DateTime end,
      )) {
        return DateTimeRange(start, end);
      }
    }
    return null;
  }
}
