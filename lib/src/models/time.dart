import 'package:meta/meta.dart';
import 'package:scheduler/src/exceptions/exception_messages.dart';
import 'package:scheduler/src/extensions/string_extension.dart';

/// A time, identified by: [hours], [minutes] and [seconds].
///
@immutable
class Time implements Comparable<Time> {
  /// Constructs a new [Time] instance from the supplied [hours], [minutes], and
  /// [seconds].
  ///
  /// The constructor will correctly calculate the hours, minutes and seconds,
  /// ensuring that the time remains within 24 hours.
  ///
  const Time([
    final int hours = 0,
    final int minutes = 0,
    final int seconds = 0,
  ]) : _secondsSinceMidnight =
           (hours * secondsPerHour + minutes * secondsPerMinute + seconds) %
           secondsPerDay;

  /// Constructs a new [Time] instance from [dateTime].
  ///
  factory Time.fromDateTime(final DateTime dateTime) =>
      Time(dateTime.hour, dateTime.minute, dateTime.second);

  /// Constructs a new [Time] instance from the [duration].
  ///
  factory Time.fromDuration(final Duration duration) =>
      Time.fromSeconds(duration.inSeconds);

  /// Constructs a new [Time] instance from the amount of [minutes].
  ///
  factory Time.fromMinutes(final num minutes) =>
      Time.fromSeconds(minutes * secondsPerMinute);

  /// Constructs a new [Time] instance from the amount of [seconds].
  ///
  Time.fromSeconds(final num seconds)
    : _secondsSinceMidnight = seconds.round() % secondsPerDay;

  /// Constructs a new [Time] instance from a [formattedString].
  ///
  /// The expected format of the [formattedString] is:
  ///
  /// * `[Thh:mm:ss]`, or
  /// * `[Thh:mm]`, or
  /// * `[hh:mm:ss]`, or
  /// * `[hh:mm]`.
  ///
  factory Time.parse(final String formattedString) {
    final Time? result = tryParse(formattedString);
    if (result == null) {
      throw FormatException(
        parseFormatExceptionMessage(className, formattedString),
        formattedString,
      );
    }
    return result;
  }

  /// The name of the class.
  static const String className = 'Time';

  /// The number of hours per day.
  static const int hoursPerDay = 24;

  /// The number of minutes per day.
  static const int minutesPerDay = 1440;

  /// The number of minutes per hour.
  static const int minutesPerHour = 60;

  /// The number of seconds per day.
  static const int secondsPerDay = 86400;

  /// The number of seconds per hour.
  static const int secondsPerHour = 3600;

  /// The number of seconds per minute.
  static const int secondsPerMinute = 60;

  /// Internal storage of total seconds elapsed since midnight.
  final int _secondsSinceMidnight;

  @override
  int get hashCode => _secondsSinceMidnight.hashCode;

  /// The hours.
  int get hours => _secondsSinceMidnight ~/ secondsPerHour;

  /// Expresses this time in hours.
  int get inHours => minutes >= 30 ? (hours + 1) % hoursPerDay : hours;

  /// Expresses this time in seconds.
  int get inSeconds => _secondsSinceMidnight;

  /// The minutes.
  int get minutes => (_secondsSinceMidnight % secondsPerHour) ~/ minutesPerHour;

  /// The seconds.
  int get seconds => _secondsSinceMidnight % secondsPerMinute;

  /// Returns the time resulting from the multiplication of this time and the
  /// [number].
  ///
  Time operator *(final num number) =>
      Time.fromSeconds(_secondsSinceMidnight * number);

  /// Returns the time resulting from the sum of this time and the [other] time.
  ///
  Time operator +(final Time other) =>
      Time.fromSeconds(_secondsSinceMidnight + other.inSeconds);

  /// Returns the time resulting from the difference between this time and the
  /// [other] time.
  ///
  Time operator -(final Time other) =>
      Time.fromSeconds(_secondsSinceMidnight - other.inSeconds);

  /// Returns the time resulting from the division between this time and the
  /// [number].
  ///
  Time operator /(final num number) =>
      Time.fromSeconds(_secondsSinceMidnight / number);

  /// Returns if this time is earlier than the [other].
  ///
  bool operator <(final Time other) => isBefore(other);

  /// Returns if this time is earlier than or equal to the [other].
  ///
  bool operator <=(final Time other) => isBeforeOrEqual(other);

  @override
  bool operator ==(final Object other) =>
      identical(this, other) || (other is Time && compareTo(other) == 0);

  /// Returns if this time is later than the [other].
  ///
  bool operator >(final Time other) => isAfter(other);

