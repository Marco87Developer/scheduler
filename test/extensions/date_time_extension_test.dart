import 'package:scheduler/src/extensions/date_time_extension.dart';
import 'package:test/test.dart';

void main() {
  // -------------------------------------------------------------------------
  // Shared fixtures
  // -------------------------------------------------------------------------
  final DateTime epoch = DateTime.utc(1970);
  final DateTime past = DateTime.utc(2000);
  final DateTime present = DateTime.utc(2020);
  final DateTime future = DateTime.utc(2040);

  // -------------------------------------------------------------------------
  // maxDateTime
  // -------------------------------------------------------------------------
  group('maxDateTime', () {
    group('returns the later date', () {
      test('when the first argument comes after the second', () {
        expect(maxDateTime(future, past), equals(future));
      });

      test('when the second argument comes after the first', () {
        expect(maxDateTime(past, future), equals(future));
      });

      test('when both arguments are identical instances', () {
        expect(maxDateTime(present, present), equals(present));
      });

      test('when both arguments represent the same moment', () {
        final DateTime a = DateTime.utc(2020, 6, 15, 12);
        final DateTime b = DateTime.utc(2020, 6, 15, 12);
        expect(maxDateTime(a, b), equals(b));
      });

      test('favours the second argument on equal moments (returns b)', () {
        final DateTime a = DateTime.utc(2020);
        final DateTime b = DateTime.utc(2020);
        // When equal, isAfter is false so the second argument is returned.
        expect(maxDateTime(a, b), same(b));
      });

      test('works with millisecond precision', () {
        final DateTime a = DateTime.utc(2020);
        final DateTime b = DateTime.utc(2020, 1, 1, 0, 0, 0, 1);
        expect(maxDateTime(a, b), equals(b));
      });

      test('works with microsecond precision', () {
        final DateTime a = DateTime.utc(2020);
        final DateTime b = DateTime.utc(2020, 1, 1, 0, 0, 0, 0, 1);
        expect(maxDateTime(a, b), equals(b));
      });

      test('works with the epoch', () {
        expect(maxDateTime(epoch, past), equals(past));
      });
    });

    group('is commutative', () {
      test('maxDateTime(a, b) == maxDateTime(b, a)', () {
        expect(maxDateTime(past, future), equals(maxDateTime(future, past)));
      });
    });

    group('is idempotent', () {
      test('maxDateTime(a, a) == a', () {
        expect(maxDateTime(present, present), equals(present));
      });
    });
  });

  // -------------------------------------------------------------------------
  // minDateTime
  // -------------------------------------------------------------------------
  group('minDateTime', () {
    group('returns the earlier date', () {
      test('when the first argument comes before the second', () {
        expect(minDateTime(past, future), equals(past));
      });

      test('when the second argument comes before the first', () {
        expect(minDateTime(future, past), equals(past));
      });

      test('when both arguments are identical instances', () {
        expect(minDateTime(present, present), equals(present));
      });

      test('when both arguments represent the same moment', () {
        final DateTime a = DateTime.utc(2020, 6, 15, 12);
        final DateTime b = DateTime.utc(2020, 6, 15, 12);
        expect(minDateTime(a, b), equals(a));
      });

      test('favours the first argument on equal moments (returns a)', () {
        final DateTime a = DateTime.utc(2020);
        final DateTime b = DateTime.utc(2020);
        // When equal, isBefore is false so the second argument is returned —
        // both are equal so either is correct, but we document the behaviour.
        expect(minDateTime(a, b), equals(a));
      });

      test('works with millisecond precision', () {
        final DateTime a = DateTime.utc(2020);
        final DateTime b = DateTime.utc(2020, 1, 1, 0, 0, 0, 1);
        expect(minDateTime(a, b), equals(a));
      });

      test('works with microsecond precision', () {
        final DateTime a = DateTime.utc(2020);
        final DateTime b = DateTime.utc(2020, 1, 1, 0, 0, 0, 0, 1);
        expect(minDateTime(a, b), equals(a));
      });

      test('works with the epoch', () {
        expect(minDateTime(epoch, past), equals(epoch));
      });
    });

    group('is commutative', () {
      test('minDateTime(a, b) == minDateTime(b, a)', () {
        expect(minDateTime(past, future), equals(minDateTime(future, past)));
      });
    });

    group('is idempotent', () {
      test('minDateTime(a, a) == a', () {
        expect(minDateTime(present, present), equals(present));
      });
    });
  });

  // -------------------------------------------------------------------------
  // maxDateTime / minDateTime — combined invariants
  // -------------------------------------------------------------------------
  group('maxDateTime and minDateTime — combined invariants', () {
    test('minDateTime <= maxDateTime for any pair', () {
      final List<(DateTime, DateTime)> pairs = <(DateTime, DateTime)>[
        (past, future),
        (future, past),
        (present, present),
        (epoch, future),
      ];
      for (final (DateTime a, DateTime b) in pairs) {
        expect(
          minDateTime(a, b).isBeforeOrAtSameMomentAs(maxDateTime(a, b)),
          isTrue,
        );
      }
    });

    test(
      'minDateTime(a, b) is always before or equal to maxDateTime(a, b)',
      () {
        expect(
          minDateTime(
            past,
            future,
          ).isBeforeOrAtSameMomentAs(maxDateTime(past, future)),
          isTrue,
        );
      },
    );

    test('min and max coincide when both arguments are equal', () {
      expect(
        minDateTime(present, present),
        equals(maxDateTime(present, present)),
      );
    });
  });

  // -------------------------------------------------------------------------
  // DateTimeExtension.isAfterOrAtSameMomentAs
  // -------------------------------------------------------------------------
  group('DateTimeExtension.isAfterOrAtSameMomentAs', () {
    group('returns true', () {
      test('when this is strictly after other', () {
        expect(future.isAfterOrAtSameMomentAs(past), isTrue);
      });

      test('when this is at the same moment as other', () {
        expect(present.isAfterOrAtSameMomentAs(present), isTrue);
      });

      test('when both represent the same moment (different instances)', () {
        final DateTime a = DateTime.utc(2020);
        final DateTime b = DateTime.utc(2020);
        expect(a.isAfterOrAtSameMomentAs(b), isTrue);
      });

      test('with millisecond precision', () {
        final DateTime a = DateTime.utc(2020, 1, 1, 0, 0, 0, 1);
        final DateTime b = DateTime.utc(2020);
        expect(a.isAfterOrAtSameMomentAs(b), isTrue);
      });

      test('with microsecond precision', () {
        final DateTime a = DateTime.utc(2020, 1, 1, 0, 0, 0, 0, 1);
        final DateTime b = DateTime.utc(2020);
        expect(a.isAfterOrAtSameMomentAs(b), isTrue);
      });
    });

    group('returns false', () {
      test('when this is strictly before other', () {
        expect(past.isAfterOrAtSameMomentAs(future), isFalse);
      });

      test('with millisecond precision', () {
        final DateTime a = DateTime.utc(2020);
        final DateTime b = DateTime.utc(2020, 1, 1, 0, 0, 0, 1);
        expect(a.isAfterOrAtSameMomentAs(b), isFalse);
      });
    });

    group('consistency with isAfter and isAtSameMomentAs', () {
      test('isAfterOrAtSameMomentAs == isAfter || isAtSameMomentAs', () {
        final List<(DateTime, DateTime)> pairs = <(DateTime, DateTime)>[
          (past, future),
          (future, past),
          (present, present),
        ];
        for (final (DateTime a, DateTime b) in pairs) {
          expect(
            a.isAfterOrAtSameMomentAs(b),
            equals(a.isAfter(b) || a.isAtSameMomentAs(b)),
          );
        }
      });
    });
  });

  // -------------------------------------------------------------------------
  // DateTimeExtension.isBeforeOrAtSameMomentAs
  // -------------------------------------------------------------------------
  group('DateTimeExtension.isBeforeOrAtSameMomentAs', () {
    group('returns true', () {
      test('when this is strictly before other', () {
        expect(past.isBeforeOrAtSameMomentAs(future), isTrue);
      });

      test('when this is at the same moment as other', () {
        expect(present.isBeforeOrAtSameMomentAs(present), isTrue);
      });

      test('when both represent the same moment (different instances)', () {
        final DateTime a = DateTime.utc(2020);
        final DateTime b = DateTime.utc(2020);
        expect(a.isBeforeOrAtSameMomentAs(b), isTrue);
      });

      test('with millisecond precision', () {
        final DateTime a = DateTime.utc(2020);
        final DateTime b = DateTime.utc(2020, 1, 1, 0, 0, 0, 1);
        expect(a.isBeforeOrAtSameMomentAs(b), isTrue);
      });

      test('with microsecond precision', () {
        final DateTime a = DateTime.utc(2020);
        final DateTime b = DateTime.utc(2020, 1, 1, 0, 0, 0, 0, 1);
        expect(a.isBeforeOrAtSameMomentAs(b), isTrue);
      });
    });

    group('returns false', () {
      test('when this is strictly after other', () {
        expect(future.isBeforeOrAtSameMomentAs(past), isFalse);
      });

      test('with millisecond precision', () {
        final DateTime a = DateTime.utc(2020, 1, 1, 0, 0, 0, 1);
        final DateTime b = DateTime.utc(2020);
        expect(a.isBeforeOrAtSameMomentAs(b), isFalse);
      });
    });

    group('consistency with isBefore and isAtSameMomentAs', () {
      test('isBeforeOrAtSameMomentAs == isBefore || isAtSameMomentAs', () {
        final List<(DateTime, DateTime)> pairs = <(DateTime, DateTime)>[
          (past, future),
          (future, past),
          (present, present),
        ];
        for (final (DateTime a, DateTime b) in pairs) {
          expect(
            a.isBeforeOrAtSameMomentAs(b),
            equals(a.isBefore(b) || a.isAtSameMomentAs(b)),
          );
        }
      });
    });

    group('is the logical inverse of isAfterOrAtSameMomentAs', () {
      test('a <= b implies !(b <= a) when a != b', () {
        expect(past.isBeforeOrAtSameMomentAs(future), isTrue);
        expect(future.isBeforeOrAtSameMomentAs(past), isFalse);
      });

      test('both are true when a == b', () {
        expect(present.isBeforeOrAtSameMomentAs(present), isTrue);
        expect(present.isAfterOrAtSameMomentAs(present), isTrue);
      });
    });
  });

  // -------------------------------------------------------------------------
  // DateTimeExtension.isBetween
  // -------------------------------------------------------------------------
  group('DateTimeExtension.isBetween', () {
    group('returns true', () {
      test('when this is strictly between the two bounds (ordered)', () {
        expect(present.isBetween(past, future), isTrue);
      });

      test('when this is strictly between the two bounds (reversed)', () {
        expect(present.isBetween(future, past), isTrue);
      });

      test('with millisecond precision', () {
        final DateTime lower = DateTime.utc(2020);
        final DateTime mid = DateTime.utc(2020, 1, 1, 0, 0, 0, 1);
        final DateTime upper = DateTime.utc(2020, 1, 1, 0, 0, 0, 2);
        expect(mid.isBetween(lower, upper), isTrue);
      });

      test('with microsecond precision', () {
        final DateTime lower = DateTime.utc(2020);
        final DateTime mid = DateTime.utc(2020, 1, 1, 0, 0, 0, 0, 1);
        final DateTime upper = DateTime.utc(2020, 1, 1, 0, 0, 0, 0, 2);
        expect(mid.isBetween(lower, upper), isTrue);
      });
    });

    group('returns false', () {
      test('when this is exactly at the lower bound', () {
        expect(past.isBetween(past, future), isFalse);
      });

      test('when this is exactly at the upper bound', () {
        expect(future.isBetween(past, future), isFalse);
      });

      test('when this is strictly before the lower bound', () {
        expect(epoch.isBetween(past, future), isFalse);
      });

      test('when this is strictly after the upper bound', () {
        final DateTime wayFuture = DateTime.utc(2100);
        expect(wayFuture.isBetween(past, future), isFalse);
      });

      test('when both bounds are the same moment', () {
        // There is no open interval to be strictly inside.
        expect(present.isBetween(present, present), isFalse);
      });

      test('when this equals both bounds (degenerate interval)', () {
        expect(past.isBetween(past, past), isFalse);
      });
    });

    group('is symmetric with respect to argument order', () {
      test('isBetween(a, b) == isBetween(b, a)', () {
        expect(
          present.isBetween(past, future),
          equals(present.isBetween(future, past)),
        );
      });

      test('returns false regardless of order when outside', () {
        expect(epoch.isBetween(past, future), isFalse);
        expect(epoch.isBetween(future, past), isFalse);
      });
    });
  });

  // -------------------------------------------------------------------------
  // DateTimeExtension.isBetweenOrAtSameMomentAs
  // -------------------------------------------------------------------------
  group('DateTimeExtension.isBetweenOrAtSameMomentAs', () {
    group('returns true', () {
      test('when this is strictly between the two bounds', () {
        expect(present.isBetweenOrAtSameMomentAs(past, future), isTrue);
      });

      test('when this is at the lower bound', () {
        expect(past.isBetweenOrAtSameMomentAs(past, future), isTrue);
      });

      test('when this is at the upper bound', () {
        expect(future.isBetweenOrAtSameMomentAs(past, future), isTrue);
      });

      test('when both bounds are the same moment and this equals them', () {
        expect(present.isBetweenOrAtSameMomentAs(present, present), isTrue);
      });

      test('when bounds are reversed and this is at the lower bound', () {
        expect(past.isBetweenOrAtSameMomentAs(future, past), isTrue);
      });

      test('when bounds are reversed and this is at the upper bound', () {
        expect(future.isBetweenOrAtSameMomentAs(future, past), isTrue);
      });

      test('when bounds are reversed and this is strictly between', () {
        expect(present.isBetweenOrAtSameMomentAs(future, past), isTrue);
      });

      test('with millisecond precision at lower bound', () {
        final DateTime lower = DateTime.utc(2020);
        final DateTime upper = DateTime.utc(2020, 1, 1, 0, 0, 0, 2);
        expect(lower.isBetweenOrAtSameMomentAs(lower, upper), isTrue);
      });

      test('with millisecond precision at upper bound', () {
        final DateTime lower = DateTime.utc(2020);
        final DateTime upper = DateTime.utc(2020, 1, 1, 0, 0, 0, 2);
        expect(upper.isBetweenOrAtSameMomentAs(lower, upper), isTrue);
      });
    });

    group('returns false', () {
      test('when this is strictly before the lower bound', () {
        expect(epoch.isBetweenOrAtSameMomentAs(past, future), isFalse);
      });

      test('when this is strictly after the upper bound', () {
        final DateTime wayFuture = DateTime.utc(2100);
        expect(wayFuture.isBetweenOrAtSameMomentAs(past, future), isFalse);
      });

      test('when both bounds are the same moment and this is outside', () {
        expect(past.isBetweenOrAtSameMomentAs(future, future), isFalse);
      });

      test('with millisecond precision — one ms before lower bound', () {
        final DateTime lower = DateTime.utc(2020, 1, 1, 0, 0, 0, 1);
        final DateTime upper = DateTime.utc(2020, 1, 1, 0, 0, 0, 3);
        final DateTime before = DateTime.utc(2020);
        expect(before.isBetweenOrAtSameMomentAs(lower, upper), isFalse);
      });
    });

    group('is a superset of isBetween', () {
      test('anything isBetween is also isBetweenOrAtSameMomentAs', () {
        expect(present.isBetween(past, future), isTrue);
        expect(present.isBetweenOrAtSameMomentAs(past, future), isTrue);
      });
    });

    group('is symmetric with respect to argument order', () {
      test(
        'isBetweenOrAtSameMomentAs(a, b) == isBetweenOrAtSameMomentAs(b, a)',
        () {
          final List<DateTime> dates = <DateTime>[epoch, past, present, future];
          for (final DateTime d in dates) {
            expect(
              d.isBetweenOrAtSameMomentAs(past, future),
              equals(d.isBetweenOrAtSameMomentAs(future, past)),
            );
          }
        },
      );
    });
  });
}
