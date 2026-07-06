import 'package:checks/checks.dart';
import 'package:scheduler/src/models/hour_credit.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('HourCredit constructor', () {
    test('stores description and hours', () {
      final HourCredit credit = HourCredit('Field service', 10);
      check(credit.description).equals('Field service');
      check(credit.hours).equals(10);
    });

    test('has an empty tags set when tags is omitted', () {
      final HourCredit credit = HourCredit('Field service', 10);
      check(credit.tags).isEmpty();
    });

    test('has an empty tags set when tags is null', () {
      final HourCredit credit = HourCredit('Field service', 10);
      check(credit.tags).isEmpty();
    });

    test('has an empty tags set when tags is empty', () {
      final HourCredit credit = HourCredit(
        'Field service',
        10,
        tags: const <String>[],
      );
      check(credit.tags).isEmpty();
    });

    test('stores the given tags', () {
      final HourCredit credit = HourCredit(
        'Field service',
        10,
        tags: const <String>['b', 'a'],
      );
      check(credit.tags).deepEquals(<String>['a', 'b']);
    });

    test('sorts tags alphabetically regardless of input order', () {
      final HourCredit credit = HourCredit(
        'Field service',
        10,
        tags: const <String>['zeta', 'alpha', 'mu'],
      );
      check(credit.tags).deepEquals(<String>['alpha', 'mu', 'zeta']);
    });

    test('removes duplicate tags', () {
      final HourCredit credit = HourCredit(
        'Field service',
        10,
        tags: const <String>['a', 'a', 'b'],
      );
      check(credit.tags).deepEquals(<String>['a', 'b']);
    });

    test('produces an unmodifiable tags set', () {
      final HourCredit credit = HourCredit(
        'Field service',
        10,
        tags: const <String>['a'],
      );
      check(() => credit.tags.add('b')).throws<UnsupportedError>();
    });

    test('accepts negative hours', () {
      final HourCredit credit = HourCredit('Correction', -5);
      check(credit.hours).equals(-5);
    });

    test('accepts zero hours', () {
      final HourCredit credit = HourCredit('No hours', 0);
      check(credit.hours).equals(0);
    });

    test('accepts an empty description', () {
      final HourCredit credit = HourCredit('', 10);
      check(credit.description).equals('');
    });
  });

  group('HourCredit.parse', () {
    test('parses description and hours without tags', () {
      final HourCredit credit = HourCredit.parse('Field service|10');
      check(credit.description).equals('Field service');
      check(credit.hours).equals(10);
      check(credit.tags).isEmpty();
    });

    test('parses description, hours and a single tag', () {
      final HourCredit credit = HourCredit.parse('Field service|10|a');
      check(credit.tags).deepEquals(<String>['a']);
    });

    test('parses description, hours and multiple tags', () {
      final HourCredit credit = HourCredit.parse('Field service|10|b,a');
      check(credit.tags).deepEquals(<String>['a', 'b']);
    });

    test('trims whitespace around the whole input', () {
      final HourCredit credit = HourCredit.parse('  Field service|10  ');
      check(credit.description).equals('Field service');
    });

    test('trims whitespace around description and hours', () {
      final HourCredit credit = HourCredit.parse(' Field service | 10 ');
      check(credit.description).equals('Field service');
      check(credit.hours).equals(10);
    });

    test('trims whitespace around each tag', () {
      final HourCredit credit = HourCredit.parse('Field service|10| a , b ');
      check(credit.tags).deepEquals(<String>['a', 'b']);
    });

    test('ignores empty tags produced by trailing commas', () {
      final HourCredit credit = HourCredit.parse('Field service|10|a,,b,');
      check(credit.tags).deepEquals(<String>['a', 'b']);
    });

    test('parses negative hours', () {
      final HourCredit credit = HourCredit.parse('Correction|-5');
      check(credit.hours).equals(-5);
    });

    test('throws FormatException when missing the hours part', () {
      check(() => HourCredit.parse('Field service')).throws<FormatException>();
    });

    test('throws FormatException when hours is not an integer', () {
      check(
        () => HourCredit.parse('Field service|abc'),
      ).throws<FormatException>();
    });

    test('throws FormatException on empty input', () {
      check(() => HourCredit.parse('')).throws<FormatException>();
    });

    test('throws FormatException with too many segments', () {
      check(
        () => HourCredit.parse('Field service|10|a|extra'),
      ).throws<FormatException>();
    });

    test('FormatException carries the original formatted string', () {
      check(() => HourCredit.parse('bad')).throws<FormatException>()
        ..has((final FormatException e) => e.source, 'source').equals('bad');
    });
  });

  group('HourCredit.hashCode', () {
    test('is equal for two instances with the same fields', () {
      final HourCredit a = HourCredit('Field service', 10);
      final HourCredit b = HourCredit('Field service', 10);
      check(a.hashCode).equals(b.hashCode);
    });

    test('is equal regardless of the order tags were given in', () {
      final HourCredit a = HourCredit(
        'Field service',
        10,
        tags: const <String>['a', 'b'],
      );
      final HourCredit b = HourCredit(
        'Field service',
        10,
        tags: const <String>['b', 'a'],
      );
      check(a.hashCode).equals(b.hashCode);
    });
  });

  group('HourCredit.compareTo', () {
    test('returns 0 for the identical instance', () {
      final HourCredit credit = HourCredit('Field service', 10);
      check(credit.compareTo(credit)).equals(0);
    });

    test('returns 0 for equivalent instances', () {
      final HourCredit a = HourCredit('Field service', 10);
      final HourCredit b = HourCredit('Field service', 10);
      check(a.compareTo(b)).equals(0);
    });

    test('compares by tags first', () {
      final HourCredit a = HourCredit('Same', 10, tags: const <String>['a']);
      final HourCredit b = HourCredit('Same', 10, tags: const <String>['b']);
      check(a.compareTo(b)).isLessThan(0);
      check(b.compareTo(a)).isGreaterThan(0);
    });

    test('compares by description when tags are equal', () {
      final HourCredit a = HourCredit('Alpha', 10);
      final HourCredit b = HourCredit('Beta', 10);
      check(a.compareTo(b)).isLessThan(0);
      check(b.compareTo(a)).isGreaterThan(0);
    });

    test('compares by hours when tags and description are equal', () {
      final HourCredit a = HourCredit('Same', 5);
      final HourCredit b = HourCredit('Same', 10);
      check(a.compareTo(b)).isLessThan(0);
      check(b.compareTo(a)).isGreaterThan(0);
    });
  });

  group('HourCredit operators', () {
    final HourCredit low = HourCredit('Same', 5);
    final HourCredit high = HourCredit('Same', 10);
    final HourCredit sameAsLow = HourCredit('Same', 5);

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
      // ignore: unrelated_type_equality_checks
      check(low == 'not a credit').isFalse();
    });
  });

  group('HourCredit.toString', () {
    test('omits tags when there are none', () {
      final HourCredit credit = HourCredit('Field service', 10);
      check(credit.toString()).equals('Field service|10');
    });

    test('includes tags, joined by commas, when present', () {
      final HourCredit credit = HourCredit(
        'Field service',
        10,
        tags: const <String>['b', 'a'],
      );
      check(credit.toString()).equals('Field service|10|a,b');
    });

    test('round-trips through parse', () {
      final HourCredit original = HourCredit(
        'Field service',
        10,
        tags: const <String>['b', 'a'],
      );
      final HourCredit reparsed = HourCredit.parse(original.toString());
      check(reparsed == original).isTrue();
    });
  });

  group('HourCredit.className', () {
    test('equals the class name', () {
      check(HourCredit.className).equals('HourCredit');
    });
  });
}
