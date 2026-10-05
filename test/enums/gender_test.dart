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
            (e) => e.message,
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
            (e) => e.message,
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
            (e) => e.source,
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
      final sorted = List<Gender>.from(Gender.values)
        ..sort((a, b) => a.compareTo(b));
      expect(sorted.first, equals(Gender.female));
    });

    test('male is the maximum value', () {
      final sorted = List<Gender>.from(Gender.values)
        ..sort((a, b) => a.compareTo(b));
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

  group('Gender.tryParse — female', () {
    test('returns female for "female"', () {
      expect(Gender.tryParse('female'), equals(Gender.female));
    });
    test('returns female for "f"', () {
      expect(Gender.tryParse('f'), equals(Gender.female));
    });
    test('returns female for "Female" (title case)', () {
      expect(Gender.tryParse('Female'), equals(Gender.female));
    });
    test('returns female for "FEMALE" (upper case)', () {
      expect(Gender.tryParse('FEMALE'), equals(Gender.female));
    });
    test('returns female for "F" (upper case shorthand)', () {
      expect(Gender.tryParse('F'), equals(Gender.female));
    });
    test('returns female for "fEmAlE" (alternating case)', () {
      expect(Gender.tryParse('fEmAlE'), equals(Gender.female));
    });
    test('returns female for " female " (surrounding whitespace)', () {
      expect(Gender.tryParse(' female '), equals(Gender.female));
    });
    test('returns female for "f e m a l e" (internal whitespace)', () {
      expect(Gender.tryParse('f e m a l e'), equals(Gender.female));
    });
    test('returns female for " f " (padded shorthand)', () {
      expect(Gender.tryParse(' f '), equals(Gender.female));
    });
    test('returns female for tab and newline whitespace', () {
      expect(Gender.tryParse('\t female \n'), equals(Gender.female));
    });
    test('returns female for a non-breaking space (U+00A0)', () {
      expect(Gender.tryParse(' female'), equals(Gender.female));
    });
    test('returns female for an em space (U+2003)', () {
      expect(Gender.tryParse('fe male'), equals(Gender.female));
    });
  });

  group('Gender.tryParse — male', () {
    test('returns male for "male"', () {
      expect(Gender.tryParse('male'), equals(Gender.male));
    });
    test('returns male for "m"', () {
      expect(Gender.tryParse('m'), equals(Gender.male));
    });
    test('returns male for "Male" (title case)', () {
      expect(Gender.tryParse('Male'), equals(Gender.male));
    });
    test('returns male for "MALE" (upper case)', () {
      expect(Gender.tryParse('MALE'), equals(Gender.male));
    });
    test('returns male for "M" (upper case shorthand)', () {
      expect(Gender.tryParse('M'), equals(Gender.male));
    });
    test('returns male for "mAlE" (alternating case)', () {
      expect(Gender.tryParse('mAlE'), equals(Gender.male));
    });
    test('returns male for " male " (surrounding whitespace)', () {
      expect(Gender.tryParse(' male '), equals(Gender.male));
    });
    test('returns male for "m a l e" (internal whitespace)', () {
      expect(Gender.tryParse('m a l e'), equals(Gender.male));
    });
    test('returns male for " m " (padded shorthand)', () {
      expect(Gender.tryParse(' m '), equals(Gender.male));
    });
    test('returns male for tab, newline and carriage return', () {
      expect(Gender.tryParse('\tma\nle\r'), equals(Gender.male));
    });
    test('returns male for a non-breaking space (U+00A0)', () {
      expect(Gender.tryParse('ma le'), equals(Gender.male));
    });
    test('returns male for an em space (U+2003)', () {
      expect(Gender.tryParse(' male'), equals(Gender.male));
    });
  });

  group('Gender.tryParse — invalid input returns null', () {
    test('returns null for the empty string', () {
      expect(Gender.tryParse(''), isNull);
    });
    test('returns null for a whitespace-only string', () {
      expect(Gender.tryParse('   '), isNull);
    });
    test('returns null for tab, newline and carriage return only', () {
      expect(Gender.tryParse('\t\n\r'), isNull);
    });
    test('returns null for an unknown word', () {
      expect(Gender.tryParse('invalid'), isNull);
    });
    test('returns null for a prefix of "female"', () {
      expect(Gender.tryParse('fem'), isNull);
    });
    test('returns null for a prefix of "male"', () {
      expect(Gender.tryParse('ma'), isNull);
    });
    test('returns null for a suffix of "female"', () {
      expect(Gender.tryParse('emale'), isNull);
    });
    test('returns null for "females" (extra trailing letter)', () {
      expect(Gender.tryParse('females'), isNull);
    });
    test('returns null for "males" (extra trailing letter)', () {
      expect(Gender.tryParse('males'), isNull);
    });
    test('returns null for "ff" and "mm" (repeated abbreviation)', () {
      expect(Gender.tryParse('ff'), isNull);
      expect(Gender.tryParse('mm'), isNull);
    });
    test('returns null for "fm" and "mf" (two values at once)', () {
      expect(Gender.tryParse('fm'), isNull);
      expect(Gender.tryParse('mf'), isNull);
    });
    test('returns null for "f,m" (separated values)', () {
      expect(Gender.tryParse('f,m'), isNull);
    });
    test('returns null for "f." (trailing punctuation)', () {
      expect(Gender.tryParse('f.'), isNull);
    });
    test('returns null for a numeric string', () {
      expect(Gender.tryParse('1'), isNull);
    });
    test('returns null for the string "null"', () {
      expect(Gender.tryParse('null'), isNull);
    });
    test('returns null for a qualified enum name', () {
      expect(Gender.tryParse('Gender.female'), isNull);
    });
    test('returns null for an accented letter', () {
      expect(Gender.tryParse('fémale'), isNull);
    });
    test('returns null when a zero-width space (U+200B) is present', () {
      // U+200B is not whitespace for `\s`, so it is not stripped.
      expect(Gender.tryParse('​female'), isNull);
      expect(Gender.tryParse('ma​le'), isNull);
    });
    test('returns null for a very long string', () {
      expect(Gender.tryParse('f' * 10000), isNull);
    });
  });

  group('Gender.tryParse — never throws', () {
    test('does not throw for any of a set of awkward inputs', () {
      final inputs = <String>[
        '',
        ' ',
        '\n',
        'invalid',
        'female!',
        '\u0000',
        '￿',
        '\u{1F600}',
        'f' * 10000,
      ];
      for (final input in inputs) {
        expect(
          () => Gender.tryParse(input),
          returnsNormally,
          reason: 'input of length ${input.length} must not throw',
        );
      }
    });
  });

  group('Gender.tryParse — result type', () {
    test('returns a Gender for valid input', () {
      expect(Gender.tryParse('f'), isA<Gender>());
    });
    test('returns the canonical (identical) enum instance', () {
      expect(identical(Gender.tryParse('female'), Gender.female), isTrue);
      expect(identical(Gender.tryParse('m'), Gender.male), isTrue);
    });
    test('different valid inputs for different values are distinct', () {
      expect(Gender.tryParse('f'), isNot(equals(Gender.tryParse('m'))));
    });
    test('every alias for the same value yields the same instance', () {
      const femaleAliases = <String>['female', 'f', 'F', ' FEMALE '];
      for (final alias in femaleAliases) {
        expect(Gender.tryParse(alias), same(Gender.female));
      }
      const maleAliases = <String>['male', 'm', 'M', ' MALE '];
      for (final alias in maleAliases) {
        expect(Gender.tryParse(alias), same(Gender.male));
      }
    });
  });

  group('Gender.tryParse — consistency with parse', () {
    test('equals parse for every valid input', () {
      const inputs = <String>[
        'female',
        'f',
        'F',
        ' Female ',
        'f e m a l e',
        'male',
        'm',
        'M',
        ' Male ',
        'm a l e',
      ];
      for (final input in inputs) {
        expect(
          Gender.tryParse(input),
          equals(Gender.parse(input)),
          reason: '"$input" should parse identically',
        );
      }
    });
    test('returns null exactly where parse throws FormatException', () {
      const inputs = <String>['', '   ', 'invalid', 'fem', 'ma'];
      for (final input in inputs) {
        expect(Gender.tryParse(input), isNull, reason: '"$input"');
        expect(
          () => Gender.parse(input),
          throwsA(isA<FormatException>()),
          reason: '"$input"',
        );
      }
    });
  });

  group('Gender.tryParse — round-trip', () {
    test('tryParse(toString()) returns the original for every value', () {
      for (final Gender gender in Gender.values) {
        expect(
          Gender.tryParse(gender.toString()),
          equals(gender),
          reason: '$gender should round-trip',
        );
      }
    });
    test('tryParse(name) returns the original for every value', () {
      for (final Gender gender in Gender.values) {
        expect(
          Gender.tryParse(gender.name),
          equals(gender),
          reason: '${gender.name} should round-trip',
        );
      }
    });
  });

  group('Gender.tryParse — idempotence and purity', () {
    test('returns the same result on repeated calls', () {
      expect(Gender.tryParse('m'), equals(Gender.tryParse('m')));
      expect(Gender.tryParse('nope'), equals(Gender.tryParse('nope')));
    });
    test('does not depend on the order of previous calls', () {
      final Gender? first = Gender.tryParse('f');
      final Gender? second = Gender.tryParse('m');
      final Gender? third = Gender.tryParse('invalid');
      expect(second, equals(Gender.male));
      expect(third, isNull);
      expect(Gender.tryParse('f'), equals(first));
    });
  });
}
