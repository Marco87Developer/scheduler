import 'dart:collection';

import 'package:scheduler/src/models/date_time_range.dart';
import 'package:test/test.dart';

// ---------------------------------------------------------------------------
// Shared fixtures
// ---------------------------------------------------------------------------

void main() {
  // -------------------------------------------------------------------------
  // DateTimeRange.className
  // -------------------------------------------------------------------------
  group('DateTimeRange.className', () {
    test('is "DateTimeRange"', () {
      expect(DateTimeRange.className, equals('DateTimeRange'));
    });
  });

  // -------------------------------------------------------------------------
  // DateTimeRange constructor
  // -------------------------------------------------------------------------
  group('DateTimeRange constructor — field assignment', () {
    test('dt1 < dt2: start = dt1, end = dt2', () {
      final DateTimeRange r = DateTimeRange(t1, t3);
      expect(r.start, equals(t1));
      expect(r.end, equals(t3));
    });

    test('dt1 > dt2: start = dt2, end = dt1 (swapped)', () {
      final DateTimeRange r = DateTimeRange(t3, t1);
      expect(r.start, equals(t1));
      expect(r.end, equals(t3));
    });

    test('dt1 == dt2: start == end (degenerate range)', () {
      final DateTimeRange r = DateTimeRange(t1, t1);
      expect(r.start, equals(t1));
      expect(r.end, equals(t1));
    });

    test('swapped and non-swapped produce equal ranges', () {
      expect(DateTimeRange(t1, t3), equals(DateTimeRange(t3, t1)));
    });

    test('works with local DateTimes', () {
      final DateTime local1 = DateTime(2020);
      final DateTime local2 = DateTime(2020, 6);
      final DateTimeRange r = DateTimeRange(local1, local2);
      expect(r.start, equals(local1));
      expect(r.end, equals(local2));
    });

    test('works with millisecond precision', () {
      final DateTime a = DateTime.utc(2020);
      final DateTime b = DateTime.utc(2020, 1, 1, 0, 0, 0, 1);
      final DateTimeRange r = DateTimeRange(a, b);
      expect(r.start, equals(a));
      expect(r.end, equals(b));
    });

    test('works with microsecond precision', () {
      final DateTime a = DateTime.utc(2020);
      final DateTime b = DateTime.utc(2020, 1, 1, 0, 0, 0, 0, 1);
      final DateTimeRange r = DateTimeRange(a, b);
      expect(r.start, equals(a));
      expect(r.end, equals(b));
    });

    test('start is always before or equal to end', () {
      for (final (DateTime a, DateTime b) in <(DateTime, DateTime)>[
        (t1, t2),
        (t2, t1),
        (t1, t1),
        (t3, t1),
      ]) {
        final DateTimeRange r = DateTimeRange(a, b);
        expect(
          r.start.isAfter(r.end),
          isFalse,
          reason: 'start must not be after end for ($a, $b)',
        );
      }
    });
  });

  // -------------------------------------------------------------------------
  // DateTimeRange.fromMap
  // -------------------------------------------------------------------------
  group('DateTimeRange.fromMap — valid input', () {
    test('creates range from valid map', () {
      final Map<String, Object?> map = <String, Object?>{
        'start': t1.toIso8601String(),
        'end': t3.toIso8601String(),
      };
      final DateTimeRange r = DateTimeRange.fromMap(map);
      expect(r.start, equals(t1));
      expect(r.end, equals(t3));
    });

    test('swaps start and end when start is after end', () {
      final Map<String, Object?> map = <String, Object?>{
        'start': t3.toIso8601String(),
        'end': t1.toIso8601String(),
      };
      final DateTimeRange r = DateTimeRange.fromMap(map);
      expect(r.start, equals(t1));
      expect(r.end, equals(t3));
    });

    test('handles equal start and end (degenerate range)', () {
      final Map<String, Object?> map = <String, Object?>{
        'start': t1.toIso8601String(),
        'end': t1.toIso8601String(),
      };
      final DateTimeRange r = DateTimeRange.fromMap(map);
      expect(r.start, equals(t1));
      expect(r.end, equals(t1));
    });
  });

  group('DateTimeRange.fromMap — invalid input', () {
    test('throws FormatException when "start" key is missing', () {
      final Map<String, Object?> map = <String, Object?>{
        'end': t3.toIso8601String(),
      };
      expect(() => DateTimeRange.fromMap(map), throwsA(isA<FormatException>()));
    });

    test('throws FormatException when "end" key is missing', () {
      final Map<String, Object?> map = <String, Object?>{
        'start': t1.toIso8601String(),
      };
      expect(() => DateTimeRange.fromMap(map), throwsA(isA<FormatException>()));
    });

    test('throws FormatException when "start" value is null', () {
      final Map<String, Object?> map = <String, Object?>{
        'start': null,
        'end': t3.toIso8601String(),
      };
      expect(() => DateTimeRange.fromMap(map), throwsA(isA<FormatException>()));
    });

    test('throws FormatException when "end" value is null', () {
      final Map<String, Object?> map = <String, Object?>{
        'start': t1.toIso8601String(),
        'end': null,
      };
      expect(() => DateTimeRange.fromMap(map), throwsA(isA<FormatException>()));
    });

    test('throws FormatException when "start" value is not a String', () {
      final Map<String, Object?> map = <String, Object?>{
        'start': 12345,
        'end': t3.toIso8601String(),
      };
      expect(() => DateTimeRange.fromMap(map), throwsA(isA<FormatException>()));
    });

    test('throws FormatException when "start" is an invalid date string', () {
      final Map<String, Object?> map = <String, Object?>{
        'start': 'not-a-date',
        'end': t3.toIso8601String(),
      };
      expect(() => DateTimeRange.fromMap(map), throwsA(isA<FormatException>()));
    });

    test('throws FormatException when "end" is an invalid date string', () {
      final Map<String, Object?> map = <String, Object?>{
        'start': t1.toIso8601String(),
        'end': 'not-a-date',
      };
      expect(() => DateTimeRange.fromMap(map), throwsA(isA<FormatException>()));
    });

    test('throws FormatException when map is empty', () {
      expect(
        () => DateTimeRange.fromMap(const <String, Object?>{}),
        throwsA(isA<FormatException>()),
      );
    });

    test('FormatException message contains "DateTimeRange"', () {
      expect(
        () => DateTimeRange.fromMap(const <String, Object?>{'end': 'x'}),
        throwsA(
          isA<FormatException>().having(
            (final FormatException e) => e.message,
            'message',
            contains('DateTimeRange'),
          ),
        ),
      );
    });

    test('FormatException source is the "bad" string', () {
      final Map<String, Object?> map = <String, Object?>{
        'start': 'bad',
        'end': t3.toIso8601String(),
      };
      expect(
        () => DateTimeRange.fromMap(map),
        throwsA(
          isA<FormatException>().having(
            (final FormatException e) => e.source,
            'source',
            'bad',
          ),
        ),
      );
    });
  });

  // -------------------------------------------------------------------------
  // DateTimeRange.fromJson
  // -------------------------------------------------------------------------
  group('DateTimeRange.fromJson — valid input', () {
    test('creates range from valid JSON', () {
      final String json =
          '{"start":"${t1.toIso8601String()}",'
          '"end":"${t3.toIso8601String()}"}';
      final DateTimeRange r = DateTimeRange.fromJson(json);
      expect(r.start, equals(t1));
      expect(r.end, equals(t3));
    });

    test('swaps dates when start is after end', () {
      final String json =
          '{"start":"${t3.toIso8601String()}",'
          '"end":"${t1.toIso8601String()}"}';
      final DateTimeRange r = DateTimeRange.fromJson(json);
      expect(r.start, equals(t1));
      expect(r.end, equals(t3));
    });

    test('handles equal start and end', () {
      final String json =
          '{"start":"${t1.toIso8601String()}",'
          '"end":"${t1.toIso8601String()}"}';
      final DateTimeRange r = DateTimeRange.fromJson(json);
      expect(r.start, equals(t1));
      expect(r.end, equals(t1));
    });
  });

  group('DateTimeRange.fromJson — invalid JSON syntax', () {
    test('throws FormatException for non-JSON input', () {
      expect(
        () => DateTimeRange.fromJson('not json'),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws FormatException for empty string', () {
      expect(() => DateTimeRange.fromJson(''), throwsA(isA<FormatException>()));
    });

    test('throws FormatException for partial JSON', () {
      expect(
        () => DateTimeRange.fromJson('{'),
        throwsA(isA<FormatException>()),
      );
    });
  });

  group('DateTimeRange.fromJson — wrong JSON structure', () {
    test('throws FormatException when JSON is a string (not a map)', () {
      expect(
        () => DateTimeRange.fromJson('"hello"'),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws FormatException when JSON is a number', () {
      expect(
        () => DateTimeRange.fromJson('42'),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws FormatException when JSON is an array', () {
      expect(
        () => DateTimeRange.fromJson('[]'),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws FormatException when JSON is null', () {
      expect(
        () => DateTimeRange.fromJson('null'),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws FormatException when "start" key is missing', () {
      final String json = '{"end":"${t3.toIso8601String()}"}';
      expect(
        () => DateTimeRange.fromJson(json),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws FormatException when "start" is not a valid date', () {
      final String json = '{"start":"bad","end":"${t3.toIso8601String()}"}';
      expect(
        () => DateTimeRange.fromJson(json),
        throwsA(isA<FormatException>()),
      );
    });

    test('FormatException message contains "DateTimeRange"', () {
      expect(
        () => DateTimeRange.fromJson('null'),
        throwsA(
          isA<FormatException>().having(
            (final FormatException e) => e.message,
            'message',
            contains('DateTimeRange'),
          ),
        ),
      );
    });

    test('FormatException message contains ".fromJson"', () {
      expect(
        () => DateTimeRange.fromJson('null'),
        throwsA(
          isA<FormatException>().having(
            (final FormatException e) => e.message,
            'message',
            contains('.fromJson'),
          ),
        ),
      );
    });

    test('FormatException source is the original JSON string', () {
      const String json = 'null';
      expect(
        () => DateTimeRange.fromJson(json),
        throwsA(
          isA<FormatException>().having(
            (final FormatException e) => e.source,
            'source',
            equals(json),
          ),
        ),
      );
    });

    test('FormatException source preserves the original string', () {
      const String json = '{"start":"bad","end":"also-bad"}';
      expect(
        () => DateTimeRange.fromJson(json),
        throwsA(
          isA<FormatException>().having(
            (final FormatException e) => e.source,
            'source',
            equals(json),
          ),
        ),
      );
    });
  });

  // -------------------------------------------------------------------------
  // DateTimeRange.parse
  // -------------------------------------------------------------------------
  group('DateTimeRange.parse — valid input', () {
    test('parses a valid pipe-delimited string', () {
      final DateTimeRange r = DateTimeRange(t1, t3);
      final DateTimeRange parsed = DateTimeRange.parse(r.toString());
      expect(parsed, equals(r));
    });

    test('produces correct start and end', () {
      final String s = '${t1.toIso8601String()}|${t3.toIso8601String()}';
      final DateTimeRange r = DateTimeRange.parse(s);
      expect(r.start, equals(t1));
      expect(r.end, equals(t3));
    });

    test('swaps when start > end in the string', () {
      final String s = '${t3.toIso8601String()}|${t1.toIso8601String()}';
      final DateTimeRange r = DateTimeRange.parse(s);
      expect(r.start, equals(t1));
      expect(r.end, equals(t3));
    });

    test('handles equal start and end', () {
      final String s = '${t1.toIso8601String()}|${t1.toIso8601String()}';
      final DateTimeRange r = DateTimeRange.parse(s);
      expect(r.start, equals(t1));
      expect(r.end, equals(t1));
    });

    test('leading/trailing whitespace on the whole string is trimmed', () {
      final String s = '  ${t1.toIso8601String()}|${t3.toIso8601String()}  ';
      final DateTimeRange r = DateTimeRange.parse(s);
      expect(r.start, equals(t1));
      expect(r.end, equals(t3));
    });
  });

  group('DateTimeRange.parse — invalid input', () {
    test('throws FormatException for empty string', () {
      expect(() => DateTimeRange.parse(''), throwsA(isA<FormatException>()));
    });

    test('throws FormatException for string without pipe', () {
      expect(
        () => DateTimeRange.parse(t1.toIso8601String()),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws FormatException for string with two pipes', () {
      final String s =
          '${t1.toIso8601String()}|${t2.toIso8601String()}'
          '|${t3.toIso8601String()}';
      expect(() => DateTimeRange.parse(s), throwsA(isA<FormatException>()));
    });

    test('throws FormatException when start is not a valid date', () {
      expect(
        () => DateTimeRange.parse('not-a-date|${t3.toIso8601String()}'),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws FormatException when end is not a valid date', () {
      expect(
        () => DateTimeRange.parse('${t1.toIso8601String()}|not-a-date'),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws FormatException for pipe-only string', () {
      expect(() => DateTimeRange.parse('|'), throwsA(isA<FormatException>()));
    });

    test(
      'throws FormatException when space around pipe makes parts invalid',
      () {
        final String s = '${t1.toIso8601String()} | ${t3.toIso8601String()}';
        expect(() => DateTimeRange.parse(s), throwsA(isA<FormatException>()));
      },
    );

    test('FormatException message contains "DateTimeRange"', () {
      expect(
        () => DateTimeRange.parse('bad'),
        throwsA(
          isA<FormatException>().having(
            (final FormatException e) => e.message,
            'message',
            contains('DateTimeRange'),
          ),
        ),
      );
    });

    test('FormatException message contains ".parse"', () {
      expect(
        () => DateTimeRange.parse('bad'),
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
        () => DateTimeRange.parse('bad|input'),
        throwsA(
          isA<FormatException>().having(
            (final FormatException e) => e.message,
            'message',
            contains('bad|input'),
          ),
        ),
      );
    });

    test('FormatException source is the original string', () {
      const String input = 'bad|input';
      expect(
        () => DateTimeRange.parse(input),
        throwsA(
          isA<FormatException>().having(
            (final FormatException e) => e.source,
            'source',
            equals(input),
          ),
        ),
      );
    });

    test('FormatException source preserves surrounding whitespace', () {
      const String input = '  bad  ';
      expect(
        () => DateTimeRange.parse(input),
        throwsA(
          isA<FormatException>().having(
            (final FormatException e) => e.source,
            'source',
            equals(input),
          ),
        ),
      );
    });
  });

  // -------------------------------------------------------------------------
  // start / end fields
  // -------------------------------------------------------------------------
  group('DateTimeRange.start and .end', () {
    test('start is the minimum of the two given dates', () {
      expect(DateTimeRange(t2, t1).start, equals(t1));
    });

    test('end is the maximum of the two given dates', () {
      expect(DateTimeRange(t1, t2).end, equals(t2));
    });

    test('start == end for a degenerate range', () {
      final DateTimeRange r = DateTimeRange(t1, t1);
      expect(r.start, equals(r.end));
    });
  });

  // -------------------------------------------------------------------------
  // hashCode
  // -------------------------------------------------------------------------
  group('DateTimeRange.hashCode', () {
    test('equal objects have the same hashCode', () {
      expect(r12().hashCode, equals(r12().hashCode));
    });

    test('identical objects have the same hashCode', () {
      final DateTimeRange r = r12();
      expect(r.hashCode, equals(r.hashCode));
    });

    test('swapped-argument ranges have the same hashCode as the original', () {
      final DateTimeRange a = DateTimeRange(t1, t3);
      final DateTimeRange b = DateTimeRange(t3, t1);
      expect(a.hashCode, equals(b.hashCode));
    });

    test('distinct ranges almost certainly have different hashCodes', () {
      expect(r12().hashCode, isNot(equals(r34().hashCode)));
    });

    test('hashCode is consistent with == for equal objects', () {
      final DateTimeRange a = r12();
      final DateTimeRange b = r12();
      expect(a == b, isTrue);
      expect(a.hashCode, equals(b.hashCode));
    });
  });

  // -------------------------------------------------------------------------
  // operator ==
  // -------------------------------------------------------------------------
  group('DateTimeRange operator ==', () {
    test('a range equals itself', () {
      final DateTimeRange r = r12();
      expect(r == r, isTrue);
    });

    test('two ranges with same start and end are equal', () {
      expect(r12(), equals(r12()));
    });

    test('swapped-argument ranges are equal', () {
      expect(DateTimeRange(t1, t3), equals(DateTimeRange(t3, t1)));
    });

    test('ranges with different start are not equal', () {
      expect(r12(), isNot(equals(r23())));
    });

    test('same start but different end are not equal', () {
      final DateTimeRange a = DateTimeRange(t1, t2);
      final DateTimeRange b = DateTimeRange(t1, t3);
      expect(a, isNot(equals(b)));
    });

    test('different start, same end are not equal', () {
      final DateTimeRange a = DateTimeRange(t1, t3);
      final DateTimeRange b = DateTimeRange(t2, t3);
      expect(a, isNot(equals(b)));
    });
  });

  // -------------------------------------------------------------------------
  // compareTo
  // -------------------------------------------------------------------------
  group('DateTimeRange.compareTo', () {
    test('same instance returns 0', () {
      final DateTimeRange r = r12();
      expect(r.compareTo(r), equals(0));
    });

    test('equal but distinct ranges return 0', () {
      expect(r12().compareTo(r12()), equals(0));
    });

    test('earlier start gives negative result', () {
      expect(r12().compareTo(r34()), isNegative);
    });

    test('later start gives positive result', () {
      expect(r34().compareTo(r12()), isPositive);
    });

    test('same start, earlier end gives negative result', () {
      final DateTimeRange a = DateTimeRange(t1, t2);
      final DateTimeRange b = DateTimeRange(t1, t3);
      expect(a.compareTo(b), isNegative);
    });

    test('same start, later end gives positive result', () {
      final DateTimeRange a = DateTimeRange(t1, t3);
      final DateTimeRange b = DateTimeRange(t1, t2);
      expect(a.compareTo(b), isPositive);
    });

    test('same start and end returns 0', () {
      expect(r12().compareTo(r12()), equals(0));
    });

    test('compareTo is antisymmetric', () {
      expect(r12().compareTo(r34()).sign, equals(-r34().compareTo(r12()).sign));
    });

    test('compareTo is transitive: r12 < r23 < r34 → r12 < r34', () {
      expect(r12().compareTo(r23()), isNegative);
      expect(r23().compareTo(r34()), isNegative);
      expect(r12().compareTo(r34()), isNegative);
    });
  });

  // -------------------------------------------------------------------------
  // operator <
  // -------------------------------------------------------------------------
  group('DateTimeRange operator <', () {
    test('earlier range is less than later range', () {
      expect(r12() < r34(), isTrue);
    });

    test('later range is not less than earlier range', () {
      expect(r34() < r12(), isFalse);
    });

    test('a range is not less than itself', () {
      final DateTimeRange r = r12();
      expect(r < r, isFalse);
    });

    test('equal distinct ranges: neither is less than the other', () {
      expect(r12() < r12(), isFalse);
    });

    test('same start, shorter range is less than longer', () {
      final DateTimeRange shorter = DateTimeRange(t1, t2);
      final DateTimeRange longer = DateTimeRange(t1, t3);
      expect(shorter < longer, isTrue);
    });
  });

  // -------------------------------------------------------------------------
  // operator <=
  // -------------------------------------------------------------------------
  group('DateTimeRange operator <=', () {
    test('earlier range is <= later range', () {
      expect(r12() <= r34(), isTrue);
    });

    test('later range is not <= earlier range', () {
      expect(r34() <= r12(), isFalse);
    });

    test('a range is <= itself', () {
      final DateTimeRange r = r12();
      expect(r <= r, isTrue);
    });

    test('equal distinct ranges are <= each other', () {
      expect(r12() <= r12(), isTrue);
    });
  });

  // -------------------------------------------------------------------------
  // operator >
  // -------------------------------------------------------------------------
  group('DateTimeRange operator >', () {
    test('later range is > earlier range', () {
      expect(r34() > r12(), isTrue);
    });

    test('earlier range is not > later range', () {
      expect(r12() > r34(), isFalse);
    });

    test('a range is not > itself', () {
      final DateTimeRange r = r12();
      expect(r > r, isFalse);
    });

    test('equal distinct ranges: neither is > the other', () {
      expect(r12() > r12(), isFalse);
    });
  });

  // -------------------------------------------------------------------------
  // operator >=
  // -------------------------------------------------------------------------
  group('DateTimeRange operator >=', () {
    test('later range is >= earlier range', () {
      expect(r34() >= r12(), isTrue);
    });

    test('earlier range is not >= later range', () {
      expect(r12() >= r34(), isFalse);
    });

    test('a range is >= itself', () {
      final DateTimeRange r = r12();
      expect(r >= r, isTrue);
    });

    test('equal distinct ranges are >= each other', () {
      expect(r12() >= r12(), isTrue);
    });

    test('compareTo is consistent with < operator', () {
      final List<DateTimeRange> rs = <DateTimeRange>[r12(), r23(), r34()];
      for (final DateTimeRange a in rs) {
        for (final DateTimeRange b in rs) {
          expect(a < b, equals(a.compareTo(b) < 0));
        }
      }
    });

    test('compareTo is consistent with > operator', () {
      final List<DateTimeRange> rs = <DateTimeRange>[r12(), r23(), r34()];
      for (final DateTimeRange a in rs) {
        for (final DateTimeRange b in rs) {
          expect(a > b, equals(a.compareTo(b) > 0));
        }
      }
    });

    test('compareTo is consistent with <= operator', () {
      final List<DateTimeRange> rs = <DateTimeRange>[r12(), r23(), r34()];
      for (final DateTimeRange a in rs) {
        for (final DateTimeRange b in rs) {
          expect(a <= b, equals(a.compareTo(b) <= 0));
        }
      }
    });

    test('compareTo is consistent with >= operator', () {
      final List<DateTimeRange> rs = <DateTimeRange>[r12(), r23(), r34()];
      for (final DateTimeRange a in rs) {
        for (final DateTimeRange b in rs) {
          expect(a >= b, equals(a.compareTo(b) >= 0));
        }
      }
    });
  });

  // -------------------------------------------------------------------------
  // copyWith
  // -------------------------------------------------------------------------
  group('DateTimeRange.copyWith', () {
    test('no args: produces an equal range', () {
      final DateTimeRange original = r12();
      final DateTimeRange copy = original.copyWith();
      expect(copy, equals(original));
    });

    test('replacing start only', () {
      final DateTimeRange r = DateTimeRange(t1, t3).copyWith(start: t2);
      expect(r.start, equals(t2));
      expect(r.end, equals(t3));
    });

    test('replacing end only', () {
      final DateTimeRange r = DateTimeRange(t1, t2).copyWith(end: t3);
      expect(r.start, equals(t1));
      expect(r.end, equals(t3));
    });

    test('replacing both start and end', () {
      final DateTimeRange r = r12().copyWith(start: t3, end: t4);
      expect(r.start, equals(t3));
      expect(r.end, equals(t4));
    });

    test('swaps if new start > new end', () {
      final DateTimeRange r = r12().copyWith(start: t3, end: t1);
      expect(r.start, equals(t1));
      expect(r.end, equals(t3));
    });

    test('allows setting start to a value after original start', () {
      final DateTimeRange original = DateTimeRange(t1, t4);
      final DateTimeRange r = original.copyWith(start: t2);
      expect(r.start, equals(t2));
      expect(r.end, equals(t4));
    });

    test('produces a distinct object (not identical)', () {
      final DateTimeRange original = r12();
      final DateTimeRange copy = original.copyWith();
      expect(identical(original, copy), isFalse);
    });
  });

  // -------------------------------------------------------------------------
  // endsBeforeOrAtStart
  // -------------------------------------------------------------------------
  group('DateTimeRange.endsBeforeOrAtStart', () {
    test('returns true when end is strictly before other.start', () {
      // r12 ends at t2; r34 starts at t3 > t2
      expect(r12().endsBeforeOrAtStart(r34()), isTrue);
    });

    test('returns true when end equals other.start (touching)', () {
      // r12 ends at t2; r23 starts at t2
      expect(r12().endsBeforeOrAtStart(r23()), isTrue);
    });

    test('returns false when end is after other.start (overlapping)', () {
      // r13 ends at t3; r23 starts at t2 < t3
      expect(r13().endsBeforeOrAtStart(r23()), isFalse);
    });

    test('returns false when ranges are identical', () {
      expect(r12().endsBeforeOrAtStart(r12()), isFalse);
    });

    test('returns false when other is fully within this range', () {
      final DateTimeRange outer = DateTimeRange(t1, t4);
      final DateTimeRange inner = DateTimeRange(t2, t3);
      expect(outer.endsBeforeOrAtStart(inner), isFalse);
    });

    test('returns true for adjacent ranges (gap of one day)', () {
      final DateTime dayAfterT2 = t2.add(const Duration(days: 1));
      final DateTimeRange before = DateTimeRange(t1, t2);
      final DateTimeRange after = DateTimeRange(dayAfterT2, t3);
      expect(before.endsBeforeOrAtStart(after), isTrue);
    });
  });

  // -------------------------------------------------------------------------
  // endsBeforeStart
  // -------------------------------------------------------------------------
  group('DateTimeRange.endsBeforeStart', () {
    test('returns true when end is strictly before other.start', () {
      expect(r12().endsBeforeStart(r34()), isTrue);
    });

    test('returns false when end equals other.start (touching)', () {
      expect(r12().endsBeforeStart(r23()), isFalse);
    });

    test('returns false when ranges overlap', () {
      expect(r13().endsBeforeStart(r23()), isFalse);
    });

    test('returns false when ranges are identical', () {
      expect(r12().endsBeforeStart(r12()), isFalse);
    });

    test('is stricter than endsBeforeOrAtStart at the boundary', () {
      // At the exact touching point:
      expect(r12().endsBeforeOrAtStart(r23()), isTrue);
      expect(r12().endsBeforeStart(r23()), isFalse);
    });
  });

  // -------------------------------------------------------------------------
  // overlapsOrTouches
  // -------------------------------------------------------------------------
  group('DateTimeRange.overlapsOrTouches', () {
    test('returns true for identical ranges', () {
      expect(r12().overlapsOrTouches(r12()), isTrue);
    });

    test('returns true when ranges overlap', () {
      expect(r13().overlapsOrTouches(r23()), isTrue);
    });

    test('returns true when one range contains the other', () {
      final DateTimeRange outer = DateTimeRange(t1, t4);
      final DateTimeRange inner = DateTimeRange(t2, t3);
      expect(outer.overlapsOrTouches(inner), isTrue);
    });

    test('returns true when touching at end of this / start of other', () {
      // r12 ends at t2; r23 starts at t2
      expect(r12().overlapsOrTouches(r23()), isTrue);
    });

    test('returns true when touching at start of this / end of other', () {
      expect(r23().overlapsOrTouches(r12()), isTrue);
    });

    test('returns false when ranges have a gap', () {
      expect(r12().overlapsOrTouches(r34()), isFalse);
    });

    test('returns false for completely disjoint ranges (reversed)', () {
      expect(r34().overlapsOrTouches(r12()), isFalse);
    });

    test('is commutative for overlapping ranges', () {
      expect(
        r13().overlapsOrTouches(r23()),
        equals(r23().overlapsOrTouches(r13())),
      );
    });

    test('is commutative for disjoint ranges', () {
      expect(
        r12().overlapsOrTouches(r34()),
        equals(r34().overlapsOrTouches(r12())),
      );
    });

    test('returns true for a point range touching another', () {
      final DateTimeRange point = DateTimeRange(t2, t2);
      expect(r12().overlapsOrTouches(point), isTrue);
    });

    test('not overlapsOrTouches equals endsBeforeStart or startsAfterEnds', () {
      final List<(DateTimeRange, DateTimeRange)> pairs =
          <(DateTimeRange, DateTimeRange)>[
            (r12(), r23()),
            (r12(), r34()),
            (r13(), r24()),
            (r34(), r12()),
          ];
      for (final (DateTimeRange a, DateTimeRange b) in pairs) {
        expect(
          !a.overlapsOrTouches(b),
          equals(a.endsBeforeStart(b) || a.startsAfterEnds(b)),
        );
      }
    });
  });

  // -------------------------------------------------------------------------
  // startsAfterEnds
  // -------------------------------------------------------------------------
  group('DateTimeRange.startsAfterEnds', () {
    test('returns true when start is strictly after other.end', () {
      // r34 starts at t3; r12 ends at t2 < t3
      expect(r34().startsAfterEnds(r12()), isTrue);
    });

    test('returns false when start equals other.end (touching)', () {
      // r23 starts at t2; r12 ends at t2
      expect(r23().startsAfterEnds(r12()), isFalse);
    });

    test('returns false when ranges overlap', () {
      expect(r23().startsAfterEnds(r13()), isFalse);
    });

    test('returns false for identical ranges', () {
      expect(r12().startsAfterEnds(r12()), isFalse);
    });

    test('is the reverse of endsBeforeStart', () {
      expect(
        r12().endsBeforeStart(r34()),
        equals(r34().startsAfterEnds(r12())),
      );
    });
  });

  // -------------------------------------------------------------------------
  // startsAfterOrAtEnd
  // -------------------------------------------------------------------------
  group('DateTimeRange.startsAfterOrAtEnd', () {
    test('returns true when start is strictly after other.end', () {
      expect(r34().startsAfterOrAtEnd(r12()), isTrue);
    });

    test('returns true when start equals other.end (touching)', () {
      // r23 starts at t2; r12 ends at t2
      expect(r23().startsAfterOrAtEnd(r12()), isTrue);
    });

    test('returns false when ranges overlap', () {
      expect(r23().startsAfterOrAtEnd(r13()), isFalse);
    });

    test('returns false for identical ranges', () {
      expect(r12().startsAfterOrAtEnd(r12()), isFalse);
    });

    test('is the reverse of endsBeforeOrAtStart', () {
      expect(
        r12().endsBeforeOrAtStart(r23()),
        equals(r23().startsAfterOrAtEnd(r12())),
      );
    });

    test('is stricter than startsAfterEnds at the boundary', () {
      expect(r23().startsAfterOrAtEnd(r12()), isTrue);
      expect(r23().startsAfterEnds(r12()), isFalse);
    });
  });

  // -------------------------------------------------------------------------
  // toMap
  // -------------------------------------------------------------------------
  group('DateTimeRange.toMap', () {
    test('contains "start" key with ISO-8601 string', () {
      final Map<String, Object?> map = r12().toMap();
      expect(map['start'], equals(t1.toIso8601String()));
    });

    test('contains "end" key with ISO-8601 string', () {
      final Map<String, Object?> map = r12().toMap();
      expect(map['end'], equals(t2.toIso8601String()));
    });

    test('contains exactly the keys "start" and "end"', () {
      final Map<String, Object?> map = r12().toMap();
      expect(map.keys, containsAll(<String>['start', 'end']));
      expect(map.length, equals(2));
    });

    test('values are Strings', () {
      final Map<String, Object?> map = r12().toMap();
      expect(map['start'], isA<String>());
      expect(map['end'], isA<String>());
    });
  });

  // -------------------------------------------------------------------------
  // toJson
  // -------------------------------------------------------------------------
  group('DateTimeRange.toJson', () {
    test('produces a non-empty JSON string', () {
      expect(r12().toJson(), isNotEmpty);
    });

    test('produces valid JSON (parseable back to a map)', () {
      final String json = r12().toJson();
      expect(() => DateTimeRange.fromJson(json), returnsNormally);
    });

    test('JSON contains the start ISO-8601 string', () {
      expect(r12().toJson(), contains(t1.toIso8601String()));
    });

    test('JSON contains the end ISO-8601 string', () {
      expect(r12().toJson(), contains(t2.toIso8601String()));
    });

    test('JSON contains the key "start"', () {
      expect(r12().toJson(), contains('"start"'));
    });

    test('JSON contains the key "end"', () {
      expect(r12().toJson(), contains('"end"'));
    });
  });

  // -------------------------------------------------------------------------
  // toString
  // -------------------------------------------------------------------------
  group('DateTimeRange.toString', () {
    test('contains a pipe character', () {
      expect(r12().toString(), contains('|'));
    });

    test('starts with start ISO-8601 string', () {
      expect(r12().toString(), startsWith(t1.toIso8601String()));
    });

    test('ends with end ISO-8601 string', () {
      expect(r12().toString(), endsWith(t2.toIso8601String()));
    });

    test('is formatted as "start|end"', () {
      final String expected = '${t1.toIso8601String()}|${t2.toIso8601String()}';
      expect(r12().toString(), equals(expected));
    });

    test('degenerate range formats correctly', () {
      final DateTimeRange r = DateTimeRange(t1, t1);
      final String expected = '${t1.toIso8601String()}|${t1.toIso8601String()}';
      expect(r.toString(), equals(expected));
    });
  });

  // -------------------------------------------------------------------------
  // Round-trip invariants
  // -------------------------------------------------------------------------
  group('DateTimeRange — parse/toString round-trip', () {
    test('toString → parse round-trip is identity', () {
      final DateTimeRange r = r12();
      expect(DateTimeRange.parse(r.toString()), equals(r));
    });

    test('all fixture ranges survive a round-trip', () {
      for (final DateTimeRange r in <DateTimeRange>[
        r12(),
        r23(),
        r34(),
        r45(),
        r13(),
        r24(),
      ]) {
        expect(
          DateTimeRange.parse(r.toString()),
          equals(r),
          reason: 'Round-trip failed for $r',
        );
      }
    });
  });

  group('DateTimeRange — toMap/fromMap round-trip', () {
    test('toMap → fromMap round-trip is identity', () {
      final DateTimeRange r = r12();
      expect(DateTimeRange.fromMap(r.toMap()), equals(r));
    });
  });

  group('DateTimeRange — toJson/fromJson round-trip', () {
    test('toJson → fromJson round-trip is identity', () {
      final DateTimeRange r = r12();
      expect(DateTimeRange.fromJson(r.toJson()), equals(r));
    });
  });

  // -------------------------------------------------------------------------
  // DateTimeRange.areThereOverlaps (static)
  // -------------------------------------------------------------------------
  group('DateTimeRange.areThereOverlaps — empty and singleton sets', () {
    test('returns false for empty set', () {
      expect(
        DateTimeRange.areThereOverlaps(rangeSet(<DateTimeRange>[])),
        isFalse,
      );
    });

    test('returns false for a singleton set', () {
      expect(
        DateTimeRange.areThereOverlaps(rangeSet(<DateTimeRange>[r12()])),
        isFalse,
      );
    });
  });

  group('DateTimeRange.areThereOverlaps — two ranges', () {
    test('returns false for two non-overlapping, non-touching ranges', () {
      expect(
        DateTimeRange.areThereOverlaps(rangeSet(<DateTimeRange>[r12(), r34()])),
        isFalse,
      );
    });

    test('returns true for two overlapping ranges', () {
      expect(
        DateTimeRange.areThereOverlaps(rangeSet(<DateTimeRange>[r13(), r23()])),
        isTrue,
      );
    });

    test('returns true for two touching ranges (start == end of previous)', () {
      // r12 ends at t2; r23 starts at t2 → touching → detected
      expect(
        DateTimeRange.areThereOverlaps(rangeSet(<DateTimeRange>[r12(), r23()])),
        isTrue,
      );
    });

    test('returns true when one range contains the other', () {
      final DateTimeRange outer = DateTimeRange(t1, t4);
      final DateTimeRange inner = DateTimeRange(t2, t3);
      expect(
        DateTimeRange.areThereOverlaps(rangeSet(<DateTimeRange>[outer, inner])),
        isTrue,
      );
    });
  });

  group('DateTimeRange.areThereOverlaps — three or more ranges', () {
    test('returns false for three non-overlapping, non-touching ranges', () {
      final DateTime gap1 = t2.add(const Duration(days: 1));
      final DateTime gap2 = t3.add(const Duration(days: 1));
      final DateTimeRange a = DateTimeRange(t1, t2);
      final DateTimeRange b = DateTimeRange(gap1, t3);
      final DateTimeRange c = DateTimeRange(gap2, t4);
      expect(
        DateTimeRange.areThereOverlaps(rangeSet(<DateTimeRange>[a, b, c])),
        isFalse,
      );
    });

    test('returns true when first two of three overlap', () {
      expect(
        DateTimeRange.areThereOverlaps(
          rangeSet(<DateTimeRange>[r13(), r23(), r45()]),
        ),
        isTrue,
      );
    });

    test('returns true when last two of three overlap', () {
      final DateTime gap = t3.add(const Duration(days: 1));
      final DateTimeRange a = DateTimeRange(t1, t2);
      expect(
        DateTimeRange.areThereOverlaps(
          rangeSet(<DateTimeRange>[a, r34(), DateTimeRange(gap, t5)]),
        ),
        isTrue,
      );
    });
  });

  // -------------------------------------------------------------------------
  // DateTimeRange.join (static)
  // -------------------------------------------------------------------------
  group('DateTimeRange.join — overlapping ranges', () {
    test('returns a singleton set for overlapping ranges', () {
      final SplayTreeSet<DateTimeRange> result = DateTimeRange.join(
        r13(),
        r23(),
      );
      expect(result, hasLength(1));
    });

    test('merged range spans from earliest start to latest end', () {
      final SplayTreeSet<DateTimeRange> result = DateTimeRange.join(
        r13(),
        r24(),
      );
      final DateTimeRange merged = result.first;
      expect(merged.start, equals(t1));
      expect(merged.end, equals(t4));
    });

    test('is commutative for overlapping ranges', () {
      final SplayTreeSet<DateTimeRange> ab = DateTimeRange.join(r13(), r24());
      final SplayTreeSet<DateTimeRange> ba = DateTimeRange.join(r24(), r13());
      expect(ab.first, equals(ba.first));
    });
  });

  group('DateTimeRange.join — touching ranges', () {
    test('returns a singleton set for touching ranges', () {
      // r12 ends at t2; r23 starts at t2 → touching
      final SplayTreeSet<DateTimeRange> result = DateTimeRange.join(
        r12(),
        r23(),
      );
      expect(result, hasLength(1));
    });

    test('merged touching range spans from t1 to t3', () {
      final SplayTreeSet<DateTimeRange> result = DateTimeRange.join(
        r12(),
        r23(),
      );
      expect(result.first.start, equals(t1));
      expect(result.first.end, equals(t3));
    });
  });

  group('DateTimeRange.join — non-overlapping ranges', () {
    test('returns a set of two for non-overlapping, non-touching ranges', () {
      final SplayTreeSet<DateTimeRange> result = DateTimeRange.join(
        r12(),
        r34(),
      );
      expect(result, hasLength(2));
    });

    test('returned set contains both original ranges', () {
      final SplayTreeSet<DateTimeRange> result = DateTimeRange.join(
        r12(),
        r34(),
      );
      expect(result, containsAll(<DateTimeRange>[r12(), r34()]));
    });

    test('is commutative for non-overlapping ranges', () {
      expect(
        DateTimeRange.join(r12(), r34()),
        equals(DateTimeRange.join(r34(), r12())),
      );
    });
  });

  group('DateTimeRange.join — identical ranges', () {
    test('joining a range with itself returns a singleton', () {
      final SplayTreeSet<DateTimeRange> result = DateTimeRange.join(
        r12(),
        r12(),
      );
      expect(result, hasLength(1));
    });

    test('the merged range equals the original', () {
      final SplayTreeSet<DateTimeRange> result = DateTimeRange.join(
        r12(),
        r12(),
      );
      expect(result.first, equals(r12()));
    });
  });

  // -------------------------------------------------------------------------
  // DateTimeRange.merge (static)
  // -------------------------------------------------------------------------
  group('DateTimeRange.merge — empty input', () {
    test('returns empty set for empty iterable', () {
      expect(DateTimeRange.merge(<DateTimeRange>[]), isEmpty);
    });
  });

  group('DateTimeRange.merge — single range', () {
    test('returns a singleton set', () {
      expect(DateTimeRange.merge(<DateTimeRange>[r12()]), hasLength(1));
    });

    test('returned range equals the original', () {
      expect(DateTimeRange.merge(<DateTimeRange>[r12()]).first, equals(r12()));
    });
  });

  group('DateTimeRange.merge — two overlapping ranges', () {
    test('returns a singleton set', () {
      expect(DateTimeRange.merge(<DateTimeRange>[r13(), r23()]), hasLength(1));
    });

    test('merged range spans entire extent', () {
      final DateTimeRange merged = DateTimeRange.merge(<DateTimeRange>[
        r13(),
        r24(),
      ]).first;
      expect(merged.start, equals(t1));
      expect(merged.end, equals(t4));
    });
  });

  group('DateTimeRange.merge — two touching ranges', () {
    test('returns a singleton set', () {
      expect(DateTimeRange.merge(<DateTimeRange>[r12(), r23()]), hasLength(1));
    });

    test('merged range spans from t1 to t3', () {
      final DateTimeRange merged = DateTimeRange.merge(<DateTimeRange>[
        r12(),
        r23(),
      ]).first;
      expect(merged.start, equals(t1));
      expect(merged.end, equals(t3));
    });
  });

  group('DateTimeRange.merge — two non-overlapping ranges', () {
    test('returns a set of two', () {
      expect(DateTimeRange.merge(<DateTimeRange>[r12(), r34()]), hasLength(2));
    });

    test('both original ranges are preserved', () {
      final SplayTreeSet<DateTimeRange> result = DateTimeRange.merge(
        <DateTimeRange>[r12(), r34()],
      );
      expect(result, containsAll(<DateTimeRange>[r12(), r34()]));
    });
  });

  group('DateTimeRange.merge — three ranges', () {
    test('merges all three overlapping into one', () {
      final DateTimeRange a = DateTimeRange(t1, t3);
      final DateTimeRange b = DateTimeRange(t2, t4);
      final DateTimeRange c = DateTimeRange(t3, t5);
      expect(DateTimeRange.merge(<DateTimeRange>[a, b, c]), hasLength(1));
    });

    test('merged span is correct for three overlapping ranges', () {
      final DateTimeRange a = DateTimeRange(t1, t3);
      final DateTimeRange b = DateTimeRange(t2, t4);
      final DateTimeRange c = DateTimeRange(t3, t5);
      final DateTimeRange merged = DateTimeRange.merge(<DateTimeRange>[
        a,
        b,
        c,
      ]).first;
      expect(merged.start, equals(t1));
      expect(merged.end, equals(t5));
    });

    test('first two merge but third is separate', () {
      final DateTime gap = t3.add(const Duration(days: 1));
      final DateTimeRange c = DateTimeRange(gap, t5);
      expect(
        DateTimeRange.merge(<DateTimeRange>[r13(), r23(), c]),
        hasLength(2),
      );
    });

    test('result is sorted (earlier start first)', () {
      final DateTime gap = t3.add(const Duration(days: 1));
      final DateTimeRange c = DateTimeRange(gap, t5);
      final List<DateTimeRange> result = DateTimeRange.merge(<DateTimeRange>[
        r13(),
        r23(),
        c,
      ]).toList();
      expect(result[0].start, equals(t1));
      expect(result[1].start, equals(gap));
    });
  });

  group('DateTimeRange.merge — input order does not matter', () {
    test('same result regardless of input order', () {
      final List<DateTimeRange> rs = <DateTimeRange>[r12(), r23(), r34()];
      final SplayTreeSet<DateTimeRange> forward = DateTimeRange.merge(rs);
      final SplayTreeSet<DateTimeRange> reversed = DateTimeRange.merge(
        rs.reversed,
      );
      expect(forward.toList(), equals(reversed.toList()));
    });
  });

  group('DateTimeRange.merge — result has no overlaps', () {
    test('areThereOverlaps returns false on any merge result', () {
      final List<DateTimeRange> inputs = <DateTimeRange>[
        r12(),
        r23(),
        r34(),
        r45(),
      ];
      final SplayTreeSet<DateTimeRange> result = DateTimeRange.merge(inputs);
      expect(DateTimeRange.areThereOverlaps(result), isFalse);
    });

    test('duplicate ranges in input collapse to one', () {
      expect(
        DateTimeRange.merge(<DateTimeRange>[r12(), r12(), r12()]),
        hasLength(1),
      );
    });
  });
}

/// UTC points used across tests.
final DateTime t1 = DateTime.utc(2020);
final DateTime t2 = DateTime.utc(2020, 6);
final DateTime t3 = DateTime.utc(2020, 12, 31);
final DateTime t4 = DateTime.utc(2021, 6);

final DateTime t5 = DateTime.utc(2021, 12, 31);

/// A range [t1, t2].
DateTimeRange r12() => DateTimeRange(t1, t2);

/// A range [t1, t3].
DateTimeRange r13() => DateTimeRange(t1, t3);

/// A range [t2, t3].
DateTimeRange r23() => DateTimeRange(t2, t3);

/// A range [t2, t4].
DateTimeRange r24() => DateTimeRange(t2, t4);

/// A range [t3, t4].
DateTimeRange r34() => DateTimeRange(t3, t4);

/// A range [t4, t5].
DateTimeRange r45() => DateTimeRange(t4, t5);

/// Creates a [SplayTreeSet<DateTimeRange>] from [ranges].
SplayTreeSet<DateTimeRange> rangeSet(final Iterable<DateTimeRange> ranges) =>
    SplayTreeSet<DateTimeRange>.from(ranges);
