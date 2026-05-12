import 'dart:collection' show SplayTreeSet;

import 'package:scheduler/src/exceptions/exception_messages.dart';

/// Parses a boolean value from a [map].
///
/// Accepts a [bool] value or a case-insensitive string representation (`'true'`
///  / `'false'`).
///
/// * [className]: The name of the calling class, used in exception messages.
/// * [map]: The source map.
/// * [key]: The key to look up.
///
/// Throws [FormatException] if the value is absent, not a [bool], or not a
/// valid boolean string.
///
bool parseBoolean({
  required final String className,
  required final Map<String, Object?> map,
  required final String key,
}) => switch (map[key]) {
  final bool value => value,
  final String s when s.toLowerCase() == 'true' => true,
  final String s when s.toLowerCase() == 'false' => false,
  _ => throw FormatException(
    fromMapFormatExceptionMessage(className, key),
    map,
  ),
};

/// Parses a boolean value from a [map] like [parseBoolean], but returns `null`
/// when the value is `null` or the string `'null'`.
///
bool? parseBooleanNullable({
  required final String className,
  required final Map<String, Object?> map,
  required final String key,
}) => switch (map[key]) {
  null || 'null' => null,
  final bool value => value,
  final String s when s.toLowerCase() == 'true' => true,
  final String s when s.toLowerCase() == 'false' => false,
  _ => throw FormatException(
    fromMapFormatExceptionMessage(className, key),
    map,
  ),
};

/// Parses a value of type [K] from [map] and converts it to [T] via [parser].
///
/// Extracts a value of type [K] from a [map] using the provided [key], then
/// transforms it into type [T] using the supplied [parser] function. It ensures
/// type safety by validating that the value exists and has the correct type
/// before parsing.
///
/// Parameters:
///
/// * [className]: The name of the calling class, used in exception messages.
/// * [map]: The source map.
/// * [key]: The key to look up.
/// * [parser]: Converts the raw value of type [K] to [T].
///
/// Throws [FormatException] if the value is absent, has the wrong type, or
/// [parser] throws.
///
T parseClass<T, K>({
  required final String className,
  required final Map<String, Object?> map,
  required final String key,
  required final T Function(K) parser,
}) => switch (map[key]) {
  final K value => parser(value),
  _ => throw FormatException(
    fromMapFormatExceptionMessage(className, key),
    map,
  ),
};

/// Like [parseClass], but returns `null` when the value is `null` or the string
/// `'null'`.
///
T? parseClassNullable<T, K>({
  required final String className,
  required final Map<String, Object?> map,
  required final String key,
  required final T Function(K) parser,
}) => switch (map[key]) {
  null || 'null' => null,
  final K value => parser(value),
  _ => throw FormatException(
    fromMapFormatExceptionMessage(className, key),
    map,
  ),
};

/// Parses a [double] value from a [map].
///
/// Accepts a [double] or an [int] (automatically promoted to [double]).
///
/// Throws [FormatException] if the value is absent or not numeric.
///
double parseDouble({
  required final String className,
  required final Map<String, Object?> map,
  required final String key,
}) => switch (map[key]) {
  final double value => value,
  final int value => value.toDouble(),
  _ => throw FormatException(
    fromMapFormatExceptionMessage(className, key),
    map,
  ),
};

/// Like [parseDouble], but returns `null` when the value is `null` or the
/// string `'null'`.
///
double? parseDoubleNullable({
  required final String className,
  required final Map<String, Object?> map,
  required final String key,
}) => switch (map[key]) {
  null || 'null' => null,
  final double value => value,
  final int value => value.toDouble(),
  _ => throw FormatException(
    fromMapFormatExceptionMessage(className, key),
    map,
  ),
};

