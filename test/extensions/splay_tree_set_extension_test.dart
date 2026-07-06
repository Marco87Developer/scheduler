import 'dart:collection';

import 'package:checks/checks.dart';
import 'package:scheduler/src/extensions/splay_tree_set_extension.dart';
import 'package:test/scaffolding.dart';

void main() {
  // ---------------------------------------------------------------------
  // _compareIterables — tested indirectly through compareTo /
  // compareToReversed, which are the only callers.
  //
  // The private function iterates both sequences in lock-step and
  // returns the comparison of the first differing pair, or 0 when all
  // paired elements agree (regardless of whether the sequences have
  // the same length).
  // ---------------------------------------------------------------------

  group('_compareIterables (via compareTo) — both non-empty, same length', () {
    test('equal singletons return 0', () {
      check(intSet(<int>[1]).compareTo(intSet(<int>[1]))).equals(0);
    });

    test('equal pairs return 0', () {
      check(intSet(<int>[1, 2]).compareTo(intSet(<int>[1, 2]))).equals(0);
    });

    test('first element smaller gives negative result', () {
      check(intSet(<int>[1, 9]).compareTo(intSet(<int>[2, 9]))).isNegative();
    });

    test('first element larger gives positive result', () {
      check(
        intSet(<int>[3, 9]).compareTo(intSet(<int>[2, 9])),
      ).isGreaterThan(0);
    });

    test('first elements equal, second smaller gives negative', () {
      check(intSet(<int>[1, 2]).compareTo(intSet(<int>[1, 3]))).isNegative();
    });

    test('first elements equal, second larger gives positive', () {
      check(
        intSet(<int>[1, 4]).compareTo(intSet(<int>[1, 3])),
      ).isGreaterThan(0);
    });

    test('comparison stops at first differing element', () {
      // [1, 2, 99] vs [1, 3, 4]: second pair differs → negative.
      check(
        intSet(<int>[1, 2, 99]).compareTo(intSet(<int>[1, 3, 4])),
      ).isNegative();
    });
  });

  group('_compareIterables (via compareTo) — different lengths', () {
    // _compareIterables stops when the shorter iterator is exhausted.
    // The outer compareTo has NO length tiebreak, so prefix-equal
    // sets of different sizes return 0 from the private helper.

    test('differing first element wins over length difference', () {
      check(intSet(<int>[0, 5, 6]).compareTo(intSet(<int>[1]))).isNegative();
    });
  });

  group('_compareIterables with String elements', () {
    test('equal string singletons return 0', () {
      check(
        stringSet(<String>['apple']).compareTo(stringSet(<String>['apple'])),
      ).equals(0);
    });

    test('"apple" < "banana" gives negative', () {
      check(
        stringSet(<String>['apple']).compareTo(stringSet(<String>['banana'])),
      ).isNegative();
    });

    test('"banana" > "apple" gives positive', () {
      check(
        stringSet(<String>['banana']).compareTo(stringSet(<String>['apple'])),
      ).isGreaterThan(0);
    });

    test('lexicographic order on second element', () {
      check(
        stringSet(<String>['a', 'b']).compareTo(stringSet(<String>['a', 'c'])),
      ).isNegative();
    });
  });

  // ---------------------------------------------------------------------
  // SplayTreeSetExtension.compareTo
  // ---------------------------------------------------------------------

  group('SplayTreeSetExtension.compareTo — identical reference', () {
    test('same instance returns 0', () {
      final SplayTreeSet<int> s = intSet(<int>[1, 2, 3]);
      check(s.compareTo(s)).equals(0);
    });

    test('empty set compared with itself returns 0', () {
      final SplayTreeSet<int> s = intSet(<int>[]);
      check(s.compareTo(s)).equals(0);
    });
  });

  group('SplayTreeSetExtension.compareTo — empty sets', () {
    test('two distinct empty sets return 0', () {
      check(intSet(<int>[]).compareTo(intSet(<int>[]))).equals(0);
    });

    test('empty set compared to non-empty returns -1', () {
      check(intSet(<int>[]).compareTo(intSet(<int>[1]))).equals(-1);
    });

    test('non-empty set compared to empty returns 1', () {
      check(intSet(<int>[1]).compareTo(intSet(<int>[]))).equals(1);
    });

    test('empty vs multi-element set returns -1', () {
      check(intSet(<int>[]).compareTo(intSet(<int>[1, 2, 3]))).equals(-1);
    });

    test('multi-element set vs empty returns 1', () {
      check(intSet(<int>[1, 2, 3]).compareTo(intSet(<int>[]))).equals(1);
    });
  });

  group('SplayTreeSetExtension.compareTo — equal non-empty sets', () {
    test('singleton equal sets return 0', () {
      check(intSet(<int>[42]).compareTo(intSet(<int>[42]))).equals(0);
    });

    test('multi-element equal sets return 0', () {
      check(intSet(<int>[1, 2, 3]).compareTo(intSet(<int>[1, 2, 3]))).equals(0);
    });

    test('insertion order is irrelevant (SplayTreeSet sorts)', () {
      // SplayTreeSet always iterates in sorted order.
      check(intSet(<int>[3, 1, 2]).compareTo(intSet(<int>[1, 2, 3]))).equals(0);
    });
  });

  group('SplayTreeSetExtension.compareTo — ordering', () {
    test('smaller first element gives negative result', () {
      check(intSet(<int>[1, 5]).compareTo(intSet(<int>[2, 5]))).isNegative();
    });

    test('larger first element gives positive result', () {
      check(
        intSet(<int>[3, 5]).compareTo(intSet(<int>[2, 5])),
      ).isGreaterThan(0);
    });

    test('first elements equal, smaller second gives negative', () {
      check(intSet(<int>[1, 2]).compareTo(intSet(<int>[1, 3]))).isNegative();
    });

    test('first elements equal, larger second gives positive', () {
      check(
        intSet(<int>[1, 4]).compareTo(intSet(<int>[1, 3])),
      ).isGreaterThan(0);
    });

    test('negative integers are ordered correctly', () {
      check(
        intSet(<int>[-3, -1]).compareTo(intSet(<int>[-2, -1])),
      ).isNegative();
    });

    test('mixed negative and positive integers', () {
      check(
        intSet(<int>[-1, 0, 1]).compareTo(intSet(<int>[-1, 0, 2])),
      ).isNegative();
    });
  });

  group('SplayTreeSetExtension.compareTo — antisymmetry', () {
    test('sign of a.compareTo(b) equals negative sign of b.compareTo(a)', () {
      final SplayTreeSet<int> a = intSet(<int>[1, 2]);
      final SplayTreeSet<int> b = intSet(<int>[1, 3]);
      check(a.compareTo(b).sign).equals(-b.compareTo(a).sign);
    });

    test('antisymmetry holds when first elements differ', () {
      final SplayTreeSet<int> a = intSet(<int>[1]);
      final SplayTreeSet<int> b = intSet(<int>[2]);
      check(a.compareTo(b).sign).equals(-b.compareTo(a).sign);
    });

    test('antisymmetry holds for empty vs non-empty', () {
      final SplayTreeSet<int> empty = intSet(<int>[]);
      final SplayTreeSet<int> nonEmpty = intSet(<int>[1]);
      check(
        empty.compareTo(nonEmpty).sign,
      ).equals(-nonEmpty.compareTo(empty).sign);
    });
  });

  group('SplayTreeSetExtension.compareTo — transitivity', () {
    test('{1} < {2} < {3} implies {1} < {3}', () {
      final SplayTreeSet<int> a = intSet(<int>[1]);
      final SplayTreeSet<int> b = intSet(<int>[2]);
      final SplayTreeSet<int> c = intSet(<int>[3]);
      check(a.compareTo(b)).isNegative();
      check(b.compareTo(c)).isNegative();
      check(a.compareTo(c)).isNegative();
    });
  });

  // ---------------------------------------------------------------------
  // SplayTreeSetExtension.compareToReversed
  // ---------------------------------------------------------------------

  group('SplayTreeSetExtension.compareToReversed — identical reference', () {
    test('same instance returns 0', () {
      final SplayTreeSet<int> s = intSet(<int>[1, 2, 3]);
      check(s.compareToReversed(s)).equals(0);
    });

    test('empty set compared with itself returns 0', () {
      final SplayTreeSet<int> s = intSet(<int>[]);
      check(s.compareToReversed(s)).equals(0);
    });
  });

  group('SplayTreeSetExtension.compareToReversed — empty sets', () {
    test('two distinct empty sets return 0', () {
      check(intSet(<int>[]).compareToReversed(intSet(<int>[]))).equals(0);
    });

    test('empty vs non-empty returns -1', () {
      check(intSet(<int>[]).compareToReversed(intSet(<int>[1]))).equals(-1);
    });

    test('non-empty vs empty returns 1', () {
      check(intSet(<int>[1]).compareToReversed(intSet(<int>[]))).equals(1);
    });
  });

  group('SplayTreeSetExtension.compareToReversed — equal sets', () {
    test('singleton equal sets return 0', () {
      check(intSet(<int>[42]).compareToReversed(intSet(<int>[42]))).equals(0);
    });

    test('multi-element equal sets return 0', () {
      check(
        intSet(<int>[1, 2, 3]).compareToReversed(intSet(<int>[1, 2, 3])),
      ).equals(0);
    });

    test('insertion order is irrelevant (SplayTreeSet sorts)', () {
      check(
        intSet(<int>[3, 1, 2]).compareToReversed(intSet(<int>[1, 2, 3])),
      ).equals(0);
    });
  });

  group('SplayTreeSetExtension.compareToReversed — ordering from last '
      'element', () {
    // compareToReversed compares from the last (largest) element
    // first. {1,5} reversed=[5,1]; {1,3} reversed=[3,1] →
    // 5 > 3 → positive.
    test('{1,5} > {1,3} because last element 5 > 3', () {
      check(
        intSet(<int>[1, 5]).compareToReversed(intSet(<int>[1, 3])),
      ).isGreaterThan(0);
    });

    test('{1,2} < {1,4} because last element 2 < 4', () {
      check(
        intSet(<int>[1, 2]).compareToReversed(intSet(<int>[1, 4])),
      ).isNegative();
    });

    // When last elements are equal, the next-to-last pair decides.
    // {2,5} reversed=[5,2]; {3,5} reversed=[5,3] →
    // 5==5, then 2 < 3.
    test('last elements equal, second-to-last decides', () {
      check(
        intSet(<int>[2, 5]).compareToReversed(intSet(<int>[3, 5])),
      ).isNegative();
    });

    test('last elements equal, larger second-to-last gives positive', () {
      check(
        intSet(<int>[4, 5]).compareToReversed(intSet(<int>[3, 5])),
      ).isGreaterThan(0);
    });

    // {1,2,9} reversed=[9,2,1]; {1,3,9} reversed=[9,3,1].
    // 9==9, then 2 < 3 → negative.
    test('three-element sets: tiebreak at second-to-last', () {
      check(
        intSet(<int>[1, 2, 9]).compareToReversed(intSet(<int>[1, 3, 9])),
      ).isNegative();
    });

    test('negative integers in reversed comparison', () {
      // {-3,-1} reversed=[-1,-3]; {-2,-1} reversed=[-1,-2].
      // -1==-1, then -3 < -2 → negative.
      check(
        intSet(<int>[-3, -1]).compareToReversed(intSet(<int>[-2, -1])),
      ).isNegative();
    });
  });

  group('SplayTreeSetExtension.compareToReversed — differs from compareTo', () {
    // {1,5} vs {2,3}:
    //   compareTo:         1 < 2 → negative
    //   compareToReversed: 5 > 3 → positive
    test('same pair gives opposite signs under the two methods', () {
      final SplayTreeSet<int> a = intSet(<int>[1, 5]);
      final SplayTreeSet<int> b = intSet(<int>[2, 3]);
      check(a.compareTo(b)).isNegative();
      check(a.compareToReversed(b)).isGreaterThan(0);
    });

    // {3,4} vs {1,5}:
    //   compareTo:         3 > 1 → positive
    //   compareToReversed: 4 < 5 → negative
    test('another pair giving opposite signs', () {
      final SplayTreeSet<int> a = intSet(<int>[3, 4]);
      final SplayTreeSet<int> b = intSet(<int>[1, 5]);
      check(a.compareTo(b)).isGreaterThan(0);
      check(a.compareToReversed(b)).isNegative();
    });

    test('equal sets return 0 in both methods', () {
      final SplayTreeSet<int> a = intSet(<int>[1, 2, 3]);
      final SplayTreeSet<int> b = intSet(<int>[1, 2, 3]);
      check(a.compareTo(b)).equals(0);
      check(a.compareToReversed(b)).equals(0);
    });
  });

  group('SplayTreeSetExtension.compareToReversed — antisymmetry', () {
    test('sign of a.compareToReversed(b) equals negative of '
        'b.compareToReversed(a)', () {
      final SplayTreeSet<int> a = intSet(<int>[1, 5]);
      final SplayTreeSet<int> b = intSet(<int>[1, 3]);
      check(a.compareToReversed(b).sign).equals(-b.compareToReversed(a).sign);
    });

    test('antisymmetry for empty vs non-empty', () {
      final SplayTreeSet<int> empty = intSet(<int>[]);
      final SplayTreeSet<int> nonEmpty = intSet(<int>[1]);
      check(
        empty.compareToReversed(nonEmpty).sign,
      ).equals(-nonEmpty.compareToReversed(empty).sign);
    });
  });

  group('SplayTreeSetExtension.compareToReversed — different lengths', () {
    // {1,2} reversed=[2,1]; {1,2,3} reversed=[3,2,1].
    // First pair: 2 < 3 → negative.
    test('{1,2} reversed < {1,2,3} reversed (last 2 < last 3)', () {
      check(
        intSet(<int>[1, 2]).compareToReversed(intSet(<int>[1, 2, 3])),
      ).isNegative();
    });

    test('{1,2,3} reversed > {1,2} reversed (last 3 > last 2)', () {
      check(
        intSet(<int>[1, 2, 3]).compareToReversed(intSet(<int>[1, 2])),
      ).isGreaterThan(0);
    });
  });

  group('SplayTreeSetExtension — String sets', () {
    test('compareTo on equal string sets returns 0', () {
      check(
        stringSet(<String>['a', 'b']).compareTo(stringSet(<String>['a', 'b'])),
      ).equals(0);
    });

    test('compareTo: {"a","b"} < {"a","c"}', () {
      check(
        stringSet(<String>['a', 'b']).compareTo(stringSet(<String>['a', 'c'])),
      ).isNegative();
    });

    test('compareToReversed on equal string sets returns 0', () {
      check(
        stringSet(<String>[
          'a',
          'b',
        ]).compareToReversed(stringSet(<String>['a', 'b'])),
      ).equals(0);
    });

    test('compareToReversed: {"a","b"} > {"a","a"} because last '
        '"b" > "a"', () {
      // {"a","b"} reversed=["b","a"]; {"a","a"} reversed=["a","a"].
      check(
        stringSet(<String>[
          'a',
          'b',
        ]).compareToReversed(stringSet(<String>['a', 'a'])),
      ).isGreaterThan(0);
    });

    test('compareToReversed: {"a","c"} > {"a","b"}', () {
      check(
        stringSet(<String>[
          'a',
          'c',
        ]).compareToReversed(stringSet(<String>['a', 'b'])),
      ).isGreaterThan(0);
    });
  });
}

/// Creates a [SplayTreeSet<int>] with natural ordering from [elements].
SplayTreeSet<int> intSet(final Iterable<int> elements) =>
    SplayTreeSet<int>.of(elements);

/// Creates a [SplayTreeSet<String>] with natural ordering from
/// [elements].
SplayTreeSet<String> stringSet(final Iterable<String> elements) =>
    SplayTreeSet<String>.of(elements);
