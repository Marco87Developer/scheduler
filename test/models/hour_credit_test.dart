import 'package:checks/checks.dart';
import 'package:scheduler/src/models/hour_credit.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('HourCredit constructor', () {
    test('stores description and hours', () {
      final credit = HourCredit('Field service', 10);
      check(credit.description).equals('Field service');
      check(credit.hours).equals(10);
    });

    test('has an empty tags set when tags is omitted', () {
      final credit = HourCredit('Field service', 10);
      check(credit.tags).isEmpty();
    });

    test('has an empty tags set when tags is null', () {
      final credit = HourCredit('Field service', 10);
      check(credit.tags).isEmpty();
    });

    test('has an empty tags set when tags is empty', () {
      final credit = HourCredit('Field service', 10, tags: const <String>[]);
      check(credit.tags).isEmpty();
    });

    test('stores the given tags', () {
      final credit = HourCredit(
        'Field service',
        10,
        tags: const <String>['b', 'a'],
      );
      check(credit.tags).deepEquals(<String>['a', 'b']);
    });

    test('sorts tags alphabetically regardless of input order', () {
      final credit = HourCredit(
        'Field service',
        10,
        tags: const <String>['zeta', 'alpha', 'mu'],
      );
      check(credit.tags).deepEquals(<String>['alpha', 'mu', 'zeta']);
    });

    test('removes duplicate tags', () {
      final credit = HourCredit(
        'Field service',
        10,
        tags: const <String>['a', 'a', 'b'],
      );
      check(credit.tags).deepEquals(<String>['a', 'b']);
    });

    test('produces an unmodifiable tags set', () {
      final credit = HourCredit('Field service', 10, tags: const <String>['a']);
      check(() => credit.tags.add('b')).throws<UnsupportedError>();
    });

    test('accepts negative hours', () {
      final credit = HourCredit('Correction', -5);
      check(credit.hours).equals(-5);
    });

    test('accepts zero hours', () {
      final credit = HourCredit('No hours', 0);
      check(credit.hours).equals(0);
    });

    test('accepts an empty description', () {
      final credit = HourCredit('', 10);
      check(credit.description).equals('');
    });
  });

  group('HourCredit.parse', () {
    test('parses description and hours without tags', () {
      final credit = HourCredit.parse('Field service|10');
      check(credit.description).equals('Field service');
      check(credit.hours).equals(10);
      check(credit.tags).isEmpty();
    });

    test('parses description, hours and a single tag', () {
      final credit = HourCredit.parse('Field service|10|a');
      check(credit.tags).deepEquals(<String>['a']);
    });

    test('parses description, hours and multiple tags', () {
      final credit = HourCredit.parse('Field service|10|b,a');
      check(credit.tags).deepEquals(<String>['a', 'b']);
    });

    test('trims whitespace around the whole input', () {
      final credit = HourCredit.parse('  Field service|10  ');
      check(credit.description).equals('Field service');
    });

    test('trims whitespace around description and hours', () {
      final credit = HourCredit.parse(' Field service | 10 ');
      check(credit.description).equals('Field service');
      check(credit.hours).equals(10);
    });

    test('trims whitespace around each tag', () {
      final credit = HourCredit.parse('Field service|10| a , b ');
      check(credit.tags).deepEquals(<String>['a', 'b']);
    });

    test('ignores empty tags produced by trailing commas', () {
      final credit = HourCredit.parse('Field service|10|a,,b,');
      check(credit.tags).deepEquals(<String>['a', 'b']);
    });

    test('parses negative hours', () {
      final credit = HourCredit.parse('Correction|-5');
      check(credit.hours).equals(-5);
    });

    test('throws FormatException when missing the hours part', () {
      check(() => HourCredit.parse('Field service')).throws<FormatException>();
    });

    test('throws FormatException when hours is not an integer', () {
      check(() => HourCredit.parse('Field service|abc'))
          .throws<FormatException>();
    });

    test('throws FormatException on empty input', () {
      check(() => HourCredit.parse('')).throws<FormatException>();
    });

    test('throws FormatException with too many segments', () {
      check(() => HourCredit.parse('Field service|10|a|extra'))
          .throws<FormatException>();
    });

    test('FormatException carries the original formatted string', () {
      check(() => HourCredit.parse('bad'))
          .throws<FormatException>()
          .has((e) => e.source, 'source')
          .equals('bad');
    });
  });

  group('HourCredit.hashCode', () {
    test('is equal for two instances with the same fields', () {
      final a = HourCredit('Field service', 10);
      final b = HourCredit('Field service', 10);
      check(a.hashCode).equals(b.hashCode);
    });

    test('is equal regardless of the order tags were given in', () {
      final a = HourCredit('Field service', 10, tags: const <String>['a', 'b']);
      final b = HourCredit('Field service', 10, tags: const <String>['b', 'a']);
      check(a.hashCode).equals(b.hashCode);
    });
  });

  group('HourCredit.compareTo', () {
    test('returns 0 for the identical instance', () {
      final credit = HourCredit('Field service', 10);
      check(credit.compareTo(credit)).equals(0);
    });

    test('returns 0 for equivalent instances', () {
      final a = HourCredit('Field service', 10);
      final b = HourCredit('Field service', 10);
      check(a.compareTo(b)).equals(0);
    });

    test('compares by tags first', () {
      final a = HourCredit('Same', 10, tags: const <String>['a']);
      final b = HourCredit('Same', 10, tags: const <String>['b']);
      check(a.compareTo(b)).isLessThan(0);
      check(b.compareTo(a)).isGreaterThan(0);
    });

    test('compares by description when tags are equal', () {
      final a = HourCredit('Alpha', 10);
      final b = HourCredit('Beta', 10);
      check(a.compareTo(b)).isLessThan(0);
      check(b.compareTo(a)).isGreaterThan(0);
    });

    test('compares by hours when tags and description are equal', () {
      final a = HourCredit('Same', 5);
      final b = HourCredit('Same', 10);
      check(a.compareTo(b)).isLessThan(0);
      check(b.compareTo(a)).isGreaterThan(0);
    });
  });

  group('HourCredit operators', () {
    final low = HourCredit('Same', 5);
    final high = HourCredit('Same', 10);
    final sameAsLow = HourCredit('Same', 5);

    test('< returns true when this comes before other', () {
      check(low < high).isTrue();
      check(high < low).isFalse();
    });

    test('<= returns true when this is before or equal to other', () {
      check(low <= high).isTrue();
      check(low <= sameAsLow).isTrue();
      check(high <= low).isFalse();
    });

    test('> returns true when this comes after other', () {
      check(high > low).isTrue();
      check(low > high).isFalse();
    });

    test('>= returns true when this is after or equal to other', () {
      check(high >= low).isTrue();
      check(low >= sameAsLow).isTrue();
      check(low >= high).isFalse();
    });

    test('== returns true for the identical instance', () {
      check(low == low).isTrue();
    });

    test('== returns true for equivalent, non-identical instances', () {
      check(low == sameAsLow).isTrue();
    });

    test('== returns false for different instances', () {
      check(low == high).isFalse();
    });

    test('== returns false when compared to a non-HourCredit', () {
      /// Ignore is for the purpose of the test
      // ignore: unrelated_type_equality_checks
      check(low == 'not a credit').isFalse();
    });
  });

  group('HourCredit.toString', () {
    test('omits tags when there are none', () {
      final credit = HourCredit('Field service', 10);
      check(credit.toString()).equals('Field service|10');
    });

    test('includes tags, joined by commas, when present', () {
      final credit = HourCredit(
        'Field service',
        10,
        tags: const <String>['b', 'a'],
      );
      check(credit.toString()).equals('Field service|10|a,b');
    });

    test('round-trips through parse', () {
      final original = HourCredit(
        'Field service',
        10,
        tags: const <String>['b', 'a'],
      );
      final reparsed = HourCredit.parse(original.toString());
      check(reparsed == original).isTrue();
    });
  });

  group('HourCredit.className', () {
    test('equals the class name', () {
      check(HourCredit.className).equals('HourCredit');
    });
  });

  group('HourCredit.tryParse', () {
    test('parses description and hours without tags', () {
      final HourCredit credit = HourCredit.tryParse('Field service|10')!;
      check(credit.description).equals('Field service');
      check(credit.hours).equals(10);
      check(credit.tags).isEmpty();
    });

    test('parses and sorts multiple tags', () {
      final HourCredit credit = HourCredit.tryParse('Field service|10|b,a')!;
      check(credit.tags).deepEquals(<String>['a', 'b']);
    });

    test('trims whitespace around the string and each part', () {
      final HourCredit credit = HourCredit.tryParse(
        '  Field service | 10 | a , b  ',
      )!;
      check(credit.description).equals('Field service');
      check(credit.hours).equals(10);
      check(credit.tags).deepEquals(<String>['a', 'b']);
    });

    test('ignores empty tags', () {
      final HourCredit credit = HourCredit.tryParse('Field service|10|a,,b,')!;
      check(credit.tags).deepEquals(<String>['a', 'b']);
    });

    test('has an empty tags set when the tags segment is blank', () {
      final HourCredit credit = HourCredit.tryParse('Field service|10| , ')!;
      check(credit.tags).isEmpty();
    });

    test('parses negative hours', () {
      final HourCredit credit = HourCredit.tryParse('Correction|-5')!;
      check(credit.hours).equals(-5);
    });

    test('returns null for empty input', () {
      check(HourCredit.tryParse('')).isNull();
    });

    test('returns null when the hours segment is missing', () {
      check(HourCredit.tryParse('Field service')).isNull();
    });

    test('returns null when hours is not an integer', () {
      check(HourCredit.tryParse('Field service|abc')).isNull();
      check(HourCredit.tryParse('Field service|1.5')).isNull();
      check(HourCredit.tryParse('Field service|')).isNull();
    });

    test('returns null with too many segments', () {
      check(HourCredit.tryParse('Field service|10|a|extra')).isNull();
    });

    test('is consistent with parse for valid input', () {
      const input = 'Field service|10|b,a';
      check(HourCredit.tryParse(input)! == HourCredit.parse(input)).isTrue();
    });

    test('round-trips through toString', () {
      final original = HourCredit(
        'Field service',
        10,
        tags: const <String>['b', 'a'],
      );
      check(HourCredit.tryParse(original.toString())! == original).isTrue();
    });
  });

  group('HourCredit — tags normalization', () {
    test('produces an unmodifiable tags set when there are no tags', () {
      final credit = HourCredit('Field service', 10);
      check(() => credit.tags.add('a')).throws<UnsupportedError>();
    });

    test('is not affected by later changes to the source collection', () {
      final source = <String>['b', 'a'];
      final credit = HourCredit('Field service', 10, tags: source);
      source.add('c');
      check(credit.tags).deepEquals(<String>['a', 'b']);
    });

    test('treats an empty lazy iterable as no tags', () {
      final credit = HourCredit(
        'Field service',
        10,
        tags: <String>['a'].where((tag) => tag.isEmpty),
      );
      check(credit.tags).isEmpty();
    });
  });

  group('HourCredit operator == — field differences', () {
    test('returns false when only the tags differ', () {
      final a = HourCredit('Same', 10, tags: const <String>['a']);
      final b = HourCredit('Same', 10, tags: const <String>['b']);
      check(a == b).isFalse();
    });

    test('returns false when only one has tags', () {
      final a = HourCredit('Same', 10);
      final b = HourCredit('Same', 10, tags: const <String>['a']);
      check(a == b).isFalse();
    });

    test('returns false when only the description differs', () {
      check(HourCredit('A', 10) == HourCredit('B', 10)).isFalse();
    });

    test('is consistent with compareTo', () {
      final credits = <HourCredit>[
        HourCredit('A', 1),
        HourCredit('A', 2),
        HourCredit('B', 1),
        HourCredit('A', 1, tags: const <String>['x']),
        HourCredit('A', 1, tags: const <String>['x', 'y']),
      ];
      for (final a in credits) {
        for (final b in credits) {
          check(a == b).equals(a.compareTo(b) == 0);
        }
      }
    });
  });
}