/// Parses an integer value from a [map].
///
/// Extracts an integer value from a [map] using the provided [key]. It ensures
/// type safety by validating that the value exists and is of type [int].
///
/// Parameters:
///
/// * [className]: The name of the calling class, used in exception messages.
/// * [map]: The source map.
/// * [key]: The key to look up.
///
/// Throws [FormatException] if the value is absent or not an [int].
///
int parseInt({
  required final String className,
  required final Map<String, Object?> map,
  required final String key,
}) => switch (map[key]) {
  final int value => value,
  _ => throw FormatException(
    fromMapFormatExceptionMessage(className, key),
    map,
  ),
};

/// Like [parseInt], but returns `null` when the value is `null` or the string
/// `'null'`.
///
int? parseIntNullable({
  required final String className,
  required final Map<String, Object?> map,
  required final String key,
}) => switch (map[key]) {
  null || 'null' => null,
  final int value => value,
  _ => throw FormatException(
    fromMapFormatExceptionMessage(className, key),
    map,
  ),
};

/// Parses a list of [K] values from [map] and returns a [SplayTreeSet<T>].
///
/// Extracts a list from the [map], transforms each element of type [K] into
/// type [T] using the [parser], and collects them into a [SplayTreeSet]. The
/// resulting set is sorted by [T]’s natural ordering; duplicates are silently
/// dropped.
///
SplayTreeSet<T> parseObjectListToSplayTreeSet<T extends Comparable<T>, K>({
  required final String className,
  required final Map<String, Object?> map,
  required final String key,
  required final T Function(K) parser,
}) => switch (map[key]) {
  final List<Object?> list => SplayTreeSet<T>.from(
    list.map(
      (final Object? item) => switch (item) {
        final K value => parser(value),
        _ => throw FormatException(
          fromMapFormatExceptionMessage(className, key),
          map,
        ),
      },
    ),
  ),
  _ => throw FormatException(
    fromMapFormatExceptionMessage(className, key),
    map,
  ),
};

/// Like [parseObjectListToSplayTreeSet], but returns `null` when the value is
/// `null` or the string `'null'`.
///
SplayTreeSet<T>?
parseObjectListToSplayTreeSetNullable<T extends Comparable<T>, K>({
  required final String className,
  required final Map<String, Object?> map,
  required final String key,
  required final T Function(K) parser,
}) => switch (map[key]) {
  null || 'null' => null,
  final List<Object?> list => SplayTreeSet<T>.from(
    list.map(
      (final Object? item) => switch (item) {
        final K value => parser(value),
        _ => throw FormatException(
          fromMapFormatExceptionMessage(className, key),
          map,
        ),
      },
    ),
  ),
  _ => throw FormatException(
    fromMapFormatExceptionMessage(className, key),
    map,
  ),
};

/// Like [parseObjectListToSplayTreeSet], but returns an empty set instead of
/// throwing when the value is `null` or the string `'null'`.
///
SplayTreeSet<T>
parseObjectListToSplayTreeSetPossiblyEmpty<T extends Comparable<T>, K>({
  required final String className,
  required final Map<String, Object?> map,
  required final String key,
  required final T Function(K) parser,
}) => switch (map[key]) {
  null || 'null' => SplayTreeSet<T>(),
  final List<Object?> list => SplayTreeSet<T>.from(
    list.map(
      (final Object? item) => switch (item) {
        final K value => parser(value),
        _ => throw FormatException(
          fromMapFormatExceptionMessage(className, key),
          map,
        ),
      },
    ),
  ),
  _ => throw FormatException(
    fromMapFormatExceptionMessage(className, key),
    map,
  ),
};

