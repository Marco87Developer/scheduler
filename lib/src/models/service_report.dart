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
/// Important:
///
/// * Check that [bibleStudies] >= 0.
/// * Check that [hours] is either `null` or >= 0.
/// * Check that 1 <= [month] <= 12.
/// * Check that [year] >= 0.
@immutable
class ServiceReport({
  required int month,
  required bool sharedMinistry,

  /// The year.
  required final int year,

  /// Comments.
  final String comments = '',

  /// The number of *different* Bible studies conducted.
  final int bibleStudies = 0,

  /// The hour credit.
  final HourCredit? hourCredit,

  /// The number of hours (if auxiliary, regular, or special pioneer or field
  /// missionary).
  final int? hours,
}) implements Comparable<ServiceReport> {
  /// Constructs a new [ServiceReport] instance based on [json].
  ///
  /// Throws a [FormatException] if [json] is not valid JSON or does not
  /// represent a valid service report.
  factory fromJson(String json) {
    final invalid = FormatException(
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
  /// Throws a [FormatException] if a value is absent or has an invalid type.
  new fromMap(Map<String, Object?> map)
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
  /// The string has the form
  /// `<year>|<month>|<sharedMinistry>|<bibleStudies>|<hourCredit>|<hours>|<comments>`,
  /// where `<hourCredit>` is either `null` or the [HourCredit] string format.
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
  static const String className = 'ServiceReport';

  /// The month, from 1 to 12.
  final int month = (month - 1) % 12 + 1;

  /// Whether the publisher shared in any form of the ministry during the month.
  ///
  /// It is always `true` when [hours] or [bibleStudies] is positive.
  final bool sharedMinistry =
      sharedMinistry || bibleStudies > 0 || (hours != null && hours > 0);

  /// The year and month of the service report, expressed as a [DateTime].
  DateTime get date => DateTime(year, month);

  @override
  @useResult
  int get hashCode => Object.hash(
    bibleStudies,
    comments,
    hourCredit,
    hours,
    month,
    sharedMinistry,
    year,
  );

  /// Whether this service report comes before the [other].
  @useResult
  bool operator <(ServiceReport other) => compareTo(other) < 0;

  /// Whether this service report comes before or is equal to the
  /// [other].
  @useResult
  bool operator <=(ServiceReport other) => compareTo(other) <= 0;

  @override
  @useResult
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ServiceReport && compareTo(other) == 0);

  /// Whether this service report comes after the [other].
  @useResult
  bool operator >(ServiceReport other) => compareTo(other) > 0;

  /// Whether this service report comes after or is equal to the
  /// [other].
  @useResult
  bool operator >=(ServiceReport other) => compareTo(other) >= 0;

  @override
  @useResult
  int compareTo(ServiceReport other) {
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
  /// Because [hourCredit] and [hours] are nullable, they take a function that
  /// returns the new value, which makes it possible to replace them with
  /// `null`.
  @useResult
  ServiceReport copyWith({
    int? bibleStudies,
    String? comments,
    HourCredit? Function()? hourCredit,
    int? Function()? hours,
    int? month,
    bool? sharedMinistry,
    int? year,
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
  @useResult
  String toJson() => jsonEncode(toMap());

  /// Returns a map representing this instance of [ServiceReport].
  @useResult
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
  @useResult
  String toString() =>
      '$year|$month|$sharedMinistry|$bibleStudies|$hourCredit|$hours|$comments';

  /// Parses [formattedString] like [ServiceReport.parse], but returns `null`
  /// instead of throwing when it is not a valid service report.
  @useResult
  static ServiceReport? tryParse(String formattedString) {
    final List<String> properties = formattedString.trim().split('|');
    final int length = properties.length;
    final String? credit;
    switch (length) {
      case 7 when properties[4] == 'null':
        credit = null;
      case 8:
        credit = '${properties[4]}|${properties[5]}';
      case 9:
        credit = '${properties[4]}|${properties[5]}|${properties[6]}';
      default:
        return null;
    }
    final int? year = int.tryParse(properties[0]);
    final int? month = int.tryParse(properties[1]);
    final bool? sharedMinistry = bool.tryParse(properties[2]);
    final int? bibleStudies = int.tryParse(properties[3]);
    if (year == null ||
        month == null ||
        sharedMinistry == null ||
        bibleStudies == null) {
      return null;
    }
    HourCredit? hourCredit;
    if (credit != null) {
      try {
        hourCredit = HourCredit.parse(credit);
      } on FormatException {
        return null;
      }
    }
    return ServiceReport(
      bibleStudies: bibleStudies,
      comments: properties[length - 1],
      hourCredit: hourCredit,
      hours: int.tryParse(properties[length - 2]),
      month: month,
      sharedMinistry: sharedMinistry,
      year: year,
    );
  }
}
