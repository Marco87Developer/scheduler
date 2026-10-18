import 'package:meta/meta.dart';
import 'package:scheduler/src/exceptions/exception_messages.dart';
import 'package:scheduler/src/extensions/date_time_extension.dart';

/// A service year.
///
/// A service year runs from September 1st of one calendar year to August 31st
/// of the following calendar year.
@immutable
class const ServiceYear(
  /// The year this service year starts.
  final int startingYear,
) implements Comparable<ServiceYear> {
  /// Constructs a new [ServiceYear] instance based on [reference].
  new fromReference(DateTime reference)
    : this(reference.month >= firstMonth ? reference.year : reference.year - 1);

  /// Constructs a new [ServiceYear] instance from a [formattedString].
  ///
  /// Whitespace around [formattedString] is ignored.
  ///
  /// Throws a [FormatException] if [formattedString] cannot be parsed as an
  /// `int`. Use [tryParse] to get `null` instead of an exception.
  factory parse(String formattedString) =>
      tryParse(formattedString) ??
      (throw FormatException(
        parseFormatExceptionMessage(className, formattedString),
        formattedString,
      ));

  /// The name of the class.
  static const String className = 'ServiceYear';

  /// The first month of a service year.
  static const int firstMonth = 9;

  /// The last month of a service year.
  static const int lastMonth = 8;

  /// The end date of this service year (exclusive upper bound).
  @useResult
  DateTime get end => DateTime(startingYear + 1, firstMonth);

  @override
  int get hashCode => startingYear.hashCode;

  /// The start date of this service year (inclusive).
  @useResult
  DateTime get start => DateTime(startingYear, firstMonth);

  /// Whether this service year starts before the [other].
  @useResult
  bool operator <(ServiceYear other) => compareTo(other) < 0;

  /// Whether this service year starts before or at the same time as the
  /// [other].
  @useResult
  bool operator <=(ServiceYear other) => compareTo(other) <= 0;

  @override
  @useResult
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ServiceYear && startingYear == other.startingYear);

  /// Whether this service year starts after the [other].
  @useResult
  bool operator >(ServiceYear other) => compareTo(other) > 0;

  /// Whether this service year starts after or at the same time as the
  /// [other].
  @useResult
  bool operator >=(ServiceYear other) => compareTo(other) >= 0;

  @override
  @useResult
  int compareTo(ServiceYear other) =>
      identical(this, other) ? 0 : startingYear.compareTo(other.startingYear);

  /// Whether [reference] falls within this service year.
  ///
  /// Returns true when [reference] is on or after [start] and strictly before
  /// [end].
  @useResult
  bool contains(DateTime reference) =>
      reference.isAfterOrAtSameMomentAs(start) && reference.isBefore(end);

  /// The number of months remaining in this service year, counting the month
  /// of [reference].
  ///
  /// Returns `null` when [reference] is outside this service year.
  @useResult
  int? monthsLeft(DateTime reference) => contains(reference)
      ? DateTime.monthsPerYear - monthsPassed(reference)!
      : null;

  /// The number of complete months elapsed since the [start] of this service
  /// year up to (but not including) the month of [reference].
  ///
  /// Returns `null` when [reference] is outside this service year.
  @useResult
  int? monthsPassed(DateTime reference) => contains(reference)
      ? (reference.month + DateTime.monthsPerYear - firstMonth) %
            DateTime.monthsPerYear
      : null;

  @override
  @useResult
  String toString() => '$startingYear';

  /// Parses [formattedString] like [ServiceYear.parse], but returns `null`
  /// instead of throwing when [formattedString] is not a valid integer.
  @useResult
  static ServiceYear? tryParse(String formattedString) =>
      switch (int.tryParse(formattedString.trim())) {
        final int year => ServiceYear(year),
        null => null,
      };
}
