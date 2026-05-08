import 'package:scheduler/src/exceptions/exception_messages.dart';
import 'package:scheduler/src/extensions/string_extension.dart';

/// A person’s gender.
///
enum Gender implements Comparable<Gender> {
  /// Female
  female,

  /// Male
  male;

  /// Constructs a new [Gender] instance from a [formattedString].
  ///
  factory Gender.parse(final String formattedString) {
    final String lowerNoWhiteSpaces = formattedString
        .removeAllWhitespace()
        .toLowerCase();
    return switch (lowerNoWhiteSpaces) {
      'female' || 'f' => .female,
      'male' || 'm' => .male,
      _ => throw FormatException(
        parseFormatExceptionMessage(enumName, formattedString),
        formattedString,
      ),
    };
  }

  /// The name of this enum.
  static const String enumName = 'Gender';

  /// Returns if this gender comes before the [other] in alphabetical order.
  ///
  bool operator <(covariant final Gender other) => compareTo(other) < 0;

  /// Returns if this gender comes before or is equal to the [other] in
  /// alphabetical order.
  ///
  bool operator <=(covariant final Gender other) => compareTo(other) <= 0;

  /// Returns if this gender comes after the [other] in alphabetical order.
  ///
  bool operator >(covariant final Gender other) => compareTo(other) > 0;

  /// Returns if this gender comes after or is equal to the [other] in
  /// alphabetical order.
  ///
  bool operator >=(covariant final Gender other) => compareTo(other) >= 0;

  @override
  int compareTo(covariant final Gender other) =>
      identical(this, other) ? 0 : name.compareTo(other.name);

  @override
  String toString() => name.toLowerCase();
}
