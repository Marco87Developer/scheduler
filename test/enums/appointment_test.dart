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
        () => Appointment.parse('bishop'),
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
            (final FormatException e) => e.message,
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
            (final FormatException e) => e.message,
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
            (final FormatException e) => e.source,
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
      final List<Appointment> sorted = List<Appointment>.from(
        Appointment.values,
      )..sort((final Appointment a, final Appointment b) => a.compareTo(b));
      expect(sorted.first, equals(Appointment.elder));
    });

    test('ministerialservant is the maximum value', () {
      final List<Appointment> sorted = List<Appointment>.from(
        Appointment.values,
      )..sort((final Appointment a, final Appointment b) => a.compareTo(b));
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
}