/// Parses a list of `Map<String, Object?>` values from [map] into a
/// [SplayTreeSet<T>] using [fromMap] to construct each element.
///
/// Is designed for deserializing complex objects from nested map structures. It
/// extracts a list from the source [map], expecting each list element to be a
/// map that can be converted to type [T] using the [fromMap] constructor. The
/// results are collected into a sorted [SplayTreeSet].
///
/// Parameters:
///
/// * [className]: The name of the calling class, used in exception messages.
/// * [map]: The source map.
/// * [key]: The key to look up.
/// * [fromMap]: Constructs a [T] instance from a map.
///
/// Throws [FormatException] if the value is absent, has the wrong type, or
/// [fromMap] throws.
///
SplayTreeSet<T> parseObjectMapToSplayTreeSet<T extends Comparable<T>>({
  required final String className,
  required final Map<String, Object?> map,
  required final String key,
  required final T Function(Map<String, Object?>) fromMap,
}) => switch (map[key]) {
  final List<Object?> list => SplayTreeSet<T>.from(
    list.map(
      (final Object? item) => switch (item) {
        final Map<String, Object?> m => fromMap(m),
        _ => throw FormatException(
          fromMapFormatExceptionMessage(className, key),
          map,
        ),
      },
    ),
  ),
  _ => throw FormatException(
    fromMapFormatExceptionMessage(className, key),
    map,
  ),
};

/// Like [parseObjectMapToSplayTreeSet], but returns `null` when the value is
/// `null` or the string `'null'`.
///
SplayTreeSet<T>? parseObjectMapToSplayTreeSetNullable<T extends Comparable<T>>({
  required final String className,
  required final Map<String, Object?> map,
  required final String key,
  required final T Function(Map<String, Object?>) fromMap,
}) => switch (map[key]) {
  null || 'null' => null,
  final List<Object?> list => SplayTreeSet<T>.from(
    list.map(
      (final Object? item) => switch (item) {
        final Map<String, Object?> m => fromMap(m),
        _ => throw FormatException(
          fromMapFormatExceptionMessage(className, key),
          map,
        ),
      },
    ),
  ),
  _ => throw FormatException(
    fromMapFormatExceptionMessage(className, key),
    map,
  ),
};

/// Like [parseObjectMapToSplayTreeSet], but returns an empty set instead of
/// throwing when the value is `null` or the string `'null'`.
///
SplayTreeSet<T>
parseObjectMapToSplayTreeSetPossiblyEmpty<T extends Comparable<T>>({
  required final String className,
  required final Map<String, Object?> map,
  required final String key,
  required final T Function(Map<String, Object?>) fromMap,
}) => switch (map[key]) {
  null || 'null' => SplayTreeSet<T>(),
  final List<Object?> list => SplayTreeSet<T>.from(
    list.map(
      (final Object? item) => switch (item) {
        final Map<String, Object?> m => fromMap(m),
        _ => throw FormatException(
          fromMapFormatExceptionMessage(className, key),
          map,
        ),
      },
    ),
  ),
  _ => throw FormatException(
    fromMapFormatExceptionMessage(className, key),
    map,
  ),
};

/// Parses a [String] value from a [map].
///
/// Extracts a string value from a [map] using the provided [key]. It ensures
/// type safety by validating that the value exists and is of type [String].
///
/// Parameters:
///
/// * [className]: The name of the class in which this method is used. It is
/// used in the message of any exception that is thrown.
/// * [map]: The source map containing the value to parse.
/// * [key]: The key to look up in the map.
///
/// Throws [FormatException] if the value is absent or not a [String].
///
String parseString({
  required final String className,
  required final Map<String, Object?> map,
  required final String key,
}) => switch (map[key]) {
  final String value => value,
  _ => throw FormatException(
    fromMapFormatExceptionMessage(className, key),
    map,
  ),
};

/// Parses a [String] value from a [map] like [parseString], but returns `null`
/// when the value is `null` or the string `'null'`.
///
/// Extracts a string value from a [map] using the provided [key]. It ensures
/// type safety by validating that the value exists and is of type [String].
///
/// Parameters:
///
/// * [className]: The name of the class in which this method is used. It is
/// used in the message of any exception that is thrown.
/// * [map]: The source map containing the value to parse.
/// * [key]: The key to look up in the map.
///
/// Throws [FormatException] if the value is absent or not a [String].
///
String? parseStringNullable({
  required final String className,
  required final Map<String, Object?> map,
  required final String key,
}) => switch (map[key]) {
  null || 'null' => null,
  final String value => value,
  _ => throw FormatException(
    fromMapFormatExceptionMessage(className, key),
    map,
  ),
};
