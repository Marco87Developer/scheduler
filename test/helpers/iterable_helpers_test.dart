import 'package:checks/checks.dart';
import 'package:scheduler/src/helpers/iterable_helpers.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('elementCompareIterables', () {
    test('returns 0 for identical instances', () {
      final List<num> a = <num>[1, 2, 3];
      check(elementCompareIterables<num>(a, a)).equals(0);
    });

    test('returns 0 for equal non-identical iterables', () {
      final List<num> a = <num>[1, 2, 3];
      final List<num> b = <num>[1, 2, 3];
      check(elementCompareIterables<num>(a, b)).equals(0);
    });

    test('returns 0 for two empty iterables', () {
      check(elementCompareIterables<num>(<num>[], <num>[])).equals(0);
    });

    test('returns positive when a differs and is greater', () {
      final List<num> a = <num>[1, 5, 3];
      final List<num> b = <num>[1, 2, 3];
      check(elementCompareIterables<num>(a, b)).isGreaterThan(0);
    });

    test('returns negative when b differs and is greater', () {
      final List<num> a = <num>[1, 2, 3];
      final List<num> b = <num>[1, 5, 3];
      check(elementCompareIterables<num>(a, b)).isNegative();
    });

    test('stops at first differing pair, ignoring later elements', () {
      final List<num> a = <num>[1, 9, 100];
      final List<num> b = <num>[1, 2, 3];
      check(elementCompareIterables<num>(a, b)).isGreaterThan(0);
    });

    test('returns positive when a is longer with equal prefix', () {
      final List<num> a = <num>[1, 2, 3];
      final List<num> b = <num>[1, 2];
      check(elementCompareIterables<num>(a, b)).equals(1);
    });

    test('returns negative when b is longer with equal prefix', () {
      final List<num> a = <num>[1, 2];
      final List<num> b = <num>[1, 2, 3];
      check(elementCompareIterables<num>(a, b)).equals(-1);
    });

    test('handles empty a against non-empty b', () {
      check(elementCompareIterables<num>(<num>[], <num>[1])).equals(-1);
    });

    test('handles non-empty a against empty b', () {
      check(elementCompareIterables<num>(<num>[1], <num>[])).equals(1);
    });

    test('works with String elements', () {
      check(
        elementCompareIterables<String>(<String>['a', 'b'], <String>['a', 'c']),
      ).isNegative();
    });

    test('works with non-List iterables (e.g. Set, Iterable views)', () {
      final Iterable<num> a = <num>{1, 2, 3};
      final Iterable<num> b = <num>[1, 2, 3].map((num e) => e);
      check(elementCompareIterables<num>(a, b)).equals(0);
    });

    test('single-element iterables compare correctly', () {
      check(elementCompareIterables<num>(<num>[5], <num>[5])).equals(0);
      check(elementCompareIterables<num>(<num>[5], <num>[6])).isNegative();
    });
  });

  group('elementCompareIterablesReversed', () {
    test('returns 0 for identical instances', () {
      final List<num> a = <num>[1, 2, 3];
      check(elementCompareIterablesReversed<num>(a, a)).equals(0);
    });

    test('returns 0 for equal non-identical lists', () {
      final List<num> a = <num>[1, 2, 3];
      final List<num> b = <num>[1, 2, 3];
      check(elementCompareIterablesReversed<num>(a, b)).equals(0);
    });

    test('returns 0 for two empty iterables', () {
      check(elementCompareIterablesReversed<num>(<num>[], <num>[])).equals(0);
    });

    test('compares from the end: differing last elements', () {
      final List<num> a = <num>[1, 2, 9];
      final List<num> b = <num>[1, 2, 3];
      check(elementCompareIterablesReversed<num>(a, b)).isGreaterThan(0);
    });

    test('ignores a leading difference if the trailing elements '
        'differ first', () {
      // Reversed comparison looks at the tail first: last elements
      // differ (9 vs 3), so that decides the result regardless of
      // the first elements.
      final List<num> a = <num>[9, 2, 3];
      final List<num> b = <num>[1, 2, 9];
      check(elementCompareIterablesReversed<num>(a, b)).isNegative();
    });

    test('returns positive when a is longer with equal suffix', () {
      final List<num> a = <num>[0, 1, 2, 3];
      final List<num> b = <num>[1, 2, 3];
      check(elementCompareIterablesReversed<num>(a, b)).equals(1);
    });

    test('returns negative when b is longer with equal suffix', () {
      final List<num> a = <num>[1, 2, 3];
      final List<num> b = <num>[0, 1, 2, 3];
      check(elementCompareIterablesReversed<num>(a, b)).equals(-1);
    });

    test('handles empty a against non-empty b', () {
      check(elementCompareIterablesReversed<num>(<num>[], <num>[1])).equals(-1);
    });

    test('handles non-empty a against empty b', () {
      check(elementCompareIterablesReversed<num>(<num>[1], <num>[])).equals(1);
    });

    test('works with a non-List Iterable input for a', () {
      final Iterable<num> a = <num>[1, 2, 3].map((num e) => e);
      final List<num> b = <num>[1, 2, 3];
      check(elementCompareIterablesReversed<num>(a, b)).equals(0);
    });

    test('works with a non-List Iterable input for b', () {
      final List<num> a = <num>[1, 2, 3];
      final Iterable<num> b = <num>[1, 2, 3].map((num e) => e);
      check(elementCompareIterablesReversed<num>(a, b)).equals(0);
    });

    test('works with Set inputs for both a and b', () {
      final Set<num> a = <num>{1, 2, 3};
      final Set<num> b = <num>{1, 2, 3};
      check(elementCompareIterablesReversed<num>(a, b)).equals(0);
    });

    test('single-element iterables compare correctly', () {
      check(elementCompareIterablesReversed<num>(<num>[5], <num>[5])).equals(0);
      check(
        elementCompareIterablesReversed<num>(<num>[5], <num>[6]),
      ).isNegative();
    });

    test('works with String elements', () {
      check(
        elementCompareIterablesReversed<String>(
          <String>['a', 'z'],
          <String>['b', 'z'],
        ),
      ).isNegative();
    });
  });
}
