import 'package:meta/meta.dart';

/// Extension methods on the [String] class.
extension StringExtension on String {
  /// Whitespace regular expression (with Unicode support).
  static final RegExp _whitespaceRegExp = RegExp(r'\s+', unicode: true);

  /// Returns a string obtained by replacing each sequence of one or more
  /// whitespace characters with a single space, and trimming any leading or
  /// trailing whitespace.
  ///
  /// Useful for normalizing user input where multiple consecutive spaces, tabs,
  /// or newlines should be collapsed into one.
  @useResult
  String collapseWhitespace() => trim().replaceAll(_whitespaceRegExp, ' ');

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
  @useResult
  String removeAllWhitespace() => replaceAll(_whitespaceRegExp, '');
}
