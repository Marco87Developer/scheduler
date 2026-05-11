/// Returns a string with the message to use in the [FormatException] thrown
/// when the JSON string passed to the `fromJson` constructor is invalid.
///
String fromJsonFormatExceptionMessage(
  final String classOrEnumName,
  final String formattedString,
) =>
    '$classOrEnumName.fromJson: the JSON string “$formattedString” is invalid.';

/// Returns a string with the message to use in the [FormatException] thrown
/// when the map value passed to the `fromMap` constructor is invalid.
///
String fromMapFormatExceptionMessage(
  final String classOrEnumName,
  final String key,
) => "$classOrEnumName.fromMap: map['$key'] value is invalid.";

/// Returns a string with the message to use in the [FormatException] thrown
/// when the string passed to the `parse` constructor is invalid.
///
String parseFormatExceptionMessage(
  final String classOrEnumName,
  final String formattedString,
) => '$classOrEnumName.parse: the string “$formattedString” is invalid.';
