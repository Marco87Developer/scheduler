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
/// The [start] and [end] dates are inclusive. This means that the [start] date
/// is included in the range and the [end] date is also included in the range.
///
@immutable
class DateTimeRange implements Comparable<DateTimeRange> {
  /// Constructs a new [DateTimeRange] instance from the two given dates.
  ///
  DateTimeRange(final DateTime dt1, final DateTime dt2)
    : start = minDateTime(dt1, dt2),
      end = maxDateTime(dt1, dt2);

  /// Constructs a new [DateTimeRange] instance based on [json].
  ///
  factory DateTimeRange.fromJson(final String json) {
    final Object? decoded;
    try {
      decoded = jsonDecode(json);
    } on Exception {
      throw FormatException(
        fromJsonFormatExceptionMessage(className, json),
        json,
      );
    }
    if (decoded is Map<String, Object?>) {
      try {
        return DateTimeRange.fromMap(decoded);
      } on Exception {
        throw FormatException(
          fromJsonFormatExceptionMessage(className, json),
          json,
        );
      }
    } else {
      throw FormatException(
        fromJsonFormatExceptionMessage(className, json),
        json,
      );
    }
  }

  /// Constructs a new [DateTimeRange] instance based on [map].
  ///
  DateTimeRange.fromMap(final Map<String, Object?> map)
    : this(
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

  /// Constructs a new [DateTimeRange] instance from a [formattedString].
  ///
  factory DateTimeRange.parse(final String formattedString) {
    if (formattedString.trim().split('|') case [
      final String stringStart,
      final String stringEnd,
    ]) {
      if (DateTime.tryParse(stringStart) case final DateTime start) {
        if (DateTime.tryParse(stringEnd) case final DateTime end) {
          return DateTimeRange(start, end);
        }
      }
    }
    throw FormatException(
      parseFormatExceptionMessage(className, formattedString),
      formattedString,
    );
  }

  /// Constructs a new [DateTimeRange] instance setting the fields directly when
  /// order is already guaranteed by the caller. Avoids two redundant
  /// comparisons per call site.
  ///
  const DateTimeRange._(this.start, this.end);

  /// The name of the class.
  static const String className = 'DateTimeRange';

  /// The end.
  final DateTime end;

  /// The start.
  final DateTime start;

  @override
  int get hashCode => Object.hash(end, start);

  /// Returns whether the [start] of this date time range is before the start of
  /// the [other] date time range. Or whether, in the case where the two starts
  /// are the same, the [end] of this date time range is before the end of the
  /// [other] date time range.
  ///
  bool operator <(final DateTimeRange other) => compareTo(other) < 0;

  /// Returns whether the [start] of this date time range is before the start of
  /// the [other] date time range. Or whether, in the case where the two starts
  /// are the same, the [end] of this date time range is before or coincides
  /// with the end of the [other] date time range.
  ///
  bool operator <=(final DateTimeRange other) => compareTo(other) <= 0;

  @override
  bool operator ==(final Object other) =>
      identical(this, other) || other is DateTimeRange && compareTo(other) == 0;

  /// Returns whether the [start] of this date time range is after the start of
  /// the [other] date time range. Or whether, in the case where the two starts
  /// are the same, the [end] of this date time range is after the end of the
  /// [other] date time range.
  ///
  bool operator >(final DateTimeRange other) => compareTo(other) > 0;

  /// Returns whether the [start] of this date time range is after the start of
  /// the [other] date time range. Or whether, in the case where the two starts
  /// are the same, the [end] of this date time range is after or coincides
  /// with the end of the [other] date time range.
  ///
  bool operator >=(final DateTimeRange other) => compareTo(other) >= 0;

  @override
  int compareTo(final DateTimeRange other) {
    if (identical(this, other)) {
      return 0;
    }
    return switch (start.compareTo(other.start)) {
      0 => end.compareTo(other.end),
      final int result => result,
    };
    // // 1º comparison
    // final int comparison1 = start.compareTo(other.start);
    // if (comparison1 != 0) {
    //   return comparison1;
    // }
    // // Last comparison
    // return end.compareTo(other.end);
  }

  /// Creates a copy of this [DateTimeRange] instance, but with the given fields
  /// replaced with the new values.
  ///
  DateTimeRange copyWith({final DateTime? end, final DateTime? start}) =>
      DateTimeRange(start ?? this.start, end ?? this.end);

  /// Returns if this date time range ends before or on the start of the
  /// [other].
  ///
  bool endsBeforeOrAtStart(final DateTimeRange other) =>
      end.isBefore(other.start) || end.isAtSameMomentAs(other.start);

  /// Returns if this date time range ends before the start of the [other].
  ///
  bool endsBeforeStart(final DateTimeRange other) => end.isBefore(other.start);

  /// Returns if this date time range overlaps with or touches the [other].
  ///
  bool overlapsOrTouches(final DateTimeRange other) =>
      !(start.isAfter(other.end) || end.isBefore(other.start));

  /// Returns if this date time range starts after the end of the [other].
  ///
  bool startsAfterEnds(final DateTimeRange other) => start.isAfter(other.end);

  /// Returns if this date time range starts after or on the end of the [other].
  ///
  bool startsAfterOrAtEnd(final DateTimeRange other) =>
      start.isAfter(other.end) || start.isAtSameMomentAs(other.end);

  /// Returns a JSON string representing this instance of [DateTimeRange].
  ///
  String toJson() => jsonEncode(toMap());

  /// Returns a map representing this instance of [DateTimeRange].
  ///
  Map<String, Object?> toMap() => <String, Object?>{
    _endKey: end.toIso8601String(),
    _startKey: start.toIso8601String(),
  };

  @override
  String toString() => '${start.toIso8601String()}|${end.toIso8601String()}';

  /// Returns if there are overlapping ranges within the [ranges].
  ///
  static bool areThereOverlaps(final SplayTreeSet<DateTimeRange> ranges) {
    if (ranges.length < 2) {
      return false;
    } else {
      /// Using [Iterator] is more performant because the iterators are designed
      /// for efficient sequential access and do not have the logarithmic
      /// overhead of [elementAt].
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

  /// Joins two [DateTimeRange] objects, merging them if they overlap or touch.
  ///
  /// Attempts to combine [dtr1] and [dtr2] into a single [DateTimeRange] if
  /// their temporal extents either overlap or are immediately adjacent
  /// (touching).
  ///
  /// If [dtr1] and [dtr2] overlap or touch, a new [DateTimeRange] is created
  /// that spans from the earliest start time of the two ranges to the latest
  /// end time. The result is a [SplayTreeSet] containing this single merged
  /// range.
  ///
  /// If [dtr1] and [dtr2] do not overlap and are not touching, they are
  /// considered distinct. In this scenario, the method returns a [SplayTreeSet]
  /// containing both [dtr1] and [dtr2] as separate, unmerged ranges.
  ///
  /// The returned [SplayTreeSet] guarantees that the [DateTimeRange] objects
  /// (if more than one) are ordered according to their natural comparison (in
  /// accordance with the [compareTo] method).
  ///
  static SplayTreeSet<DateTimeRange> join(
    final DateTimeRange dtr1,
    final DateTimeRange dtr2,
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

  /// Merges overlapping or adjacent [DateTimeRange] instances into a
  /// consolidated set.
  ///
  /// Takes a collection of [DateTimeRange] objects and combines them if they
  /// overlap or are immediately adjacent to each other. Returns a
  /// [SplayTreeSet] containing the merged ranges in ascending order.
  ///
  /// Returns an empty set if no ranges are provided.
  ///
  static SplayTreeSet<DateTimeRange> merge(
    final Iterable<DateTimeRange> ranges,
  ) {
    if (ranges.isEmpty) {
      return SplayTreeSet<DateTimeRange>();
    }
    final List<DateTimeRange> sorted = List<DateTimeRange>.of(ranges)..sort();
    final List<DateTimeRange> merged = <DateTimeRange>[];
    DateTimeRange current = sorted.first;
    for (int i = 1; i < sorted.length; i++) {
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
    return SplayTreeSet<DateTimeRange>.from(merged);
  }
}
