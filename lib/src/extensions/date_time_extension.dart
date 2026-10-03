import 'package:meta/meta.dart';

/// Returns the date that comes after between [dateTime1] and [dateTime2].
@useResult
DateTime maxDateTime(DateTime dateTime1, DateTime dateTime2) =>
    dateTime1.isAfter(dateTime2) ? dateTime1 : dateTime2;

/// Returns the date that comes before between [dateTime1] and [dateTime2].
@useResult
DateTime minDateTime(DateTime dateTime1, DateTime dateTime2) =>
    dateTime1.isBefore(dateTime2) ? dateTime1 : dateTime2;

/// A [DateTime] extension that enhances the built-in [DateTime] class with
/// intuitive methods for comparing dates and determining temporal
/// relationships.
///
/// This extension provides type-safe, performant utilities for common date
/// comparison scenarios.
extension DateTimeExtension on DateTime {
  /// Whether this date is after or at the same moment as [other].
  @useResult
  bool isAfterOrAtSameMomentAs(DateTime other) => !isBefore(other);

  /// Whether this date is before or at the same moment as [other].
  @useResult
  bool isBeforeOrAtSameMomentAs(DateTime other) => !isAfter(other);

  /// Whether this date is strictly between the two given dates.
  @useResult
  bool isBetween(DateTime dateTime1, DateTime dateTime2) =>
      (isAfter(dateTime1) && isBefore(dateTime2)) ||
      (isAfter(dateTime2) && isBefore(dateTime1));

  /// Whether this date is between the two given dates or if it is at the same
  /// moment as one of them.
  @useResult
  bool isBetweenOrAtSameMomentAs(DateTime dateTime1, DateTime dateTime2) =>
      (isAfterOrAtSameMomentAs(dateTime1) &&
          isBeforeOrAtSameMomentAs(dateTime2)) ||
      (isAfterOrAtSameMomentAs(dateTime2) &&
          isBeforeOrAtSameMomentAs(dateTime1));
}
