/// Returns a string with the message to use in the [FormatException] thrown
/// when the string passed to the `parse` constructor is invalid.
///
String parseFormatExceptionMessage(
  final String classOrEnumName,
  final String formattedString,
) => '$classOrEnumName.parse: the string “$formattedString” is invalid.';
