/// Returns the date that comes after between [dateTime1] and [dateTime2].
///
DateTime maxDateTime(final DateTime dateTime1, final DateTime dateTime2) =>
    dateTime1.isAfter(dateTime2) ? dateTime1 : dateTime2;

/// Returns the date that comes before between [dateTime1] and [dateTime2].
///
DateTime minDateTime(final DateTime dateTime1, final DateTime dateTime2) =>
    dateTime1.isBefore(dateTime2) ? dateTime1 : dateTime2;

/// A [DateTime] extension that enhances the built-in [DateTime] class with
/// intuitive methods for comparing dates and determining temporal
/// relationships.
///
/// This extension provides type-safe, performant utilities for common date
/// comparison scenarios.
///
extension DateTimeExtension on DateTime {
  /// Returns if this date is after or at the same moment as the [other] one.
  ///
  bool isAfterOrAtSameMomentAs(final DateTime other) =>
      isAfter(other) || isAtSameMomentAs(other);

  /// Returns if this date is before or at the same moment as the [other] one.
  ///
  bool isBeforeOrAtSameMomentAs(final DateTime other) =>
      isBefore(other) || isAtSameMomentAs(other);

  /// Returns if this date is strictly between the two given dates.
  ///
  bool isBetween(final DateTime dateTime1, final DateTime dateTime2) =>
      isAfter(minDateTime(dateTime1, dateTime2)) &&
      isBefore(maxDateTime(dateTime1, dateTime2));

  /// Returns whether this date is between the two given dates or if it is at
  /// the same moment as one of them.
  ///
  bool isBetweenOrAtSameMomentAs(
    final DateTime dateTime1,
    final DateTime dateTime2,
  ) =>
      isBetween(dateTime1, dateTime2) ||
      isAtSameMomentAs(dateTime1) ||
      isAtSameMomentAs(dateTime2);
}
