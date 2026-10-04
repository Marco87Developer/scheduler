import 'package:meta/meta.dart';

/// Builds the message for the [FormatException] thrown when the JSON string
/// passed to a `fromJson` constructor is invalid.
///
/// The message names [classOrEnumName] and quotes [formattedString], the
/// invalid JSON string, verbatim.
@useResult
String fromJsonFormatExceptionMessage(
  String classOrEnumName,
  String formattedString,
) =>
    '$classOrEnumName.fromJson: the JSON string “$formattedString” is invalid.';

/// Builds the message for the [FormatException] thrown when a value in the map
/// passed to a `fromMap` constructor is invalid.
///
/// The message names [classOrEnumName] and the [key] whose value is invalid.
@useResult
String fromMapFormatExceptionMessage(String classOrEnumName, String key) =>
    "$classOrEnumName.fromMap: map['$key'] value is invalid.";

/// Builds the message for the [FormatException] thrown when the string passed
/// to a `parse` constructor is invalid.
///
/// The message names [classOrEnumName] and quotes [formattedString], the
/// invalid string, verbatim.
@useResult
String parseFormatExceptionMessage(
  String classOrEnumName,
  String formattedString,
) => '$classOrEnumName.parse: the string “$formattedString” is invalid.';
