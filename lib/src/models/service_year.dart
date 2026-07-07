import 'package:meta/meta.dart';
import 'package:scheduler/src/exceptions/exception_messages.dart';
import 'package:scheduler/src/extensions/date_time_extension.dart';

/// A service year.
///
/// A service year runs from September 1st of one calendar year to August 31st
/// of the following calendar year.
///
@immutable
class ServiceYear implements Comparable<ServiceYear> {
  /// Constructs a new [ServiceYear] instance.
  ///
  const ServiceYear(this.startingYear);

  /// Constructs a new [ServiceYear] instance based on [reference].
  ///
  ServiceYear.fromReference(final DateTime reference)
    : this(reference.month >= firstMonth ? reference.year : reference.year - 1);

  /// Constructs a new [ServiceYear] instance from a [formattedString].
  ///
  /// Throws a [FormatException] if [formattedString] cannot be parsed as an
  /// `int`.
  ///
  factory ServiceYear.parse(final String formattedString) =>
      switch (int.tryParse(formattedString.trim())) {
        final int year => ServiceYear(year),
        null => throw FormatException(
          parseFormatExceptionMessage(className, formattedString),
          formattedString,
        ),
      };

  /// The name of the class.
  static const String className = 'ServiceYear';

  /// The first month of a service year.
  static const int firstMonth = 9;

  /// The last month of a service year.
  static const int lastMonth = 8;

  /// The year this service year starts.
  final int startingYear;

  /// The end date of this service year (exclusive upper bound).
  DateTime get end => DateTime(startingYear + 1, firstMonth);

  @override
  int get hashCode => startingYear.hashCode;

  /// The start date of this service year (inclusive).
  DateTime get start => DateTime(startingYear, firstMonth);

  /// Returns if this service year starts before the [other].
  ///
  bool operator <(final ServiceYear other) => compareTo(other) < 0;

  /// Returns if this service year starts before or at the same time as the
  /// [other].
  ///
  bool operator <=(final ServiceYear other) => compareTo(other) <= 0;

  @override
  bool operator ==(final Object other) =>
      identical(this, other) || (other is ServiceYear && compareTo(other) == 0);

  /// Returns if this service year starts after the [other].
  ///
  bool operator >(final ServiceYear other) => compareTo(other) > 0;

  /// Returns if this service year starts after or at the same time as the
  /// [other].
  ///
  bool operator >=(final ServiceYear other) => compareTo(other) >= 0;

  @override
  int compareTo(final ServiceYear other) =>
      identical(this, other) ? 0 : startingYear.compareTo(other.startingYear);

  /// Whether [reference] falls within this service year.
  ///
  /// Returns true when [reference] is on or after [start] and strictly before
  /// [end].
  ///
  bool contains(final DateTime reference) =>
      reference.isAfterOrAtSameMomentAs(start) && reference.isBefore(end);

  /// The number of months remaining in this service year, counting
  /// [reference]’s own month.
  ///
  /// Returns `null` when [reference] is outside this service year.
  ///
  int? monthsLeft(final DateTime reference) =>
      contains(reference) ? 12 - monthsPassed(reference)! : null;

  /// The number of complete months elapsed since the [start] of this service
  /// year up to (but not including) the month of [reference].
  ///
  /// Returns `null` when [reference] is outside this service year.
  ///
  int? monthsPassed(final DateTime reference) =>
      contains(reference) ? (reference.month + 12 - firstMonth) % 12 : null;

  @override
  String toString() => '$startingYear';

  /// Parses [formattedString] like [ServiceYear.parse], but returns `null`
  /// instead of throwing when [formattedString] is not a valid integer.
  ///
  static ServiceYear? tryParse(final String formattedString) {
    final int? year = int.tryParse(formattedString.trim());
    return year != null ? ServiceYear(year) : null;
  }
}
