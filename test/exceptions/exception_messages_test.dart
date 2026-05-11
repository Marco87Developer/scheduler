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
        equals('.parse: the string “” is invalid.'),
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
        equals('Same.parse: the string “Same” is invalid.'),
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

  // -----------------------------------------------------------------------
  // fromJsonFormatExceptionMessage
  // -----------------------------------------------------------------------

  group('fromJsonFormatExceptionMessage — return type', () {
    test('returns a String', () {
      expect(fromJsonFormatExceptionMessage('Foo', 'bar'), isA<String>());
    });
  });

  group('fromJsonFormatExceptionMessage — contains class/enum name', () {
    test('contains the class name when it is a simple word', () {
      expect(
        fromJsonFormatExceptionMessage('MyClass', 'bad'),
        contains('MyClass'),
      );
    });

    test('contains the class name when it has digits', () {
      expect(
        fromJsonFormatExceptionMessage('Vector3', 'bad'),
        contains('Vector3'),
      );
    });

    test('contains the class name when it is a single character', () {
      expect(fromJsonFormatExceptionMessage('X', 'bad'), contains('X'));
    });

    test('contains the class name when it is an empty string', () {
      expect(fromJsonFormatExceptionMessage('', 'bad'), contains(''));
    });
  });

  group('fromJsonFormatExceptionMessage — contains formatted string', () {
    test('contains the formatted string when it is a simple word', () {
      expect(fromJsonFormatExceptionMessage('MyClass', 'bad'), contains('bad'));
    });

    test('contains the formatted string when it has whitespace', () {
      expect(
        fromJsonFormatExceptionMessage('MyClass', 'hello world'),
        contains('hello world'),
      );
    });

    test('contains the formatted string when it is empty', () {
      expect(fromJsonFormatExceptionMessage('MyClass', ''), contains(''));
    });

    test('contains the formatted string with special characters', () {
      const String special = r'$pecial!@#';
      expect(
        fromJsonFormatExceptionMessage('MyClass', special),
        contains(special),
      );
    });

    test('contains the formatted string with unicode characters', () {
      const String unicode = 'caf\u00e9';
      expect(
        fromJsonFormatExceptionMessage('MyClass', unicode),
        contains(unicode),
      );
    });
  });

  group('fromJsonFormatExceptionMessage — contains ".fromJson"', () {
    test('message contains ".fromJson"', () {
      expect(
        fromJsonFormatExceptionMessage('MyClass', 'bad'),
        contains('.fromJson'),
      );
    });

    test('message starts with the class name followed by ".fromJson"', () {
      expect(
        fromJsonFormatExceptionMessage('MyClass', 'bad'),
        startsWith('MyClass.fromJson'),
      );
    });
  });

  group('fromJsonFormatExceptionMessage — contains "JSON"', () {
    test('message contains the word "JSON"', () {
      expect(
        fromJsonFormatExceptionMessage('MyClass', 'bad'),
        contains('JSON'),
      );
    });
  });

  group('fromJsonFormatExceptionMessage — exact format', () {
    test('produces the expected message for typical inputs', () {
      expect(
        fromJsonFormatExceptionMessage('Pioneer', 'foo'),
        equals('Pioneer.fromJson: the JSON string “foo” is invalid.'),
      );
    });

    test('produces the expected message for Appointment enum', () {
      expect(
        fromJsonFormatExceptionMessage('Appointment', 'foo'),
        equals('Appointment.fromJson: the JSON string “foo” is invalid.'),
      );
    });

    test('produces the expected message for Gender enum', () {
      expect(
        fromJsonFormatExceptionMessage('Gender', 'invalid'),
        equals('Gender.fromJson: the JSON string “invalid” is invalid.'),
      );
    });

    test('produces the expected message for DayOfWeek enum', () {
      expect(
        fromJsonFormatExceptionMessage('DayOfWeek', 'holiday'),
        equals('DayOfWeek.fromJson: the JSON string “holiday” is invalid.'),
      );
    });

    test('wraps the formatted string in double quotes', () {
      final String result = fromJsonFormatExceptionMessage('Foo', 'bar');
      expect(result, contains('bar'));
    });

    test('ends with a full stop', () {
      expect(fromJsonFormatExceptionMessage('Foo', 'bar'), endsWith('.'));
    });
  });

  group('fromJsonFormatExceptionMessage — edge cases', () {
    test('empty class name and empty formatted string', () {
      expect(
        fromJsonFormatExceptionMessage('', ''),
        equals('.fromJson: the JSON string “” is invalid.'),
      );
    });

    test('class name with spaces is preserved verbatim', () {
      expect(
        fromJsonFormatExceptionMessage('My Class', 'bad'),
        startsWith('My Class.fromJson'),
      );
    });

    test('formatted string with double quotes is preserved verbatim', () {
      const String quoted = '"already quoted"';
      expect(fromJsonFormatExceptionMessage('Foo', quoted), contains(quoted));
    });

    test('very long class name is preserved verbatim', () {
      final String longName = 'A' * 200;
      expect(
        fromJsonFormatExceptionMessage(longName, 'bad'),
        startsWith(longName),
      );
    });

    test('very long formatted string is preserved verbatim', () {
      final String longValue = 'b' * 200;
      expect(
        fromJsonFormatExceptionMessage('Foo', longValue),
        contains(longValue),
      );
    });

    test('class name and formatted string that are identical', () {
      expect(
        fromJsonFormatExceptionMessage('Same', 'Same'),
        equals('Same.fromJson: the JSON string “Same” is invalid.'),
      );
    });

    test('newline in formatted string is preserved verbatim', () {
      const String value = 'line1\nline2';
      expect(fromJsonFormatExceptionMessage('Foo', value), contains(value));
    });

    test('tab in formatted string is preserved verbatim', () {
      const String value = 'col1\tcol2';
      expect(fromJsonFormatExceptionMessage('Foo', value), contains(value));
    });
  });

  group('fromJsonFormatExceptionMessage — determinism', () {
    test('returns the same result on repeated calls with the same input', () {
      const String name = 'MyClass';
      const String value = 'bad';
      expect(
        fromJsonFormatExceptionMessage(name, value),
        equals(fromJsonFormatExceptionMessage(name, value)),
      );
    });

    test('different class names produce different messages', () {
      final String a = fromJsonFormatExceptionMessage('ClassA', 'bad');
      final String b = fromJsonFormatExceptionMessage('ClassB', 'bad');
      expect(a, isNot(equals(b)));
    });

    test('different formatted strings produce different messages', () {
      final String a = fromJsonFormatExceptionMessage('MyClass', 'foo');
      final String b = fromJsonFormatExceptionMessage('MyClass', 'bar');
      expect(a, isNot(equals(b)));
    });
  });

  // -----------------------------------------------------------------------
  // fromMapFormatExceptionMessage
  // -----------------------------------------------------------------------

  group('fromMapFormatExceptionMessage — return type', () {
    test('returns a String', () {
      expect(fromMapFormatExceptionMessage('Foo', 'bar'), isA<String>());
    });
  });

  group('fromMapFormatExceptionMessage — contains class/enum name', () {
    test('contains the class name when it is a simple word', () {
      expect(
        fromMapFormatExceptionMessage('MyClass', 'key'),
        contains('MyClass'),
      );
    });

    test('contains the class name when it has digits', () {
      expect(
        fromMapFormatExceptionMessage('Vector3', 'key'),
        contains('Vector3'),
      );
    });

    test('contains the class name when it is a single character', () {
      expect(fromMapFormatExceptionMessage('X', 'key'), contains('X'));
    });

    test('contains the class name when it is an empty string', () {
      expect(fromMapFormatExceptionMessage('', 'key'), contains(''));
    });
  });

  group('fromMapFormatExceptionMessage — contains key', () {
    test('contains the key when it is a simple word', () {
      expect(
        fromMapFormatExceptionMessage('MyClass', 'name'),
        contains('name'),
      );
    });

    test('contains the key when it is empty', () {
      expect(fromMapFormatExceptionMessage('MyClass', ''), contains("map['']"));
    });

    test('contains the key with special characters', () {
      const String special = r'$key!';
      expect(
        fromMapFormatExceptionMessage('MyClass', special),
        contains(special),
      );
    });

    test('contains the key with unicode characters', () {
      const String unicode = 'cl\u00e9';
      expect(
        fromMapFormatExceptionMessage('MyClass', unicode),
        contains(unicode),
      );
    });

    test('key is wrapped in single quotes inside map accessor syntax', () {
      expect(
        fromMapFormatExceptionMessage('Foo', 'myKey'),
        contains("map['myKey']"),
      );
    });
  });

  group('fromMapFormatExceptionMessage — contains ".fromMap"', () {
    test('message contains ".fromMap"', () {
      expect(
        fromMapFormatExceptionMessage('MyClass', 'key'),
        contains('.fromMap'),
      );
    });

    test('message starts with the class name followed by ".fromMap"', () {
      expect(
        fromMapFormatExceptionMessage('MyClass', 'key'),
        startsWith('MyClass.fromMap'),
      );
    });
  });

  group('fromMapFormatExceptionMessage — contains "value is invalid"', () {
    test('message contains "value is invalid"', () {
      expect(
        fromMapFormatExceptionMessage('MyClass', 'key'),
        contains('value is invalid'),
      );
    });
  });

  group('fromMapFormatExceptionMessage — exact format', () {
    test('produces the expected message for typical inputs', () {
      expect(
        fromMapFormatExceptionMessage('Pioneer', 'type'),
        equals("Pioneer.fromMap: map['type'] value is invalid."),
      );
    });

    test('produces the expected message for Appointment enum', () {
      expect(
        fromMapFormatExceptionMessage('Appointment', 'role'),
        equals("Appointment.fromMap: map['role'] value is invalid."),
      );
    });

    test('produces the expected message for Gender enum', () {
      expect(
        fromMapFormatExceptionMessage('Gender', 'gender'),
        equals("Gender.fromMap: map['gender'] value is invalid."),
      );
    });

    test('produces the expected message for DayOfWeek enum', () {
      expect(
        fromMapFormatExceptionMessage('DayOfWeek', 'day'),
        equals("DayOfWeek.fromMap: map['day'] value is invalid."),
      );
    });

    test('ends with a full stop', () {
      expect(fromMapFormatExceptionMessage('Foo', 'key'), endsWith('.'));
    });
  });

  group('fromMapFormatExceptionMessage — edge cases', () {
    test('empty class name and empty key', () {
      expect(
        fromMapFormatExceptionMessage('', ''),
        equals(".fromMap: map[''] value is invalid."),
      );
    });

    test('class name with spaces is preserved verbatim', () {
      expect(
        fromMapFormatExceptionMessage('My Class', 'key'),
        startsWith('My Class.fromMap'),
      );
    });

    test('key with single quotes is preserved verbatim', () {
      const String singleQuoteKey = "it's";
      expect(
        fromMapFormatExceptionMessage('Foo', singleQuoteKey),
        contains(singleQuoteKey),
      );
    });

    test('key with spaces is preserved verbatim', () {
      expect(
        fromMapFormatExceptionMessage('Foo', 'my key'),
        contains("map['my key']"),
      );
    });

    test('very long class name is preserved verbatim', () {
      final String longName = 'A' * 200;
      expect(
        fromMapFormatExceptionMessage(longName, 'key'),
        startsWith(longName),
      );
    });

    test('very long key is preserved verbatim', () {
      final String longKey = 'k' * 200;
      expect(fromMapFormatExceptionMessage('Foo', longKey), contains(longKey));
    });

    test('class name and key that are identical', () {
      expect(
        fromMapFormatExceptionMessage('Same', 'Same'),
        equals("Same.fromMap: map['Same'] value is invalid."),
      );
    });

    test('newline in key is preserved verbatim', () {
      const String value = 'line1\nline2';
      expect(fromMapFormatExceptionMessage('Foo', value), contains(value));
    });

    test('tab in key is preserved verbatim', () {
      const String value = 'col1\tcol2';
      expect(fromMapFormatExceptionMessage('Foo', value), contains(value));
    });
  });

  group('fromMapFormatExceptionMessage — determinism', () {
    test('returns the same result on repeated calls with the same input', () {
      const String name = 'MyClass';
      const String key = 'myKey';
      expect(
        fromMapFormatExceptionMessage(name, key),
        equals(fromMapFormatExceptionMessage(name, key)),
      );
    });

    test('different class names produce different messages', () {
      final String a = fromMapFormatExceptionMessage('ClassA', 'key');
      final String b = fromMapFormatExceptionMessage('ClassB', 'key');
      expect(a, isNot(equals(b)));
    });

    test('different keys produce different messages', () {
      final String a = fromMapFormatExceptionMessage('MyClass', 'foo');
      final String b = fromMapFormatExceptionMessage('MyClass', 'bar');
      expect(a, isNot(equals(b)));
    });
  });

  // -----------------------------------------------------------------------
  // Cross-function — distinguishability
  // -----------------------------------------------------------------------

  group('fromJsonFormatExceptionMessage vs fromMapFormatExceptionMessage'
      ' — distinguishability', () {
    test('messages with the same class name are different', () {
      expect(
        fromJsonFormatExceptionMessage('MyClass', 'v'),
        isNot(equals(fromMapFormatExceptionMessage('MyClass', 'v'))),
      );
    });

    test('fromJson message does not contain ".fromMap"', () {
      expect(
        fromJsonFormatExceptionMessage('Foo', 'bar'),
        isNot(contains('.fromMap')),
      );
    });

    test('fromMap message does not contain ".fromJson"', () {
      expect(
        fromMapFormatExceptionMessage('Foo', 'bar'),
        isNot(contains('.fromJson')),
      );
    });
  });
}
