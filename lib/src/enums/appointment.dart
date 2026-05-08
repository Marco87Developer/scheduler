import 'package:scheduler/src/exceptions/exception_messages.dart';
import 'package:scheduler/src/extensions/string_extension.dart';

/// The appointment that a brother can have.
///
enum Appointment implements Comparable<Appointment> {
  /// Elder
  elder,

  /// Ministerial Servant
  ministerialservant;

  /// Constructs a new [Appointment] instance from a [formattedString].
  ///
  factory Appointment.parse(final String formattedString) {
    final String lowerNoWhiteSpaces = formattedString
        .removeAllWhitespace()
        .toLowerCase();
    return switch (lowerNoWhiteSpaces) {
      'elder' || 'e' => .elder,
      'ministerialservant' || 'ms' => .ministerialservant,
      _ => throw FormatException(
        parseFormatExceptionMessage(enumName, formattedString),
        formattedString,
      ),
    };
  }

  /// The name of this enum.
  static const String enumName = 'Appointment';

  /// Returns if this appointment comes before the [other] in alphabetical
  /// order.
  ///
  bool operator <(covariant final Appointment other) => compareTo(other) < 0;

  /// Returns if this appointment comes before or is equal to the [other] in
  /// alphabetical order.
  ///
  bool operator <=(covariant final Appointment other) => compareTo(other) <= 0;

  /// Returns if this appointment comes after the [other] in alphabetical
  /// order.
  ///
  bool operator >(covariant final Appointment other) => compareTo(other) > 0;

  /// Returns if this appointment comes after or is equal to the [other] in
  /// alphabetical order.
  ///
  bool operator >=(covariant final Appointment other) => compareTo(other) >= 0;

  @override
  int compareTo(covariant final Appointment other) =>
      identical(this, other) ? 0 : name.compareTo(other.name);

  @override
  String toString() => name.toLowerCase();
}
