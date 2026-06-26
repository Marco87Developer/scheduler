import 'package:scheduler/src/models/service_year.dart';
import 'package:test/test.dart';

void main() {
  // -------------------------------------------------------------------------
  // Fixtures — used across groups.
  // const construction is tested here too: if the line below does not
  // compile, the const-constructor guarantee is broken.
  // -------------------------------------------------------------------------

  const ServiceYear sy2024 = ServiceYear(2024);
  const ServiceYear sy2025 = ServiceYear(2025);
  const ServiceYear sy2023 = ServiceYear(2023);

  // -------------------------------------------------------------------------
  // Static constants
  // -------------------------------------------------------------------------

  group('ServiceYear.className', () {
    test('equals "ServiceYear"', () {
      expect(ServiceYear.className, equals('ServiceYear'));
    });
  });

  group('ServiceYear.firstMonth', () {
    test('equals 9 (September)', () {
      expect(ServiceYear.firstMonth, equals(9));
    });
  });

  group('ServiceYear.lastMonth', () {
    test('equals 8 (August)', () {
      expect(ServiceYear.lastMonth, equals(8));
    });

    test('is one less than firstMonth (mod 12)', () {
      expect(
        (ServiceYear.lastMonth + 1) % 12,
        equals(ServiceYear.firstMonth % 12),
      );
    });
  });

  // -------------------------------------------------------------------------
  // ServiceYear(startingYear) — primary constructor
  // -------------------------------------------------------------------------

  group('ServiceYear(startingYear) — const construction', () {
    test('instance is equal to a second const with the same year', () {
      expect(sy2024, equals(const ServiceYear(2024)));
    });
  });

  group('ServiceYear(startingYear) — startingYear', () {
    test('stores the provided year', () {
      expect(sy2024.startingYear, equals(2024));
    });

    test('stores year 0', () {
      expect(const ServiceYear(0).startingYear, equals(0));
    });

    test('stores negative years', () {
      expect(const ServiceYear(-1).startingYear, equals(-1));
    });
  });

  group('ServiceYear(startingYear) — start getter', () {
    test('is 1 September of startingYear', () {
      expect(sy2024.start, equals(DateTime(2024, 9)));
    });

    test('day is always 1', () {
      expect(sy2024.start.day, equals(1));
    });

    test('month equals firstMonth', () {
      expect(sy2024.start.month, equals(ServiceYear.firstMonth));
    });

    test('year equals startingYear', () {
      expect(sy2024.start.year, equals(2024));
    });

    test('returns a new equal DateTime on each call (no identity)', () {
      expect(sy2024.start, equals(sy2024.start));
    });
  });

  group('ServiceYear(startingYear) — end getter', () {
    test('is 1 September of startingYear + 1', () {
      expect(sy2024.end, equals(DateTime(2025, 9)));
    });

    test('day is always 1', () {
      expect(sy2024.end.day, equals(1));
    });

    test('month equals firstMonth', () {
      expect(sy2024.end.month, equals(ServiceYear.firstMonth));
    });

    test('year is startingYear + 1', () {
      expect(sy2024.end.year, equals(2025));
    });

    test('end is exactly one year after start (365 days, 2024-2025)', () {
      expect(sy2024.end.difference(sy2024.start).inDays, equals(365));
    });

    test('end is a leap-year span when applicable (2023-2024: 366 days)', () {
      // 2024 is a leap year; the span Sep 2023 – Sep 2024 crosses it.
      expect(sy2023.end.difference(sy2023.start).inDays, equals(366));
    });

    test('end equals start of the next service year', () {
      expect(sy2024.end, equals(sy2025.start));
    });
  });

  // -------------------------------------------------------------------------
  // ServiceYear.fromReference
  // -------------------------------------------------------------------------

  group('ServiceYear.fromReference — month >= September', () {
    test('September → service year starting that calendar year', () {
      expect(
        ServiceYear.fromReference(DateTime(2024, 9)).startingYear,
        equals(2024),
      );
    });

    test('October → service year starting that calendar year', () {
      expect(
        ServiceYear.fromReference(DateTime(2024, 10, 15)).startingYear,
        equals(2024),
      );
    });

    test('December → service year starting that calendar year', () {
      expect(
        ServiceYear.fromReference(DateTime(2024, 12, 31)).startingYear,
        equals(2024),
      );
    });
  });

  group('ServiceYear.fromReference — month < September', () {
    test('January → service year that started the previous year', () {
      expect(
        ServiceYear.fromReference(DateTime(2025)).startingYear,
        equals(2024),
      );
    });

    test('August → service year that started the previous year', () {
      expect(
        ServiceYear.fromReference(DateTime(2025, 8, 31)).startingYear,
        equals(2024),
      );
    });

    test('February → service year that started the previous year', () {
      expect(
        ServiceYear.fromReference(DateTime(2025, 2, 14)).startingYear,
        equals(2024),
      );
    });
  });

  group('ServiceYear.fromReference — boundary', () {
    test('exactly 1 Sep belongs to that service year', () {
      expect(
        ServiceYear.fromReference(DateTime(2024, 9)),
        equals(const ServiceYear(2024)),
      );
    });

    test('31 Aug belongs to the previous service year', () {
      expect(
        ServiceYear.fromReference(DateTime(2024, 8, 31)),
        equals(const ServiceYear(2023)),
      );
    });

    test('covers all 12 months correctly', () {
      for (int m = 1; m <= 12; m++) {
        final int expected = m >= ServiceYear.firstMonth ? 2024 : 2023;
        expect(
          ServiceYear.fromReference(DateTime(2024, m, 15)).startingYear,
          equals(expected),
          reason: 'month $m',
        );
      }
    });
  });

  group('ServiceYear.fromReference — round-trip', () {
    test('fromReference(start) reproduces the service year', () {
      expect(ServiceYear.fromReference(sy2024.start), equals(sy2024));
    });

    test('fromReference(end - 1 day) reproduces the service year', () {
      final DateTime lastDay = sy2024.end.subtract(const Duration(days: 1));
      expect(ServiceYear.fromReference(lastDay), equals(sy2024));
    });
  });

  // -------------------------------------------------------------------------
  // ServiceYear.parse
  // -------------------------------------------------------------------------

  group('ServiceYear.parse — valid input', () {
    test('parses "2024"', () {
      expect(ServiceYear.parse('2024'), equals(const ServiceYear(2024)));
    });

    test('parses "0"', () {
      expect(ServiceYear.parse('0'), equals(const ServiceYear(0)));
    });

    test('parses negative year "-1"', () {
      expect(ServiceYear.parse('-1'), equals(const ServiceYear(-1)));
    });

    test('strips single surrounding spaces', () {
      expect(ServiceYear.parse(' 2024 '), equals(const ServiceYear(2024)));
    });

    test('strips multiple surrounding spaces', () {
      expect(ServiceYear.parse('  2024  '), equals(const ServiceYear(2024)));
    });

    test('strips tab and newline whitespace', () {
      expect(ServiceYear.parse('\t2024\n'), equals(const ServiceYear(2024)));
    });
  });

  group('ServiceYear.parse — invalid input', () {
    test('throws FormatException for empty string', () {
      expect(() => ServiceYear.parse(''), throwsA(isA<FormatException>()));
    });

    test('throws FormatException for whitespace-only string', () {
      expect(() => ServiceYear.parse('   '), throwsA(isA<FormatException>()));
    });

    test('throws FormatException for alphabetic string', () {
      expect(() => ServiceYear.parse('abc'), throwsA(isA<FormatException>()));
    });

    test('throws FormatException for float string', () {
      expect(
        () => ServiceYear.parse('2024.5'),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws FormatException for mixed string', () {
      expect(() => ServiceYear.parse('20a4'), throwsA(isA<FormatException>()));
    });

    test('FormatException message contains "ServiceYear"', () {
      expect(
        () => ServiceYear.parse('bad'),
        throwsA(
          isA<FormatException>().having(
            (final FormatException e) => e.message,
            'message',
            contains('ServiceYear'),
          ),
        ),
      );
    });

    test('FormatException message contains ".parse"', () {
      expect(
        () => ServiceYear.parse('bad'),
        throwsA(
          isA<FormatException>().having(
            (final FormatException e) => e.message,
            'message',
            contains('.parse'),
          ),
        ),
      );
    });

    test('FormatException message contains the invalid string', () {
      expect(
        () => ServiceYear.parse('bad'),
        throwsA(
          isA<FormatException>().having(
            (final FormatException e) => e.message,
            'message',
            contains('bad'),
          ),
        ),
      );
    });

    test('FormatException source is the original unmodified string', () {
      expect(
        () => ServiceYear.parse(' bad '),
        throwsA(
          isA<FormatException>().having(
            (final FormatException e) => e.source,
            'source',
            equals(' bad '),
          ),
        ),
      );
    });
  });

  group('ServiceYear.parse — round-trip', () {
    test('parse(toString()) reproduces the original', () {
      expect(ServiceYear.parse(sy2024.toString()), equals(sy2024));
    });

    test('round-trip is stable for a range of years', () {
      for (int y = 2000; y <= 2030; y++) {
        final ServiceYear original = ServiceYear(y);
        expect(
          ServiceYear.parse(original.toString()),
          equals(original),
          reason: 'year $y',
        );
      }
    });
  });

  // -------------------------------------------------------------------------
  // ServiceYear.tryParse
  // -------------------------------------------------------------------------

  group('ServiceYear.tryParse — valid input', () {
    test('returns ServiceYear for "2024"', () {
      expect(ServiceYear.tryParse('2024'), equals(const ServiceYear(2024)));
    });

    test('returns ServiceYear for "0"', () {
      expect(ServiceYear.tryParse('0'), equals(const ServiceYear(0)));
    });

    test('returns ServiceYear for "-1"', () {
      expect(ServiceYear.tryParse('-1'), equals(const ServiceYear(-1)));
    });

    test('strips surrounding whitespace', () {
      expect(ServiceYear.tryParse(' 2024 '), equals(const ServiceYear(2024)));
    });
  });

  group('ServiceYear.tryParse — invalid input returns null', () {
    test('returns null for empty string', () {
      expect(ServiceYear.tryParse(''), isNull);
    });

    test('returns null for whitespace-only string', () {
      expect(ServiceYear.tryParse('   '), isNull);
    });

    test('returns null for alphabetic string', () {
      expect(ServiceYear.tryParse('abc'), isNull);
    });

    test('returns null for float string', () {
      expect(ServiceYear.tryParse('2024.5'), isNull);
    });

    test('never throws for any input', () {
      final List<String> inputs = <String>['', '   ', 'abc', '2024.5', '20a4'];
      for (final String s in inputs) {
        expect(
          () => ServiceYear.tryParse(s),
          returnsNormally,
          reason: '"$s" must not throw',
        );
      }
    });
  });

  group('ServiceYear.tryParse — symmetry with parse', () {
    test('tryParse("2024") equals parse("2024")', () {
      expect(ServiceYear.tryParse('2024'), equals(ServiceYear.parse('2024')));
    });

    test('tryParse returns null where parse would throw', () {
      expect(ServiceYear.tryParse('invalid'), isNull);
    });
  });

  // -------------------------------------------------------------------------
  // contains
  // -------------------------------------------------------------------------

  group('ServiceYear.contains — returns true', () {
    test('start (1 Sep) is inside', () {
      expect(sy2024.contains(DateTime(2024, 9)), isTrue);
    });

    test('mid-year date is inside', () {
      expect(sy2024.contains(DateTime(2025, 3, 15)), isTrue);
    });

    test('31 Aug of the ending year is inside', () {
      expect(sy2024.contains(DateTime(2025, 8, 31)), isTrue);
    });

    test('1 ms before end is inside', () {
      final DateTime almostEnd = sy2024.end.subtract(
        const Duration(milliseconds: 1),
      );
      expect(sy2024.contains(almostEnd), isTrue);
    });

    test('every first-of-month inside the year returns true', () {
      for (int m = 9; m <= 12; m++) {
        expect(
          sy2024.contains(DateTime(2024, m)),
          isTrue,
          reason: '2024-$m-01',
        );
      }
      for (int m = 1; m <= 8; m++) {
        expect(
          sy2024.contains(DateTime(2025, m)),
          isTrue,
          reason: '2025-$m-01',
        );
      }
    });
  });

  group('ServiceYear.contains — returns false', () {
    test('end (1 Sep of next year) is outside', () {
      expect(sy2024.contains(DateTime(2025, 9)), isFalse);
    });

    test('31 Aug of the starting year is outside', () {
      expect(sy2024.contains(DateTime(2024, 8, 31)), isFalse);
    });

    test('date two years in the future is outside', () {
      expect(sy2024.contains(DateTime(2027)), isFalse);
    });

    test('date two years in the past is outside', () {
      expect(sy2024.contains(DateTime(2020)), isFalse);
    });

    test('noon on 31 Aug of the ending year is inside (not excluded)', () {
      // Confirms end = Sep 1, not Aug 31 midnight.
      expect(sy2024.contains(DateTime(2025, 8, 31, 12)), isTrue);
    });
  });

  group('ServiceYear.contains — consistency with fromReference', () {
    test('agrees with fromReference for dates spanning both years', () {
      final List<DateTime> dates = <DateTime>[
        DateTime(2024, 9),
        DateTime(2025, 3, 15),
        DateTime(2025, 8, 31),
        DateTime(2024, 8, 31),
        DateTime(2025, 9),
      ];
      for (final DateTime d in dates) {
        expect(
          sy2024.contains(d),
          equals(ServiceYear.fromReference(d) == sy2024),
          reason: d.toIso8601String(),
        );
      }
    });
  });

  // -------------------------------------------------------------------------
  // == and hashCode
  // -------------------------------------------------------------------------

  group('ServiceYear.== and hashCode', () {
    test('same startingYear produces equal instances', () {
      expect(const ServiceYear(2024), equals(const ServiceYear(2024)));
    });

    test('different startingYears are not equal', () {
      expect(sy2024, isNot(equals(sy2025)));
    });

    test('identical instance equals itself', () {
      expect(sy2024, equals(sy2024));
    });

    test('equal instances have the same hashCode', () {
      expect(
        const ServiceYear(2024).hashCode,
        equals(const ServiceYear(2024).hashCode),
      );
    });

    test('parse and primary produce equal instances', () {
      expect(ServiceYear.parse('2024'), equals(const ServiceYear(2024)));
    });

    test('fromReference and primary produce equal instances', () {
      expect(
        ServiceYear.fromReference(DateTime(2024, 10)),
        equals(const ServiceYear(2024)),
      );
    });

    test('equal instances from different constructors share hashCode', () {
      final ServiceYear fromRef = ServiceYear.fromReference(DateTime(2024, 10));
      expect(fromRef.hashCode, equals(const ServiceYear(2024).hashCode));
    });
  });

  // -------------------------------------------------------------------------
  // compareTo
  // -------------------------------------------------------------------------

  group('ServiceYear.compareTo', () {
    test('identical instance returns 0', () {
      expect(sy2024.compareTo(sy2024), equals(0));
    });

    test('equal instances (different objects) return 0', () {
      expect(
        const ServiceYear(2024).compareTo(const ServiceYear(2024)),
        equals(0),
      );
    });

    test('earlier year vs later year returns negative', () {
      expect(sy2023.compareTo(sy2024), isNegative);
    });

    test('later year vs earlier year returns positive', () {
      expect(sy2025.compareTo(sy2024), isPositive);
    });

    test('is antisymmetric', () {
      expect(
        sy2023.compareTo(sy2025).sign,
        equals(-sy2025.compareTo(sy2023).sign),
      );
    });

    test('is transitive', () {
      expect(sy2023.compareTo(sy2024), isNegative);
      expect(sy2024.compareTo(sy2025), isNegative);
      expect(sy2023.compareTo(sy2025), isNegative);
    });
  });

  // -------------------------------------------------------------------------
  // Operators < <= > >=
  // -------------------------------------------------------------------------

  group('ServiceYear operator <', () {
    test('sy2023 < sy2024 is true', () {
      expect(sy2023 < sy2024, isTrue);
    });

    test('sy2024 < sy2023 is false', () {
      expect(sy2024 < sy2023, isFalse);
    });

    test('sy2024 < sy2024 is false', () {
      expect(sy2024 < sy2024, isFalse);
    });

    test('consistent with compareTo for all fixture pairs', () {
      final List<ServiceYear> years = <ServiceYear>[sy2023, sy2024, sy2025];
      for (final ServiceYear a in years) {
        for (final ServiceYear b in years) {
          expect(a < b, equals(a.compareTo(b) < 0));
        }
      }
    });
  });

  group('ServiceYear operator <=', () {
    test('sy2023 <= sy2024 is true', () {
      expect(sy2023 <= sy2024, isTrue);
    });

    test('sy2024 <= sy2023 is false', () {
      expect(sy2024 <= sy2023, isFalse);
    });

    test('sy2024 <= sy2024 is true', () {
      expect(sy2024 <= sy2024, isTrue);
    });

    test('consistent with compareTo for all fixture pairs', () {
      final List<ServiceYear> years = <ServiceYear>[sy2023, sy2024, sy2025];
      for (final ServiceYear a in years) {
        for (final ServiceYear b in years) {
          expect(a <= b, equals(a.compareTo(b) <= 0));
        }
      }
    });
  });

  group('ServiceYear operator >', () {
    test('sy2025 > sy2024 is true', () {
      expect(sy2025 > sy2024, isTrue);
    });

    test('sy2024 > sy2025 is false', () {
      expect(sy2024 > sy2025, isFalse);
    });

    test('sy2024 > sy2024 is false', () {
      expect(sy2024 > sy2024, isFalse);
    });

    test('consistent with compareTo for all fixture pairs', () {
      final List<ServiceYear> years = <ServiceYear>[sy2023, sy2024, sy2025];
      for (final ServiceYear a in years) {
        for (final ServiceYear b in years) {
          expect(a > b, equals(a.compareTo(b) > 0));
        }
      }
    });
  });

  group('ServiceYear operator >=', () {
    test('sy2025 >= sy2024 is true', () {
      expect(sy2025 >= sy2024, isTrue);
    });

    test('sy2024 >= sy2025 is false', () {
      expect(sy2024 >= sy2025, isFalse);
    });

    test('sy2024 >= sy2024 is true', () {
      expect(sy2024 >= sy2024, isTrue);
    });

    test('consistent with compareTo for all fixture pairs', () {
      final List<ServiceYear> years = <ServiceYear>[sy2023, sy2024, sy2025];
      for (final ServiceYear a in years) {
        for (final ServiceYear b in years) {
          expect(a >= b, equals(a.compareTo(b) >= 0));
        }
      }
    });
  });

  group('ServiceYear — ordering consistency', () {
    test('sorted list is in ascending startingYear order', () {
      final List<ServiceYear> unsorted = <ServiceYear>[sy2025, sy2023, sy2024]
        ..sort((final ServiceYear a, final ServiceYear b) => a.compareTo(b));
      expect(unsorted, equals(<ServiceYear>[sy2023, sy2024, sy2025]));
    });
  });

  // -------------------------------------------------------------------------
  // monthsPassed
  // -------------------------------------------------------------------------

  group('ServiceYear.monthsPassed — inside the service year', () {
    test('September returns 0', () {
      expect(sy2024.monthsPassed(DateTime(2024, 9)), equals(0));
    });

    test('October returns 1', () {
      expect(sy2024.monthsPassed(DateTime(2024, 10)), equals(1));
    });

    test('November returns 2', () {
      expect(sy2024.monthsPassed(DateTime(2024, 11)), equals(2));
    });

    test('December returns 3', () {
      expect(sy2024.monthsPassed(DateTime(2024, 12)), equals(3));
    });

    test('January returns 4', () {
      expect(sy2024.monthsPassed(DateTime(2025)), equals(4));
    });

    test('February returns 5', () {
      expect(sy2024.monthsPassed(DateTime(2025, 2)), equals(5));
    });

    test('March returns 6', () {
      expect(sy2024.monthsPassed(DateTime(2025, 3)), equals(6));
    });

    test('April returns 7', () {
      expect(sy2024.monthsPassed(DateTime(2025, 4)), equals(7));
    });

    test('May returns 8', () {
      expect(sy2024.monthsPassed(DateTime(2025, 5)), equals(8));
    });

    test('June returns 9', () {
      expect(sy2024.monthsPassed(DateTime(2025, 6)), equals(9));
    });

    test('July returns 10', () {
      expect(sy2024.monthsPassed(DateTime(2025, 7)), equals(10));
    });

    test('August returns 11', () {
      expect(sy2024.monthsPassed(DateTime(2025, 8)), equals(11));
    });

    test('day-of-month does not affect the result', () {
      expect(
        sy2024.monthsPassed(DateTime(2024, 11, 30)),
        equals(sy2024.monthsPassed(DateTime(2024, 11))),
      );
    });
  });

  group('ServiceYear.monthsPassed — outside the service year', () {
    test('returns null for 31 Aug before service year', () {
      expect(sy2024.monthsPassed(DateTime(2024, 8, 31)), isNull);
    });

    test('returns null for 1 Sep of the following service year', () {
      expect(sy2024.monthsPassed(DateTime(2025, 9)), isNull);
    });

    test('returns null for a far-future date', () {
      expect(sy2024.monthsPassed(DateTime(2030)), isNull);
    });

    test('returns null for a far-past date', () {
      expect(sy2024.monthsPassed(DateTime(2000)), isNull);
    });
  });

  group('ServiceYear.monthsPassed — invariants', () {
    test('all inside values are in 0..11', () {
      for (int m = 9; m <= 12; m++) {
        expect(
          sy2024.monthsPassed(DateTime(2024, m)),
          inInclusiveRange(0, 11),
          reason: '2024-$m',
        );
      }
      for (int m = 1; m <= 8; m++) {
        expect(
          sy2024.monthsPassed(DateTime(2025, m)),
          inInclusiveRange(0, 11),
          reason: '2025-$m',
        );
      }
    });

    test('increases monotonically from September through August', () {
      final List<int?> values = <int?>[
        for (int m = 9; m <= 12; m++) sy2024.monthsPassed(DateTime(2024, m)),
        for (int m = 1; m <= 8; m++) sy2024.monthsPassed(DateTime(2025, m)),
      ];
      for (int i = 0; i < values.length - 1; i++) {
        expect(values[i], lessThan(values[i + 1]!));
      }
    });
  });

  // -------------------------------------------------------------------------
  // monthsLeft
  // -------------------------------------------------------------------------

  group('ServiceYear.monthsLeft — inside the service year', () {
    test('September returns 12', () {
      expect(sy2024.monthsLeft(DateTime(2024, 9)), equals(12));
    });

    test('October returns 11', () {
      expect(sy2024.monthsLeft(DateTime(2024, 10)), equals(11));
    });

    test('November returns 10', () {
      expect(sy2024.monthsLeft(DateTime(2024, 11)), equals(10));
    });

    test('December returns 9', () {
      expect(sy2024.monthsLeft(DateTime(2024, 12)), equals(9));
    });

    test('January returns 8', () {
      expect(sy2024.monthsLeft(DateTime(2025)), equals(8));
    });

    test('February returns 7', () {
      expect(sy2024.monthsLeft(DateTime(2025, 2)), equals(7));
    });

    test('March returns 6', () {
      expect(sy2024.monthsLeft(DateTime(2025, 3)), equals(6));
    });

    test('April returns 5', () {
      expect(sy2024.monthsLeft(DateTime(2025, 4)), equals(5));
    });

    test('May returns 4', () {
      expect(sy2024.monthsLeft(DateTime(2025, 5)), equals(4));
    });

    test('June returns 3', () {
      expect(sy2024.monthsLeft(DateTime(2025, 6)), equals(3));
    });

    test('July returns 2', () {
      expect(sy2024.monthsLeft(DateTime(2025, 7)), equals(2));
    });

    test('August returns 1', () {
      expect(sy2024.monthsLeft(DateTime(2025, 8)), equals(1));
    });
  });

  group('ServiceYear.monthsLeft — outside the service year', () {
    test('returns null for date before the service year', () {
      expect(sy2024.monthsLeft(DateTime(2024, 8, 31)), isNull);
    });

    test('returns null for 1 Sep of the following service year', () {
      expect(sy2024.monthsLeft(DateTime(2025, 9)), isNull);
    });

    test('returns null for a far-future date', () {
      expect(sy2024.monthsLeft(DateTime(2030)), isNull);
    });

    test('returns null for a far-past date', () {
      expect(sy2024.monthsLeft(DateTime(2000)), isNull);
    });
  });

  group('ServiceYear.monthsLeft — invariants', () {
    test('all inside values are in 1..12', () {
      for (int m = 9; m <= 12; m++) {
        expect(
          sy2024.monthsLeft(DateTime(2024, m)),
          inInclusiveRange(1, 12),
          reason: '2024-$m',
        );
      }
      for (int m = 1; m <= 8; m++) {
        expect(
          sy2024.monthsLeft(DateTime(2025, m)),
          inInclusiveRange(1, 12),
          reason: '2025-$m',
        );
      }
    });

    test('monthsPassed + monthsLeft == 12 for every month inside', () {
      for (int m = 9; m <= 12; m++) {
        final DateTime d = DateTime(2024, m);
        expect(
          sy2024.monthsPassed(d)! + sy2024.monthsLeft(d)!,
          equals(12),
          reason: '2024-$m',
        );
      }
      for (int m = 1; m <= 8; m++) {
        final DateTime d = DateTime(2025, m);
        expect(
          sy2024.monthsPassed(d)! + sy2024.monthsLeft(d)!,
          equals(12),
          reason: '2025-$m',
        );
      }
    });

    test('decreases monotonically from September through August', () {
      final List<int?> values = <int?>[
        for (int m = 9; m <= 12; m++) sy2024.monthsLeft(DateTime(2024, m)),
        for (int m = 1; m <= 8; m++) sy2024.monthsLeft(DateTime(2025, m)),
      ];
      for (int i = 0; i < values.length - 1; i++) {
        expect(values[i], greaterThan(values[i + 1]!));
      }
    });
  });

  // -------------------------------------------------------------------------
  // toString
  // -------------------------------------------------------------------------

  group('ServiceYear.toString', () {
    test('returns the startingYear as a decimal string', () {
      expect(sy2024.toString(), equals('2024'));
    });

    test('returns "2025" for sy2025', () {
      expect(sy2025.toString(), equals('2025'));
    });

    test('returns "0" for year 0', () {
      expect(const ServiceYear(0).toString(), equals('0'));
    });

    test('returns negative year correctly', () {
      expect(const ServiceYear(-1).toString(), equals('-1'));
    });

    test('is deterministic', () {
      expect(sy2024.toString(), equals(sy2024.toString()));
    });

    test('all years in a range produce distinct strings', () {
      final Set<String> strings = <String>{
        for (int y = 2000; y <= 2030; y++) ServiceYear(y).toString(),
      };
      expect(strings, hasLength(31));
    });
  });
}
