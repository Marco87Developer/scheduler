import 'package:meta/meta.dart';
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
  /// Matching ignores case and whitespace, and accepts the full name or the
  /// abbreviations `e` and `ms`.
  ///
  /// Throws a [FormatException] if [formattedString] does not match any
  /// appointment. Use [tryParse] to get `null` instead of an exception.
  factory parse(String formattedString) =>
      tryParse(formattedString) ??
      (throw FormatException(
        parseFormatExceptionMessage(enumName, formattedString),
        formattedString,
      ));

  /// The name of this enum.
  static const String enumName = 'Appointment';

  /// Whether this appointment comes before the [other] in alphabetical order.
  @useResult
  bool operator <(Appointment other) => compareTo(other) < 0;

  /// Whether this appointment comes before or is equal to the [other] in
  /// alphabetical order.
  @useResult
  bool operator <=(Appointment other) => compareTo(other) <= 0;

  /// Whether this appointment comes after the [other] in alphabetical order.
  @useResult
  bool operator >(Appointment other) => compareTo(other) > 0;

  /// Whether this appointment comes after or is equal to the [other] in
  /// alphabetical order.
  @useResult
  bool operator >=(Appointment other) => compareTo(other) >= 0;

  @override
  @useResult
  int compareTo(Appointment other) =>
      identical(this, other) ? 0 : Enum.compareByName(this, other);

  @override
  @useResult
  String toString() => name;

  /// Parses [formattedString] like [Appointment.parse], but returns `null`
  /// instead of throwing when it does not match any appointment.
  @useResult
  static Appointment? tryParse(String formattedString) =>
      switch (formattedString.removeAllWhitespace().toLowerCase()) {
        'elder' || 'e' => .elder,
        'ministerialservant' || 'ms' => .ministerialservant,
        _ => null,
      };
}
