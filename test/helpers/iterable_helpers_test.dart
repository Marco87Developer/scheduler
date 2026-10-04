import 'package:checks/checks.dart';
import 'package:scheduler/src/helpers/iterable_helpers.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('elementCompareIterables', () {
    test('returns 0 for identical instances', () {
      final a = <num>[1, 2, 3];
      check(elementCompareIterables<num>(a, a)).equals(0);
    });

    test('returns 0 for equal non-identical iterables', () {
      final a = <num>[1, 2, 3];
      final b = <num>[1, 2, 3];
      check(elementCompareIterables<num>(a, b)).equals(0);
    });

    test('returns 0 for two empty iterables', () {
      check(elementCompareIterables<num>(<num>[], <num>[])).equals(0);
    });

    test('returns positive when a differs and is greater', () {
      final a = <num>[1, 5, 3];
      final b = <num>[1, 2, 3];
      check(elementCompareIterables<num>(a, b)).isGreaterThan(0);
    });

    test('returns negative when b differs and is greater', () {
      final a = <num>[1, 2, 3];
      final b = <num>[1, 5, 3];
      check(elementCompareIterables<num>(a, b)).isNegative();
    });

    test('stops at first differing pair, ignoring later elements', () {
      final a = <num>[1, 9, 100];
      final b = <num>[1, 2, 3];
      check(elementCompareIterables<num>(a, b)).isGreaterThan(0);
    });

    test('returns positive when a is longer with equal prefix', () {
      final a = <num>[1, 2, 3];
      final b = <num>[1, 2];
      check(elementCompareIterables<num>(a, b)).equals(1);
    });

    test('returns negative when b is longer with equal prefix', () {
      final a = <num>[1, 2];
      final b = <num>[1, 2, 3];
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
      final Iterable<num> b = <num>[1, 2, 3].map((e) => e);
      check(elementCompareIterables<num>(a, b)).equals(0);
    });

    test('single-element iterables compare correctly', () {
      check(elementCompareIterables<num>(<num>[5], <num>[5])).equals(0);
      check(elementCompareIterables<num>(<num>[5], <num>[6])).isNegative();
    });
  });

  group('elementCompareIterablesReversed', () {
    test('returns 0 for identical instances', () {
      final a = <num>[1, 2, 3];
      check(elementCompareIterablesReversed<num>(a, a)).equals(0);
    });

    test('returns 0 for equal non-identical lists', () {
      final a = <num>[1, 2, 3];
      final b = <num>[1, 2, 3];
      check(elementCompareIterablesReversed<num>(a, b)).equals(0);
    });

    test('returns 0 for two empty iterables', () {
      check(elementCompareIterablesReversed<num>(<num>[], <num>[])).equals(0);
    });

    test('compares from the end: differing last elements', () {
      final a = <num>[1, 2, 9];
      final b = <num>[1, 2, 3];
      check(elementCompareIterablesReversed<num>(a, b)).isGreaterThan(0);
    });

    test('ignores a leading difference if the trailing elements '
        'differ first', () {
      // Reversed comparison looks at the tail first: last elements
      // differ (9 vs 3), so that decides the result regardless of
      // the first elements.
      final a = <num>[9, 2, 3];
      final b = <num>[1, 2, 9];
      check(elementCompareIterablesReversed<num>(a, b)).isNegative();
    });

    test('returns positive when a is longer with equal suffix', () {
      final a = <num>[0, 1, 2, 3];
      final b = <num>[1, 2, 3];
      check(elementCompareIterablesReversed<num>(a, b)).equals(1);
    });

    test('returns negative when b is longer with equal suffix', () {
      final a = <num>[1, 2, 3];
      final b = <num>[0, 1, 2, 3];
      check(elementCompareIterablesReversed<num>(a, b)).equals(-1);
    });

    test('handles empty a against non-empty b', () {
      check(elementCompareIterablesReversed<num>(<num>[], <num>[1])).equals(-1);
    });

    test('handles non-empty a against empty b', () {
      check(elementCompareIterablesReversed<num>(<num>[1], <num>[])).equals(1);
    });

    test('works with a non-List Iterable input for a', () {
      final Iterable<num> a = <num>[1, 2, 3].map((e) => e);
      final b = <num>[1, 2, 3];
      check(elementCompareIterablesReversed<num>(a, b)).equals(0);
    });

    test('works with a non-List Iterable input for b', () {
      final a = <num>[1, 2, 3];
      final Iterable<num> b = <num>[1, 2, 3].map((e) => e);
      check(elementCompareIterablesReversed<num>(a, b)).equals(0);
    });

    test('works with Set inputs for both a and b', () {
      final a = <num>{1, 2, 3};
      final b = <num>{1, 2, 3};
      check(elementCompareIterablesReversed<num>(a, b)).equals(0);
    });

    test('single-element iterables compare correctly', () {
      check(elementCompareIterablesReversed<num>(<num>[5], <num>[5])).equals(0);
      check(elementCompareIterablesReversed<num>(<num>[5], <num>[6]))
          .isNegative();
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

  group('elementCompareIterables', () {
    test('returns 0 for identical iterables', () {
      final list = <int>[1, 2, 3];
      check(elementCompareIterables(list, list)).equals(0);
    });
    test('returns 0 for equal iterables of same length', () {
      final a = <int>[1, 2, 3];
      final b = <int>[1, 2, 3];
      check(elementCompareIterables(a, b)).equals(0);
    });
    test('returns positive when a has greater element', () {
      final a = <int>[1, 3, 3];
      final b = <int>[1, 2, 3];
      check(elementCompareIterables(a, b)).isGreaterThan(0);
    });
    test('returns negative when b has greater element', () {
      final a = <int>[1, 2, 3];
      final b = <int>[1, 3, 3];
      check(elementCompareIterables(a, b)).isNegative();
    });
    test('returns positive when a is longer', () {
      final a = <int>[1, 2, 3, 4];
      final b = <int>[1, 2, 3];
      check(elementCompareIterables(a, b)).isGreaterThan(0);
    });
    test('returns negative when b is longer', () {
      final a = <int>[1, 2, 3];
      final b = <int>[1, 2, 3, 4];
      check(elementCompareIterables(a, b)).isNegative();
    });
    test('handles empty iterables correctly', () {
      final List<int> empty1 = [];
      final List<int> empty2 = [];
      final nonEmpty = <int>[1];
      check(elementCompareIterables(empty1, empty2)).equals(0);
      check(elementCompareIterables(empty1, nonEmpty)).isNegative();
      check(elementCompareIterables(nonEmpty, empty1)).isGreaterThan(0);
    });
    test('works with non-List iterables', () {
      final a = <int>{1, 2, 3};
      final b = <int>{1, 2, 3};
      final c = <int>{1, 2, 4};
      final d = <int>{1, 2};
      check(elementCompareIterables(a, b)).equals(0);
      check(elementCompareIterables(a, c)).isNegative();
      check(elementCompareIterables(a, d)).isGreaterThan(0);
    });
  });

  group('elementCompareIterablesReversed', () {
    test('returns 0 for identical iterables', () {
      final list = <int>[1, 2, 3];
      check(elementCompareIterablesReversed(list, list)).equals(0);
    });
    test('returns 0 for equal iterables of same length', () {
      final a = <int>[1, 2, 3];
      final b = <int>[1, 2, 3];
      check(elementCompareIterablesReversed(a, b)).equals(0);
    });
    test('returns positive when a has greater element from end', () {
      final a = <int>[1, 3, 2];
      final b = <int>[1, 2, 2];
      check(elementCompareIterablesReversed(a, b)).isGreaterThan(0);
    });
    test('returns negative when b has greater element from end', () {
      final a = <int>[1, 2, 2];
      final b = <int>[1, 3, 2];
      check(elementCompareIterablesReversed(a, b)).isNegative();
    });
    test('returns positive when a is longer', () {
      final a = <int>[0, 1, 2, 3];
      final b = <int>[1, 2, 3];
      check(elementCompareIterablesReversed(a, b)).isGreaterThan(0);
    });
    test('returns negative when b is longer', () {
      final a = <int>[1, 2, 3];
      final b = <int>[0, 1, 2, 3];
      check(elementCompareIterablesReversed(a, b)).isNegative();
    });
    test('handles empty iterables correctly', () {
      final List<int> emptyA = [];
      final List<int> emptyB = [];
      final nonEmpty = <int>[1];
      check(elementCompareIterablesReversed(emptyA, emptyB)).equals(0);
      check(elementCompareIterablesReversed(emptyA, nonEmpty)).isNegative();
      check(elementCompareIterablesReversed(nonEmpty, emptyA)).isGreaterThan(0);
    });
    test('works with non-List iterables', () {
      final Iterable<int> a = {1, 2, 3};
      final Iterable<int> b = {1, 2, 4};
      final Iterable<int> c = {2, 3};
      check(elementCompareIterablesReversed(a, b)).isNegative();
      check(elementCompareIterablesReversed(a, c)).isGreaterThan(0);
    });
  });
}
