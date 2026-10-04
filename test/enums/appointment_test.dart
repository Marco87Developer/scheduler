import 'package:scheduler/src/enums/appointment.dart';
import 'package:test/test.dart';

void main() {
  group('Appointment.values', () {
    test('contains exactly two values', () {
      expect(Appointment.values, hasLength(2));
    });

    test('contains elder', () {
      expect(Appointment.values, contains(Appointment.elder));
    });

    test('contains ministerialservant', () {
      expect(Appointment.values, contains(Appointment.ministerialservant));
    });
  });

  group('Appointment.enumName', () {
    test('is "Appointment"', () {
      expect(Appointment.enumName, equals('Appointment'));
    });
  });

  group('Appointment.parse — elder', () {
    test('parses "elder"', () {
      expect(Appointment.parse('elder'), equals(Appointment.elder));
    });

    test('parses "e"', () {
      expect(Appointment.parse('e'), equals(Appointment.elder));
    });

    test('parses "Elder" (mixed case)', () {
      expect(Appointment.parse('Elder'), equals(Appointment.elder));
    });

    test('parses "ELDER" (upper case)', () {
      expect(Appointment.parse('ELDER'), equals(Appointment.elder));
    });

    test('parses "E" (upper case shorthand)', () {
      expect(Appointment.parse('E'), equals(Appointment.elder));
    });

    test('parses " elder " (surrounding whitespace)', () {
      expect(Appointment.parse(' elder '), equals(Appointment.elder));
    });

    test('parses "e l d e r" (internal whitespace)', () {
      expect(Appointment.parse('e l d e r'), equals(Appointment.elder));
    });
  });

  group('Appointment.parse — ministerialservant', () {
    test('parses "ministerialservant"', () {
      expect(
        Appointment.parse('ministerialservant'),
        equals(Appointment.ministerialservant),
      );
    });

    test('parses "ms"', () {
      expect(Appointment.parse('ms'), equals(Appointment.ministerialservant));
    });

    test('parses "MinisterialServant" (mixed case)', () {
      expect(
        Appointment.parse('MinisterialServant'),
        equals(Appointment.ministerialservant),
      );
    });

    test('parses "MINISTERIALSERVANT" (upper case)', () {
      expect(
        Appointment.parse('MINISTERIALSERVANT'),
        equals(Appointment.ministerialservant),
      );
    });

    test('parses "MS" (upper case shorthand)', () {
      expect(Appointment.parse('MS'), equals(Appointment.ministerialservant));
    });

    test('parses " ministerialservant " (surrounding whitespace)', () {
      expect(
        Appointment.parse(' ministerialservant '),
        equals(Appointment.ministerialservant),
      );
    });

    test('parses "ministerial servant" (internal whitespace)', () {
      expect(
        Appointment.parse('ministerial servant'),
        equals(Appointment.ministerialservant),
      );
    });
  });

  group('Appointment.parse — invalid input', () {
    test('throws FormatException for empty string', () {
      expect(() => Appointment.parse(''), throwsA(isA<FormatException>()));
    });

    test('throws FormatException for whitespace-only string', () {
      expect(() => Appointment.parse('   '), throwsA(isA<FormatException>()));
    });

    test('throws FormatException for unknown string', () {
      expect(
        () => Appointment.parse('string'),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws FormatException for partial match', () {
      expect(() => Appointment.parse('eld'), throwsA(isA<FormatException>()));
    });

    test('FormatException message contains the class name', () {
      expect(
        () => Appointment.parse('invalid'),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            contains('Appointment'),
          ),
        ),
      );
    });

    test('FormatException message contains the invalid string', () {
      expect(
        () => Appointment.parse('invalid'),
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
        () => Appointment.parse('invalid'),
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

  group('Appointment.compareTo', () {
    test('elder compared to itself returns 0', () {
      expect(Appointment.elder.compareTo(Appointment.elder), equals(0));
    });

    test('ministerialservant compared to itself returns 0', () {
      expect(
        Appointment.ministerialservant.compareTo(
          Appointment.ministerialservant,
        ),
        equals(0),
      );
    });

    test('elder comes before ministerialservant alphabetically', () {
      expect(
        Appointment.elder.compareTo(Appointment.ministerialservant),
        isNegative,
      );
    });

    test('ministerialservant comes after elder alphabetically', () {
      expect(
        Appointment.ministerialservant.compareTo(Appointment.elder),
        isPositive,
      );
    });
  });

  group('Appointment operator <', () {
    test('elder < ministerialservant is true', () {
      expect(Appointment.elder < Appointment.ministerialservant, isTrue);
    });

    test('ministerialservant < elder is false', () {
      expect(Appointment.ministerialservant < Appointment.elder, isFalse);
    });

    test('elder < elder is false', () {
      expect(Appointment.elder < Appointment.elder, isFalse);
    });

    test('ministerialservant < ministerialservant is false', () {
      expect(
        Appointment.ministerialservant < Appointment.ministerialservant,
        isFalse,
      );
    });
  });

  group('Appointment operator <=', () {
    test('elder <= ministerialservant is true', () {
      expect(Appointment.elder <= Appointment.ministerialservant, isTrue);
    });

    test('ministerialservant <= elder is false', () {
      expect(Appointment.ministerialservant <= Appointment.elder, isFalse);
    });

    test('elder <= elder is true', () {
      expect(Appointment.elder <= Appointment.elder, isTrue);
    });

    test('ministerialservant <= ministerialservant is true', () {
      expect(
        Appointment.ministerialservant <= Appointment.ministerialservant,
        isTrue,
      );
    });
  });

  group('Appointment operator >', () {
    test('ministerialservant > elder is true', () {
      expect(Appointment.ministerialservant > Appointment.elder, isTrue);
    });

    test('elder > ministerialservant is false', () {
      expect(Appointment.elder > Appointment.ministerialservant, isFalse);
    });

    test('elder > elder is false', () {
      expect(Appointment.elder > Appointment.elder, isFalse);
    });

    test('ministerialservant > ministerialservant is false', () {
      expect(
        Appointment.ministerialservant > Appointment.ministerialservant,
        isFalse,
      );
    });
  });

  group('Appointment operator >=', () {
    test('ministerialservant >= elder is true', () {
      expect(Appointment.ministerialservant >= Appointment.elder, isTrue);
    });

    test('elder >= ministerialservant is false', () {
      expect(Appointment.elder >= Appointment.ministerialservant, isFalse);
    });

    test('elder >= elder is true', () {
      expect(Appointment.elder >= Appointment.elder, isTrue);
    });

    test('ministerialservant >= ministerialservant is true', () {
      expect(
        Appointment.ministerialservant >= Appointment.ministerialservant,
        isTrue,
      );
    });
  });

  group('Appointment.toString', () {
    test('elder returns "elder"', () {
      expect(Appointment.elder.toString(), equals('elder'));
    });

    test('ministerialservant returns "ministerialservant"', () {
      expect(
        Appointment.ministerialservant.toString(),
        equals('ministerialservant'),
      );
    });

    test('toString is always lowercase', () {
      for (final Appointment appointment in Appointment.values) {
        expect(
          appointment.toString(),
          equals(appointment.toString().toLowerCase()),
        );
      }
    });
  });

  group('Appointment — parse/toString round-trip', () {
    test('elder survives a round-trip', () {
      expect(
        Appointment.parse(Appointment.elder.toString()),
        equals(Appointment.elder),
      );
    });

    test('ministerialservant survives a round-trip', () {
      expect(
        Appointment.parse(Appointment.ministerialservant.toString()),
        equals(Appointment.ministerialservant),
      );
    });
  });

  group('Appointment — ordering consistency', () {
    test('elder is the minimum value', () {
      final sorted = List<Appointment>.from(Appointment.values)
        ..sort((a, b) => a.compareTo(b));
      expect(sorted.first, equals(Appointment.elder));
    });

    test('ministerialservant is the maximum value', () {
      final sorted = List<Appointment>.from(Appointment.values)
        ..sort((a, b) => a.compareTo(b));
      expect(sorted.last, equals(Appointment.ministerialservant));
    });

    test('compareTo is consistent with < operator', () {
      for (final Appointment a in Appointment.values) {
        for (final Appointment b in Appointment.values) {
          expect(a < b, equals(a.compareTo(b) < 0));
        }
      }
    });

    test('compareTo is consistent with > operator', () {
      for (final Appointment a in Appointment.values) {
        for (final Appointment b in Appointment.values) {
          expect(a > b, equals(a.compareTo(b) > 0));
        }
      }
    });

    test('compareTo is consistent with <= operator', () {
      for (final Appointment a in Appointment.values) {
        for (final Appointment b in Appointment.values) {
          expect(a <= b, equals(a.compareTo(b) <= 0));
        }
      }
    });

    test('compareTo is consistent with >= operator', () {
      for (final Appointment a in Appointment.values) {
        for (final Appointment b in Appointment.values) {
          expect(a >= b, equals(a.compareTo(b) >= 0));
        }
      }
    });

    test('compareTo is antisymmetric', () {
      expect(
        Appointment.elder.compareTo(Appointment.ministerialservant).sign,
        equals(
          -Appointment.ministerialservant.compareTo(Appointment.elder).sign,
        ),
      );
    });
  });

  group('Appointment.tryParse — elder', () {
    test('returns elder for "elder"', () {
      expect(Appointment.tryParse('elder'), equals(Appointment.elder));
    });
    test('returns elder for "e"', () {
      expect(Appointment.tryParse('e'), equals(Appointment.elder));
    });
    test('returns elder for "Elder" (mixed case)', () {
      expect(Appointment.tryParse('Elder'), equals(Appointment.elder));
    });
    test('returns elder for "ELDER" (upper case)', () {
      expect(Appointment.tryParse('ELDER'), equals(Appointment.elder));
    });
    test('returns elder for "E" (upper case shorthand)', () {
      expect(Appointment.tryParse('E'), equals(Appointment.elder));
    });
    test('returns elder for "eLdEr" (alternating case)', () {
      expect(Appointment.tryParse('eLdEr'), equals(Appointment.elder));
    });
    test('returns elder for " elder " (surrounding whitespace)', () {
      expect(Appointment.tryParse(' elder '), equals(Appointment.elder));
    });
    test('returns elder for "e l d e r" (internal whitespace)', () {
      expect(Appointment.tryParse('e l d e r'), equals(Appointment.elder));
    });
    test('returns elder for tab and newline whitespace', () {
      expect(Appointment.tryParse('\t elder \n'), equals(Appointment.elder));
    });
    test('returns elder for " e " (padded shorthand)', () {
      expect(Appointment.tryParse(' e '), equals(Appointment.elder));
    });
    test('returns elder for a non-breaking space (U+00A0)', () {
      expect(Appointment.tryParse('\u00A0elder'), equals(Appointment.elder));
    });
    test('returns elder for an em space (U+2003)', () {
      expect(Appointment.tryParse('el\u2003der'), equals(Appointment.elder));
    });
  });

  group('Appointment.tryParse — ministerialservant', () {
    test('returns ministerialservant for "ministerialservant"', () {
      expect(
        Appointment.tryParse('ministerialservant'),
        equals(Appointment.ministerialservant),
      );
    });
    test('returns ministerialservant for "ms"', () {
      expect(
        Appointment.tryParse('ms'),
        equals(Appointment.ministerialservant),
      );
    });
    test('returns ministerialservant for "MinisterialServant"', () {
      expect(
        Appointment.tryParse('MinisterialServant'),
        equals(Appointment.ministerialservant),
      );
    });
    test('returns ministerialservant for "MINISTERIALSERVANT"', () {
      expect(
        Appointment.tryParse('MINISTERIALSERVANT'),
        equals(Appointment.ministerialservant),
      );
    });
    test('returns ministerialservant for "MS" (upper case shorthand)', () {
      expect(
        Appointment.tryParse('MS'),
        equals(Appointment.ministerialservant),
      );
    });
    test('returns ministerialservant for "Ms" and "mS" (mixed case)', () {
      expect(
        Appointment.tryParse('Ms'),
        equals(Appointment.ministerialservant),
      );
      expect(
        Appointment.tryParse('mS'),
        equals(Appointment.ministerialservant),
      );
    });
    test('returns ministerialservant for " ministerialservant "', () {
      expect(
        Appointment.tryParse(' ministerialservant '),
        equals(Appointment.ministerialservant),
      );
    });
    test('returns ministerialservant for "ministerial servant"', () {
      expect(
        Appointment.tryParse('ministerial servant'),
        equals(Appointment.ministerialservant),
      );
    });
    test('returns ministerialservant for "m s" (spaced shorthand)', () {
      expect(
        Appointment.tryParse('m s'),
        equals(Appointment.ministerialservant),
      );
    });
    test('returns ministerialservant for tab and newline whitespace', () {
      expect(
        Appointment.tryParse('\tministerial\nservant\r'),
        equals(Appointment.ministerialservant),
      );
    });
    test('returns ministerialservant for a non-breaking space', () {
      expect(
        Appointment.tryParse('ministerial\u00A0servant'),
        equals(Appointment.ministerialservant),
      );
    });
  });

  group('Appointment.tryParse — invalid input returns null', () {
    test('returns null for the empty string', () {
      expect(Appointment.tryParse(''), isNull);
    });
    test('returns null for a whitespace-only string', () {
      expect(Appointment.tryParse('   '), isNull);
    });
    test('returns null for a tab, newline and carriage return only', () {
      expect(Appointment.tryParse('\t\n\r'), isNull);
    });
    test('returns null for an unknown word', () {
      expect(Appointment.tryParse('string'), isNull);
    });
    test('returns null for a prefix of "elder"', () {
      expect(Appointment.tryParse('eld'), isNull);
    });
    test('returns null for a prefix of "ministerialservant"', () {
      expect(Appointment.tryParse('ministerial'), isNull);
    });
    test('returns null for a suffix of "ministerialservant"', () {
      expect(Appointment.tryParse('servant'), isNull);
    });
    test('returns null for a single "m" and a single "s"', () {
      expect(Appointment.tryParse('m'), isNull);
      expect(Appointment.tryParse('s'), isNull);
    });
    test('returns null for "sm" (reversed abbreviation)', () {
      expect(Appointment.tryParse('sm'), isNull);
    });
    test('returns null for "elders" (extra trailing letter)', () {
      expect(Appointment.tryParse('elders'), isNull);
    });
    test('returns null for "ee" (repeated abbreviation)', () {
      expect(Appointment.tryParse('ee'), isNull);
    });
    test('returns null for "e,ms" (two values at once)', () {
      expect(Appointment.tryParse('e,ms'), isNull);
    });
    test('returns null for "e." (trailing punctuation)', () {
      expect(Appointment.tryParse('e.'), isNull);
    });
    test('returns null for a numeric string', () {
      expect(Appointment.tryParse('1'), isNull);
    });
    test('returns null for the string "null"', () {
      expect(Appointment.tryParse('null'), isNull);
    });
    test('returns null for a qualified enum name', () {
      expect(Appointment.tryParse('Appointment.elder'), isNull);
    });
    test('returns null for an accented letter', () {
      expect(Appointment.tryParse('\u00E9lder'), isNull);
    });
    test('returns null when a zero-width space (U+200B) is present', () {
      // U+200B is not whitespace for `\s`, so it is not stripped.
      expect(Appointment.tryParse('\u200Belder'), isNull);
      expect(Appointment.tryParse('el\u200Bder'), isNull);
    });
    test('returns null for a very long string', () {
      expect(Appointment.tryParse('e' * 10000), isNull);
    });
  });

  group('Appointment.tryParse — never throws', () {
    test('does not throw for any of a set of awkward inputs', () {
      final inputs = <String>[
        '',
        ' ',
        '\n',
        'string',
        'elder!',
        '\u0000',
        '\uFFFF',
        '😀',
        'e' * 10000,
      ];
      for (final input in inputs) {
        expect(
          () => Appointment.tryParse(input),
          returnsNormally,
          reason: '"$input" must not throw',
        );
      }
    });
  });

  group('Appointment.tryParse — result type', () {
    test('returns an Appointment for valid input', () {
      expect(Appointment.tryParse('e'), isA<Appointment>());
    });
    test('returns the canonical (identical) enum instance', () {
      expect(
        identical(Appointment.tryParse('elder'), Appointment.elder),
        isTrue,
      );
      expect(
        identical(Appointment.tryParse('ms'), Appointment.ministerialservant),
        isTrue,
      );
    });
    test('different valid inputs for different values are distinct', () {
      expect(
        Appointment.tryParse('e'),
        isNot(equals(Appointment.tryParse('ms'))),
      );
    });
    test('every alias for the same value yields the same instance', () {
      const elderAliases = <String>['elder', 'e', 'E', ' ELDER '];
      for (final alias in elderAliases) {
        expect(Appointment.tryParse(alias), same(Appointment.elder));
      }
    });
  });

  group('Appointment.tryParse — consistency with parse', () {
    test('equals parse for every valid input', () {
      const inputs = <String>[
        'elder',
        'e',
        'E',
        ' Elder ',
        'e l d e r',
        'ministerialservant',
        'ms',
        'MS',
        'ministerial servant',
      ];
      for (final input in inputs) {
        expect(
          Appointment.tryParse(input),
          equals(Appointment.parse(input)),
          reason: '"$input" should parse identically',
        );
      }
    });
    test('returns null exactly where parse throws FormatException', () {
      const inputs = <String>['', '   ', 'string', 'eld', 'servant', 'sm', '1'];
      for (final input in inputs) {
        expect(Appointment.tryParse(input), isNull, reason: '"$input"');
        expect(
          () => Appointment.parse(input),
          throwsA(isA<FormatException>()),
          reason: '"$input"',
        );
      }
    });
  });

  group('Appointment.tryParse — round-trip', () {
    test('tryParse(toString()) returns the original for every value', () {
      for (final Appointment appointment in Appointment.values) {
        expect(
          Appointment.tryParse(appointment.toString()),
          equals(appointment),
          reason: '$appointment should round-trip',
        );
      }
    });
    test('tryParse(name) returns the original for every value', () {
      for (final Appointment appointment in Appointment.values) {
        expect(
          Appointment.tryParse(appointment.name),
          equals(appointment),
          reason: '${appointment.name} should round-trip',
        );
      }
    });
  });

  group('Appointment.tryParse — idempotence and purity', () {
    test('returns the same result on repeated calls', () {
      expect(Appointment.tryParse('ms'), equals(Appointment.tryParse('ms')));
      expect(
        Appointment.tryParse('nope'),
        equals(Appointment.tryParse('nope')),
      );
    });
    test('does not depend on the order of previous calls', () {
      final Appointment? first = Appointment.tryParse('e');

      /// Ignored because of the objective of this test.
      // ignore: unused_result
      Appointment.tryParse('ms');

      /// Ignored because of the objective of this test.
      // ignore: unused_result
      Appointment.tryParse('invalid');
      expect(Appointment.tryParse('e'), equals(first));
    });
  });
}
