import 'package:scheduler/src/exceptions/exception_messages.dart';
import 'package:scheduler/src/extensions/string_extension.dart';

/// The kind of pioneering.
///
enum Pioneer implements Comparable<Pioneer> {
  /// Auxiliary
  auxiliary(30),

  /// Auxiliary Continuously
  auxiliarycontinuously(360),

  /// Regular
  regular(600);

  /// Constructs a new [Pioneer] instance.
  ///
  const Pioneer(this._duration);

  /// Constructs a new [Pioneer] instance from a [formattedString].
  ///
  factory Pioneer.parse(final String formattedString) {
    final String lowerNoWhiteSpaces = formattedString
        .removeAllWhitespace()
        .toLowerCase();
    return switch (lowerNoWhiteSpaces) {
      'auxiliary' => .auxiliary,
      'auxiliarycontinuously' => .auxiliarycontinuously,
      'regular' => .regular,
      _ => throw FormatException(
        parseFormatExceptionMessage(enumName, formattedString),
        formattedString,
      ),
    };
  }

  /// The name of this enum.
  static String enumName = Pioneer.values.first.runtimeType.toString();

  /// The duration factor.
  final int _duration;

  /// Returns if the duration of this pioneering kind is longer than the
  /// [other].
  ///
  bool operator <(covariant final Pioneer other) => compareTo(other) < 0;

  /// Returns if the duration of this pioneering kind is greater than or equal
  /// to the [other].
  ///
  bool operator <=(covariant final Pioneer other) => compareTo(other) <= 0;

  /// Returns if the duration of this pioneering kind is shorter than the
  /// [other].
  ///
  bool operator >(covariant final Pioneer other) => compareTo(other) > 0;

  /// Returns if the duration of this pioneering kind is less than or equal to
  /// the [other].
  ///
  bool operator >=(covariant final Pioneer other) => compareTo(other) >= 0;

  @override
  int compareTo(covariant final Pioneer other) =>
      identical(this, other) ? 0 : _duration.compareTo(other._duration);

  @override
  String toString() => name.toLowerCase();
}
