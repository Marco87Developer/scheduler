import 'package:scheduler/src/enums/gender.dart';
import 'package:test/test.dart';

void main() {
  group('Gender.values', () {
    test('contains exactly two values', () {
      expect(Gender.values, hasLength(2));
    });

    test('contains female', () {
      expect(Gender.values, contains(Gender.female));
    });

    test('contains male', () {
      expect(Gender.values, contains(Gender.male));
    });
  });

  group('Gender.enumName', () {
    test('is "Gender"', () {
      expect(Gender.enumName, equals('Gender'));
    });
  });

  group('Gender.parse — female', () {
    test('parses "female"', () {
      expect(Gender.parse('female'), equals(Gender.female));
    });

    test('parses "f"', () {
      expect(Gender.parse('f'), equals(Gender.female));
    });

    test('parses "Female" (mixed case)', () {
      expect(Gender.parse('Female'), equals(Gender.female));
    });

    test('parses "FEMALE" (upper case)', () {
      expect(Gender.parse('FEMALE'), equals(Gender.female));
    });

    test('parses "F" (upper case shorthand)', () {
      expect(Gender.parse('F'), equals(Gender.female));
    });

    test('parses " female " (surrounding whitespace)', () {
      expect(Gender.parse(' female '), equals(Gender.female));
    });

    test('parses "f e m a l e" (internal whitespace)', () {
      expect(Gender.parse('f e m a l e'), equals(Gender.female));
    });
  });

  group('Gender.parse — male', () {
    test('parses "male"', () {
      expect(Gender.parse('male'), equals(Gender.male));
    });

    test('parses "m"', () {
      expect(Gender.parse('m'), equals(Gender.male));
    });

    test('parses "Male" (mixed case)', () {
      expect(Gender.parse('Male'), equals(Gender.male));
    });

    test('parses "MALE" (upper case)', () {
      expect(Gender.parse('MALE'), equals(Gender.male));
    });

    test('parses "M" (upper case shorthand)', () {
      expect(Gender.parse('M'), equals(Gender.male));
    });

    test('parses " male " (surrounding whitespace)', () {
      expect(Gender.parse(' male '), equals(Gender.male));
    });

    test('parses "m a l e" (internal whitespace)', () {
      expect(Gender.parse('m a l e'), equals(Gender.male));
    });
  });

  group('Gender.parse — invalid input', () {
    test('throws FormatException for empty string', () {
      expect(() => Gender.parse(''), throwsA(isA<FormatException>()));
    });

    test('throws FormatException for whitespace-only string', () {
      expect(() => Gender.parse('   '), throwsA(isA<FormatException>()));
    });

    test('throws FormatException for unknown string', () {
      expect(() => Gender.parse('nonbinary'), throwsA(isA<FormatException>()));
    });

    test('throws FormatException for partial match', () {
      expect(() => Gender.parse('fem'), throwsA(isA<FormatException>()));
    });

    test('throws FormatException for partial match of male', () {
      expect(() => Gender.parse('ma'), throwsA(isA<FormatException>()));
    });

    test('FormatException message contains the class name', () {
      expect(
        () => Gender.parse('invalid'),
        throwsA(
          isA<FormatException>().having(
            (final FormatException e) => e.message,
            'message',
            contains('Gender'),
          ),
        ),
      );
    });

    test('FormatException message contains the invalid string', () {
      expect(
        () => Gender.parse('invalid'),
        throwsA(
          isA<FormatException>().having(
            (final FormatException e) => e.message,
            'message',
            contains('invalid'),
          ),
        ),
      );
    });

    test('FormatException source is the original string', () {
      expect(
        () => Gender.parse('invalid'),
        throwsA(
          isA<FormatException>().having(
            (final FormatException e) => e.source,
            'source',
            equals('invalid'),
          ),
        ),
      );
    });
  });

  group('Gender.compareTo', () {
    test('female compared to itself returns 0', () {
      expect(Gender.female.compareTo(Gender.female), equals(0));
    });

    test('male compared to itself returns 0', () {
      expect(Gender.male.compareTo(Gender.male), equals(0));
    });

    test('female comes before male alphabetically', () {
      expect(Gender.female.compareTo(Gender.male), isNegative);
    });

    test('male comes after female alphabetically', () {
      expect(Gender.male.compareTo(Gender.female), isPositive);
    });
  });

  group('Gender operator <', () {
    test('female < male is true', () {
      expect(Gender.female < Gender.male, isTrue);
    });

    test('male < female is false', () {
      expect(Gender.male < Gender.female, isFalse);
    });

    test('female < female is false', () {
      expect(Gender.female < Gender.female, isFalse);
    });

    test('male < male is false', () {
      expect(Gender.male < Gender.male, isFalse);
    });
  });

  group('Gender operator <=', () {
    test('female <= male is true', () {
      expect(Gender.female <= Gender.male, isTrue);
    });

    test('male <= female is false', () {
      expect(Gender.male <= Gender.female, isFalse);
    });

    test('female <= female is true', () {
      expect(Gender.female <= Gender.female, isTrue);
    });

    test('male <= male is true', () {
      expect(Gender.male <= Gender.male, isTrue);
    });
  });

  group('Gender operator >', () {
    test('male > female is true', () {
      expect(Gender.male > Gender.female, isTrue);
    });

    test('female > male is false', () {
      expect(Gender.female > Gender.male, isFalse);
    });

    test('female > female is false', () {
      expect(Gender.female > Gender.female, isFalse);
    });

    test('male > male is false', () {
      expect(Gender.male > Gender.male, isFalse);
    });
  });

  group('Gender operator >=', () {
    test('male >= female is true', () {
      expect(Gender.male >= Gender.female, isTrue);
    });

    test('female >= male is false', () {
      expect(Gender.female >= Gender.male, isFalse);
    });

    test('female >= female is true', () {
      expect(Gender.female >= Gender.female, isTrue);
    });

    test('male >= male is true', () {
      expect(Gender.male >= Gender.male, isTrue);
    });
  });

  group('Gender.toString', () {
    test('female returns "female"', () {
      expect(Gender.female.toString(), equals('female'));
    });

    test('male returns "male"', () {
      expect(Gender.male.toString(), equals('male'));
    });

    test('toString is always lowercase', () {
      for (final Gender gender in Gender.values) {
        expect(gender.toString(), equals(gender.toString().toLowerCase()));
      }
    });
  });

  group('Gender — parse/toString round-trip', () {
    test('female survives a round-trip', () {
      expect(Gender.parse(Gender.female.toString()), equals(Gender.female));
    });

    test('male survives a round-trip', () {
      expect(Gender.parse(Gender.male.toString()), equals(Gender.male));
    });
  });

  group('Gender — ordering consistency', () {
    test('female is the minimum value', () {
      final List<Gender> sorted = List<Gender>.from(Gender.values)
        ..sort((final Gender a, final Gender b) => a.compareTo(b));
      expect(sorted.first, equals(Gender.female));
    });

    test('male is the maximum value', () {
      final List<Gender> sorted = List<Gender>.from(Gender.values)
        ..sort((final Gender a, final Gender b) => a.compareTo(b));
      expect(sorted.last, equals(Gender.male));
    });

    test('compareTo is consistent with < operator', () {
      for (final Gender a in Gender.values) {
        for (final Gender b in Gender.values) {
          expect(a < b, equals(a.compareTo(b) < 0));
        }
      }
    });

    test('compareTo is consistent with > operator', () {
      for (final Gender a in Gender.values) {
        for (final Gender b in Gender.values) {
          expect(a > b, equals(a.compareTo(b) > 0));
        }
      }
    });

    test('compareTo is consistent with <= operator', () {
      for (final Gender a in Gender.values) {
        for (final Gender b in Gender.values) {
          expect(a <= b, equals(a.compareTo(b) <= 0));
        }
      }
    });

    test('compareTo is consistent with >= operator', () {
      for (final Gender a in Gender.values) {
        for (final Gender b in Gender.values) {
          expect(a >= b, equals(a.compareTo(b) >= 0));
        }
      }
    });

    test('compareTo is antisymmetric', () {
      expect(
        Gender.female.compareTo(Gender.male).sign,
        equals(-Gender.male.compareTo(Gender.female).sign),
      );
    });
  });
}
