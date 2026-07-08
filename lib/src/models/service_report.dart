import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:scheduler/src/exceptions/exception_messages.dart';
import 'package:scheduler/src/helpers/from_map_helpers.dart';
import 'package:scheduler/src/models/hour_credit.dart';

const String _bibleStudiesKey = 'bibleStudies';
const String _commentsKey = 'comments';
const String _hourCreditKey = 'hourCredit';
const String _hoursKey = 'hours';
const String _monthKey = 'month';
const String _sharedMinistryKey = 'sharedMinistry';
const String _yearKey = 'year';

/// The [ServiceReport] of a publisher.
///
@immutable
class ServiceReport implements Comparable<ServiceReport> {
  /// Constructs a new [ServiceReport] instance.
  ///
  /// Important:
  ///
  /// * Check that [bibleStudies] >= 0.
  /// * Check that [hours] is either `null` or >= 0.
  /// * Check that 1 <= [month] <= 12.
  /// * Check that [year] >= 0.
  ///
  const ServiceReport({
    this.bibleStudies = 0,
    this.comments = '',
    this.hourCredit,
    this.hours,
    required final int month,
    required final bool sharedMinistry,
    required this.year,
  }) : month = month % 12 == 0 ? 12 : month % 12,
       sharedMinistry =
           (hours != null && hours > 0) || sharedMinistry || bibleStudies > 0;

  /// Constructs a new [ServiceReport] instance based on [json].
  ///
  factory ServiceReport.fromJson(final String json) {
    final FormatException invalid = FormatException(
      fromJsonFormatExceptionMessage(className, json),
      json,
    );
    final Object? decoded;
    try {
      decoded = jsonDecode(json);
    } on FormatException {
      throw invalid;
    }
    if (decoded case final Map<String, Object?> map) {
      try {
        return ServiceReport.fromMap(map);
      } on FormatException {
        throw invalid;
      }
    }
    throw invalid;
  }

  /// Constructs a new [ServiceReport] instance based on [map].
  ///
  ServiceReport.fromMap(final Map<String, Object?> map)
    : this(
        bibleStudies: parseInt(
          className: className,
          map: map,
          key: _bibleStudiesKey,
        ),
        comments: parseString(
          className: className,
          map: map,
          key: _commentsKey,
        ),
        hourCredit: parseClassNullable(
          className: className,
          map: map,
          key: _hourCreditKey,
          parser: HourCredit.parse,
        ),
        hours: parseIntNullable(className: className, map: map, key: _hoursKey),
        month: parseInt(className: className, map: map, key: _monthKey),
        sharedMinistry: parseBoolean(
          className: className,
          map: map,
          key: _sharedMinistryKey,
        ),
        year: parseInt(className: className, map: map, key: _yearKey),
      );

  /// Constructs a new [ServiceReport] instance from a [formattedString].
  ///
  factory ServiceReport.parse(final String formattedString) {
    final FormatException invalid = FormatException(
      parseFormatExceptionMessage(className, formattedString),
      formattedString,
    );
    final List<String> properties = formattedString.trim().split('|');
    try {
      return switch (properties) {
        /// Case 1: [hourCredit] is `null`
        [
          final String year,
          final String month,
          final String sharedMinistry,
          final String bibleStudies,
          'null',
          final String hours,
          final String comments,
        ] =>
          ServiceReport(
            bibleStudies: int.parse(bibleStudies),
            comments: comments,
            hours: int.tryParse(hours),
            month: int.parse(month),
            sharedMinistry: bool.parse(sharedMinistry),
            year: int.parse(year),
          ),

        /// Case 2: [hourCredit] exists but has no tags
        [
          final String year,
          final String month,
          final String sharedMinistry,
          final String bibleStudies,
          final String description,
          final String hourCreditHours,
          final String hours,
          final String comments,
        ] =>
          ServiceReport(
            bibleStudies: int.parse(bibleStudies),
            comments: comments,
            hourCredit: HourCredit.parse('$description|$hourCreditHours'),
            hours: int.tryParse(hours),
            month: int.parse(month),
            sharedMinistry: bool.parse(sharedMinistry),
            year: int.parse(year),
          ),

        /// Case 3: [hourCredit] exists and has tags
        [
          final String year,
          final String month,
          final String sharedMinistry,
          final String bibleStudies,
          final String description,
          final String hourCreditHours,
          final String tags,
          final String hours,
          final String comments,
        ] =>
          ServiceReport(
            bibleStudies: int.parse(bibleStudies),
            comments: comments,
            hourCredit: HourCredit.parse('$description|$hourCreditHours|$tags'),
            hours: int.tryParse(hours),
            month: int.parse(month),
            sharedMinistry: bool.parse(sharedMinistry),
            year: int.parse(year),
          ),
        _ => throw invalid,
      };
    } on FormatException {
      throw invalid;
    }
  }

