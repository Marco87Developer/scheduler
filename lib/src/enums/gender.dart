import 'package:meta/meta.dart';
import 'package:scheduler/src/exceptions/exception_messages.dart';
import 'package:scheduler/src/extensions/string_extension.dart';

/// A person’s gender.
enum Gender implements Comparable<Gender> {
  /// Female
  female,

  /// Male
  male;

  /// Constructs a new [Gender] instance from a [formattedString].
  ///
  /// Matching ignores case and whitespace, and accepts the full name or the
  /// abbreviations `f` and `m`.
  ///
  /// Throws a [FormatException] if [formattedString] does not match any
  /// gender. Use [tryParse] to get `null` instead of an exception.
  factory parse(String formattedString) =>
      tryParse(formattedString) ??
      (throw FormatException(
        parseFormatExceptionMessage(enumName, formattedString),
        formattedString,
      ));

  /// The name of this enum.
  static const String enumName = 'Gender';

  /// Whether this gender comes before the [other] in alphabetical order.
  @useResult
  bool operator <(Gender other) => compareTo(other) < 0;

  /// Whether this gender comes before or is equal to the [other] in
  /// alphabetical order.
  @useResult
  bool operator <=(Gender other) => compareTo(other) <= 0;

  /// Whether this gender comes after the [other] in alphabetical order.
  @useResult
  bool operator >(Gender other) => compareTo(other) > 0;

  /// Whether this gender comes after or is equal to the [other] in
  /// alphabetical order.
  @useResult
  bool operator >=(Gender other) => compareTo(other) >= 0;

  @override
  @useResult
  int compareTo(covariant Gender other) =>
      identical(this, other) ? 0 : Enum.compareByName(this, other);

  @override
  @useResult
  String toString() => name;

  /// Parses [formattedString] like [Gender.parse], but returns `null` instead
  /// of throwing when it does not match any gender.
  @useResult
  static Gender? tryParse(String formattedString) =>
      switch (formattedString.removeAllWhitespace().toLowerCase()) {
        'female' || 'f' => .female,
        'male' || 'm' => .male,
        _ => null,
      };
}
