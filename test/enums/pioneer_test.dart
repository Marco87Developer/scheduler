import 'package:scheduler/src/enums/pioneer.dart';
import 'package:test/test.dart';

void main() {
  group('Pioneer.values', () {
    test('contains exactly three values', () {
      expect(Pioneer.values, hasLength(3));
    });

    test('contains auxiliary', () {
      expect(Pioneer.values, contains(Pioneer.auxiliary));
    });

    test('contains auxiliarycontinuously', () {
      expect(Pioneer.values, contains(Pioneer.auxiliarycontinuously));
    });

    test('contains regular', () {
      expect(Pioneer.values, contains(Pioneer.regular));
    });

    test('declaration order is auxiliary, auxiliarycontinuously, regular', () {
      expect(
        Pioneer.values,
        equals(<Pioneer>[
          Pioneer.auxiliary,
          Pioneer.auxiliarycontinuously,
          Pioneer.regular,
        ]),
      );
    });
  });

  group('Pioneer.enumName', () {
    test('is "Pioneer"', () {
      expect(Pioneer.enumName, equals('Pioneer'));
    });
  });

  group('Pioneer.parse — auxiliary', () {
    test('parses "auxiliary"', () {
      expect(Pioneer.parse('auxiliary'), equals(Pioneer.auxiliary));
    });

    test('parses "Auxiliary" (title case)', () {
      expect(Pioneer.parse('Auxiliary'), equals(Pioneer.auxiliary));
    });

    test('parses "AUXILIARY" (upper case)', () {
      expect(Pioneer.parse('AUXILIARY'), equals(Pioneer.auxiliary));
    });

    test('parses "aUxIlIaRy" (mixed case)', () {
      expect(Pioneer.parse('aUxIlIaRy'), equals(Pioneer.auxiliary));
    });

    test('parses " auxiliary " (surrounding whitespace)', () {
      expect(Pioneer.parse(' auxiliary '), equals(Pioneer.auxiliary));
    });

    test('parses "a u x i l i a r y" (internal whitespace)', () {
      expect(Pioneer.parse('a u x i l i a r y'), equals(Pioneer.auxiliary));
    });

    test('parses "\t auxiliary \n" (tab and newline whitespace)', () {
      expect(Pioneer.parse('\t auxiliary \n'), equals(Pioneer.auxiliary));
    });
  });

  group('Pioneer.parse — auxiliarycontinuously', () {
    test('parses "auxiliarycontinuously"', () {
      expect(
        Pioneer.parse('auxiliarycontinuously'),
        equals(Pioneer.auxiliarycontinuously),
      );
    });

    test('parses "AuxiliaryContinuously" (title case)', () {
      expect(
        Pioneer.parse('AuxiliaryContinuously'),
        equals(Pioneer.auxiliarycontinuously),
      );
    });

    test('parses "AUXILIARYCONTINUOUSLY" (upper case)', () {
      expect(
        Pioneer.parse('AUXILIARYCONTINUOUSLY'),
        equals(Pioneer.auxiliarycontinuously),
      );
    });

    test('parses "aUxIlIaRyCONTINUOUSLY" (mixed case)', () {
      expect(
        Pioneer.parse('aUxIlIaRyCONTINUOUSLY'),
        equals(Pioneer.auxiliarycontinuously),
      );
    });

    test('parses " auxiliarycontinuously " (surrounding whitespace)', () {
      expect(
        Pioneer.parse(' auxiliarycontinuously '),
        equals(Pioneer.auxiliarycontinuously),
      );
    });

    test('parses "auxiliary continuously" (internal whitespace)', () {
      expect(
        Pioneer.parse('auxiliary continuously'),
        equals(Pioneer.auxiliarycontinuously),
      );
    });

    test('parses "auxiliary  continuously" (multiple internal spaces)', () {
      expect(
        Pioneer.parse('auxiliary  continuously'),
        equals(Pioneer.auxiliarycontinuously),
      );
    });
  });

  group('Pioneer.parse — regular', () {
    test('parses "regular"', () {
      expect(Pioneer.parse('regular'), equals(Pioneer.regular));
    });

    test('parses "Regular" (title case)', () {
      expect(Pioneer.parse('Regular'), equals(Pioneer.regular));
    });

    test('parses "REGULAR" (upper case)', () {
      expect(Pioneer.parse('REGULAR'), equals(Pioneer.regular));
    });

    test('parses "rEgUlAr" (mixed case)', () {
      expect(Pioneer.parse('rEgUlAr'), equals(Pioneer.regular));
    });

    test('parses " regular " (surrounding whitespace)', () {
      expect(Pioneer.parse(' regular '), equals(Pioneer.regular));
    });

    test('parses "r e g u l a r" (internal whitespace)', () {
      expect(Pioneer.parse('r e g u l a r'), equals(Pioneer.regular));
    });

    test('parses "\t regular \n" (tab and newline whitespace)', () {
      expect(Pioneer.parse('\t regular \n'), equals(Pioneer.regular));
    });
  });

  group('Pioneer.parse — invalid input', () {
    test('throws FormatException for empty string', () {
      expect(() => Pioneer.parse(''), throwsA(isA<FormatException>()));
    });

    test('throws FormatException for whitespace-only string', () {
      expect(() => Pioneer.parse('   '), throwsA(isA<FormatException>()));
    });

    test('throws FormatException for unknown string', () {
      expect(() => Pioneer.parse('special'), throwsA(isA<FormatException>()));
    });

    test('throws FormatException for partial match of auxiliary', () {
      expect(() => Pioneer.parse('aux'), throwsA(isA<FormatException>()));
    });

    test('throws FormatException for partial match of regular', () {
      expect(() => Pioneer.parse('reg'), throwsA(isA<FormatException>()));
    });

    test(
      'throws FormatException for partial match of auxiliarycontinuously',
      () {
        expect(
          () => Pioneer.parse('auxiliarycont'),
          throwsA(isA<FormatException>()),
        );
      },
    );

    test('throws FormatException for numeric string', () {
      expect(() => Pioneer.parse('1'), throwsA(isA<FormatException>()));
    });

    test('throws FormatException for arbitrary word', () {
      expect(() => Pioneer.parse('pioneer'), throwsA(isA<FormatException>()));
    });

    test('FormatException message contains the enum name', () {
      expect(
        () => Pioneer.parse('invalid'),
        throwsA(
          isA<FormatException>().having(
            (final FormatException e) => e.message,
            'message',
            contains('Pioneer'),
          ),
        ),
      );
    });

    test('FormatException message contains the invalid string', () {
      expect(
        () => Pioneer.parse('invalid'),
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
        () => Pioneer.parse('invalid'),
        throwsA(
          isA<FormatException>().having(
            (final FormatException e) => e.source,
            'source',
            equals('invalid'),
          ),
        ),
      );
    });

    test('FormatException source preserves original casing', () {
      expect(
        () => Pioneer.parse('INVALID'),
        throwsA(
          isA<FormatException>().having(
            (final FormatException e) => e.source,
            'source',
            equals('INVALID'),
          ),
        ),
      );
    });

    test('FormatException source preserves surrounding whitespace', () {
      expect(
        () => Pioneer.parse(' invalid '),
        throwsA(
          isA<FormatException>().having(
            (final FormatException e) => e.source,
            'source',
            equals(' invalid '),
          ),
        ),
      );
    });
  });

  group('Pioneer.compareTo', () {
    test('auxiliary compared to itself returns 0', () {
      expect(Pioneer.auxiliary.compareTo(Pioneer.auxiliary), equals(0));
    });

    test('auxiliarycontinuously compared to itself returns 0', () {
      expect(
        Pioneer.auxiliarycontinuously.compareTo(Pioneer.auxiliarycontinuously),
        equals(0),
      );
    });

    test('regular compared to itself returns 0', () {
      expect(Pioneer.regular.compareTo(Pioneer.regular), equals(0));
    });

    test('auxiliary has shorter duration than auxiliarycontinuously', () {
      expect(
        Pioneer.auxiliary.compareTo(Pioneer.auxiliarycontinuously),
        isNegative,
      );
    });

    test('auxiliarycontinuously has longer duration than auxiliary', () {
      expect(
        Pioneer.auxiliarycontinuously.compareTo(Pioneer.auxiliary),
        isPositive,
      );
    });

    test('auxiliary has shorter duration than regular', () {
      expect(Pioneer.auxiliary.compareTo(Pioneer.regular), isNegative);
    });

    test('regular has longer duration than auxiliary', () {
      expect(Pioneer.regular.compareTo(Pioneer.auxiliary), isPositive);
    });

    test('auxiliarycontinuously has shorter duration than regular', () {
      expect(
        Pioneer.auxiliarycontinuously.compareTo(Pioneer.regular),
        isNegative,
      );
    });

    test('regular has longer duration than auxiliarycontinuously', () {
      expect(
        Pioneer.regular.compareTo(Pioneer.auxiliarycontinuously),
        isPositive,
      );
    });

    test('each adjacent pair is in ascending duration order', () {
      final List<Pioneer> byDuration = <Pioneer>[
        Pioneer.auxiliary,
        Pioneer.auxiliarycontinuously,
        Pioneer.regular,
      ];
      for (int i = 0; i < byDuration.length - 1; i++) {
        expect(
          byDuration[i].compareTo(byDuration[i + 1]),
          isNegative,
          reason:
              '${byDuration[i]} should have a shorter duration than '
              '${byDuration[i + 1]}',
        );
      }
    });
  });

  group('Pioneer operator <', () {
    test('auxiliary < auxiliarycontinuously is true', () {
      expect(Pioneer.auxiliary < Pioneer.auxiliarycontinuously, isTrue);
    });

    test('auxiliary < regular is true', () {
      expect(Pioneer.auxiliary < Pioneer.regular, isTrue);
    });

    test('auxiliarycontinuously < regular is true', () {
      expect(Pioneer.auxiliarycontinuously < Pioneer.regular, isTrue);
    });

    test('auxiliarycontinuously < auxiliary is false', () {
      expect(Pioneer.auxiliarycontinuously < Pioneer.auxiliary, isFalse);
    });

    test('regular < auxiliary is false', () {
      expect(Pioneer.regular < Pioneer.auxiliary, isFalse);
    });

    test('regular < auxiliarycontinuously is false', () {
      expect(Pioneer.regular < Pioneer.auxiliarycontinuously, isFalse);
    });

    test('auxiliary < auxiliary is false', () {
      expect(Pioneer.auxiliary < Pioneer.auxiliary, isFalse);
    });

    test('auxiliarycontinuously < auxiliarycontinuously is false', () {
      expect(
        Pioneer.auxiliarycontinuously < Pioneer.auxiliarycontinuously,
        isFalse,
      );
    });

    test('regular < regular is false', () {
      expect(Pioneer.regular < Pioneer.regular, isFalse);
    });
  });

  group('Pioneer operator <=', () {
    test('auxiliary <= auxiliarycontinuously is true', () {
      expect(Pioneer.auxiliary <= Pioneer.auxiliarycontinuously, isTrue);
    });

    test('auxiliary <= regular is true', () {
      expect(Pioneer.auxiliary <= Pioneer.regular, isTrue);
    });

    test('auxiliarycontinuously <= regular is true', () {
      expect(Pioneer.auxiliarycontinuously <= Pioneer.regular, isTrue);
    });

    test('auxiliarycontinuously <= auxiliary is false', () {
      expect(Pioneer.auxiliarycontinuously <= Pioneer.auxiliary, isFalse);
    });

    test('regular <= auxiliary is false', () {
      expect(Pioneer.regular <= Pioneer.auxiliary, isFalse);
    });

    test('regular <= auxiliarycontinuously is false', () {
      expect(Pioneer.regular <= Pioneer.auxiliarycontinuously, isFalse);
    });

    test('auxiliary <= auxiliary is true', () {
      expect(Pioneer.auxiliary <= Pioneer.auxiliary, isTrue);
    });

    test('auxiliarycontinuously <= auxiliarycontinuously is true', () {
      expect(
        Pioneer.auxiliarycontinuously <= Pioneer.auxiliarycontinuously,
        isTrue,
      );
    });

    test('regular <= regular is true', () {
      expect(Pioneer.regular <= Pioneer.regular, isTrue);
    });
  });

  group('Pioneer operator >', () {
    test('auxiliarycontinuously > auxiliary is true', () {
      expect(Pioneer.auxiliarycontinuously > Pioneer.auxiliary, isTrue);
    });

    test('regular > auxiliary is true', () {
      expect(Pioneer.regular > Pioneer.auxiliary, isTrue);
    });

    test('regular > auxiliarycontinuously is true', () {
      expect(Pioneer.regular > Pioneer.auxiliarycontinuously, isTrue);
    });

    test('auxiliary > auxiliarycontinuously is false', () {
      expect(Pioneer.auxiliary > Pioneer.auxiliarycontinuously, isFalse);
    });

    test('auxiliary > regular is false', () {
      expect(Pioneer.auxiliary > Pioneer.regular, isFalse);
    });

    test('auxiliarycontinuously > regular is false', () {
      expect(Pioneer.auxiliarycontinuously > Pioneer.regular, isFalse);
    });

    test('auxiliary > auxiliary is false', () {
      expect(Pioneer.auxiliary > Pioneer.auxiliary, isFalse);
    });

    test('auxiliarycontinuously > auxiliarycontinuously is false', () {
      expect(
        Pioneer.auxiliarycontinuously > Pioneer.auxiliarycontinuously,
        isFalse,
      );
    });

    test('regular > regular is false', () {
      expect(Pioneer.regular > Pioneer.regular, isFalse);
    });
  });

  group('Pioneer operator >=', () {
    test('auxiliarycontinuously >= auxiliary is true', () {
      expect(Pioneer.auxiliarycontinuously >= Pioneer.auxiliary, isTrue);
    });

    test('regular >= auxiliary is true', () {
      expect(Pioneer.regular >= Pioneer.auxiliary, isTrue);
    });

    test('regular >= auxiliarycontinuously is true', () {
      expect(Pioneer.regular >= Pioneer.auxiliarycontinuously, isTrue);
    });

    test('auxiliary >= auxiliarycontinuously is false', () {
      expect(Pioneer.auxiliary >= Pioneer.auxiliarycontinuously, isFalse);
    });

    test('auxiliary >= regular is false', () {
      expect(Pioneer.auxiliary >= Pioneer.regular, isFalse);
    });

    test('auxiliarycontinuously >= regular is false', () {
      expect(Pioneer.auxiliarycontinuously >= Pioneer.regular, isFalse);
    });

    test('auxiliary >= auxiliary is true', () {
      expect(Pioneer.auxiliary >= Pioneer.auxiliary, isTrue);
    });

    test('auxiliarycontinuously >= auxiliarycontinuously is true', () {
      expect(
        Pioneer.auxiliarycontinuously >= Pioneer.auxiliarycontinuously,
        isTrue,
      );
    });

    test('regular >= regular is true', () {
      expect(Pioneer.regular >= Pioneer.regular, isTrue);
    });
  });

  group('Pioneer.toString', () {
    test('auxiliary returns "auxiliary"', () {
      expect(Pioneer.auxiliary.toString(), equals('auxiliary'));
    });

    test('auxiliarycontinuously returns "auxiliarycontinuously"', () {
      expect(
        Pioneer.auxiliarycontinuously.toString(),
        equals('auxiliarycontinuously'),
      );
    });

    test('regular returns "regular"', () {
      expect(Pioneer.regular.toString(), equals('regular'));
    });

    test('toString is always lower-case for all values', () {
      for (final Pioneer pioneer in Pioneer.values) {
        expect(pioneer.toString(), equals(pioneer.toString().toLowerCase()));
      }
    });

    test('toString results are all distinct', () {
      final Set<String> strings = Pioneer.values
          .map((final Pioneer p) => p.toString())
          .toSet();
      expect(strings, hasLength(Pioneer.values.length));
    });
  });

  group('Pioneer — parse/toString round-trip', () {
    test('auxiliary survives a round-trip', () {
      expect(
        Pioneer.parse(Pioneer.auxiliary.toString()),
        equals(Pioneer.auxiliary),
      );
    });

    test('auxiliarycontinuously survives a round-trip', () {
      expect(
        Pioneer.parse(Pioneer.auxiliarycontinuously.toString()),
        equals(Pioneer.auxiliarycontinuously),
      );
    });

    test('regular survives a round-trip', () {
      expect(
        Pioneer.parse(Pioneer.regular.toString()),
        equals(Pioneer.regular),
      );
    });

    test('all values survive a parse(toString()) round-trip', () {
      for (final Pioneer pioneer in Pioneer.values) {
        expect(
          Pioneer.parse(pioneer.toString()),
          equals(pioneer),
          reason: '$pioneer should round-trip correctly',
        );
      }
    });
  });

  group('Pioneer — ordering consistency', () {
    test('auxiliary is the minimum value (shortest duration)', () {
      final List<Pioneer> sorted = List<Pioneer>.from(Pioneer.values)
        ..sort((final Pioneer a, final Pioneer b) => a.compareTo(b));
      expect(sorted.first, equals(Pioneer.auxiliary));
    });

    test('regular is the maximum value (longest duration)', () {
      final List<Pioneer> sorted = List<Pioneer>.from(Pioneer.values)
        ..sort((final Pioneer a, final Pioneer b) => a.compareTo(b));
      expect(sorted.last, equals(Pioneer.regular));
    });

    test('sorted order is auxiliary, auxiliarycontinuously, regular', () {
      final List<Pioneer> sorted = List<Pioneer>.from(Pioneer.values)
        ..sort((final Pioneer a, final Pioneer b) => a.compareTo(b));
      expect(
        sorted,
        equals(<Pioneer>[
          Pioneer.auxiliary,
          Pioneer.auxiliarycontinuously,
          Pioneer.regular,
        ]),
      );
    });

    test('compareTo is consistent with < operator', () {
      for (final Pioneer a in Pioneer.values) {
        for (final Pioneer b in Pioneer.values) {
          expect(a < b, equals(a.compareTo(b) < 0));
        }
      }
    });

    test('compareTo is consistent with <= operator', () {
      for (final Pioneer a in Pioneer.values) {
        for (final Pioneer b in Pioneer.values) {
          expect(a <= b, equals(a.compareTo(b) <= 0));
        }
      }
    });

    test('compareTo is consistent with > operator', () {
      for (final Pioneer a in Pioneer.values) {
        for (final Pioneer b in Pioneer.values) {
          expect(a > b, equals(a.compareTo(b) > 0));
        }
      }
    });

    test('compareTo is consistent with >= operator', () {
      for (final Pioneer a in Pioneer.values) {
        for (final Pioneer b in Pioneer.values) {
          expect(a >= b, equals(a.compareTo(b) >= 0));
        }
      }
    });

    test('compareTo is antisymmetric (auxiliary vs regular)', () {
      expect(
        Pioneer.auxiliary.compareTo(Pioneer.regular).sign,
        equals(-Pioneer.regular.compareTo(Pioneer.auxiliary).sign),
      );
    });

    test('compareTo is antisymmetric '
        '(auxiliary vs auxiliarycontinuously)', () {
      expect(
        Pioneer.auxiliary.compareTo(Pioneer.auxiliarycontinuously).sign,
        equals(
          -Pioneer.auxiliarycontinuously.compareTo(Pioneer.auxiliary).sign,
        ),
      );
    });

    test('compareTo is antisymmetric '
        '(auxiliarycontinuously vs regular)', () {
      expect(
        Pioneer.auxiliarycontinuously.compareTo(Pioneer.regular).sign,
        equals(-Pioneer.regular.compareTo(Pioneer.auxiliarycontinuously).sign),
      );
    });

    test('compareTo is transitive '
        '(auxiliary < auxiliarycontinuously < regular)', () {
      expect(
        Pioneer.auxiliary.compareTo(Pioneer.auxiliarycontinuously),
        isNegative,
      );
      expect(
        Pioneer.auxiliarycontinuously.compareTo(Pioneer.regular),
        isNegative,
      );
      expect(Pioneer.auxiliary.compareTo(Pioneer.regular), isNegative);
    });

    test('ordering is determined by duration, not declaration index', () {
      // Durations: auxiliary=30, auxiliarycontinuously=360, regular=600.
      // The declaration order matches the duration order, so confirm that
      // compareTo yields the same sign as the duration difference.
      final List<(Pioneer, int)> withDuration = <(Pioneer, int)>[
        (Pioneer.auxiliary, 30),
        (Pioneer.auxiliarycontinuously, 360),
        (Pioneer.regular, 600),
      ];
      for (final (Pioneer a, int da) in withDuration) {
        for (final (Pioneer b, int db) in withDuration) {
          expect(
            a.compareTo(b).sign,
            equals(da.compareTo(db).sign),
            reason:
                'compareTo($a, $b) sign should match '
                'duration difference sign (${da - db})',
          );
        }
      }
    });
  });
}
