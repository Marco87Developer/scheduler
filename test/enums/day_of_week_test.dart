import 'package:scheduler/src/enums/day_of_week.dart';
import 'package:test/test.dart';

void main() {
  group('DayOfWeek.values', () {
    test('contains exactly seven values', () {
      expect(DayOfWeek.values, hasLength(7));
    });

    test('contains monday', () {
      expect(DayOfWeek.values, contains(DayOfWeek.monday));
    });

    test('contains tuesday', () {
      expect(DayOfWeek.values, contains(DayOfWeek.tuesday));
    });

    test('contains wednesday', () {
      expect(DayOfWeek.values, contains(DayOfWeek.wednesday));
    });

    test('contains thursday', () {
      expect(DayOfWeek.values, contains(DayOfWeek.thursday));
    });

    test('contains friday', () {
      expect(DayOfWeek.values, contains(DayOfWeek.friday));
    });

    test('contains saturday', () {
      expect(DayOfWeek.values, contains(DayOfWeek.saturday));
    });

    test('contains sunday', () {
      expect(DayOfWeek.values, contains(DayOfWeek.sunday));
    });

    test('declaration order is monday … sunday', () {
      expect(
        DayOfWeek.values,
        equals(<DayOfWeek>[
          DayOfWeek.monday,
          DayOfWeek.tuesday,
          DayOfWeek.wednesday,
          DayOfWeek.thursday,
          DayOfWeek.friday,
          DayOfWeek.saturday,
          DayOfWeek.sunday,
        ]),
      );
    });
  });

  group('DayOfWeek.enumName', () {
    test('is "DayOfWeek"', () {
      expect(DayOfWeek.enumName, equals('DayOfWeek'));
    });
  });

  group('DayOfWeek.number', () {
    test('monday has number 1', () {
      expect(DayOfWeek.monday.number, equals(1));
    });

    test('tuesday has number 2', () {
      expect(DayOfWeek.tuesday.number, equals(2));
    });

    test('wednesday has number 3', () {
      expect(DayOfWeek.wednesday.number, equals(3));
    });

    test('thursday has number 4', () {
      expect(DayOfWeek.thursday.number, equals(4));
    });

    test('friday has number 5', () {
      expect(DayOfWeek.friday.number, equals(5));
    });

    test('saturday has number 6', () {
      expect(DayOfWeek.saturday.number, equals(6));
    });

    test('sunday has number 7', () {
      expect(DayOfWeek.sunday.number, equals(7));
    });

    test('every number is in the inclusive range 1–7', () {
      for (final DayOfWeek day in DayOfWeek.values) {
        expect(day.number, inInclusiveRange(1, 7));
      }
    });

    test('all numbers are distinct', () {
      final Set<int> numbers = DayOfWeek.values
          .map((final DayOfWeek d) => d.number)
          .toSet();
      expect(numbers, hasLength(DayOfWeek.values.length));
    });

    test('numbers increase monotonically with declaration order', () {
      for (int i = 0; i < DayOfWeek.values.length - 1; i++) {
        expect(
          DayOfWeek.values[i].number,
          lessThan(DayOfWeek.values[i + 1].number),
        );
      }
    });
  });

  // NOTE: the current implementation has an off-by-one error:
  //   DayOfWeek.values[(number % 7 + 6) % 7 + 1]
  // The trailing `+ 1` shifts every result by one position and throws a
  // RangeError for any n ≡ 0 (mod 7) (e.g. 0, 7, 14).
  // The correct formula is: DayOfWeek.values[(number % 7 + 6) % 7]
  // All tests below assert the *specified* behaviour.
  group('DayOfWeek.fromNumber — standard range (1–7)', () {
    test('1 returns monday', () {
      expect(DayOfWeek.fromNumber(1), equals(DayOfWeek.monday));
    });

    test('2 returns tuesday', () {
      expect(DayOfWeek.fromNumber(2), equals(DayOfWeek.tuesday));
    });

    test('3 returns wednesday', () {
      expect(DayOfWeek.fromNumber(3), equals(DayOfWeek.wednesday));
    });

    test('4 returns thursday', () {
      expect(DayOfWeek.fromNumber(4), equals(DayOfWeek.thursday));
    });

    test('5 returns friday', () {
      expect(DayOfWeek.fromNumber(5), equals(DayOfWeek.friday));
    });

    test('6 returns saturday', () {
      expect(DayOfWeek.fromNumber(6), equals(DayOfWeek.saturday));
    });

    test('7 returns sunday', () {
      expect(DayOfWeek.fromNumber(7), equals(DayOfWeek.sunday));
    });
  });

  group('DayOfWeek.fromNumber — wrapping above 7', () {
    test('8 wraps to monday', () {
      expect(DayOfWeek.fromNumber(8), equals(DayOfWeek.monday));
    });

    test('9 wraps to tuesday', () {
      expect(DayOfWeek.fromNumber(9), equals(DayOfWeek.tuesday));
    });

    test('14 wraps to sunday', () {
      expect(DayOfWeek.fromNumber(14), equals(DayOfWeek.sunday));
    });

    test('15 wraps to monday', () {
      expect(DayOfWeek.fromNumber(15), equals(DayOfWeek.monday));
    });

    test('100 wraps correctly (100 mod 7 = 2 → tuesday)', () {
      expect(DayOfWeek.fromNumber(100), equals(DayOfWeek.tuesday));
    });
  });

  group('DayOfWeek.fromNumber — wrapping at 0', () {
    test('0 wraps to sunday (0 ≡ 7 mod 7)', () {
      expect(DayOfWeek.fromNumber(0), equals(DayOfWeek.sunday));
    });
  });

  group('DayOfWeek.fromNumber — wrapping below 0', () {
    test('-1 wraps to saturday (-1 ≡ 6 mod 7)', () {
      expect(DayOfWeek.fromNumber(-1), equals(DayOfWeek.saturday));
    });

    test('-2 wraps to friday (-2 ≡ 5 mod 7)', () {
      expect(DayOfWeek.fromNumber(-2), equals(DayOfWeek.friday));
    });

    test('-6 wraps to monday (-6 ≡ 1 mod 7)', () {
      expect(DayOfWeek.fromNumber(-6), equals(DayOfWeek.monday));
    });

    test('-7 wraps to sunday (-7 ≡ 0 ≡ 7 mod 7)', () {
      expect(DayOfWeek.fromNumber(-7), equals(DayOfWeek.sunday));
    });

    test('-8 wraps to saturday (-8 ≡ 6 mod 7)', () {
      expect(DayOfWeek.fromNumber(-8), equals(DayOfWeek.saturday));
    });
  });

  group('DayOfWeek.fromNumber — period invariance', () {
    test('fromNumber(n) == fromNumber(n + 7) for selected values', () {
      const List<int> bases = <int>[-14, -7, -1, 1, 2, 3, 4, 5, 6];
      for (final int n in bases) {
        expect(
          DayOfWeek.fromNumber(n),
          equals(DayOfWeek.fromNumber(n + 7)),
          reason: 'fromNumber($n) should equal fromNumber(${n + 7})',
        );
      }
    });
  });

  group('DayOfWeek.parse — full names', () {
    test('parses "monday"', () {
      expect(DayOfWeek.parse('monday'), equals(DayOfWeek.monday));
    });

    test('parses "tuesday"', () {
      expect(DayOfWeek.parse('tuesday'), equals(DayOfWeek.tuesday));
    });

    test('parses "wednesday"', () {
      expect(DayOfWeek.parse('wednesday'), equals(DayOfWeek.wednesday));
    });

    test('parses "thursday"', () {
      expect(DayOfWeek.parse('thursday'), equals(DayOfWeek.thursday));
    });

    test('parses "friday"', () {
      expect(DayOfWeek.parse('friday'), equals(DayOfWeek.friday));
    });

    test('parses "saturday"', () {
      expect(DayOfWeek.parse('saturday'), equals(DayOfWeek.saturday));
    });

    test('parses "sunday"', () {
      expect(DayOfWeek.parse('sunday'), equals(DayOfWeek.sunday));
    });
  });

  group('DayOfWeek.parse — three-letter abbreviations', () {
    test('parses "mon"', () {
      expect(DayOfWeek.parse('mon'), equals(DayOfWeek.monday));
    });

    test('parses "tue"', () {
      expect(DayOfWeek.parse('tue'), equals(DayOfWeek.tuesday));
    });

    test('parses "wed"', () {
      expect(DayOfWeek.parse('wed'), equals(DayOfWeek.wednesday));
    });

    test('parses "thu"', () {
      expect(DayOfWeek.parse('thu'), equals(DayOfWeek.thursday));
    });

    test('parses "fri"', () {
      expect(DayOfWeek.parse('fri'), equals(DayOfWeek.friday));
    });

    test('parses "sat"', () {
      expect(DayOfWeek.parse('sat'), equals(DayOfWeek.saturday));
    });

    test('parses "sun"', () {
      expect(DayOfWeek.parse('sun'), equals(DayOfWeek.sunday));
    });
  });

  group('DayOfWeek.parse — integer strings (1–7)', () {
    test('parses "1" as monday', () {
      expect(DayOfWeek.parse('1'), equals(DayOfWeek.monday));
    });

    test('parses "2" as tuesday', () {
      expect(DayOfWeek.parse('2'), equals(DayOfWeek.tuesday));
    });

    test('parses "3" as wednesday', () {
      expect(DayOfWeek.parse('3'), equals(DayOfWeek.wednesday));
    });

    test('parses "4" as thursday', () {
      expect(DayOfWeek.parse('4'), equals(DayOfWeek.thursday));
    });

    test('parses "5" as friday', () {
      expect(DayOfWeek.parse('5'), equals(DayOfWeek.friday));
    });

    test('parses "6" as saturday', () {
      expect(DayOfWeek.parse('6'), equals(DayOfWeek.saturday));
    });

    test('parses "7" as sunday', () {
      expect(DayOfWeek.parse('7'), equals(DayOfWeek.sunday));
    });
  });

  group('DayOfWeek.parse — integer strings (wrapping)', () {
    test('parses "0" as sunday (wraps)', () {
      expect(DayOfWeek.parse('0'), equals(DayOfWeek.sunday));
    });

    test('parses "8" as monday (wraps)', () {
      expect(DayOfWeek.parse('8'), equals(DayOfWeek.monday));
    });

    test('parses "14" as sunday (wraps)', () {
      expect(DayOfWeek.parse('14'), equals(DayOfWeek.sunday));
    });

    test('parses "-1" as saturday (wraps)', () {
      expect(DayOfWeek.parse('-1'), equals(DayOfWeek.saturday));
    });

    test('parses "-7" as sunday (wraps)', () {
      expect(DayOfWeek.parse('-7'), equals(DayOfWeek.sunday));
    });
  });

  group('DayOfWeek.parse — case insensitivity', () {
    test('parses "Monday" (title case)', () {
      expect(DayOfWeek.parse('Monday'), equals(DayOfWeek.monday));
    });

    test('parses "MONDAY" (upper case)', () {
      expect(DayOfWeek.parse('MONDAY'), equals(DayOfWeek.monday));
    });

    test('parses "MON" (upper case abbreviation)', () {
      expect(DayOfWeek.parse('MON'), equals(DayOfWeek.monday));
    });

    test('parses "Sunday" (title case)', () {
      expect(DayOfWeek.parse('Sunday'), equals(DayOfWeek.sunday));
    });

    test('parses "SUNDAY" (upper case)', () {
      expect(DayOfWeek.parse('SUNDAY'), equals(DayOfWeek.sunday));
    });

    test('parses "SUN" (upper case abbreviation)', () {
      expect(DayOfWeek.parse('SUN'), equals(DayOfWeek.sunday));
    });

    test('parses "WeDnEsDaY" (mixed case)', () {
      expect(DayOfWeek.parse('WeDnEsDaY'), equals(DayOfWeek.wednesday));
    });
  });

  group('DayOfWeek.parse — whitespace handling', () {
    test('parses " monday " (surrounding whitespace)', () {
      expect(DayOfWeek.parse(' monday '), equals(DayOfWeek.monday));
    });

    test('parses "m on day" (internal whitespace)', () {
      expect(DayOfWeek.parse('m on day'), equals(DayOfWeek.monday));
    });

    test('parses "  sun  " (surrounding whitespace)', () {
      expect(DayOfWeek.parse('  sun  '), equals(DayOfWeek.sunday));
    });

    test('parses "s un" (internal whitespace in abbreviation)', () {
      expect(DayOfWeek.parse('s un'), equals(DayOfWeek.sunday));
    });

    test('parses " 1 " (surrounding whitespace around integer)', () {
      expect(DayOfWeek.parse(' 1 '), equals(DayOfWeek.monday));
    });

    test('parses "\t friday \n" (tab and newline whitespace)', () {
      expect(DayOfWeek.parse('\t friday \n'), equals(DayOfWeek.friday));
    });
  });

  group('DayOfWeek.parse — invalid input', () {
    test('throws FormatException for empty string', () {
      expect(() => DayOfWeek.parse(''), throwsA(isA<FormatException>()));
    });

    test('throws FormatException for whitespace-only string', () {
      expect(() => DayOfWeek.parse('   '), throwsA(isA<FormatException>()));
    });

    test('throws FormatException for unknown string', () {
      expect(
        () => DayOfWeek.parse('wednesday2'),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws FormatException for partial name (2-letter)', () {
      expect(() => DayOfWeek.parse('mo'), throwsA(isA<FormatException>()));
    });

    test('throws FormatException for partial name (4-letter)', () {
      expect(() => DayOfWeek.parse('mond'), throwsA(isA<FormatException>()));
    });

    test('throws FormatException for arbitrary word', () {
      expect(() => DayOfWeek.parse('holiday'), throwsA(isA<FormatException>()));
    });

    test('throws FormatException for float string', () {
      expect(() => DayOfWeek.parse('1.0'), throwsA(isA<FormatException>()));
    });

    test('FormatException message contains the enum name', () {
      expect(
        () => DayOfWeek.parse('invalid'),
        throwsA(
          isA<FormatException>().having(
            (final FormatException e) => e.message,
            'message',
            contains('DayOfWeek'),
          ),
        ),
      );
    });

    test('FormatException message contains the invalid string', () {
      expect(
        () => DayOfWeek.parse('invalid'),
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
        () => DayOfWeek.parse('invalid'),
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
        () => DayOfWeek.parse('INVALID'),
        throwsA(
          isA<FormatException>().having(
            (final FormatException e) => e.source,
            'source',
            equals('INVALID'),
          ),
        ),
      );
    });
  });

  group('DayOfWeek.compareTo', () {
    test('monday compared to itself returns 0', () {
      expect(DayOfWeek.monday.compareTo(DayOfWeek.monday), equals(0));
    });

    test('sunday compared to itself returns 0', () {
      expect(DayOfWeek.sunday.compareTo(DayOfWeek.sunday), equals(0));
    });

    test('monday comes before tuesday', () {
      expect(DayOfWeek.monday.compareTo(DayOfWeek.tuesday), isNegative);
    });

    test('tuesday comes after monday', () {
      expect(DayOfWeek.tuesday.compareTo(DayOfWeek.monday), isPositive);
    });

    test('monday comes before sunday', () {
      expect(DayOfWeek.monday.compareTo(DayOfWeek.sunday), isNegative);
    });

    test('sunday comes after monday', () {
      expect(DayOfWeek.sunday.compareTo(DayOfWeek.monday), isPositive);
    });

    test('each adjacent pair is in ascending order', () {
      for (int i = 0; i < DayOfWeek.values.length - 1; i++) {
        expect(
          DayOfWeek.values[i].compareTo(DayOfWeek.values[i + 1]),
          isNegative,
          reason:
              '${DayOfWeek.values[i]} should come before '
              '${DayOfWeek.values[i + 1]}',
        );
      }
    });
  });

  group('DayOfWeek operator <', () {
    test('monday < tuesday is true', () {
      expect(DayOfWeek.monday < DayOfWeek.tuesday, isTrue);
    });

    test('tuesday < monday is false', () {
      expect(DayOfWeek.tuesday < DayOfWeek.monday, isFalse);
    });

    test('monday < monday is false', () {
      expect(DayOfWeek.monday < DayOfWeek.monday, isFalse);
    });

    test('sunday < sunday is false', () {
      expect(DayOfWeek.sunday < DayOfWeek.sunday, isFalse);
    });

    test('monday < sunday is true', () {
      expect(DayOfWeek.monday < DayOfWeek.sunday, isTrue);
    });

    test('sunday < monday is false', () {
      expect(DayOfWeek.sunday < DayOfWeek.monday, isFalse);
    });
  });

  group('DayOfWeek operator <=', () {
    test('monday <= tuesday is true', () {
      expect(DayOfWeek.monday <= DayOfWeek.tuesday, isTrue);
    });

    test('tuesday <= monday is false', () {
      expect(DayOfWeek.tuesday <= DayOfWeek.monday, isFalse);
    });

    test('monday <= monday is true', () {
      expect(DayOfWeek.monday <= DayOfWeek.monday, isTrue);
    });

    test('sunday <= sunday is true', () {
      expect(DayOfWeek.sunday <= DayOfWeek.sunday, isTrue);
    });

    test('monday <= sunday is true', () {
      expect(DayOfWeek.monday <= DayOfWeek.sunday, isTrue);
    });

    test('sunday <= monday is false', () {
      expect(DayOfWeek.sunday <= DayOfWeek.monday, isFalse);
    });
  });

  group('DayOfWeek operator >', () {
    test('tuesday > monday is true', () {
      expect(DayOfWeek.tuesday > DayOfWeek.monday, isTrue);
    });

    test('monday > tuesday is false', () {
      expect(DayOfWeek.monday > DayOfWeek.tuesday, isFalse);
    });

    test('monday > monday is false', () {
      expect(DayOfWeek.monday > DayOfWeek.monday, isFalse);
    });

    test('sunday > sunday is false', () {
      expect(DayOfWeek.sunday > DayOfWeek.sunday, isFalse);
    });

    test('sunday > monday is true', () {
      expect(DayOfWeek.sunday > DayOfWeek.monday, isTrue);
    });

    test('monday > sunday is false', () {
      expect(DayOfWeek.monday > DayOfWeek.sunday, isFalse);
    });
  });

  group('DayOfWeek operator >=', () {
    test('tuesday >= monday is true', () {
      expect(DayOfWeek.tuesday >= DayOfWeek.monday, isTrue);
    });

    test('monday >= tuesday is false', () {
      expect(DayOfWeek.monday >= DayOfWeek.tuesday, isFalse);
    });

    test('monday >= monday is true', () {
      expect(DayOfWeek.monday >= DayOfWeek.monday, isTrue);
    });

    test('sunday >= sunday is true', () {
      expect(DayOfWeek.sunday >= DayOfWeek.sunday, isTrue);
    });

    test('sunday >= monday is true', () {
      expect(DayOfWeek.sunday >= DayOfWeek.monday, isTrue);
    });

    test('monday >= sunday is false', () {
      expect(DayOfWeek.monday >= DayOfWeek.sunday, isFalse);
    });
  });

  group('DayOfWeek.toString', () {
    test('monday returns "monday"', () {
      expect(DayOfWeek.monday.toString(), equals('monday'));
    });

    test('tuesday returns "tuesday"', () {
      expect(DayOfWeek.tuesday.toString(), equals('tuesday'));
    });

    test('wednesday returns "wednesday"', () {
      expect(DayOfWeek.wednesday.toString(), equals('wednesday'));
    });

    test('thursday returns "thursday"', () {
      expect(DayOfWeek.thursday.toString(), equals('thursday'));
    });

    test('friday returns "friday"', () {
      expect(DayOfWeek.friday.toString(), equals('friday'));
    });

    test('saturday returns "saturday"', () {
      expect(DayOfWeek.saturday.toString(), equals('saturday'));
    });

    test('sunday returns "sunday"', () {
      expect(DayOfWeek.sunday.toString(), equals('sunday'));
    });

    test('toString is always lower-case for all values', () {
      for (final DayOfWeek day in DayOfWeek.values) {
        expect(day.toString(), equals(day.toString().toLowerCase()));
      }
    });

    test('toString results are all distinct', () {
      final Set<String> strings = DayOfWeek.values
          .map((final DayOfWeek d) => d.toString())
          .toSet();
      expect(strings, hasLength(DayOfWeek.values.length));
    });
  });

  group('DayOfWeek — parse/toString round-trip', () {
    test('all values survive a parse(toString()) round-trip', () {
      for (final DayOfWeek day in DayOfWeek.values) {
        expect(
          DayOfWeek.parse(day.toString()),
          equals(day),
          reason: '$day should round-trip correctly',
        );
      }
    });

    test('fromNumber(number) round-trip for all values', () {
      for (final DayOfWeek day in DayOfWeek.values) {
        expect(
          DayOfWeek.fromNumber(day.number),
          equals(day),
          reason: 'fromNumber(${day.number}) should return $day',
        );
      }
    });
  });

  group('DayOfWeek — ordering consistency', () {
    test('monday is the minimum value', () {
      final List<DayOfWeek> sorted = List<DayOfWeek>.from(DayOfWeek.values)
        ..sort((final DayOfWeek a, final DayOfWeek b) => a.compareTo(b));
      expect(sorted.first, equals(DayOfWeek.monday));
    });

    test('sunday is the maximum value', () {
      final List<DayOfWeek> sorted = List<DayOfWeek>.from(DayOfWeek.values)
        ..sort((final DayOfWeek a, final DayOfWeek b) => a.compareTo(b));
      expect(sorted.last, equals(DayOfWeek.sunday));
    });

    test('sorted order matches the weekday sequence', () {
      final List<DayOfWeek> sorted = List<DayOfWeek>.from(DayOfWeek.values)
        ..sort((final DayOfWeek a, final DayOfWeek b) => a.compareTo(b));
      expect(sorted, equals(DayOfWeek.values));
    });

    test('compareTo is consistent with < operator', () {
      for (final DayOfWeek a in DayOfWeek.values) {
        for (final DayOfWeek b in DayOfWeek.values) {
          expect(a < b, equals(a.compareTo(b) < 0));
        }
      }
    });

    test('compareTo is consistent with <= operator', () {
      for (final DayOfWeek a in DayOfWeek.values) {
        for (final DayOfWeek b in DayOfWeek.values) {
          expect(a <= b, equals(a.compareTo(b) <= 0));
        }
      }
    });

    test('compareTo is consistent with > operator', () {
      for (final DayOfWeek a in DayOfWeek.values) {
        for (final DayOfWeek b in DayOfWeek.values) {
          expect(a > b, equals(a.compareTo(b) > 0));
        }
      }
    });

    test('compareTo is consistent with >= operator', () {
      for (final DayOfWeek a in DayOfWeek.values) {
        for (final DayOfWeek b in DayOfWeek.values) {
          expect(a >= b, equals(a.compareTo(b) >= 0));
        }
      }
    });

    test('compareTo is antisymmetric', () {
      expect(
        DayOfWeek.monday.compareTo(DayOfWeek.sunday).sign,
        equals(-DayOfWeek.sunday.compareTo(DayOfWeek.monday).sign),
      );
    });

    test('compareTo is transitive', () {
      // monday < wednesday < friday => monday < friday
      expect(DayOfWeek.monday.compareTo(DayOfWeek.wednesday), isNegative);
      expect(DayOfWeek.wednesday.compareTo(DayOfWeek.friday), isNegative);
      expect(DayOfWeek.monday.compareTo(DayOfWeek.friday), isNegative);
    });

    test('ordering is determined by the number property', () {
      for (final DayOfWeek a in DayOfWeek.values) {
        for (final DayOfWeek b in DayOfWeek.values) {
          expect(
            a.compareTo(b).sign,
            equals(a.number.compareTo(b.number).sign),
          );
        }
      }
    });
  });
}
