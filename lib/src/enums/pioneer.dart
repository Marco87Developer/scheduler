import 'package:meta/meta.dart';
import 'package:scheduler/src/exceptions/exception_messages.dart';
import 'package:scheduler/src/extensions/string_extension.dart';

/// The kind of pioneering.
///
/// The values are ordered by duration, from the shortest to the longest.
enum Pioneer(
  /// The duration factor.
  final int _duration,
) implements Comparable<Pioneer> {
  /// Auxiliary
  auxiliary(30),

  /// Auxiliary Continuously
  auxiliarycontinuously(360),

  /// Regular
  regular(600);

  /// Constructs a new [Pioneer] instance from a [formattedString].
  ///
  /// Matching ignores case and whitespace.
  ///
  /// Throws a [FormatException] if [formattedString] does not match any
  /// pioneering kind. Use [tryParse] to get `null` instead of an exception.
  factory parse(String formattedString) =>
      tryParse(formattedString) ??
      (throw FormatException(
        parseFormatExceptionMessage(enumName, formattedString),
        formattedString,
      ));

  /// The name of this enum.
  static const String enumName = 'Pioneer';

  /// Whether the duration of this pioneering kind is shorter than the [other].
  @useResult
  bool operator <(Pioneer other) => compareTo(other) < 0;

  /// Whether the duration of this pioneering kind is less than or equal to the
  /// [other].
  @useResult
  bool operator <=(Pioneer other) => compareTo(other) <= 0;

  /// Whether the duration of this pioneering kind is longer than the [other].
  @useResult
  bool operator >(Pioneer other) => compareTo(other) > 0;

  /// Whether the duration of this pioneering kind is greater than or equal to
  /// the [other].
  @useResult
  bool operator >=(Pioneer other) => compareTo(other) >= 0;

  @override
  @useResult
  int compareTo(Pioneer other) =>
      identical(this, other) ? 0 : _duration.compareTo(other._duration);

  @override
  @useResult
  String toString() => name;

  /// Parses [formattedString] like [Pioneer.parse], but returns `null` instead
  /// of throwing when it does not match any pioneering kind.
  @useResult
  static Pioneer? tryParse(String formattedString) =>
      switch (formattedString.removeAllWhitespace().toLowerCase()) {
        'auxiliary' => .auxiliary,
        'auxiliarycontinuously' => .auxiliarycontinuously,
        'regular' => .regular,
        _ => null,
      };
}