  /// The name of the class.
  static const String className = 'ServiceReport';

  /// The number of *different* Bible studies conducted.
  final int bibleStudies;

  /// Comments.
  final String comments;

  /// The hour credit.
  final HourCredit? hourCredit;

  /// The number of hours (if auxiliary, regular, or special pioneer or field
  /// missionary).
  final int? hours;

  /// The month.
  final int month;

  /// If the publisher shared in any form of the ministry during the month.
  final bool sharedMinistry;

  /// The year.
  final int year;

  /// The year and month of the service report, but expressed as an instance of
  /// [DateTime].
  DateTime get date => DateTime(year, month);

  @override
  int get hashCode => Object.hash(
    bibleStudies,
    comments,
    hourCredit,
    hours,
    month,
    sharedMinistry,
    year,
  );

  /// Returns if this service report comes before the [other].
  ///
  bool operator <(final ServiceReport other) => compareTo(other) < 0;

  /// Returns if this service report comes before or is equal to the
  /// [other].
  ///
  bool operator <=(final ServiceReport other) => compareTo(other) <= 0;

  @override
  bool operator ==(final Object other) =>
      identical(this, other) ||
      (other is ServiceReport && compareTo(other) == 0);

  /// Returns if this service report comes after the [other].
  ///
  bool operator >(final ServiceReport other) => compareTo(other) > 0;

  /// Returns if this service report comes after or is equal to the
  /// [other].
  ///
  bool operator >=(final ServiceReport other) => compareTo(other) >= 0;

  @override
  int compareTo(final ServiceReport other) {
    if (identical(this, other)) {
      return 0;
    }
    int comparison = year.compareTo(other.year);
    if (comparison != 0) {
      return comparison;
    }
    comparison = month.compareTo(other.month);
    if (comparison != 0) {
      return comparison;
    }
    if (sharedMinistry != other.sharedMinistry) {
      return sharedMinistry ? 1 : -1;
    }
    comparison = switch ((hours, other.hours)) {
      (null, null) => 0,
      (null, _) => -1,
      (_, null) => 1,
      (final int h1, final int h2) => h1.compareTo(h2),
    };
    if (comparison != 0) {
      return comparison;
    }
    comparison = switch ((hourCredit, other.hourCredit)) {
      (null, null) => 0,
      (null, _) => -1,
      (_, null) => 1,
      (final HourCredit hc1, final HourCredit hc2) => hc1.compareTo(hc2),
    };
    if (comparison != 0) {
      return comparison;
    }
    comparison = bibleStudies.compareTo(other.bibleStudies);
    if (comparison != 0) {
      return comparison;
    }
    return comments.compareTo(other.comments);
  }

  /// Creates a copy of this [ServiceReport] instance, but with the given
  /// fields replaced with the new values.
  ///
  ServiceReport copyWith({
    final int? bibleStudies,
    final String? comments,
    final HourCredit? Function()? hourCredit,
    final int? Function()? hours,
    final int? month,
    final bool? sharedMinistry,
    final int? year,
  }) => ServiceReport(
    bibleStudies: bibleStudies ?? this.bibleStudies,
    comments: comments ?? this.comments,
    hourCredit: hourCredit != null ? hourCredit() : this.hourCredit,
    hours: hours != null ? hours() : this.hours,
    month: month ?? this.month,
    sharedMinistry: sharedMinistry ?? this.sharedMinistry,
    year: year ?? this.year,
  );

  /// Returns a JSON string representing this instance of [ServiceReport].
  ///
  String toJson() => jsonEncode(toMap());

  /// Returns a map representing this instance of [ServiceReport].
  ///
  Map<String, Object?> toMap() => <String, Object?>{
    _bibleStudiesKey: bibleStudies,
    _commentsKey: comments,
    _hourCreditKey: hourCredit?.toString(),
    _hoursKey: hours,
    _monthKey: month,
    _sharedMinistryKey: sharedMinistry,
    _yearKey: year,
  };

  @override
  String toString() =>
      '$year|$month|$sharedMinistry|$bibleStudies|$hourCredit|$hours|$comments';
}