  /// Returns if this time is later than or equal to the [other].
  ///
  bool operator >=(final Time other) => isAfterOrEqual(other);

  @override
  int compareTo(final Time other) => identical(this, other)
      ? 0
      : _secondsSinceMidnight.compareTo(other._secondsSinceMidnight);

  /// Creates a copy of this [Time] instance, but with the given fields replaced
  /// with the new values.
  ///
  Time copyWith({final int? hours, final int? minutes, final int? seconds}) =>
      Time(
        hours ?? this.hours,
        minutes ?? this.minutes,
        seconds ?? this.seconds,
      );

  /// Returns the difference as [Duration] between this and the [other] time.
  ///
  Duration difference(final Time other) {
    final int d = _secondsSinceMidnight - other._secondsSinceMidnight;
    return Duration(seconds: d);
  }

  /// Returns if this time is after the [other].
  ///
  bool isAfter(final Time other) =>
      _secondsSinceMidnight > other._secondsSinceMidnight;

  /// Returns whether this time is after or the same as the [other].
  ///
  bool isAfterOrEqual(final Time other) =>
      _secondsSinceMidnight >= other._secondsSinceMidnight;

  /// Returns if this time is before the [other].
  ///
  bool isBefore(final Time other) =>
      _secondsSinceMidnight < other._secondsSinceMidnight;

  /// Returns whether this time is before or the same as the [other].
  ///
  bool isBeforeOrEqual(final Time other) =>
      _secondsSinceMidnight <= other._secondsSinceMidnight;

  /// Converts this time to a [Duration] since midnight.
  ///
  Duration toDuration() => Duration(seconds: _secondsSinceMidnight);

  @override
  String toString() {
    final String formattedH = _timeComponentToString(hours);
    final String formattedM = _timeComponentToString(minutes);
    final String formattedS = _timeComponentToString(seconds);
    return 'T$formattedH:$formattedM:$formattedS';
  }

  /// Returns a string representation of this time in the format “hh:mm”.
  ///
  String toStringHHMM() {
    final int totalMinutes = (_secondsSinceMidnight + 30) ~/ secondsPerMinute;
    final int displayHours = (totalMinutes ~/ minutesPerHour) % hoursPerDay;
    final int displayMinutes = totalMinutes % minutesPerHour;
    final String formattedHours = _timeComponentToString(displayHours);
    final String formattedMinutes = _timeComponentToString(displayMinutes);
    return '$formattedHours:$formattedMinutes';
  }

  /// Returns a string representation of this time in the format “h:mm”.
  ///
  String toStringHMM() {
    final int totalMinutes = (_secondsSinceMidnight + 30) ~/ secondsPerMinute;
    final int displayHours = (totalMinutes ~/ minutesPerHour) % hoursPerDay;
    final int displayMinutes = totalMinutes % minutesPerHour;
    final String formattedMinutes = _timeComponentToString(displayMinutes);
    return '$displayHours:$formattedMinutes';
  }

  /// Returns a string representation of this time in the format “mm:ss”.
  ///
  String toStringMMSS() {
    final String formattedMinutes = _timeComponentToString(minutes);
    final String formattedSeconds = _timeComponentToString(seconds);
    return '$formattedMinutes:$formattedSeconds';
  }

  /// Write the time component in at least two-digit format.
  ///
  /// If the number was a single digit, it would add a “0” to the left of the
  /// number.
  ///
  String _timeComponentToString(final int timeComponent) =>
      timeComponent.toString().padLeft(2, '0');

  /// Returns the later time of [t1] and [t2].
  ///
  static Time max(final Time t1, final Time t2) => t1.isAfter(t2) ? t1 : t2;

  /// Returns the earlier time of [t1] and [t2].
  ///
  static Time min(final Time t1, final Time t2) => t1.isBefore(t2) ? t1 : t2;

  /// Safely parses a [formattedString] into a [Time] instance, returning `null`
  /// if the format is invalid.
  ///
  static Time? tryParse(final String formattedString) {
    final String noWhiteSpaces = formattedString.removeAllWhitespace();
    final List<String> timeComponents = noWhiteSpaces.startsWith('T')
        ? noWhiteSpaces.substring(1).split(':')
        : noWhiteSpaces.split(':');
    if (timeComponents.isEmpty || timeComponents.length > 3) {
      return null;
    }
    final List<int> components = <int>[];
    for (final String timeComponent in timeComponents) {
      final int? t = int.tryParse(timeComponent);
      if (t == null) {
        return null;
      }
      components.add(t);
    }
    return switch (components) {
      [final int h, final int m] => Time(h, m),
      [final int h, final int m, final int s] => Time(h, m, s),
      _ => null,
    };
  }
}
