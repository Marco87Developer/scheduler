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
            (e) => e.message,
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
            (e) => e.message,
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
            (e) => e.source,
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
            (e) => e.source,
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
            (e) => e.source,
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
      final byDuration = <Pioneer>[
        Pioneer.auxiliary,
        Pioneer.auxiliarycontinuously,
        Pioneer.regular,
      ];
      for (var i = 0; i < byDuration.length - 1; i++) {
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
          .map((p) => p.toString())
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
      final sorted = List<Pioneer>.from(Pioneer.values)
        ..sort((a, b) => a.compareTo(b));
      expect(sorted.first, equals(Pioneer.auxiliary));
    });

    test('regular is the maximum value (longest duration)', () {
      final sorted = List<Pioneer>.from(Pioneer.values)
        ..sort((a, b) => a.compareTo(b));
      expect(sorted.last, equals(Pioneer.regular));
    });

    test('sorted order is auxiliary, auxiliarycontinuously, regular', () {
      final sorted = List<Pioneer>.from(Pioneer.values)
        ..sort((a, b) => a.compareTo(b));
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
      final withDuration = <(Pioneer, int)>[
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

  group('Pioneer.tryParse — auxiliary', () {
    test('returns auxiliary for "auxiliary"', () {
      expect(Pioneer.tryParse('auxiliary'), equals(Pioneer.auxiliary));
    });
    test('returns auxiliary for "Auxiliary" (title case)', () {
      expect(Pioneer.tryParse('Auxiliary'), equals(Pioneer.auxiliary));
    });
    test('returns auxiliary for "AUXILIARY" (upper case)', () {
      expect(Pioneer.tryParse('AUXILIARY'), equals(Pioneer.auxiliary));
    });
    test('returns auxiliary for "aUxIlIaRy" (alternating case)', () {
      expect(Pioneer.tryParse('aUxIlIaRy'), equals(Pioneer.auxiliary));
    });
    test('returns auxiliary for " auxiliary " (surrounding spaces)', () {
      expect(Pioneer.tryParse(' auxiliary '), equals(Pioneer.auxiliary));
    });
    test('returns auxiliary for "a u x i l i a r y" (internal spaces)', () {
      expect(Pioneer.tryParse('a u x i l i a r y'), equals(Pioneer.auxiliary));
    });
    test('returns auxiliary for tab and newline whitespace', () {
      expect(Pioneer.tryParse('\t auxiliary \n'), equals(Pioneer.auxiliary));
    });
    test('returns auxiliary for a non-breaking space (U+00A0)', () {
      expect(Pioneer.tryParse('\u00A0auxiliary'), equals(Pioneer.auxiliary));
    });
    test('returns auxiliary for an em space (U+2003)', () {
      expect(Pioneer.tryParse('auxi\u2003liary'), equals(Pioneer.auxiliary));
    });
  });

  group('Pioneer.tryParse — auxiliarycontinuously', () {
    test('returns auxiliarycontinuously for "auxiliarycontinuously"', () {
      expect(
        Pioneer.tryParse('auxiliarycontinuously'),
        equals(Pioneer.auxiliarycontinuously),
      );
    });
    test('returns auxiliarycontinuously for "AuxiliaryContinuously"', () {
      expect(
        Pioneer.tryParse('AuxiliaryContinuously'),
        equals(Pioneer.auxiliarycontinuously),
      );
    });
    test('returns auxiliarycontinuously for "AUXILIARYCONTINUOUSLY"', () {
      expect(
        Pioneer.tryParse('AUXILIARYCONTINUOUSLY'),
        equals(Pioneer.auxiliarycontinuously),
      );
    });
    test('returns auxiliarycontinuously for " auxiliarycontinuously "', () {
      expect(
        Pioneer.tryParse(' auxiliarycontinuously '),
        equals(Pioneer.auxiliarycontinuously),
      );
    });
    test('returns auxiliarycontinuously for "auxiliary continuously"', () {
      expect(
        Pioneer.tryParse('auxiliary continuously'),
        equals(Pioneer.auxiliarycontinuously),
      );
    });
    test('returns auxiliarycontinuously for multiple internal spaces', () {
      expect(
        Pioneer.tryParse('auxiliary   continuously'),
        equals(Pioneer.auxiliarycontinuously),
      );
    });
    test('returns auxiliarycontinuously for tab and newline whitespace', () {
      expect(
        Pioneer.tryParse('\tauxiliary\ncontinuously\r'),
        equals(Pioneer.auxiliarycontinuously),
      );
    });
    test('returns auxiliarycontinuously for a non-breaking space', () {
      expect(
        Pioneer.tryParse('auxiliary\u00A0continuously'),
        equals(Pioneer.auxiliarycontinuously),
      );
    });
    test('does not confuse it with auxiliary when whitespace is inside', () {
      expect(
        Pioneer.tryParse('auxiliary continuously'),
        isNot(equals(Pioneer.auxiliary)),
      );
    });
  });

  group('Pioneer.tryParse — regular', () {
    test('returns regular for "regular"', () {
      expect(Pioneer.tryParse('regular'), equals(Pioneer.regular));
    });
    test('returns regular for "Regular" (title case)', () {
      expect(Pioneer.tryParse('Regular'), equals(Pioneer.regular));
    });
    test('returns regular for "REGULAR" (upper case)', () {
      expect(Pioneer.tryParse('REGULAR'), equals(Pioneer.regular));
    });
    test('returns regular for "rEgUlAr" (alternating case)', () {
      expect(Pioneer.tryParse('rEgUlAr'), equals(Pioneer.regular));
    });
    test('returns regular for " regular " (surrounding spaces)', () {
      expect(Pioneer.tryParse(' regular '), equals(Pioneer.regular));
    });
    test('returns regular for "r e g u l a r" (internal spaces)', () {
      expect(Pioneer.tryParse('r e g u l a r'), equals(Pioneer.regular));
    });
    test('returns regular for tab, newline and carriage return', () {
      expect(Pioneer.tryParse('\tre\ngu\rlar'), equals(Pioneer.regular));
    });
    test('returns regular for a non-breaking space (U+00A0)', () {
      expect(Pioneer.tryParse('reg\u00A0ular'), equals(Pioneer.regular));
    });
    test('returns regular for an em space (U+2003)', () {
      expect(Pioneer.tryParse('regular\u2003'), equals(Pioneer.regular));
    });
  });

  group('Pioneer.tryParse — invalid input returns null', () {
    test('returns null for the empty string', () {
      expect(Pioneer.tryParse(''), isNull);
    });
    test('returns null for a whitespace-only string', () {
      expect(Pioneer.tryParse('   '), isNull);
    });
    test('returns null for tab, newline and carriage return only', () {
      expect(Pioneer.tryParse('\t\n\r'), isNull);
    });
    test('returns null for an unknown word', () {
      expect(Pioneer.tryParse('special'), isNull);
    });
    test('returns null for the enum name', () {
      expect(Pioneer.tryParse('pioneer'), isNull);
    });
    test('returns null for a prefix of "auxiliary"', () {
      expect(Pioneer.tryParse('aux'), isNull);
    });
    test('returns null for a prefix of "auxiliarycontinuously"', () {
      expect(Pioneer.tryParse('auxiliarycont'), isNull);
    });
    test('returns null for a prefix of "regular"', () {
      expect(Pioneer.tryParse('reg'), isNull);
    });
    test('returns null for a suffix of "auxiliary"', () {
      expect(Pioneer.tryParse('liary'), isNull);
    });
    test('returns null for a suffix of "auxiliarycontinuously"', () {
      expect(Pioneer.tryParse('continuously'), isNull);
    });
    test('returns null for a suffix of "regular"', () {
      expect(Pioneer.tryParse('gular'), isNull);
    });
    test('returns null for "auxiliaries" (different ending)', () {
      expect(Pioneer.tryParse('auxiliaries'), isNull);
    });
    test('returns null for "regulars" (extra trailing letter)', () {
      expect(Pioneer.tryParse('regulars'), isNull);
    });
    test('returns null for "regularregular" (repeated value)', () {
      expect(Pioneer.tryParse('regularregular'), isNull);
    });
    test('returns null for "auxiliaryregular" (two values at once)', () {
      expect(Pioneer.tryParse('auxiliaryregular'), isNull);
    });
    test('returns null for "auxiliary,regular" (separated values)', () {
      expect(Pioneer.tryParse('auxiliary,regular'), isNull);
    });
    test('returns null for "regular." (trailing punctuation)', () {
      expect(Pioneer.tryParse('regular.'), isNull);
    });
    test('returns null for "auxiliary_continuously" (underscore)', () {
      expect(Pioneer.tryParse('auxiliary_continuously'), isNull);
    });
    test('returns null for "auxiliary-continuously" (hyphen)', () {
      expect(Pioneer.tryParse('auxiliary-continuously'), isNull);
    });
    test('returns null for a numeric string', () {
      expect(Pioneer.tryParse('1'), isNull);
    });
    test('returns null for the string "null"', () {
      expect(Pioneer.tryParse('null'), isNull);
    });
    test('returns null for a qualified enum name', () {
      expect(Pioneer.tryParse('Pioneer.regular'), isNull);
    });
    test('returns null for an accented letter', () {
      expect(Pioneer.tryParse('r\u00E9gular'), isNull);
    });
    test('returns null when a zero-width space (U+200B) is present', () {
      // U+200B is not whitespace for `\s`, so it is not stripped.
      expect(Pioneer.tryParse('\u200Bregular'), isNull);
      expect(Pioneer.tryParse('reg\u200Bular'), isNull);
    });
    test('returns null for a very long string', () {
      expect(Pioneer.tryParse('r' * 10000), isNull);
    });
  });

  group('Pioneer.tryParse — never throws', () {
    test('does not throw for any of a set of awkward inputs', () {
      final inputs = <String>[
        '',
        ' ',
        '\n',
        'special',
        'regular!',
        '\u0000',
        '\uFFFF',
        '\u{1F600}',
        'r' * 10000,
      ];
      for (final input in inputs) {
        expect(
          () => Pioneer.tryParse(input),
          returnsNormally,
          reason: 'input of length ${input.length} must not throw',
        );
      }
    });
  });

  group('Pioneer.tryParse — result type', () {
    test('returns a Pioneer for valid input', () {
      expect(Pioneer.tryParse('regular'), isA<Pioneer>());
    });
    test('returns the canonical (identical) enum instance', () {
      expect(
        identical(Pioneer.tryParse('auxiliary'), Pioneer.auxiliary),
        isTrue,
      );
      expect(
        identical(
          Pioneer.tryParse('auxiliarycontinuously'),
          Pioneer.auxiliarycontinuously,
        ),
        isTrue,
      );
      expect(identical(Pioneer.tryParse('regular'), Pioneer.regular), isTrue);
    });
    test('different valid inputs for different values are distinct', () {
      final Pioneer? a = Pioneer.tryParse('auxiliary');
      final Pioneer? b = Pioneer.tryParse('auxiliarycontinuously');
      final Pioneer? c = Pioneer.tryParse('regular');
      expect(a, isNot(equals(b)));
      expect(a, isNot(equals(c)));
      expect(b, isNot(equals(c)));
    });
    test('every alias for the same value yields the same instance', () {
      const auxiliaryAliases = <String>[
        'auxiliary',
        'AUXILIARY',
        ' Auxiliary ',
        'a u x i l i a r y',
      ];
      for (final alias in auxiliaryAliases) {
        expect(Pioneer.tryParse(alias), same(Pioneer.auxiliary));
      }
      const continuouslyAliases = <String>[
        'auxiliarycontinuously',
        'AUXILIARYCONTINUOUSLY',
        ' Auxiliary Continuously ',
      ];
      for (final alias in continuouslyAliases) {
        expect(Pioneer.tryParse(alias), same(Pioneer.auxiliarycontinuously));
      }
      const regularAliases = <String>[
        'regular',
        'REGULAR',
        ' Regular ',
        'r e g u l a r',
      ];
      for (final alias in regularAliases) {
        expect(Pioneer.tryParse(alias), same(Pioneer.regular));
      }
    });
  });

  group('Pioneer.tryParse — consistency with parse', () {
    test('equals parse for every valid input', () {
      const inputs = <String>[
        'auxiliary',
        'AUXILIARY',
        ' Auxiliary ',
        'a u x i l i a r y',
        'auxiliarycontinuously',
        'Auxiliary Continuously',
        'regular',
        'REGULAR',
        ' Regular ',
        'r e g u l a r',
      ];
      for (final input in inputs) {
        expect(
          Pioneer.tryParse(input),
          equals(Pioneer.parse(input)),
          reason: '"$input" should parse identically',
        );
      }
    });
    test('returns null exactly where parse throws FormatException', () {
      const inputs = <String>[
        '',
        '   ',
        'special',
        'aux',
        'auxiliarycont',
        'reg',
        '1',
        'null',
      ];
      for (final input in inputs) {
        expect(Pioneer.tryParse(input), isNull, reason: '"$input"');
        expect(
          () => Pioneer.parse(input),
          throwsA(isA<FormatException>()),
          reason: '"$input"',
        );
      }
    });
  });

  group('Pioneer.tryParse — round-trip', () {
    test('tryParse(toString()) returns the original for every value', () {
      for (final Pioneer pioneer in Pioneer.values) {
        expect(
          Pioneer.tryParse(pioneer.toString()),
          equals(pioneer),
          reason: '$pioneer should round-trip',
        );
      }
    });
    test('tryParse(name) returns the original for every value', () {
      for (final Pioneer pioneer in Pioneer.values) {
        expect(
          Pioneer.tryParse(pioneer.name),
          equals(pioneer),
          reason: '${pioneer.name} should round-trip',
        );
      }
    });
  });

  group('Pioneer.tryParse — idempotence and purity', () {
    test('returns the same result on repeated calls', () {
      expect(Pioneer.tryParse('regular'), equals(Pioneer.tryParse('regular')));
      expect(Pioneer.tryParse('nope'), equals(Pioneer.tryParse('nope')));
    });
    test('does not depend on the order of previous calls', () {
      final Pioneer? first = Pioneer.tryParse('auxiliary');
      final Pioneer? second = Pioneer.tryParse('regular');
      final Pioneer? third = Pioneer.tryParse('invalid');
      expect(second, equals(Pioneer.regular));
      expect(third, isNull);
      expect(Pioneer.tryParse('auxiliary'), equals(first));
    });
  });
}
