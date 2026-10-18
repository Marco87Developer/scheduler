import 'package:checks/checks.dart';
import 'package:scheduler/src/exceptions/exception_messages.dart';
import 'package:scheduler/src/models/service_year.dart';
import 'package:test/scaffolding.dart';

void main() {
  const sy2023 = ServiceYear(2023);
  const sy2024 = ServiceYear(2024);
  const sy2025 = ServiceYear(2025);
  const monthNames = <String>[
    'September',
    'October',
    'November',
    'December',
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
  ];
  // The first day of every month of sy2024, in service-year order. The index
  // of each entry is its expected number of months passed.
  final monthStarts = <DateTime>[
    for (var m = 9; m <= 12; m++) DateTime(2024, m),
    for (var m = 1; m <= 8; m++) DateTime(2025, m),
  ];

  group('ServiceYear.className', () {
    test('is "ServiceYear"', () {
      check(ServiceYear.className).equals('ServiceYear');
    });
  });

  group('ServiceYear.firstMonth', () {
    test('is 9 (September)', () {
      check(ServiceYear.firstMonth).equals(9);
    });
    test('is a valid month number', () {
      check(ServiceYear.firstMonth).isGreaterOrEqual(1);
      check(ServiceYear.firstMonth).isLessOrEqual(12);
    });
  });

  group('ServiceYear.lastMonth', () {
    test('is 8 (August)', () {
      check(ServiceYear.lastMonth).equals(8);
    });
    test('is the month right before firstMonth (wrapping around)', () {
      check((ServiceYear.lastMonth + 1) % 12)
          .equals(ServiceYear.firstMonth % 12);
    });
  });

  group('ServiceYear() — primary constructor', () {
    test('stores the given starting year', () {
      check(sy2024.startingYear).equals(2024);
    });
    test('stores year 0', () {
      check(const ServiceYear(0).startingYear).equals(0);
    });
    test('stores a negative year', () {
      check(const ServiceYear(-1).startingYear).equals(-1);
    });
    test('stores a very large year', () {
      check(const ServiceYear(1000000).startingYear).equals(1000000);
    });
    test('is const-constructible and canonicalized', () {
      check(identical(const ServiceYear(2024), const ServiceYear(2024)))
          .isTrue();
    });
    test('different const years are not identical', () {
      check(identical(const ServiceYear(2024), const ServiceYear(2025)))
          .isFalse();
    });
    test('non-const instances with the same year are distinct objects', () {
      final a = ServiceYear(int.parse('2024'));
      final b = ServiceYear(int.parse('2024'));
      check(identical(a, b)).isFalse();
      check(a).equals(b);
    });
    test('implements Comparable<ServiceYear>', () {
      check(sy2024).isA<Comparable<ServiceYear>>();
    });
  });

  group('ServiceYear.fromReference — month >= September', () {
    for (var m = 9; m <= 12; m++) {
      test('month $m of 2024 gives the service year starting in 2024', () {
        check(ServiceYear.fromReference(DateTime(2024, m, 15)).startingYear)
            .equals(2024);
      });
    }
  });

  group('ServiceYear.fromReference — month < September', () {
    for (var m = 1; m <= 8; m++) {
      test('month $m of 2025 gives the service year starting in 2024', () {
        check(ServiceYear.fromReference(DateTime(2025, m, 15)).startingYear)
            .equals(2024);
      });
    }
  });

  group('ServiceYear.fromReference — boundaries', () {
    test(
      '1 September 00:00 belongs to the service year starting that year',
      () {
        check(ServiceYear.fromReference(DateTime(2024, 9))).equals(sy2024);
      },
    );
    test('31 August 23:59:59.999 belongs to the previous service year', () {
      final reference = DateTime(2024, 8, 31, 23, 59, 59, 999);
      check(ServiceYear.fromReference(reference)).equals(sy2023);
    });
    test('1 January belongs to the service year that began last year', () {
      check(ServiceYear.fromReference(DateTime(2025))).equals(sy2024);
    });
    test('31 December belongs to the service year that began this year', () {
      check(ServiceYear.fromReference(DateTime(2024, 12, 31, 23, 59, 59)))
          .equals(sy2024);
    });
    test('the time of day does not matter', () {
      check(ServiceYear.fromReference(DateTime(2024, 10, 1, 23, 59, 59)))
          .equals(ServiceYear.fromReference(DateTime(2024, 10)));
    });
    test('works for year 0', () {
      check(ServiceYear.fromReference(DateTime(0, 9)))
          .equals(const ServiceYear(0));
      check(ServiceYear.fromReference(DateTime(1)))
          .equals(const ServiceYear(0));
    });
    test('works for years before the common era', () {
      check(ServiceYear.fromReference(DateTime(-1, 12)))
          .equals(const ServiceYear(-1));
      check(ServiceYear.fromReference(DateTime(-1, 3)))
          .equals(const ServiceYear(-2));
    });
    test('uses the calendar fields of UTC dates', () {
      check(ServiceYear.fromReference(DateTime.utc(2024, 9, 15)))
          .equals(sy2024);
      check(ServiceYear.fromReference(DateTime.utc(2025, 3, 15)))
          .equals(sy2024);
    });
    test('covers all 12 months correctly', () {
      for (var m = 1; m <= 12; m++) {
        final expected = m >= ServiceYear.firstMonth ? 2024 : 2023;
        check(ServiceYear.fromReference(DateTime(2024, m, 15)).startingYear)
            .equals(expected);
      }
    });
  });

  group('ServiceYear.fromReference — consistency', () {
    test('fromReference(start) reproduces the service year', () {
      check(ServiceYear.fromReference(sy2024.start)).equals(sy2024);
    });
    test('fromReference(end - 1 ms) reproduces the service year', () {
      final DateTime last = sy2024.end.subtract(
        const Duration(milliseconds: 1),
      );
      check(ServiceYear.fromReference(last)).equals(sy2024);
    });
    test('fromReference(end) gives the next service year', () {
      check(ServiceYear.fromReference(sy2024.end)).equals(sy2025);
    });
    test('the result always contains the reference', () {
      for (final d in monthStarts) {
        check(ServiceYear.fromReference(d).contains(d)).isTrue();
      }
    });
    test('a stored reference is not mutated and yields an equal year', () {
      final reference = DateTime(2024, 10);
      check(ServiceYear.fromReference(reference))
          .equals(ServiceYear.fromReference(reference));
      check(reference).equals(DateTime(2024, 10));
    });
  });

  group('ServiceYear.parse — valid input', () {
    test('parses "2024"', () {
      check(ServiceYear.parse('2024')).equals(sy2024);
    });
    test('parses "0"', () {
      check(ServiceYear.parse('0')).equals(const ServiceYear(0));
    });
    test('parses a negative year', () {
      check(ServiceYear.parse('-1')).equals(const ServiceYear(-1));
    });
    test('parses a year with an explicit plus sign', () {
      check(ServiceYear.parse('+2024')).equals(sy2024);
    });
    test('parses a year with leading zeros', () {
      check(ServiceYear.parse('002024')).equals(sy2024);
    });
    test('parses a hexadecimal integer like int.parse does', () {
      check(ServiceYear.parse('0x7E8')).equals(sy2024);
    });
    test('strips surrounding spaces', () {
      check(ServiceYear.parse('  2024  ')).equals(sy2024);
    });
    test('strips tabs, newlines and carriage returns', () {
      check(ServiceYear.parse('\t2024\r\n')).equals(sy2024);
    });
    test('strips Unicode whitespace', () {
      check(ServiceYear.parse('\u00A02024\u2003')).equals(sy2024);
    });
    test('returns a ServiceYear', () {
      check(ServiceYear.parse('2024')).isA<ServiceYear>();
    });
  });

  group('ServiceYear.parse — invalid input', () {
    for (final input in <String>[
      '',
      '   ',
      '\t\n\r',
      'abc',
      '20a4',
      '2024a',
      '2024.5',
      '2024.0',
      '2 024',
      '2_024',
      '2,024',
      '--2024',
      '+-2024',
      '1e3',
      'null',
      'ServiceYear(2024)',
      '2024|2025',
      '\u200B2024',
      '2024\u200B',
      '\u0662\u0660\u0662\u0664',
    ]) {
      test('throws FormatException for "${input.replaceAll('\n', r'\n')}"', () {
        check(() => ServiceYear.parse(input)).throws<FormatException>();
      });
    }
    test('the message is the parse message', () {
      check(() => ServiceYear.parse('bad'))
          .throws<FormatException>()
          .has((e) => e.message, 'message')
          .equals(parseFormatExceptionMessage(ServiceYear.className, 'bad'));
    });
    test('the message contains "ServiceYear", ".parse" and the input', () {
      check(() => ServiceYear.parse('bad'))
          .throws<FormatException>()
          .has((e) => e.message, 'message')
        ..contains('ServiceYear')
        ..contains('.parse')
        ..contains('bad');
    });
    test('the source is the original, unmodified string', () {
      check(() => ServiceYear.parse(' bad '))
          .throws<FormatException>()
          .has((e) => e.source, 'source')
          .equals(' bad ');
    });
    test('the message keeps the untrimmed input', () {
      check(() => ServiceYear.parse(' bad '))
          .throws<FormatException>()
          .has((e) => e.message, 'message')
          .equals(parseFormatExceptionMessage(ServiceYear.className, ' bad '));
    });
    test('the message for an empty string is still well formed', () {
      check(() => ServiceYear.parse(''))
          .throws<FormatException>()
          .has((e) => e.message, 'message')
          .equals(parseFormatExceptionMessage(ServiceYear.className, ''));
    });
  });

  group('ServiceYear.parse — round-trip', () {
    test('parse(toString()) reproduces the original', () {
      check(ServiceYear.parse(sy2024.toString())).equals(sy2024);
    });
    test('the round-trip is stable for a range of years', () {
      for (var y = -50; y <= 3000; y += 7) {
        final original = ServiceYear(y);
        check(ServiceYear.parse(original.toString())).equals(original);
      }
    });
    test('the round-trip is stable for the boundaries of the range', () {
      for (final y in <int>[-1, 0, 1, 9999, 10000, -10000]) {
        check(ServiceYear.parse('$y')).equals(ServiceYear(y));
      }
    });
  });

  group('ServiceYear.tryParse — valid input', () {
    test('returns a ServiceYear for "2024"', () {
      check(ServiceYear.tryParse('2024')).isNotNull().equals(sy2024);
    });
    test('returns a ServiceYear for "0"', () {
      check(ServiceYear.tryParse('0')).isNotNull().equals(const ServiceYear(0));
    });
    test('returns a ServiceYear for a negative year', () {
      check(ServiceYear.tryParse('-1'))
          .isNotNull()
          .equals(const ServiceYear(-1));
    });
    test('accepts an explicit plus sign', () {
      check(ServiceYear.tryParse('+2024')).isNotNull().equals(sy2024);
    });
    test('accepts leading zeros', () {
      check(ServiceYear.tryParse('0002024')).isNotNull().equals(sy2024);
    });
    test('accepts a hexadecimal integer like int.tryParse does', () {
      check(ServiceYear.tryParse('0x7E8')).isNotNull().equals(sy2024);
    });
    test('strips surrounding whitespace', () {
      check(ServiceYear.tryParse(' \t2024\n ')).isNotNull().equals(sy2024);
    });
    test('strips Unicode whitespace', () {
      check(ServiceYear.tryParse('\u00A02024\u2003'))
          .isNotNull()
          .equals(sy2024);
    });
  });

  group('ServiceYear.tryParse — invalid input returns null', () {
    for (final input in <String>[
      '',
      '   ',
      '\t\n\r',
      'abc',
      '20a4',
      '2024a',
      '2024.5',
      '2024.0',
      '2 024',
      '2_024',
      '2,024',
      '--2024',
      '+-2024',
      '1e3',
      'null',
      'ServiceYear(2024)',
      '2024|2025',
      '\u200B2024',
      '2024\u200B',
      '\u0662\u0660\u0662\u0664',
    ]) {
      test('returns null for "${input.replaceAll('\n', r'\n')}"', () {
        check(ServiceYear.tryParse(input)).isNull();
      });
    }
    test('never throws for awkward input', () {
      for (final input in <String>[
        '',
        ' ',
        '\u0000',
        '\uFFFF',
        '\u{1F600}',
        '9' * 1000,
        '-' * 1000,
        '2024' * 1000,
      ]) {
        check(() => ServiceYear.tryParse(input)).returnsNormally();
      }
    });
  });

  group('ServiceYear.tryParse — consistency with parse', () {
    test('equals parse for every valid input', () {
      for (final input in <String>[
        '2024',
        ' 2024 ',
        '0',
        '-1',
        '+7',
        '0x10',
        '\t1999\n',
      ]) {
        check(ServiceYear.tryParse(input))
            .isNotNull()
            .equals(ServiceYear.parse(input));
      }
    });
    test('returns null exactly where parse throws FormatException', () {
      for (final input in <String>['', ' ', 'abc', '1.5', '1 2', 'x1']) {
        check(ServiceYear.tryParse(input)).isNull();
        check(() => ServiceYear.parse(input)).throws<FormatException>();
      }
    });
    test('round-trips through toString', () {
      for (var y = -20; y <= 20; y++) {
        check(ServiceYear.tryParse(ServiceYear(y).toString()))
            .isNotNull()
            .equals(ServiceYear(y));
      }
    });
  });

  group('ServiceYear.start', () {
    test('is 1 September at midnight of startingYear', () {
      check(sy2024.start).equals(DateTime(2024, 9));
    });
    test('has day 1', () {
      check(sy2024.start.day).equals(1);
    });
    test('has the firstMonth as month', () {
      check(sy2024.start.month).equals(ServiceYear.firstMonth);
    });
    test('has the startingYear as year', () {
      check(sy2024.start.year).equals(2024);
    });
    test('has a zero time of day', () {
      final DateTime start = sy2024.start;
      check(start.hour).equals(0);
      check(start.minute).equals(0);
      check(start.second).equals(0);
      check(start.millisecond).equals(0);
      check(start.microsecond).equals(0);
    });
    test('is a local (non-UTC) date', () {
      check(sy2024.start.isUtc).isFalse();
    });
    test('returns an equal value on every call', () {
      check(sy2024.start).equals(sy2024.start);
    });
    test('works for year 0 and negative years', () {
      check(const ServiceYear(0).start).equals(DateTime(0, 9));
      check(const ServiceYear(-1).start).equals(DateTime(-1, 9));
    });
    test('is before the end', () {
      check(sy2024.start.isBefore(sy2024.end)).isTrue();
    });
  });

  group('ServiceYear.end', () {
    test('is 1 September at midnight of the following year', () {
      check(sy2024.end).equals(DateTime(2025, 9));
    });
    test('has day 1', () {
      check(sy2024.end.day).equals(1);
    });
    test('has the firstMonth as month', () {
      check(sy2024.end.month).equals(ServiceYear.firstMonth);
    });
    test('has startingYear + 1 as year', () {
      check(sy2024.end.year).equals(2025);
    });
    test('has a zero time of day', () {
      final DateTime end = sy2024.end;
      check(end.hour).equals(0);
      check(end.minute).equals(0);
      check(end.second).equals(0);
      check(end.millisecond).equals(0);
      check(end.microsecond).equals(0);
    });
    test('is a local (non-UTC) date', () {
      check(sy2024.end.isUtc).isFalse();
    });
    test('equals the start of the next service year', () {
      check(sy2024.end).equals(sy2025.start);
    });
    test('works for year 0 and negative years', () {
      check(const ServiceYear(0).end).equals(DateTime(1, 9));
      check(const ServiceYear(-1).end).equals(DateTime(0, 9));
    });
    test('consecutive service years tile without gaps', () {
      for (var y = 1990; y < 2050; y++) {
        check(ServiceYear(y).end).equals(ServiceYear(y + 1).start);
      }
    });
  });

  group('ServiceYear.hashCode', () {
    test('equal instances have the same hashCode', () {
      check(const ServiceYear(2024).hashCode)
          .equals(ServiceYear(int.parse('2024')).hashCode);
    });
    test('is stable across calls', () {
      check(sy2024.hashCode).equals(sy2024.hashCode);
    });
    test('equals the hashCode of the starting year', () {
      check(sy2024.hashCode).equals(2024.hashCode);
    });
    test('different years have different hashCodes', () {
      check(sy2024.hashCode).not((it) => it.equals(sy2025.hashCode));
    });
    test('instances from different constructors share the hashCode', () {
      check(ServiceYear.fromReference(DateTime(2024, 10)).hashCode)
          .equals(sy2024.hashCode);
      check(ServiceYear.parse('2024').hashCode).equals(sy2024.hashCode);
    });
    test('a range of consecutive years has distinct hashCodes', () {
      final hashes = <int>{
        for (var y = 2000; y <= 2100; y++) ServiceYear(y).hashCode,
      };
      check(hashes.length).equals(101);
    });
  });

  group('ServiceYear operator ==', () {
    test('an instance equals itself', () {
      check(sy2024 == sy2024).isTrue();
    });
    test('same startingYear gives equal instances', () {
      check(const ServiceYear(2024) == ServiceYear(int.parse('2024'))).isTrue();
    });
    test('different startingYears are not equal', () {
      check(sy2024 == sy2025).isFalse();
    });
    test('is symmetric', () {
      check((sy2024 == sy2025) == (sy2025 == sy2024)).isTrue();
      check(sy2024 == ServiceYear(int.parse('2024')))
          .equals(ServiceYear(int.parse('2024')) == sy2024);
    });
    test('is not equal to an int with the same value', () {
      // ignore: unrelated_type_equality_checks
      check(sy2024 == 2024).isFalse();
    });
    test('is not equal to a String with the same text', () {
      // ignore: unrelated_type_equality_checks
      check(sy2024 == '2024').isFalse();
    });
    test('is not equal to null', () {
      // ignore: unnecessary_null_comparison
      check(sy2024 == null).isFalse();
    });
    test('parse, fromReference and the primary constructor agree', () {
      check(ServiceYear.parse('2024')).equals(sy2024);
      check(ServiceYear.fromReference(DateTime(2024, 10))).equals(sy2024);
      check(ServiceYear.tryParse('2024')).isNotNull().equals(sy2024);
    });
    test('is consistent with compareTo', () {
      final years = <ServiceYear>[sy2023, sy2024, sy2025];
      for (final a in years) {
        for (final b in years) {
          check(a == b).equals(a.compareTo(b) == 0);
        }
      }
    });
    test('works in a Set', () {
      final set = <ServiceYear>{sy2024, const ServiceYear(2024), sy2025};
      check(set.length).equals(2);
    });
    test('works as a Map key', () {
      final map = <ServiceYear, String>{sy2024: 'a'};
      check(map[ServiceYear(int.parse('2024'))]).equals('a');
      check(map[sy2025]).isNull();
    });
  });

  group('ServiceYear.compareTo', () {
    test('the same instance returns 0', () {
      check(sy2024.compareTo(sy2024)).equals(0);
    });
    test('equal but distinct instances return 0', () {
      check(sy2024.compareTo(ServiceYear(int.parse('2024')))).equals(0);
    });
    test('an earlier year compared to a later one is negative', () {
      check(sy2023.compareTo(sy2024)).isNegative();
    });
    test('a later year compared to an earlier one is positive', () {
      check(sy2025.compareTo(sy2024)).isGreaterThan(0);
    });
    test('years far apart compare correctly', () {
      check(const ServiceYear(-1000).compareTo(const ServiceYear(1000)))
          .isNegative();
      check(const ServiceYear(1000).compareTo(const ServiceYear(-1000)))
          .isGreaterThan(0);
    });
    test('negative years compare correctly', () {
      check(const ServiceYear(-2).compareTo(const ServiceYear(-1)))
          .isNegative();
      check(const ServiceYear(-1).compareTo(const ServiceYear(0))).isNegative();
    });
    test('is antisymmetric', () {
      check(sy2023.compareTo(sy2025).sign)
          .equals(-sy2025.compareTo(sy2023).sign);
    });
    test('is transitive', () {
      check(sy2023.compareTo(sy2024)).isNegative();
      check(sy2024.compareTo(sy2025)).isNegative();
      check(sy2023.compareTo(sy2025)).isNegative();
    });
    test('is consistent with the order of the starting years', () {
      for (var a = 2000; a < 2010; a++) {
        for (var b = 2000; b < 2010; b++) {
          check(ServiceYear(a).compareTo(ServiceYear(b)).sign)
              .equals(a.compareTo(b).sign);
        }
      }
    });
    test('is consistent with the order of the start dates', () {
      for (final a in <ServiceYear>[sy2023, sy2024, sy2025]) {
        for (final b in <ServiceYear>[sy2023, sy2024, sy2025]) {
          check(a.compareTo(b).sign).equals(a.start.compareTo(b.start).sign);
        }
      }
    });
  });

  group('ServiceYear operator <', () {
    test('an earlier year is less than a later year', () {
      check(sy2023 < sy2024).isTrue();
    });
    test('a later year is not less than an earlier year', () {
      check(sy2024 < sy2023).isFalse();
    });
    test('a year is not less than itself', () {
      check(sy2024 < sy2024).isFalse();
    });
    test('a year is not less than an equal but distinct instance', () {
      check(sy2024 < ServiceYear(int.parse('2024'))).isFalse();
    });
    test('is consistent with compareTo', () {
      final years = <ServiceYear>[sy2023, sy2024, sy2025];
      for (final a in years) {
        for (final b in years) {
          check(a < b).equals(a.compareTo(b) < 0);
        }
      }
    });
  });

  group('ServiceYear operator <=', () {
    test('an earlier year is <= a later year', () {
      check(sy2023 <= sy2024).isTrue();
    });
    test('a later year is not <= an earlier year', () {
      check(sy2024 <= sy2023).isFalse();
    });
    test('a year is <= itself', () {
      check(sy2024 <= sy2024).isTrue();
    });
    test('a year is <= an equal but distinct instance', () {
      check(sy2024 <= ServiceYear(int.parse('2024'))).isTrue();
    });
    test('is consistent with compareTo', () {
      final years = <ServiceYear>[sy2023, sy2024, sy2025];
      for (final a in years) {
        for (final b in years) {
          check(a <= b).equals(a.compareTo(b) <= 0);
        }
      }
    });
  });

  group('ServiceYear operator >', () {
    test('a later year is greater than an earlier year', () {
      check(sy2025 > sy2024).isTrue();
    });
    test('an earlier year is not greater than a later year', () {
      check(sy2024 > sy2025).isFalse();
    });
    test('a year is not greater than itself', () {
      check(sy2024 > sy2024).isFalse();
    });
    test('a year is not greater than an equal but distinct instance', () {
      check(sy2024 > ServiceYear(int.parse('2024'))).isFalse();
    });
    test('is consistent with compareTo', () {
      final years = <ServiceYear>[sy2023, sy2024, sy2025];
      for (final a in years) {
        for (final b in years) {
          check(a > b).equals(a.compareTo(b) > 0);
        }
      }
    });
  });

  group('ServiceYear operator >=', () {
    test('a later year is >= an earlier year', () {
      check(sy2025 >= sy2024).isTrue();
    });
    test('an earlier year is not >= a later year', () {
      check(sy2024 >= sy2025).isFalse();
    });
    test('a year is >= itself', () {
      check(sy2024 >= sy2024).isTrue();
    });
    test('a year is >= an equal but distinct instance', () {
      check(sy2024 >= ServiceYear(int.parse('2024'))).isTrue();
    });
    test('is consistent with compareTo', () {
      final years = <ServiceYear>[sy2023, sy2024, sy2025];
      for (final a in years) {
        for (final b in years) {
          check(a >= b).equals(a.compareTo(b) >= 0);
        }
      }
    });
  });

  group('ServiceYear — sorting', () {
    test('sorting a list gives ascending startingYear order', () {
      final sorted = <ServiceYear>[sy2025, sy2023, sy2024]..sort();
      check(sorted).deepEquals(<ServiceYear>[sy2023, sy2024, sy2025]);
    });
    test('sorting handles negative years and year 0', () {
      final sorted = <ServiceYear>[
        const ServiceYear(5),
        const ServiceYear(-5),
        const ServiceYear(0),
      ]..sort();
      check(sorted).deepEquals(<ServiceYear>[
        const ServiceYear(-5),
        const ServiceYear(0),
        const ServiceYear(5),
      ]);
    });
    test('sorting keeps equal years together', () {
      final sorted = <ServiceYear>[
        sy2025,
        sy2024,
        const ServiceYear(2025),
        sy2024,
      ]..sort();
      check(sorted).deepEquals(<ServiceYear>[sy2024, sy2024, sy2025, sy2025]);
    });
  });

  group('ServiceYear.contains — returns true', () {
    test('the start (1 September 00:00) is inside', () {
      check(sy2024.contains(DateTime(2024, 9))).isTrue();
    });
    test('the first instant, passed as a new instance, is inside', () {
      check(sy2024.contains(sy2024.start)).isTrue();
    });
    test('a mid-year date is inside', () {
      check(sy2024.contains(DateTime(2025, 3, 15))).isTrue();
    });
    test('31 August of the ending year is inside', () {
      check(sy2024.contains(DateTime(2025, 8, 31))).isTrue();
    });
    test('noon on 31 August of the ending year is inside', () {
      check(sy2024.contains(DateTime(2025, 8, 31, 12))).isTrue();
    });
    test('one millisecond before the end is inside', () {
      final DateTime almostEnd = sy2024.end.subtract(
        const Duration(milliseconds: 1),
      );
      check(sy2024.contains(almostEnd)).isTrue();
    });
    test('one millisecond after the start is inside', () {
      final DateTime justAfter = sy2024.start.add(
        const Duration(milliseconds: 1),
      );
      check(sy2024.contains(justAfter)).isTrue();
    });
    test('the first day of every month of the year is inside', () {
      for (final d in monthStarts) {
        check(sy2024.contains(d)).isTrue();
      }
    });
    test('29 February of a leap year is inside', () {
      check(sy2023.contains(DateTime(2024, 2, 29))).isTrue();
    });
    test('1 January and 31 December are inside', () {
      check(sy2024.contains(DateTime(2024, 12, 31, 23, 59, 59))).isTrue();
      check(sy2024.contains(DateTime(2025))).isTrue();
    });
    test('works for year 0 and negative years', () {
      check(const ServiceYear(0).contains(DateTime(0, 10))).isTrue();
      check(const ServiceYear(-1).contains(DateTime(-1, 12))).isTrue();
    });
  });

  group('ServiceYear.contains — returns false', () {
    test('the end (1 September of the next year) is outside', () {
      check(sy2024.contains(DateTime(2025, 9))).isFalse();
    });
    test('the end, passed as getter value, is outside', () {
      check(sy2024.contains(sy2024.end)).isFalse();
    });
    test('31 August of the starting year is outside', () {
      check(sy2024.contains(DateTime(2024, 8, 31))).isFalse();
    });
    test('one millisecond before the start is outside', () {
      final DateTime justBefore = sy2024.start.subtract(
        const Duration(milliseconds: 1),
      );
      check(sy2024.contains(justBefore)).isFalse();
    });
    test('a date two years in the future is outside', () {
      check(sy2024.contains(DateTime(2027))).isFalse();
    });
    test('a date two years in the past is outside', () {
      check(sy2024.contains(DateTime(2020))).isFalse();
    });
    test(
      'a date in the same calendar year but before September is outside',
      () {
        check(sy2024.contains(DateTime(2024, 6, 15))).isFalse();
      },
    );
    test('a date in the next calendar year after August is outside', () {
      check(sy2024.contains(DateTime(2025, 10, 15))).isFalse();
    });
    test('the neighbouring service years are outside', () {
      check(sy2024.contains(sy2023.start)).isFalse();
      check(sy2024.contains(sy2025.start)).isFalse();
    });
  });

  group('ServiceYear.contains — consistency', () {
    test('agrees with fromReference for dates spanning three years', () {
      final dates = <DateTime>[
        DateTime(2023, 8, 31),
        DateTime(2023, 9),
        DateTime(2024, 3, 15),
        DateTime(2024, 8, 31),
        DateTime(2024, 9),
        DateTime(2025, 3, 15),
        DateTime(2025, 8, 31),
        DateTime(2025, 9),
        DateTime(2026),
      ];
      for (final d in dates) {
        check(sy2024.contains(d))
            .equals(ServiceYear.fromReference(d) == sy2024);
      }
    });
    test('agrees with start and end for UTC instants', () {
      final instants = <DateTime>[
        DateTime.utc(2024, 8, 30),
        DateTime.utc(2024, 8, 31, 12),
        DateTime.utc(2024, 9),
        DateTime.utc(2024, 9, 1, 12),
        DateTime.utc(2025, 3, 15),
        DateTime.utc(2025, 8, 31, 12),
        DateTime.utc(2025, 9),
        DateTime.utc(2025, 9, 2),
      ];
      for (final u in instants) {
        check(sy2024.contains(u))
            .equals(!u.isBefore(sy2024.start) && u.isBefore(sy2024.end));
      }
    });
    test('exactly one of consecutive service years contains a date', () {
      for (final d in monthStarts) {
        final int matches = <ServiceYear>[
          sy2023,
          sy2024,
          sy2025,
        ].where((sy) => sy.contains(d)).length;
        check(matches).equals(1);
      }
    });
  });

  group('ServiceYear.monthsPassed — inside the service year', () {
    for (var i = 0; i < 12; i++) {
      test('${monthNames[i]} returns $i', () {
        check(sy2024.monthsPassed(monthStarts[i])).equals(i);
      });
    }
    test('the day of the month does not affect the result', () {
      for (var i = 0; i < 12; i++) {
        final DateTime first = monthStarts[i];
        final DateTime last = DateTime(
          first.year,
          first.month + 1,
        ).subtract(const Duration(milliseconds: 1));
        check(sy2024.monthsPassed(last)).equals(i);
        check(sy2024.monthsPassed(DateTime(first.year, first.month, 15)))
            .equals(i);
      }
    });
    test('the time of the day does not affect the result', () {
      check(sy2024.monthsPassed(DateTime(2024, 11, 5, 23, 59, 59, 999)))
          .equals(2);
      check(sy2024.monthsPassed(DateTime(2024, 11, 5))).equals(2);
    });
    test('the start returns 0', () {
      check(sy2024.monthsPassed(sy2024.start)).equals(0);
    });
    test('one millisecond before the end returns 11', () {
      final DateTime almostEnd = sy2024.end.subtract(
        const Duration(milliseconds: 1),
      );
      check(sy2024.monthsPassed(almostEnd)).equals(11);
    });
    test('works for a leap-year February', () {
      check(sy2023.monthsPassed(DateTime(2024, 2, 29))).equals(5);
    });
  });

  group('ServiceYear.monthsPassed — outside the service year', () {
    test('returns null for 31 August before the service year', () {
      check(sy2024.monthsPassed(DateTime(2024, 8, 31))).isNull();
    });
    test('returns null one millisecond before the start', () {
      final DateTime justBefore = sy2024.start.subtract(
        const Duration(milliseconds: 1),
      );
      check(sy2024.monthsPassed(justBefore)).isNull();
    });
    test('returns null for 1 September of the following service year', () {
      check(sy2024.monthsPassed(DateTime(2025, 9))).isNull();
    });
    test('returns null for the end', () {
      check(sy2024.monthsPassed(sy2024.end)).isNull();
    });
    test('returns null for a far-future date', () {
      check(sy2024.monthsPassed(DateTime(2030))).isNull();
    });
    test('returns null for a far-past date', () {
      check(sy2024.monthsPassed(DateTime(2000))).isNull();
    });
    test('returns null for the same months in other calendar years', () {
      check(sy2024.monthsPassed(DateTime(2023, 10))).isNull();
      check(sy2024.monthsPassed(DateTime(2026))).isNull();
    });
  });

  group('ServiceYear.monthsPassed — invariants', () {
    test('all inside values are in 0..11', () {
      for (final d in monthStarts) {
        check(sy2024.monthsPassed(d)).isNotNull()
          ..isGreaterOrEqual(0)
          ..isLessOrEqual(11);
      }
    });
    test('increases monotonically from September through August', () {
      for (var i = 0; i < monthStarts.length - 1; i++) {
        check(sy2024.monthsPassed(monthStarts[i])!)
            .isLessThan(sy2024.monthsPassed(monthStarts[i + 1])!);
      }
    });
    test('increases by exactly one each month', () {
      for (var i = 0; i < monthStarts.length - 1; i++) {
        check(
          sy2024.monthsPassed(monthStarts[i + 1])! -
              sy2024.monthsPassed(monthStarts[i])!,
        ).equals(1);
      }
    });
    test('is non-null exactly when contains is true', () {
      final dates = <DateTime>[
        DateTime(2024, 8, 31),
        DateTime(2024, 9),
        DateTime(2025, 8, 31, 23, 59),
        DateTime(2025, 9),
      ];
      for (final d in dates) {
        check(sy2024.monthsPassed(d) != null).equals(sy2024.contains(d));
      }
    });
    test('is the same for equal years built in different ways', () {
      final d = DateTime(2025, 2, 10);
      check(ServiceYear.parse('2024').monthsPassed(d)).equals(5);
      check(ServiceYear.fromReference(d).monthsPassed(d)).equals(5);
    });
  });

  group('ServiceYear.monthsLeft — inside the service year', () {
    for (var i = 0; i < 12; i++) {
      test('${monthNames[i]} returns ${12 - i}', () {
        check(sy2024.monthsLeft(monthStarts[i])).equals(12 - i);
      });
    }
    test('the day of the month does not affect the result', () {
      for (var i = 0; i < 12; i++) {
        final DateTime first = monthStarts[i];
        final DateTime last = DateTime(
          first.year,
          first.month + 1,
        ).subtract(const Duration(milliseconds: 1));
        check(sy2024.monthsLeft(last)).equals(12 - i);
        check(sy2024.monthsLeft(DateTime(first.year, first.month, 15)))
            .equals(12 - i);
      }
    });
    test('the start returns 12', () {
      check(sy2024.monthsLeft(sy2024.start)).equals(12);
    });
    test('one millisecond before the end returns 1', () {
      final DateTime almostEnd = sy2024.end.subtract(
        const Duration(milliseconds: 1),
      );
      check(sy2024.monthsLeft(almostEnd)).equals(1);
    });
    test('counts the month of the reference', () {
      check(sy2024.monthsLeft(DateTime(2025, 8, 31))).equals(1);
    });
    test('works for a leap-year February', () {
      check(sy2023.monthsLeft(DateTime(2024, 2, 29))).equals(7);
    });
  });

  group('ServiceYear.monthsLeft — outside the service year', () {
    test('returns null for 31 August before the service year', () {
      check(sy2024.monthsLeft(DateTime(2024, 8, 31))).isNull();
    });
    test('returns null one millisecond before the start', () {
      final DateTime justBefore = sy2024.start.subtract(
        const Duration(milliseconds: 1),
      );
      check(sy2024.monthsLeft(justBefore)).isNull();
    });
    test('returns null for 1 September of the following service year', () {
      check(sy2024.monthsLeft(DateTime(2025, 9))).isNull();
    });
    test('returns null for the end', () {
      check(sy2024.monthsLeft(sy2024.end)).isNull();
    });
    test('returns null for a far-future date', () {
      check(sy2024.monthsLeft(DateTime(2030))).isNull();
    });
    test('returns null for a far-past date', () {
      check(sy2024.monthsLeft(DateTime(2000))).isNull();
    });
  });

  group('ServiceYear.monthsLeft — invariants', () {
    test('all inside values are in 1..12', () {
      for (final d in monthStarts) {
        check(sy2024.monthsLeft(d)).isNotNull()
          ..isGreaterOrEqual(1)
          ..isLessOrEqual(12);
      }
    });
    test('monthsPassed + monthsLeft == 12 for every month inside', () {
      for (final d in monthStarts) {
        check(sy2024.monthsPassed(d)! + sy2024.monthsLeft(d)!).equals(12);
      }
    });
    test('decreases monotonically from September through August', () {
      for (var i = 0; i < monthStarts.length - 1; i++) {
        check(sy2024.monthsLeft(monthStarts[i])!)
            .isGreaterThan(sy2024.monthsLeft(monthStarts[i + 1])!);
      }
    });
    test('is non-null exactly when contains is true', () {
      final dates = <DateTime>[
        DateTime(2024, 8, 31),
        DateTime(2024, 9),
        DateTime(2025, 8, 31, 23, 59),
        DateTime(2025, 9),
      ];
      for (final d in dates) {
        check(sy2024.monthsLeft(d) != null).equals(sy2024.contains(d));
      }
    });
    test('is null exactly when monthsPassed is null', () {
      final dates = <DateTime>[
        DateTime(2000),
        DateTime(2024, 8, 31),
        DateTime(2024, 9),
        DateTime(2025, 3),
        DateTime(2025, 9),
        DateTime(2030),
      ];
      for (final d in dates) {
        check(sy2024.monthsLeft(d) == null)
            .equals(sy2024.monthsPassed(d) == null);
      }
    });
  });

  group('ServiceYear.toString', () {
    test('returns the starting year as a decimal string', () {
      check(sy2024.toString()).equals('2024');
    });
    test('returns "2025" for 2025', () {
      check(sy2025.toString()).equals('2025');
    });
    test('returns "0" for year 0', () {
      check(const ServiceYear(0).toString()).equals('0');
    });
    test('returns a negative year with a minus sign', () {
      check(const ServiceYear(-1).toString()).equals('-1');
    });
    test('has no padding or decoration', () {
      check(const ServiceYear(7).toString()).equals('7');
    });
    test('is deterministic', () {
      check(sy2024.toString()).equals(sy2024.toString());
    });
    test('interpolation uses toString', () {
      check('$sy2024').equals('2024');
    });
    test('distinct years give distinct strings', () {
      final strings = <String>{
        for (var y = 2000; y <= 2030; y++) ServiceYear(y).toString(),
      };
      check(strings.length).equals(31);
    });
  });
}
