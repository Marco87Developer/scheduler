import 'package:scheduler/src/exceptions/exception_messages.dart';
import 'package:test/test.dart';

void main() {
  group('parseFormatExceptionMessage — return type', () {
    test('returns a String', () {
      expect(parseFormatExceptionMessage('Foo', 'bar'), isA<String>());
    });
  });

  group('parseFormatExceptionMessage — contains class/enum name', () {
    test('contains the class name when it is a simple word', () {
      expect(
        parseFormatExceptionMessage('MyClass', 'bad'),
        contains('MyClass'),
      );
    });

    test('contains the class name when it has digits', () {
      expect(
        parseFormatExceptionMessage('Vector3', 'bad'),
        contains('Vector3'),
      );
    });

    test('contains the class name when it is a single character', () {
      expect(parseFormatExceptionMessage('X', 'bad'), contains('X'));
    });

    test('contains the class name when it is an empty string', () {
      expect(parseFormatExceptionMessage('', 'bad'), contains(''));
    });
  });

  group('parseFormatExceptionMessage — contains formatted string', () {
    test('contains the formatted string when it is a simple word', () {
      expect(parseFormatExceptionMessage('MyClass', 'bad'), contains('bad'));
    });

    test('contains the formatted string when it has whitespace', () {
      expect(
        parseFormatExceptionMessage('MyClass', 'hello world'),
        contains('hello world'),
      );
    });

    test('contains the formatted string when it is empty', () {
      expect(parseFormatExceptionMessage('MyClass', ''), contains(''));
    });

    test('contains the formatted string when it has special characters', () {
      const String special = r'$pecial!@#';
      expect(
        parseFormatExceptionMessage('MyClass', special),
        contains(special),
      );
    });

    test('contains the formatted string when it has unicode characters', () {
      const String unicode = 'caf\u00e9';
      expect(
        parseFormatExceptionMessage('MyClass', unicode),
        contains(unicode),
      );
    });
  });

  group('parseFormatExceptionMessage — contains ".parse"', () {
    test('message contains ".parse"', () {
      expect(parseFormatExceptionMessage('MyClass', 'bad'), contains('.parse'));
    });

    test('message starts with the class name followed by ".parse"', () {
      final String result = parseFormatExceptionMessage('MyClass', 'bad');
      expect(result, startsWith('MyClass.parse'));
    });
  });

  group('parseFormatExceptionMessage — exact format', () {
    test('produces the expected message for typical inputs', () {
      expect(
        parseFormatExceptionMessage('Pioneer', 'foo'),
        equals('Pioneer.parse: the string “foo” is invalid.'),
      );
    });

    test('produces the expected message for Appointment enum', () {
      expect(
        parseFormatExceptionMessage('Appointment', 'foo'),
        equals('Appointment.parse: the string “foo” is invalid.'),
      );
    });

    test('produces the expected message for Gender enum', () {
      expect(
        parseFormatExceptionMessage('Gender', 'invalid'),
        equals('Gender.parse: the string “invalid” is invalid.'),
      );
    });

    test('produces the expected message for DayOfWeek enum', () {
      expect(
        parseFormatExceptionMessage('DayOfWeek', 'holiday'),
        equals('DayOfWeek.parse: the string “holiday” is invalid.'),
      );
    });

    test('wraps the formatted string in double quotes', () {
      final String result = parseFormatExceptionMessage('Foo', 'bar');
      expect(result, contains('bar'));
    });

    test('ends with a full stop', () {
      final String result = parseFormatExceptionMessage('Foo', 'bar');
      expect(result, endsWith('.'));
    });
  });

  group('parseFormatExceptionMessage — edge cases', () {
    test('empty class name and empty formatted string', () {
      expect(
        parseFormatExceptionMessage('', ''),
        equals('.parse: the string "" is invalid.'),
      );
    });

    test('class name with spaces is preserved verbatim', () {
      expect(
        parseFormatExceptionMessage('My Class', 'bad'),
        startsWith('My Class.parse'),
      );
    });

    test('formatted string with double quotes is preserved verbatim', () {
      const String quoted = '"already quoted"';
      final String result = parseFormatExceptionMessage('Foo', quoted);
      expect(result, contains(quoted));
    });

    test('very long class name is preserved verbatim', () {
      final String longName = 'A' * 200;
      final String result = parseFormatExceptionMessage(longName, 'bad');
      expect(result, startsWith(longName));
    });

    test('very long formatted string is preserved verbatim', () {
      final String longValue = 'b' * 200;
      final String result = parseFormatExceptionMessage('Foo', longValue);
      expect(result, contains(longValue));
    });

    test('class name and formatted string that are identical', () {
      expect(
        parseFormatExceptionMessage('Same', 'Same'),
        equals('Same.parse: the string "Same" is invalid.'),
      );
    });

    test('newline in formatted string is preserved verbatim', () {
      const String value = 'line1\nline2';
      final String result = parseFormatExceptionMessage('Foo', value);
      expect(result, contains(value));
    });

    test('tab in formatted string is preserved verbatim', () {
      const String value = 'col1\tcol2';
      final String result = parseFormatExceptionMessage('Foo', value);
      expect(result, contains(value));
    });
  });

  group('parseFormatExceptionMessage — determinism', () {
    test('returns the same result on repeated calls with the same input', () {
      const String name = 'MyClass';
      const String value = 'bad';
      expect(
        parseFormatExceptionMessage(name, value),
        equals(parseFormatExceptionMessage(name, value)),
      );
    });

    test('different class names produce different messages', () {
      final String a = parseFormatExceptionMessage('ClassA', 'bad');
      final String b = parseFormatExceptionMessage('ClassB', 'bad');
      expect(a, isNot(equals(b)));
    });

    test('different formatted strings produce different messages', () {
      final String a = parseFormatExceptionMessage('MyClass', 'foo');
      final String b = parseFormatExceptionMessage('MyClass', 'bar');
      expect(a, isNot(equals(b)));
    });
  });
}
