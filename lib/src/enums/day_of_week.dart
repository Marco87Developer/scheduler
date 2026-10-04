import 'package:scheduler/src/exceptions/exception_messages.dart';
import 'package:scheduler/src/extensions/string_extension.dart';

/// A day of the week.
enum DayOfWeek(
  /// The number of this day of the week (1 to 7).
  final int number,
) implements Comparable<DayOfWeek> {
  /// Monday
  monday(1),

  /// Tuesday
  tuesday(2),

  /// Wednesday
  wednesday(3),

  /// Thursday
  thursday(4),

  /// Friday
  friday(5),

  /// Saturday
  saturday(6),

  /// Sunday
  sunday(7);

  /// Constructs a new [DayOfWeek] instance from an integer [number].
  ///
  /// It first normalizes the input [number] to ensure that it falls within the
  /// range from 1 (monday) to 7 (sunday).
  factory fromNumber(int number) => values[(number % 7 + 6) % 7];

  /// Constructs a new [DayOfWeek] instance from a [formattedString].
  ///
  /// In addition to the full name of the day of the week, it also accepts the
  /// first 3 letters of the name of the day of the week or a string of an
  /// integer. In the latter case, it leaves the task to the
  /// [DayOfWeek.fromNumber] constructor.
  factory parse(String formattedString) =>
      tryParse(formattedString) ??
      (throw FormatException(
        parseFormatExceptionMessage(enumName, formattedString),
        formattedString,
      ));

  /// The name of this enum.
  static const String enumName = 'DayOfWeek';

  /// Whether this day of the week comes before [other] during the week.
  bool operator <(DayOfWeek other) => compareTo(other) < 0;

  /// Whether this day of the week comes before [other] during the week or if
  /// it is the same day of the week.
  bool operator <=(DayOfWeek other) => compareTo(other) <= 0;

  /// Whether this day of the week comes after [other] during the week.
  bool operator >(DayOfWeek other) => compareTo(other) > 0;

  /// Whether this day of the week comes after [other] during the week or if it
  /// is the same day of the week.
  bool operator >=(DayOfWeek other) => compareTo(other) >= 0;

  @override
  int compareTo(DayOfWeek other) =>
      identical(this, other) ? 0 : number.compareTo(other.number);

  @override
  String toString() => name;

  /// Parses [formattedString] like [DayOfWeek.parse], but returns `null`
  /// instead of throwing when it does not match any day of the week.
  static DayOfWeek? tryParse(String formattedString) {
    final String lowerNoWhiteSpaces = formattedString
        .removeAllWhitespace()
        .toLowerCase();
    return switch (lowerNoWhiteSpaces) {
      'monday' || 'mon' => .monday,
      'tuesday' || 'tue' => .tuesday,
      'wednesday' || 'wed' => .wednesday,
      'thursday' || 'thu' => .thursday,
      'friday' || 'fri' => .friday,
      'saturday' || 'sat' => .saturday,
      'sunday' || 'sun' => .sunday,
      _ => switch (int.tryParse(lowerNoWhiteSpaces)) {
        final int number => .fromNumber(number),
        null => null,
      },
    };
  }
}
