/// Extension methods on the [String] class.
///
extension StringExtension on String {
  /// Whitespace regular expression
  static final RegExp _whitespaceRegExp = RegExp(r'\s+');

  /// Returns a string obtained by removing all whitespace characters from this
  /// string.
  ///
  /// Removes all types of whitespace, including
  ///
  /// * spaces,
  /// * tabs,
  /// * newlines,
  /// * and other Unicode whitespace characters
  ///
  /// by replacing them with an empty string.
  ///
  /// Uses a regular expression `\s+` that matches one or more consecutive
  /// whitespace characters, ensuring efficient removal of whitespace sequences.
  ///
  String removeAllWhitespace() => replaceAll(_whitespaceRegExp, '');
}
