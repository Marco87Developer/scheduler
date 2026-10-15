import 'dart:collection';

import 'package:checks/checks.dart';
import 'package:scheduler/src/exceptions/exception_messages.dart';
import 'package:scheduler/src/models/date_time_range.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('DateTimeRange.className', () {
    test('is "DateTimeRange"', () {
      check(DateTimeRange.className).equals('DateTimeRange');
    });
  });

  group('DateTimeRange() — field assignment', () {
    test('dt1 < dt2: start = dt1, end = dt2', () {
      final r = DateTimeRange(t1, t3);
      check(r.start).equals(t1);
      check(r.end).equals(t3);
    });

    test('dt1 > dt2: start = dt2, end = dt1 (swapped)', () {
      final r = DateTimeRange(t3, t1);
      check(r.start).equals(t1);
      check(r.end).equals(t3);
    });

    test('dt1 == dt2: start == end (degenerate range)', () {
      final r = DateTimeRange(t1, t1);
      check(r.start).equals(t1);
      check(r.end).equals(t1);
    });

    test('swapped and non-swapped arguments produce equal ranges', () {
      check(DateTimeRange(t1, t3)).equals(DateTimeRange(t3, t1));
    });

    test('works with local DateTimes', () {
      final a = DateTime(2020);
      final b = DateTime(2020, 6);
      final r = DateTimeRange(b, a);
      check(r.start).equals(a);
      check(r.end).equals(b);
    });

    test('works with a mix of UTC and local DateTimes', () {
      final DateTime local = asLocal(t3);
      final r = DateTimeRange(local, t1);
      check(r.start.isAtSameMomentAs(t1)).isTrue();
      check(r.end.isAtSameMomentAs(t3)).isTrue();
    });

    test('works with millisecond precision', () {
      final a = DateTime.utc(2020);
      final b = DateTime.utc(2020, 1, 1, 0, 0, 0, 1);
      final r = DateTimeRange(b, a);
      check(r.start).equals(a);
      check(r.end).equals(b);
    });

    test('works with microsecond precision', () {
      final a = DateTime.utc(2020);
      final b = DateTime.utc(2020, 1, 1, 0, 0, 0, 0, 1);
      final r = DateTimeRange(b, a);
      check(r.start).equals(a);
      check(r.end).equals(b);
    });

    test('start is never after end for any argument order', () {
      for (final (DateTime a, DateTime b) in <(DateTime, DateTime)>[
        (t1, t2),
        (t2, t1),
        (t1, t1),
        (t3, t1),
        (t5, t4),
      ]) {
        final r = DateTimeRange(a, b);
        check(r.start.isAfter(r.end)).isFalse();
      }
    });

    test('keeps the given DateTime instances (no copies)', () {
      final r = DateTimeRange(t1, t2);
      check(r.start).identicalTo(t1);
      check(r.end).identicalTo(t2);
    });
  });

  group('DateTimeRange.fromMap — valid input', () {
    test('creates a range from a valid map', () {
      final r = DateTimeRange.fromMap(<String, Object?>{
        'start': t1.toIso8601String(),
        'end': t3.toIso8601String(),
      });
      check(r.start).equals(t1);
      check(r.end).equals(t3);
    });

    test('swaps start and end when start is after end', () {
      final r = DateTimeRange.fromMap(<String, Object?>{
        'start': t3.toIso8601String(),
        'end': t1.toIso8601String(),
      });
      check(r.start).equals(t1);
      check(r.end).equals(t3);
    });

    test('handles equal start and end (degenerate range)', () {
      final r = DateTimeRange.fromMap(<String, Object?>{
        'start': t1.toIso8601String(),
        'end': t1.toIso8601String(),
      });
      check(r.start).equals(t1);
      check(r.end).equals(t1);
    });

    test('ignores unknown extra keys', () {
      final r = DateTimeRange.fromMap(<String, Object?>{
        'start': t1.toIso8601String(),
        'end': t3.toIso8601String(),
        'extra': 42,
      });
      check(r).equals(DateTimeRange(t1, t3));
    });

    test('accepts a date with a UTC offset', () {
      final r = DateTimeRange.fromMap(const <String, Object?>{
        'start': '2020-01-01T02:00:00+02:00',
        'end': '2020-01-01T10:00:00+02:00',
      });
      check(r.start.isAtSameMomentAs(t1)).isTrue();
      check(r.end.isAtSameMomentAs(DateTime.utc(2020, 1, 1, 8))).isTrue();
    });
  });

  group('DateTimeRange.fromMap — invalid input', () {
    test('throws FormatException when "start" key is missing', () {
      check(
        () => DateTimeRange.fromMap(<String, Object?>{
          'end': t3.toIso8601String(),
        }),
      ).throws<FormatException>();
    });

    test('throws FormatException when "end" key is missing', () {
      check(
        () => DateTimeRange.fromMap(<String, Object?>{
          'start': t1.toIso8601String(),
        }),
      ).throws<FormatException>();
    });

    test('throws FormatException when "start" value is null', () {
      check(
        () => DateTimeRange.fromMap(<String, Object?>{
          'start': null,
          'end': t3.toIso8601String(),
        }),
      ).throws<FormatException>();
    });

    test('throws FormatException when "end" value is null', () {
      check(
        () => DateTimeRange.fromMap(<String, Object?>{
          'start': t1.toIso8601String(),
          'end': null,
        }),
      ).throws<FormatException>();
    });

    test('throws FormatException when "start" is not a String', () {
      check(
        () => DateTimeRange.fromMap(<String, Object?>{
          'start': 12345,
          'end': t3.toIso8601String(),
        }),
      ).throws<FormatException>();
    });

    test('throws FormatException when "end" is not a String', () {
      check(
        () => DateTimeRange.fromMap(<String, Object?>{
          'start': t1.toIso8601String(),
          'end': 12345,
        }),
      ).throws<FormatException>();
    });

    test('throws FormatException when "start" is an invalid date', () {
      check(
        () => DateTimeRange.fromMap(<String, Object?>{
          'start': 'not-a-date',
          'end': t3.toIso8601String(),
        }),
      ).throws<FormatException>();
    });

    test('throws FormatException when "end" is an invalid date', () {
      check(
        () => DateTimeRange.fromMap(<String, Object?>{
          'start': t1.toIso8601String(),
          'end': 'not-a-date',
        }),
      ).throws<FormatException>();
    });

    test('throws FormatException when the map is empty', () {
      check(() => DateTimeRange.fromMap(const <String, Object?>{}))
          .throws<FormatException>();
    });

    test('message names the "start" key when it is missing', () {
      check(
            () => DateTimeRange.fromMap(<String, Object?>{
              'end': t3.toIso8601String(),
            }),
          )
          .throws<FormatException>()
          .has((e) => e.message, 'message')
          .equals(
            fromMapFormatExceptionMessage(DateTimeRange.className, 'start'),
          );
    });

    test('message names the "end" key when it is missing', () {
      check(
            () => DateTimeRange.fromMap(<String, Object?>{
              'start': t1.toIso8601String(),
            }),
          )
          .throws<FormatException>()
          .has((e) => e.message, 'message')
          .equals(
            fromMapFormatExceptionMessage(DateTimeRange.className, 'end'),
          );
    });

    test('source is the map when a key is missing', () {
      final map = <String, Object?>{'end': t3.toIso8601String()};
      check(() => DateTimeRange.fromMap(map))
          .throws<FormatException>()
          .has((e) => e.source, 'source')
          .equals(map);
    });
  });

  group('DateTimeRange.fromJson — valid input', () {
    test('creates a range from valid JSON', () {
      final json =
          '{"start":"${t1.toIso8601String()}",'
          '"end":"${t3.toIso8601String()}"}';
      final r = DateTimeRange.fromJson(json);
      check(r.start).equals(t1);
      check(r.end).equals(t3);
    });

    test('swaps dates when start is after end', () {
      final json =
          '{"start":"${t3.toIso8601String()}",'
          '"end":"${t1.toIso8601String()}"}';
      final r = DateTimeRange.fromJson(json);
      check(r.start).equals(t1);
      check(r.end).equals(t3);
    });

    test('handles equal start and end', () {
      final json =
          '{"start":"${t1.toIso8601String()}",'
          '"end":"${t1.toIso8601String()}"}';
      final r = DateTimeRange.fromJson(json);
      check(r.start).equals(t1);
      check(r.end).equals(t1);
    });

    test('ignores whitespace and key order', () {
      final json =
          ' { "end" : "${t3.toIso8601String()}" ,\n'
          '"start":"${t1.toIso8601String()}" } ';
      check(DateTimeRange.fromJson(json)).equals(DateTimeRange(t1, t3));
    });
  });

  group('DateTimeRange.fromJson — invalid JSON syntax', () {
    test('throws FormatException for non-JSON input', () {
      check(() => DateTimeRange.fromJson('not json')).throws<FormatException>();
    });

    test('throws FormatException for an empty string', () {
      check(() => DateTimeRange.fromJson('')).throws<FormatException>();
    });

    test('throws FormatException for partial JSON', () {
      check(() => DateTimeRange.fromJson('{')).throws<FormatException>();
    });
  });

  group('DateTimeRange.fromJson — wrong JSON structure', () {
    test('throws FormatException when JSON is a string', () {
      check(() => DateTimeRange.fromJson('"hello"')).throws<FormatException>();
    });

    test('throws FormatException when JSON is a number', () {
      check(() => DateTimeRange.fromJson('42')).throws<FormatException>();
    });

    test('throws FormatException when JSON is an array', () {
      check(() => DateTimeRange.fromJson('[]')).throws<FormatException>();
    });

    test('throws FormatException when JSON is null', () {
      check(() => DateTimeRange.fromJson('null')).throws<FormatException>();
    });

    test('throws FormatException when JSON is a boolean', () {
      check(() => DateTimeRange.fromJson('true')).throws<FormatException>();
    });

    test('throws FormatException when the object is empty', () {
      check(() => DateTimeRange.fromJson('{}')).throws<FormatException>();
    });

    test('throws FormatException when "start" key is missing', () {
      final json = '{"end":"${t3.toIso8601String()}"}';
      check(() => DateTimeRange.fromJson(json)).throws<FormatException>();
    });

    test('throws FormatException when "end" key is missing', () {
      final json = '{"start":"${t1.toIso8601String()}"}';
      check(() => DateTimeRange.fromJson(json)).throws<FormatException>();
    });

    test('throws FormatException when a value is not a string', () {
      final json = '{"start":1,"end":"${t3.toIso8601String()}"}';
      check(() => DateTimeRange.fromJson(json)).throws<FormatException>();
    });

    test('throws FormatException when "start" is not a valid date', () {
      final json = '{"start":"bad","end":"${t3.toIso8601String()}"}';
      check(() => DateTimeRange.fromJson(json)).throws<FormatException>();
    });

    test('message is the fromJson message for malformed JSON', () {
      const json = 'not json';
      check(() => DateTimeRange.fromJson(json))
          .throws<FormatException>()
          .has((e) => e.message, 'message')
          .equals(
            fromJsonFormatExceptionMessage(DateTimeRange.className, json),
          );
    });

    test('message is the fromJson message for a non-object', () {
      const json = '[1,2]';
      check(() => DateTimeRange.fromJson(json))
          .throws<FormatException>()
          .has((e) => e.message, 'message')
          .equals(
            fromJsonFormatExceptionMessage(DateTimeRange.className, json),
          );
    });

    test('message is the fromJson message when the map is invalid', () {
      const json = '{"start":"bad","end":"also-bad"}';
      check(() => DateTimeRange.fromJson(json))
          .throws<FormatException>()
          .has((e) => e.message, 'message')
          .equals(
            fromJsonFormatExceptionMessage(DateTimeRange.className, json),
          );
    });

    test('message contains "DateTimeRange" and ".fromJson"', () {
      check(() => DateTimeRange.fromJson('null'))
          .throws<FormatException>()
          .has((e) => e.message, 'message')
        ..contains('DateTimeRange')
        ..contains('.fromJson');
    });

    test('source is the original JSON string for malformed JSON', () {
      const json = '{not json';
      check(() => DateTimeRange.fromJson(json))
          .throws<FormatException>()
          .has((e) => e.source, 'source')
          .equals(json);
    });

    test('source is the original JSON string for a non-object', () {
      const json = 'null';
      check(() => DateTimeRange.fromJson(json))
          .throws<FormatException>()
          .has((e) => e.source, 'source')
          .equals(json);
    });

    test('source is the original JSON string when the map is invalid', () {
      const json = '{"start":"bad","end":"also-bad"}';
      check(() => DateTimeRange.fromJson(json))
          .throws<FormatException>()
          .has((e) => e.source, 'source')
          .equals(json);
    });
  });

  group('DateTimeRange.parse — valid input', () {
    test('parses a valid pipe-delimited string', () {
      final r = DateTimeRange(t1, t3);
      check(DateTimeRange.parse(r.toString())).equals(r);
    });

    test('produces the correct start and end', () {
      final r = DateTimeRange.parse(
        '${t1.toIso8601String()}|${t3.toIso8601String()}',
      );
      check(r.start).equals(t1);
      check(r.end).equals(t3);
    });

    test('swaps when start > end in the string', () {
      final r = DateTimeRange.parse(
        '${t3.toIso8601String()}|${t1.toIso8601String()}',
      );
      check(r.start).equals(t1);
      check(r.end).equals(t3);
    });

    test('handles equal start and end', () {
      final r = DateTimeRange.parse(
        '${t1.toIso8601String()}|${t1.toIso8601String()}',
      );
      check(r.start).equals(t1);
      check(r.end).equals(t1);
    });

    test('trims whitespace around the whole string', () {
      final r = DateTimeRange.parse(
        '  ${t1.toIso8601String()}|${t3.toIso8601String()}\n ',
      );
      check(r.start).equals(t1);
      check(r.end).equals(t3);
    });
  });

  group('DateTimeRange.parse — invalid input', () {
    test('throws FormatException for an empty string', () {
      check(() => DateTimeRange.parse('')).throws<FormatException>();
    });

    test('throws FormatException for a string without a pipe', () {
      check(() => DateTimeRange.parse(t1.toIso8601String()))
          .throws<FormatException>();
    });

    test('throws FormatException for a string with two pipes', () {
      final s =
          '${t1.toIso8601String()}|${t2.toIso8601String()}'
          '|${t3.toIso8601String()}';
      check(() => DateTimeRange.parse(s)).throws<FormatException>();
    });

    test('throws FormatException when start is not a valid date', () {
      check(() => DateTimeRange.parse('not-a-date|${t3.toIso8601String()}'))
          .throws<FormatException>();
    });

    test('throws FormatException when end is not a valid date', () {
      check(() => DateTimeRange.parse('${t1.toIso8601String()}|not-a-date'))
          .throws<FormatException>();
    });

    test('throws FormatException for a pipe-only string', () {
      check(() => DateTimeRange.parse('|')).throws<FormatException>();
    });

    test('throws FormatException when a part is empty', () {
      check(() => DateTimeRange.parse('${t1.toIso8601String()}|'))
          .throws<FormatException>();
    });

    test('throws FormatException when spaces surround the pipe', () {
      final s = '${t1.toIso8601String()} | ${t3.toIso8601String()}';
      check(() => DateTimeRange.parse(s)).throws<FormatException>();
    });

    test('message is the parse message', () {
      const input = 'bad|input';
      check(() => DateTimeRange.parse(input))
          .throws<FormatException>()
          .has((e) => e.message, 'message')
          .equals(parseFormatExceptionMessage(DateTimeRange.className, input));
    });

    test('message contains "DateTimeRange", ".parse" and the input', () {
      check(() => DateTimeRange.parse('bad|input'))
          .throws<FormatException>()
          .has((e) => e.message, 'message')
        ..contains('DateTimeRange')
        ..contains('.parse')
        ..contains('bad|input');
    });

    test('source is the original string', () {
      const input = 'bad|input';
      check(() => DateTimeRange.parse(input))
          .throws<FormatException>()
          .has((e) => e.source, 'source')
          .equals(input);
    });

    test('source preserves surrounding whitespace', () {
      const input = '  bad  ';
      check(() => DateTimeRange.parse(input))
          .throws<FormatException>()
          .has((e) => e.source, 'source')
          .equals(input);
    });
  });

  group('DateTimeRange.tryParse — valid input', () {
    test('returns a range for a valid string', () {
      final DateTimeRange? r = DateTimeRange.tryParse(
        '${t1.toIso8601String()}|${t3.toIso8601String()}',
      );
      check(r).isNotNull().equals(DateTimeRange(t1, t3));
    });

    test('swaps when start > end', () {
      final DateTimeRange? r = DateTimeRange.tryParse(
        '${t3.toIso8601String()}|${t1.toIso8601String()}',
      );
      check(r).isNotNull()
        ..has((r) => r.start, 'start').equals(t1)
        ..has((r) => r.end, 'end').equals(t3);
    });

    test('handles equal start and end', () {
      final DateTimeRange? r = DateTimeRange.tryParse(
        '${t1.toIso8601String()}|${t1.toIso8601String()}',
      );
      check(r).isNotNull().equals(DateTimeRange(t1, t1));
    });

    test('trims whitespace and newlines around the whole string', () {
      final DateTimeRange? r = DateTimeRange.tryParse(
        ' \n${t1.toIso8601String()}|${t3.toIso8601String()} \t',
      );
      check(r).isNotNull().equals(DateTimeRange(t1, t3));
    });

    test('accepts date-only strings', () {
      final DateTimeRange? r = DateTimeRange.tryParse('2020-01-01|2020-12-31');
      check(r).isNotNull()
        ..has((r) => r.start, 'start').equals(DateTime(2020))
        ..has((r) => r.end, 'end').equals(DateTime(2020, 12, 31));
    });

    test('accepts dates with a UTC offset', () {
      final DateTimeRange? r = DateTimeRange.tryParse(
        '2020-01-01T02:00:00+02:00|2020-01-01T10:00:00+02:00',
      );
      check(r).isNotNull()
        ..has((r) => r.start.isAtSameMomentAs(t1), 'start').isTrue()
        ..has(
          (r) => r.end.isAtSameMomentAs(DateTime.utc(2020, 1, 1, 8)),
          'end',
        ).isTrue();
    });
  });

  group('DateTimeRange.tryParse — invalid input returns null', () {
    test('returns null for an empty string', () {
      check(DateTimeRange.tryParse('')).isNull();
    });

    test('returns null for a whitespace-only string', () {
      check(DateTimeRange.tryParse('  \n\t ')).isNull();
    });

    test('returns null for a string without a pipe', () {
      check(DateTimeRange.tryParse(t1.toIso8601String())).isNull();
    });

    test('returns null for a string with two pipes', () {
      final s =
          '${t1.toIso8601String()}|${t2.toIso8601String()}'
          '|${t3.toIso8601String()}';
      check(DateTimeRange.tryParse(s)).isNull();
    });

    test('returns null for a pipe-only string', () {
      check(DateTimeRange.tryParse('|')).isNull();
    });

    test('returns null when start is invalid', () {
      check(DateTimeRange.tryParse('bad|${t3.toIso8601String()}')).isNull();
    });

    test('returns null when end is invalid', () {
      check(DateTimeRange.tryParse('${t1.toIso8601String()}|bad')).isNull();
    });

    test('returns null when both dates are invalid', () {
      check(DateTimeRange.tryParse('bad|worse')).isNull();
    });

    test('returns null when a part is empty', () {
      check(DateTimeRange.tryParse('${t1.toIso8601String()}|')).isNull();
      check(DateTimeRange.tryParse('|${t1.toIso8601String()}')).isNull();
    });

    test('returns null when spaces surround the pipe', () {
      final s = '${t1.toIso8601String()} | ${t3.toIso8601String()}';
      check(DateTimeRange.tryParse(s)).isNull();
    });

    test('never throws for awkward input', () {
      for (final s in <String>[
        '',
        ' ',
        '|',
        '||',
        '\u0000',
        '\u{1F600}',
        'a|' * 1000,
      ]) {
        check(() => DateTimeRange.tryParse(s)).returnsNormally();
      }
    });
  });

  group('DateTimeRange.tryParse — consistency with parse', () {
    test('equals parse for valid inputs', () {
      for (final r in <DateTimeRange>[r12(), r23(), r45()]) {
        check(DateTimeRange.tryParse(r.toString()))
            .isNotNull()
            .equals(DateTimeRange.parse(r.toString()));
      }
    });

    test('returns null exactly where parse throws FormatException', () {
      for (final s in <String>['', '|', 'bad', 'bad|bad', 'a|b|c']) {
        check(DateTimeRange.tryParse(s)).isNull();
        check(() => DateTimeRange.parse(s)).throws<FormatException>();
      }
    });
  });

  group('DateTimeRange.duration', () {
    test('is the difference between end and start', () {
      final r = DateTimeRange(DateTime.utc(2020), DateTime.utc(2020, 1, 2, 3));
      check(r.duration).equals(const Duration(days: 1, hours: 3));
    });

    test('is zero for an instant', () {
      check(DateTimeRange(t1, t1).duration).equals(Duration.zero);
    });

    test('does not depend on the argument order', () {
      check(DateTimeRange(t3, t1).duration)
          .equals(DateTimeRange(t1, t3).duration);
    });

    test('is never negative', () {
      check(DateTimeRange(t3, t1).duration.isNegative).isFalse();
    });

    test('has microsecond precision', () {
      final r = DateTimeRange(
        DateTime.utc(2020),
        DateTime.utc(2020, 1, 1, 0, 0, 0, 0, 1),
      );
      check(r.duration).equals(const Duration(microseconds: 1));
    });

    test('works across a mix of UTC and local DateTimes', () {
      final r = DateTimeRange(t1, asLocal(t2));
      check(r.duration).equals(t2.difference(t1));
    });
  });

  group('DateTimeRange.isInstant', () {
    test('is true when start equals end', () {
      check(DateTimeRange(t1, t1).isInstant).isTrue();
    });

    test('is false when start differs from end', () {
      check(r12().isInstant).isFalse();
    });

    test('is false for a one-microsecond range', () {
      final r = DateTimeRange(
        DateTime.utc(2020),
        DateTime.utc(2020, 1, 1, 0, 0, 0, 0, 1),
      );
      check(r.isInstant).isFalse();
    });

    test('is true for UTC and local DateTimes of the same moment', () {
      check(DateTimeRange(t1, asLocal(t1)).isInstant).isTrue();
    });
  });

  group('DateTimeRange.hashCode', () {
    test('equal objects have the same hashCode', () {
      check(r12().hashCode).equals(r12().hashCode);
    });

    test('identical objects have the same hashCode', () {
      final DateTimeRange r = r12();
      check(r.hashCode).equals(r.hashCode);
    });

    test('swapped-argument ranges have the same hashCode', () {
      check(DateTimeRange(t1, t3).hashCode)
          .equals(DateTimeRange(t3, t1).hashCode);
    });

    test('UTC and local DateTimes of the same moments hash equally', () {
      final utc = DateTimeRange(t1, t3);
      final local = DateTimeRange(asLocal(t1), asLocal(t3));
      check(utc == local).isTrue();
      check(utc.hashCode).equals(local.hashCode);
    });

    test('distinct ranges have different hashCodes', () {
      check(r12().hashCode).not((it) => it.equals(r34().hashCode));
    });

    test('ranges differing only by end have different hashCodes', () {
      check(DateTimeRange(t1, t2).hashCode)
          .not((it) => it.equals(DateTimeRange(t1, t3).hashCode));
    });

    test('ranges differing only by start have different hashCodes', () {
      check(DateTimeRange(t1, t3).hashCode)
          .not((it) => it.equals(DateTimeRange(t2, t3).hashCode));
    });

    test('is consistent with == inside a Set', () {
      final set = <DateTimeRange>{r12(), r12(), DateTimeRange(t2, t1), r23()};
      check(set.length).equals(2);
    });

    test('is usable as a Map key', () {
      final map = <DateTimeRange, String>{r12(): 'a'};
      check(map[DateTimeRange(t2, t1)]).equals('a');
    });
  });

  group('DateTimeRange operator ==', () {
    test('a range equals itself', () {
      final DateTimeRange r = r12();
      check(r == r).isTrue();
    });

    test('two ranges with the same start and end are equal', () {
      check(r12() == r12()).isTrue();
    });

    test('swapped-argument ranges are equal', () {
      check(DateTimeRange(t1, t3) == DateTimeRange(t3, t1)).isTrue();
    });

    test('ranges with different start are not equal', () {
      check(DateTimeRange(t1, t3) == DateTimeRange(t2, t3)).isFalse();
    });

    test('ranges with different end are not equal', () {
      check(DateTimeRange(t1, t2) == DateTimeRange(t1, t3)).isFalse();
    });

    test('completely different ranges are not equal', () {
      check(r12() == r34()).isFalse();
    });

    test('UTC and local DateTimes of the same moments are equal', () {
      check(DateTimeRange(t1, t3) == DateTimeRange(asLocal(t1), asLocal(t3)))
          .isTrue();
    });

    test('ranges one microsecond apart are not equal', () {
      final a = DateTime.utc(2020);
      final b = DateTime.utc(2020, 1, 1, 0, 0, 0, 0, 1);
      check(DateTimeRange(t1, a) == DateTimeRange(t1, b)).isFalse();
    });

    test('is symmetric', () {
      check((r12() == r23()) == (r23() == r12())).isTrue();
    });

    test('is not equal to an object of another type', () {
      // ignore: unrelated_type_equality_checks
      check(r12() == 'not a range').isFalse();
    });

    test('is not equal to null', () {
      // ignore: unnecessary_null_comparison
      check(r12() == null).isFalse();
    });
  });

  group('DateTimeRange.compareTo', () {
    test('the same instance returns 0', () {
      final DateTimeRange r = r12();
      check(r.compareTo(r)).equals(0);
    });

    test('equal but distinct ranges return 0', () {
      check(r12().compareTo(r12())).equals(0);
    });

    test('earlier start gives a negative result', () {
      check(r12().compareTo(r34())).isNegative();
    });

    test('later start gives a positive result', () {
      check(r34().compareTo(r12())).isGreaterThan(0);
    });

    test('same start, earlier end gives a negative result', () {
      check(DateTimeRange(t1, t2).compareTo(DateTimeRange(t1, t3)))
          .isNegative();
    });

    test('same start, later end gives a positive result', () {
      check(DateTimeRange(t1, t3).compareTo(DateTimeRange(t1, t2)))
          .isGreaterThan(0);
    });

    test('start takes precedence over end', () {
      // r13 starts earlier than r24 although it ends earlier too, and r14
      // starts earlier than r23 although it ends later.
      check(r14().compareTo(r23())).isNegative();
    });

    test('is antisymmetric', () {
      check(r12().compareTo(r34()).sign).equals(-r34().compareTo(r12()).sign);
    });

    test('is transitive: r12 < r23 < r34 implies r12 < r34', () {
      check(r12().compareTo(r23())).isNegative();
      check(r23().compareTo(r34())).isNegative();
      check(r12().compareTo(r34())).isNegative();
    });

    test('compares UTC and local DateTimes by moment', () {
      final local = DateTimeRange(asLocal(t1), asLocal(t3));
      check(DateTimeRange(t1, t3).compareTo(local)).equals(0);
    });

    test('sorts a list in ascending order', () {
      final sorted = <DateTimeRange>[r45(), r13(), r34(), r12(), r23()]
        ..sort((a, b) => a.compareTo(b));
      check(sorted)
          .deepEquals(<DateTimeRange>[r12(), r13(), r23(), r34(), r45()]);
    });
  });

  group('DateTimeRange operator <', () {
    test('an earlier range is less than a later range', () {
      check(r12() < r34()).isTrue();
    });

    test('a later range is not less than an earlier range', () {
      check(r34() < r12()).isFalse();
    });

    test('a range is not less than itself', () {
      final DateTimeRange r = r12();
      check(r < r).isFalse();
    });

    test('equal distinct ranges: neither is less than the other', () {
      check(r12() < r12()).isFalse();
    });

    test('same start, a shorter range is less than a longer one', () {
      check(DateTimeRange(t1, t2) < DateTimeRange(t1, t3)).isTrue();
    });
  });

  group('DateTimeRange operator <=', () {
    test('an earlier range is <= a later range', () {
      check(r12() <= r34()).isTrue();
    });

    test('a later range is not <= an earlier range', () {
      check(r34() <= r12()).isFalse();
    });

    test('a range is <= itself', () {
      final DateTimeRange r = r12();
      check(r <= r).isTrue();
    });

    test('equal distinct ranges are <= each other', () {
      check(r12() <= r12()).isTrue();
    });

    test('same start, a shorter range is <= a longer one', () {
      check(DateTimeRange(t1, t2) <= DateTimeRange(t1, t3)).isTrue();
    });
  });

  group('DateTimeRange operator >', () {
    test('a later range is > an earlier range', () {
      check(r34() > r12()).isTrue();
    });

    test('an earlier range is not > a later range', () {
      check(r12() > r34()).isFalse();
    });

    test('a range is not > itself', () {
      final DateTimeRange r = r12();
      check(r > r).isFalse();
    });

    test('equal distinct ranges: neither is > the other', () {
      check(r12() > r12()).isFalse();
    });

    test('same start, a longer range is > a shorter one', () {
      check(DateTimeRange(t1, t3) > DateTimeRange(t1, t2)).isTrue();
    });
  });

  group('DateTimeRange operator >=', () {
    test('a later range is >= an earlier range', () {
      check(r34() >= r12()).isTrue();
    });

    test('an earlier range is not >= a later range', () {
      check(r12() >= r34()).isFalse();
    });

    test('a range is >= itself', () {
      final DateTimeRange r = r12();
      check(r >= r).isTrue();
    });

    test('equal distinct ranges are >= each other', () {
      check(r12() >= r12()).isTrue();
    });

    test('same start, a longer range is >= a shorter one', () {
      check(DateTimeRange(t1, t3) >= DateTimeRange(t1, t2)).isTrue();
    });
  });

  group('DateTimeRange operators — consistency with compareTo', () {
    test('< is consistent with compareTo', () {
      for (final DateTimeRange a in fixtures()) {
        for (final DateTimeRange b in fixtures()) {
          check(a < b).equals(a.compareTo(b) < 0);
        }
      }
    });

    test('<= is consistent with compareTo', () {
      for (final DateTimeRange a in fixtures()) {
        for (final DateTimeRange b in fixtures()) {
          check(a <= b).equals(a.compareTo(b) <= 0);
        }
      }
    });

    test('> is consistent with compareTo', () {
      for (final DateTimeRange a in fixtures()) {
        for (final DateTimeRange b in fixtures()) {
          check(a > b).equals(a.compareTo(b) > 0);
        }
      }
    });

    test('>= is consistent with compareTo', () {
      for (final DateTimeRange a in fixtures()) {
        for (final DateTimeRange b in fixtures()) {
          check(a >= b).equals(a.compareTo(b) >= 0);
        }
      }
    });

    test('== is consistent with compareTo', () {
      for (final DateTimeRange a in fixtures()) {
        for (final DateTimeRange b in fixtures()) {
          check(a == b).equals(a.compareTo(b) == 0);
        }
      }
    });
  });

  group('DateTimeRange.contains', () {
    test('returns true for a moment strictly inside', () {
      check(r13().contains(t2)).isTrue();
    });

    test('returns true at the start (inclusive)', () {
      check(r13().contains(t1)).isTrue();
    });

    test('returns true at the end (inclusive)', () {
      check(r13().contains(t3)).isTrue();
    });

    test('returns false before the start', () {
      check(r23().contains(t1)).isFalse();
    });

    test('returns false after the end', () {
      check(r12().contains(t3)).isFalse();
    });

    test('returns false one microsecond before the start', () {
      final DateTime justBefore = t2.subtract(const Duration(microseconds: 1));
      check(r23().contains(justBefore)).isFalse();
    });

    test('returns false one microsecond after the end', () {
      final DateTime justAfter = t2.add(const Duration(microseconds: 1));
      check(r12().contains(justAfter)).isFalse();
    });

    test('returns true for the only moment of an instant', () {
      check(DateTimeRange(t2, t2).contains(t2)).isTrue();
    });

    test('returns false for any other moment of an instant', () {
      check(DateTimeRange(t2, t2).contains(t1)).isFalse();
      check(DateTimeRange(t2, t2).contains(t3)).isFalse();
    });

    test('compares by moment, ignoring UTC versus local', () {
      check(r13().contains(asLocal(t2))).isTrue();
      check(r13().contains(asLocal(t1))).isTrue();
      check(r13().contains(asLocal(t3))).isTrue();
      check(r13().contains(asLocal(t4))).isFalse();
    });
  });

  group('DateTimeRange.containsRange', () {
    test('returns true for a range strictly inside', () {
      check(r14().containsRange(r23())).isTrue();
    });

    test('returns true for an identical range', () {
      check(r12().containsRange(r12())).isTrue();
    });

    test('returns true when sharing only the start', () {
      check(r13().containsRange(r12())).isTrue();
    });

    test('returns true when sharing only the end', () {
      check(r13().containsRange(r23())).isTrue();
    });

    test('returns true for an instant inside', () {
      check(r13().containsRange(DateTimeRange(t2, t2))).isTrue();
    });

    test('returns false for a range that contains this one', () {
      check(r23().containsRange(r14())).isFalse();
    });

    test('returns false for a partially overlapping range', () {
      check(r13().containsRange(r24())).isFalse();
      check(r24().containsRange(r13())).isFalse();
    });

    test('returns false for a touching range', () {
      check(r12().containsRange(r23())).isFalse();
    });

    test('returns false for a disjoint range', () {
      check(r12().containsRange(r45())).isFalse();
    });

    test('returns false when the other ends one microsecond later', () {
      final longer = DateTimeRange(t1, t2.add(const Duration(microseconds: 1)));
      check(r12().containsRange(longer)).isFalse();
    });

    test('compares by moment, ignoring UTC versus local', () {
      final local = DateTimeRange(asLocal(t1), asLocal(t3));
      check(r13().containsRange(local)).isTrue();
      check(local.containsRange(r13())).isTrue();
    });
  });

  group('DateTimeRange.copyWith', () {
    test('with no arguments produces an equal range', () {
      final DateTimeRange original = r12();
      check(original.copyWith()).equals(original);
    });

    test('with no arguments produces a distinct object', () {
      final DateTimeRange original = r12();
      check(original.copyWith()).not((it) => it.identicalTo(original));
    });

    test('replaces start only', () {
      final DateTimeRange r = DateTimeRange(t1, t3).copyWith(start: t2);
      check(r.start).equals(t2);
      check(r.end).equals(t3);
    });

    test('replaces end only', () {
      final DateTimeRange r = DateTimeRange(t1, t2).copyWith(end: t3);
      check(r.start).equals(t1);
      check(r.end).equals(t3);
    });

    test('replaces both start and end', () {
      final DateTimeRange r = r12().copyWith(start: t3, end: t4);
      check(r.start).equals(t3);
      check(r.end).equals(t4);
    });

    test('swaps if the new start is after the original end', () {
      final DateTimeRange r = r12().copyWith(start: t3);
      check(r.start).equals(t2);
      check(r.end).equals(t3);
    });

    test('swaps if the new end is before the original start', () {
      final DateTimeRange r = r23().copyWith(end: t1);
      check(r.start).equals(t1);
      check(r.end).equals(t2);
    });

    test('swaps if the new start is after the new end', () {
      final DateTimeRange r = r12().copyWith(start: t3, end: t1);
      check(r.start).equals(t1);
      check(r.end).equals(t3);
    });

    test('can produce an instant', () {
      final DateTimeRange r = r12().copyWith(start: t2);
      check(r.isInstant).isTrue();
    });

    test('does not modify the original', () {
      final DateTimeRange original = r12();
      final DateTimeRange copy = original.copyWith(start: t1, end: t5);
      check(copy.end).equals(t5);
      check(original).equals(r12());
    });
  });

  group('DateTimeRange.endsBeforeOrAtStart', () {
    test('returns true when end is strictly before other.start', () {
      check(r12().endsBeforeOrAtStart(r34())).isTrue();
    });

    test('returns true when end equals other.start (touching)', () {
      check(r12().endsBeforeOrAtStart(r23())).isTrue();
    });

    test('returns false when ranges overlap', () {
      check(r13().endsBeforeOrAtStart(r23())).isFalse();
    });

    test('returns false for identical non-instant ranges', () {
      check(r12().endsBeforeOrAtStart(r12())).isFalse();
    });

    test('returns true for identical instants', () {
      final point = DateTimeRange(t2, t2);
      check(point.endsBeforeOrAtStart(point)).isTrue();
    });

    test('returns false when other is fully within this range', () {
      check(r14().endsBeforeOrAtStart(r23())).isFalse();
    });

    test('returns false when this range is after the other', () {
      check(r34().endsBeforeOrAtStart(r12())).isFalse();
    });

    test('returns true for ranges separated by a gap', () {
      final after = DateTimeRange(t2.add(const Duration(days: 1)), t3);
      check(r12().endsBeforeOrAtStart(after)).isTrue();
    });

    test('returns false when end is one microsecond after other.start', () {
      final later = DateTimeRange(
        t2.subtract(const Duration(microseconds: 1)),
        t3,
      );
      check(r12().endsBeforeOrAtStart(later)).isFalse();
    });

    test('compares by moment, ignoring UTC versus local', () {
      final local = DateTimeRange(asLocal(t2), asLocal(t3));
      check(r12().endsBeforeOrAtStart(local)).isTrue();
    });
  });

  group('DateTimeRange.endsBeforeStart', () {
    test('returns true when end is strictly before other.start', () {
      check(r12().endsBeforeStart(r34())).isTrue();
    });

    test('returns false when end equals other.start (touching)', () {
      check(r12().endsBeforeStart(r23())).isFalse();
    });

    test('returns false when ranges overlap', () {
      check(r13().endsBeforeStart(r23())).isFalse();
    });

    test('returns false for identical ranges', () {
      check(r12().endsBeforeStart(r12())).isFalse();
    });

    test('returns false when this range is after the other', () {
      check(r34().endsBeforeStart(r12())).isFalse();
    });

    test('returns true with a gap of one microsecond', () {
      final after = DateTimeRange(t2.add(const Duration(microseconds: 1)), t3);
      check(r12().endsBeforeStart(after)).isTrue();
    });

    test('is stricter than endsBeforeOrAtStart at the boundary', () {
      check(r12().endsBeforeOrAtStart(r23())).isTrue();
      check(r12().endsBeforeStart(r23())).isFalse();
    });
  });

  group('DateTimeRange.startsAfterEnds', () {
    test('returns true when start is strictly after other.end', () {
      check(r34().startsAfterEnds(r12())).isTrue();
    });

    test('returns false when start equals other.end (touching)', () {
      check(r23().startsAfterEnds(r12())).isFalse();
    });

    test('returns false when ranges overlap', () {
      check(r23().startsAfterEnds(r13())).isFalse();
    });

    test('returns false for identical ranges', () {
      check(r12().startsAfterEnds(r12())).isFalse();
    });

    test('returns false when this range is before the other', () {
      check(r12().startsAfterEnds(r34())).isFalse();
    });

    test('returns true with a gap of one microsecond', () {
      final later = DateTimeRange(t2.add(const Duration(microseconds: 1)), t3);
      check(later.startsAfterEnds(r12())).isTrue();
    });

    test('is the mirror of endsBeforeStart', () {
      for (final DateTimeRange a in fixtures()) {
        for (final DateTimeRange b in fixtures()) {
          check(a.endsBeforeStart(b)).equals(b.startsAfterEnds(a));
        }
      }
    });
  });

  group('DateTimeRange.startsAfterOrAtEnd', () {
    test('returns true when start is strictly after other.end', () {
      check(r34().startsAfterOrAtEnd(r12())).isTrue();
    });

    test('returns true when start equals other.end (touching)', () {
      check(r23().startsAfterOrAtEnd(r12())).isTrue();
    });

    test('returns false when ranges overlap', () {
      check(r23().startsAfterOrAtEnd(r13())).isFalse();
    });

    test('returns false for identical non-instant ranges', () {
      check(r12().startsAfterOrAtEnd(r12())).isFalse();
    });

    test('returns true for identical instants', () {
      final point = DateTimeRange(t2, t2);
      check(point.startsAfterOrAtEnd(point)).isTrue();
    });

    test('returns false when this range is before the other', () {
      check(r12().startsAfterOrAtEnd(r34())).isFalse();
    });

    test('returns false when start is one microsecond before other.end', () {
      final earlier = DateTimeRange(
        t2.subtract(const Duration(microseconds: 1)),
        t3,
      );
      check(earlier.startsAfterOrAtEnd(r12())).isFalse();
    });

    test('is the mirror of endsBeforeOrAtStart', () {
      for (final DateTimeRange a in fixtures()) {
        for (final DateTimeRange b in fixtures()) {
          check(a.endsBeforeOrAtStart(b)).equals(b.startsAfterOrAtEnd(a));
        }
      }
    });

    test('is stricter than startsAfterEnds at the boundary', () {
      check(r23().startsAfterOrAtEnd(r12())).isTrue();
      check(r23().startsAfterEnds(r12())).isFalse();
    });
  });

  group('DateTimeRange.overlapsOrTouches', () {
    test('returns true for identical ranges', () {
      check(r12().overlapsOrTouches(r12())).isTrue();
    });

    test('returns true when ranges overlap', () {
      check(r13().overlapsOrTouches(r23())).isTrue();
    });

    test('returns true when ranges partially overlap', () {
      check(r13().overlapsOrTouches(r24())).isTrue();
      check(r24().overlapsOrTouches(r13())).isTrue();
    });

    test('returns true when one range contains the other', () {
      check(r14().overlapsOrTouches(r23())).isTrue();
      check(r23().overlapsOrTouches(r14())).isTrue();
    });

    test('returns true when touching at end of this', () {
      check(r12().overlapsOrTouches(r23())).isTrue();
    });

    test('returns true when touching at start of this', () {
      check(r23().overlapsOrTouches(r12())).isTrue();
    });

    test('returns false when ranges have a gap', () {
      check(r12().overlapsOrTouches(r34())).isFalse();
    });

    test('returns false for disjoint ranges (reversed)', () {
      check(r34().overlapsOrTouches(r12())).isFalse();
    });

    test('returns false with a gap of one microsecond', () {
      final later = DateTimeRange(t2.add(const Duration(microseconds: 1)), t3);
      check(r12().overlapsOrTouches(later)).isFalse();
      check(later.overlapsOrTouches(r12())).isFalse();
    });

    test('returns true for an instant touching a range', () {
      check(r12().overlapsOrTouches(DateTimeRange(t2, t2))).isTrue();
      check(r12().overlapsOrTouches(DateTimeRange(t1, t1))).isTrue();
    });

    test('returns true for an instant inside a range', () {
      check(r13().overlapsOrTouches(DateTimeRange(t2, t2))).isTrue();
    });

    test('returns false for an instant outside a range', () {
      check(r12().overlapsOrTouches(DateTimeRange(t3, t3))).isFalse();
    });

    test('returns true for two identical instants', () {
      check(DateTimeRange(t2, t2).overlapsOrTouches(DateTimeRange(t2, t2)))
          .isTrue();
    });

    test('is commutative for every pair of fixtures', () {
      for (final DateTimeRange a in fixtures()) {
        for (final DateTimeRange b in fixtures()) {
          check(a.overlapsOrTouches(b)).equals(b.overlapsOrTouches(a));
        }
      }
    });

    test('is the negation of endsBeforeStart or startsAfterEnds', () {
      for (final DateTimeRange a in fixtures()) {
        for (final DateTimeRange b in fixtures()) {
          check(!a.overlapsOrTouches(b))
              .equals(a.endsBeforeStart(b) || a.startsAfterEnds(b));
        }
      }
    });

    test('compares by moment, ignoring UTC versus local', () {
      final local = DateTimeRange(asLocal(t2), asLocal(t3));
      check(r12().overlapsOrTouches(local)).isTrue();
    });
  });

  group('DateTimeRange.intersection', () {
    test('returns the shared part of two overlapping ranges', () {
      check(r13().intersection(r24())).isNotNull().equals(r23());
    });

    test('returns the inner range when one contains the other', () {
      check(r14().intersection(r23())).isNotNull().equals(r23());
      check(r23().intersection(r14())).isNotNull().equals(r23());
    });

    test('returns the range itself for identical ranges', () {
      check(r12().intersection(r12())).isNotNull().equals(r12());
    });

    test('returns an instant for ranges that only touch', () {
      final DateTimeRange? result = r12().intersection(r23());
      check(result).isNotNull().equals(DateTimeRange(t2, t2));
      check(result).isNotNull().has((r) => r.isInstant, 'isInstant').isTrue();
    });

    test('returns an instant for touching ranges in reverse order', () {
      check(r23().intersection(r12()))
          .isNotNull()
          .equals(DateTimeRange(t2, t2));
    });

    test('returns null for ranges with a gap', () {
      check(r12().intersection(r34())).isNull();
      check(r34().intersection(r12())).isNull();
    });

    test('returns null with a gap of one microsecond', () {
      final later = DateTimeRange(t2.add(const Duration(microseconds: 1)), t3);
      check(r12().intersection(later)).isNull();
    });

    test('returns the shared instant for an instant inside a range', () {
      final point = DateTimeRange(t2, t2);
      check(r13().intersection(point)).isNotNull().equals(point);
    });

    test('returns null for an instant outside a range', () {
      check(r12().intersection(DateTimeRange(t3, t3))).isNull();
    });

    test('shares the start when both start together', () {
      check(DateTimeRange(t1, t2).intersection(DateTimeRange(t1, t3)))
          .isNotNull()
          .equals(DateTimeRange(t1, t2));
    });

    test('shares the end when both end together', () {
      check(DateTimeRange(t1, t3).intersection(DateTimeRange(t2, t3)))
          .isNotNull()
          .equals(DateTimeRange(t2, t3));
    });

    test('is commutative for every pair of fixtures', () {
      for (final DateTimeRange a in fixtures()) {
        for (final DateTimeRange b in fixtures()) {
          check(a.intersection(b)).equals(b.intersection(a));
        }
      }
    });

    test('is null exactly when the ranges neither overlap nor touch', () {
      for (final DateTimeRange a in fixtures()) {
        for (final DateTimeRange b in fixtures()) {
          check(a.intersection(b) == null).equals(!a.overlapsOrTouches(b));
        }
      }
    });

    test('result is contained in both ranges', () {
      for (final DateTimeRange a in fixtures()) {
        for (final DateTimeRange b in fixtures()) {
          final DateTimeRange? shared = a.intersection(b);
          if (shared != null) {
            check(a.containsRange(shared)).isTrue();
            check(b.containsRange(shared)).isTrue();
          }
        }
      }
    });

    test('does not modify the operands', () {
      final DateTimeRange a = r13();
      final DateTimeRange b = r24();
      check(a.intersection(b)).isNotNull();
      check(a).equals(r13());
      check(b).equals(r24());
    });
  });

  group('DateTimeRange.toMap', () {
    test('contains the "start" key with an ISO-8601 string', () {
      check(r12().toMap()['start']).equals(t1.toIso8601String());
    });

    test('contains the "end" key with an ISO-8601 string', () {
      check(r12().toMap()['end']).equals(t2.toIso8601String());
    });

    test('contains exactly the keys "start" and "end"', () {
      final Map<String, Object?> map = r12().toMap();
      check(map.keys.toSet()).deepEquals(<String>{'start', 'end'});
    });

    test('emits keys in the order: end, start', () {
      check(r12().toMap().keys.toList()).deepEquals(<String>['end', 'start']);
    });

    test('values are Strings', () {
      final Map<String, Object?> map = r12().toMap();
      check(map['start']).isA<String>();
      check(map['end']).isA<String>();
    });

    test('puts the smaller date under "start" for swapped arguments', () {
      final Map<String, Object?> map = DateTimeRange(t3, t1).toMap();
      check(map['start']).equals(t1.toIso8601String());
      check(map['end']).equals(t3.toIso8601String());
    });

    test('keeps the microseconds', () {
      final a = DateTime.utc(2020);
      final b = DateTime.utc(2020, 1, 1, 0, 0, 0, 0, 1);
      check(DateTimeRange(a, b).toMap()['end']).equals(b.toIso8601String());
    });
  });

  group('DateTimeRange.toJson', () {
    test('produces a non-empty string', () {
      check(r12().toJson()).isNotEmpty();
    });

    test('contains the "start" and "end" keys', () {
      check(r12().toJson())
        ..contains('"start"')
        ..contains('"end"');
    });

    test('contains the ISO-8601 strings', () {
      check(r12().toJson())
        ..contains(t1.toIso8601String())
        ..contains(t2.toIso8601String());
    });

    test('produces valid JSON that fromJson accepts', () {
      check(() => DateTimeRange.fromJson(r12().toJson())).returnsNormally();
    });
  });

  group('DateTimeRange.toString', () {
    test('is formatted as "start|end"', () {
      check(r12().toString())
          .equals('${t1.toIso8601String()}|${t2.toIso8601String()}');
    });

    test('contains exactly one pipe', () {
      check('|'.allMatches(r12().toString()).length).equals(1);
    });

    test('starts with the start and ends with the end', () {
      check(r12().toString())
        ..startsWith(t1.toIso8601String())
        ..endsWith(t2.toIso8601String());
    });

    test('formats a degenerate range correctly', () {
      check(DateTimeRange(t1, t1).toString())
          .equals('${t1.toIso8601String()}|${t1.toIso8601String()}');
    });

    test('puts the smaller date first for swapped arguments', () {
      check(DateTimeRange(t3, t1).toString())
          .equals('${t1.toIso8601String()}|${t3.toIso8601String()}');
    });
  });

  group('DateTimeRange — parse/toString round-trip', () {
    test('toString then parse is the identity', () {
      check(DateTimeRange.parse(r12().toString())).equals(r12());
    });

    test('all fixture ranges survive a round-trip', () {
      for (final DateTimeRange r in fixtures()) {
        check(DateTimeRange.parse(r.toString())).equals(r);
        check(DateTimeRange.tryParse(r.toString())).isNotNull().equals(r);
      }
    });

    test('a range of local DateTimes survives a round-trip', () {
      final r = DateTimeRange(asLocal(t1), asLocal(t3));
      check(DateTimeRange.parse(r.toString())).equals(r);
    });

    test('a microsecond-precision range survives a round-trip', () {
      final r = DateTimeRange(
        DateTime.utc(2020, 1, 1, 0, 0, 0, 0, 1),
        DateTime.utc(2020, 1, 1, 0, 0, 0, 0, 2),
      );
      check(DateTimeRange.parse(r.toString())).equals(r);
    });
  });

  group('DateTimeRange — toMap/fromMap round-trip', () {
    test('toMap then fromMap is the identity', () {
      check(DateTimeRange.fromMap(r12().toMap())).equals(r12());
    });

    test('all fixture ranges survive a round-trip', () {
      for (final DateTimeRange r in fixtures()) {
        check(DateTimeRange.fromMap(r.toMap())).equals(r);
      }
    });
  });

  group('DateTimeRange — toJson/fromJson round-trip', () {
    test('toJson then fromJson is the identity', () {
      check(DateTimeRange.fromJson(r12().toJson())).equals(r12());
    });

    test('all fixture ranges survive a round-trip', () {
      for (final DateTimeRange r in fixtures()) {
        check(DateTimeRange.fromJson(r.toJson())).equals(r);
      }
    });
  });

  group('DateTimeRange.areThereOverlaps — empty and singleton sets', () {
    test('returns false for an empty set', () {
      check(DateTimeRange.areThereOverlaps(rangeSet(<DateTimeRange>[])))
          .isFalse();
    });

    test('returns false for a singleton set', () {
      check(DateTimeRange.areThereOverlaps(rangeSet(<DateTimeRange>[r12()])))
          .isFalse();
    });

    test('returns false for a singleton instant', () {
      check(
        DateTimeRange.areThereOverlaps(
          rangeSet(<DateTimeRange>[DateTimeRange(t1, t1)]),
        ),
      ).isFalse();
    });
  });

  group('DateTimeRange.areThereOverlaps — two ranges', () {
    test('returns false for two non-overlapping, non-touching ranges', () {
      check(
        DateTimeRange.areThereOverlaps(rangeSet(<DateTimeRange>[r12(), r34()])),
      ).isFalse();
    });

    test('returns true for two overlapping ranges', () {
      check(
        DateTimeRange.areThereOverlaps(rangeSet(<DateTimeRange>[r13(), r23()])),
      ).isTrue();
    });

    test('returns true for two touching ranges', () {
      check(
        DateTimeRange.areThereOverlaps(rangeSet(<DateTimeRange>[r12(), r23()])),
      ).isTrue();
    });

    test('returns true when one range contains the other', () {
      check(
        DateTimeRange.areThereOverlaps(rangeSet(<DateTimeRange>[r14(), r23()])),
      ).isTrue();
    });

    test('returns false with a gap of one microsecond', () {
      final later = DateTimeRange(t2.add(const Duration(microseconds: 1)), t3);
      check(
        DateTimeRange.areThereOverlaps(rangeSet(<DateTimeRange>[r12(), later])),
      ).isFalse();
    });

    test('returns false for two distinct instants', () {
      check(
        DateTimeRange.areThereOverlaps(
          rangeSet(<DateTimeRange>[
            DateTimeRange(t1, t1),
            DateTimeRange(t2, t2),
          ]),
        ),
      ).isFalse();
    });

    test('collapses identical ranges, so no overlap is reported', () {
      check(
        DateTimeRange.areThereOverlaps(rangeSet(<DateTimeRange>[r12(), r12()])),
      ).isFalse();
    });
  });

  group('DateTimeRange.areThereOverlaps — three or more ranges', () {
    test('returns false for three separated ranges', () {
      final a = DateTimeRange(t1, t2);
      final b = DateTimeRange(t2.add(const Duration(days: 1)), t3);
      final c = DateTimeRange(t3.add(const Duration(days: 1)), t4);
      check(DateTimeRange.areThereOverlaps(rangeSet(<DateTimeRange>[a, b, c])))
          .isFalse();
    });

    test('returns true when the first two of three overlap', () {
      check(
        DateTimeRange.areThereOverlaps(
          rangeSet(<DateTimeRange>[r13(), r23(), r45()]),
        ),
      ).isTrue();
    });

    test('returns true when the last two of three overlap', () {
      final a = DateTimeRange(t1, t2);
      final b = DateTimeRange(t2.add(const Duration(days: 1)), t4);
      final c = DateTimeRange(t3, t5);
      check(DateTimeRange.areThereOverlaps(rangeSet(<DateTimeRange>[a, b, c])))
          .isTrue();
    });

    test('returns true when a wide range covers a later non-neighbor', () {
      final wide = DateTimeRange(t1, t5);
      final small = DateTimeRange(t2, t3);
      final other = DateTimeRange(t4, t4);
      check(
        DateTimeRange.areThereOverlaps(
          rangeSet(<DateTimeRange>[wide, small, other]),
        ),
      ).isTrue();
    });

    test('is independent of the insertion order', () {
      final ranges = <DateTimeRange>[r12(), r34(), r45()];
      check(DateTimeRange.areThereOverlaps(rangeSet(ranges)))
          .equals(DateTimeRange.areThereOverlaps(rangeSet(ranges.reversed)));
    });
  });

  group('DateTimeRange.join — overlapping ranges', () {
    test('returns a singleton set', () {
      check(DateTimeRange.join(r13(), r23()).length).equals(1);
    });

    test('the merged range spans earliest start to latest end', () {
      final DateTimeRange merged = DateTimeRange.join(r13(), r24()).first;
      check(merged.start).equals(t1);
      check(merged.end).equals(t4);
    });

    test('one range containing the other yields the outer range', () {
      check(DateTimeRange.join(r14(), r23()).single).equals(r14());
      check(DateTimeRange.join(r23(), r14()).single).equals(r14());
    });

    test('is commutative', () {
      check(DateTimeRange.join(r13(), r24()).toList())
          .deepEquals(DateTimeRange.join(r24(), r13()).toList());
    });
  });

  group('DateTimeRange.join — touching ranges', () {
    test('returns a singleton set', () {
      check(DateTimeRange.join(r12(), r23()).length).equals(1);
    });

    test('the merged range spans from t1 to t3', () {
      final DateTimeRange merged = DateTimeRange.join(r12(), r23()).first;
      check(merged.start).equals(t1);
      check(merged.end).equals(t3);
    });

    test('works in reverse order', () {
      check(DateTimeRange.join(r23(), r12()).single)
          .equals(DateTimeRange(t1, t3));
    });
  });

  group('DateTimeRange.join — non-overlapping ranges', () {
    test('returns a set of two', () {
      check(DateTimeRange.join(r12(), r34()).length).equals(2);
    });

    test('the set contains both original ranges, in order', () {
      check(DateTimeRange.join(r34(), r12()).toList())
          .deepEquals(<DateTimeRange>[r12(), r34()]);
    });

    test('is commutative', () {
      check(DateTimeRange.join(r12(), r34()).toList())
          .deepEquals(DateTimeRange.join(r34(), r12()).toList());
    });

    test('keeps the ranges separate with a gap of one microsecond', () {
      final later = DateTimeRange(t2.add(const Duration(microseconds: 1)), t3);
      check(DateTimeRange.join(r12(), later).length).equals(2);
    });
  });

  group('DateTimeRange.join — identical ranges and instants', () {
    test('joining a range with itself returns a singleton', () {
      check(DateTimeRange.join(r12(), r12()).length).equals(1);
    });

    test('the merged range equals the original', () {
      check(DateTimeRange.join(r12(), r12()).first).equals(r12());
    });

    test('joining two identical instants returns that instant', () {
      final point = DateTimeRange(t2, t2);
      check(DateTimeRange.join(point, point).single).equals(point);
    });

    test('joining an instant with a range touching it extends the range', () {
      check(DateTimeRange.join(r12(), DateTimeRange(t2, t2)).single)
          .equals(r12());
    });
  });

  group('DateTimeRange.join — result type', () {
    test('returns a SplayTreeSet', () {
      check(DateTimeRange.join(r12(), r34()))
          .isA<SplayTreeSet<DateTimeRange>>();
    });

    test('returns a new set on every call', () {
      final SplayTreeSet<DateTimeRange> a = DateTimeRange.join(r12(), r34());
      final SplayTreeSet<DateTimeRange> b = DateTimeRange.join(r12(), r34());
      check(a).not((it) => it.identicalTo(b));
    });

    test('does not modify the operands', () {
      final DateTimeRange a = r13();
      final DateTimeRange b = r24();
      check(DateTimeRange.join(a, b)).isNotEmpty();
      check(a).equals(r13());
      check(b).equals(r24());
    });
  });

  group('DateTimeRange.merge — empty input', () {
    test('returns an empty set for an empty iterable', () {
      check(DateTimeRange.merge(<DateTimeRange>[])).isEmpty();
    });

    test('returns a SplayTreeSet', () {
      check(DateTimeRange.merge(<DateTimeRange>[]))
          .isA<SplayTreeSet<DateTimeRange>>();
    });

    test('returns a new set on every call', () {
      final SplayTreeSet<DateTimeRange> a = DateTimeRange.merge(
        <DateTimeRange>[],
      );
      final SplayTreeSet<DateTimeRange> b = DateTimeRange.merge(
        <DateTimeRange>[],
      );
      check(a).not((it) => it.identicalTo(b));
    });
  });

  group('DateTimeRange.merge — single range', () {
    test('returns a singleton set', () {
      check(DateTimeRange.merge(<DateTimeRange>[r12()]).length).equals(1);
    });

    test('the returned range equals the original', () {
      check(DateTimeRange.merge(<DateTimeRange>[r12()]).first).equals(r12());
    });

    test('an instant is preserved', () {
      final point = DateTimeRange(t2, t2);
      check(DateTimeRange.merge(<DateTimeRange>[point]).single).equals(point);
    });
  });

  group('DateTimeRange.merge — two overlapping ranges', () {
    test('returns a singleton set', () {
      check(DateTimeRange.merge(<DateTimeRange>[r13(), r23()]).length)
          .equals(1);
    });

    test('the merged range spans the entire extent', () {
      final DateTimeRange merged = DateTimeRange.merge(<DateTimeRange>[
        r13(),
        r24(),
      ]).first;
      check(merged.start).equals(t1);
      check(merged.end).equals(t4);
    });

    test('a contained range does not shrink the result', () {
      check(DateTimeRange.merge(<DateTimeRange>[r14(), r23()]).single)
          .equals(r14());
    });
  });

  group('DateTimeRange.merge — two touching ranges', () {
    test('returns a singleton set', () {
      check(DateTimeRange.merge(<DateTimeRange>[r12(), r23()]).length)
          .equals(1);
    });

    test('the merged range spans from t1 to t3', () {
      final DateTimeRange merged = DateTimeRange.merge(<DateTimeRange>[
        r12(),
        r23(),
      ]).first;
      check(merged.start).equals(t1);
      check(merged.end).equals(t3);
    });
  });

  group('DateTimeRange.merge — two non-overlapping ranges', () {
    test('returns a set of two', () {
      check(DateTimeRange.merge(<DateTimeRange>[r12(), r34()]).length)
          .equals(2);
    });

    test('both original ranges are preserved, in order', () {
      check(DateTimeRange.merge(<DateTimeRange>[r34(), r12()]).toList())
          .deepEquals(<DateTimeRange>[r12(), r34()]);
    });

    test('keeps ranges apart with a gap of one microsecond', () {
      final later = DateTimeRange(t2.add(const Duration(microseconds: 1)), t3);
      check(DateTimeRange.merge(<DateTimeRange>[r12(), later]).length)
          .equals(2);
    });
  });

  group('DateTimeRange.merge — three or more ranges', () {
    test('merges three chained overlapping ranges into one', () {
      final a = DateTimeRange(t1, t3);
      final b = DateTimeRange(t2, t4);
      final c = DateTimeRange(t3, t5);
      check(DateTimeRange.merge(<DateTimeRange>[a, b, c]).length).equals(1);
    });

    test('the merged span is correct for three chained ranges', () {
      final a = DateTimeRange(t1, t3);
      final b = DateTimeRange(t2, t4);
      final c = DateTimeRange(t3, t5);
      final DateTimeRange merged = DateTimeRange.merge(<DateTimeRange>[a, b, c])
          .first;
      check(merged.start).equals(t1);
      check(merged.end).equals(t5);
    });

    test('merges ranges that touch only through a bridging range', () {
      // r12 and r34 do not touch each other, but r13 bridges them.
      check(DateTimeRange.merge(<DateTimeRange>[r12(), r34(), r13()]).single)
          .equals(DateTimeRange(t1, t4));
    });

    test('keeps the maximum end when a wide range swallows later ones', () {
      final wide = DateTimeRange(t1, t5);
      check(DateTimeRange.merge(<DateTimeRange>[wide, r23(), r34()]).single)
          .equals(wide);
    });

    test('merges the first two but keeps the third separate', () {
      final c = DateTimeRange(t3.add(const Duration(days: 1)), t5);
      check(DateTimeRange.merge(<DateTimeRange>[r13(), r23(), c]).length)
          .equals(2);
    });

    test('the result is sorted (earlier start first)', () {
      final DateTime gap = t3.add(const Duration(days: 1));
      final c = DateTimeRange(gap, t5);
      final List<DateTimeRange> result = DateTimeRange.merge(<DateTimeRange>[
        c,
        r23(),
        r13(),
      ]).toList();
      check(result[0].start).equals(t1);
      check(result[0].end).equals(t3);
      check(result[1].start).equals(gap);
      check(result[1].end).equals(t5);
    });

    test('merges a run of touching ranges into one', () {
      check(
        DateTimeRange.merge(<DateTimeRange>[r12(), r23(), r34(), r45()]).single,
      ).equals(DateTimeRange(t1, t5));
    });

    test('merges identical instants into one', () {
      final point = DateTimeRange(t2, t2);
      check(DateTimeRange.merge(<DateTimeRange>[point, point, point]).single)
          .equals(point);
    });

    test('absorbs an instant inside a range', () {
      check(
        DateTimeRange.merge(<DateTimeRange>[r13(), DateTimeRange(t2, t2)])
            .single,
      ).equals(r13());
    });

    test('keeps a distinct instant separate', () {
      check(
        DateTimeRange.merge(<DateTimeRange>[r12(), DateTimeRange(t3, t3)])
            .length,
      ).equals(2);
    });
  });

  group('DateTimeRange.merge — input handling', () {
    test('the result does not depend on the input order', () {
      final rs = <DateTimeRange>[r12(), r23(), r45()];
      check(DateTimeRange.merge(rs).toList())
          .deepEquals(DateTimeRange.merge(rs.reversed).toList());
    });

    test('does not modify the input list', () {
      final input = <DateTimeRange>[r34(), r12(), r23()];
      final SplayTreeSet<DateTimeRange> result = DateTimeRange.merge(input);
      check(result).isNotEmpty();
      check(input).deepEquals(<DateTimeRange>[r34(), r12(), r23()]);
    });

    test('accepts a lazy iterable', () {
      final Iterable<DateTimeRange> lazy = <DateTimeRange>[
        r12(),
        r23(),
      ].map((r) => r);
      check(DateTimeRange.merge(lazy).single).equals(DateTimeRange(t1, t3));
    });

    test('accepts a Set as input', () {
      final set = <DateTimeRange>{r12(), r23(), r45()};
      check(DateTimeRange.merge(set).length).equals(2);
    });

    test('accepts a SplayTreeSet as input', () {
      final SplayTreeSet<DateTimeRange> set = rangeSet(<DateTimeRange>[
        r12(),
        r23(),
      ]);
      check(DateTimeRange.merge(set).single).equals(DateTimeRange(t1, t3));
    });

    test('evaluates a lazy iterable only once', () {
      var evaluations = 0;
      final Iterable<DateTimeRange> lazy = <DateTimeRange>[r12(), r23()].map((
        r,
      ) {
        evaluations++;
        return r;
      });
      final SplayTreeSet<DateTimeRange> result = DateTimeRange.merge(lazy);
      check(result).isNotEmpty();
      check(evaluations).isLessOrEqual(2);
    });
  });

  group('DateTimeRange.merge — result invariants', () {
    test('areThereOverlaps returns false on any merge result', () {
      check(
        DateTimeRange.areThereOverlaps(
          DateTimeRange.merge(<DateTimeRange>[
            r12(),
            r23(),
            r34(),
            r45(),
            r13(),
            r24(),
          ]),
        ),
      ).isFalse();
    });

    test('duplicate ranges in the input collapse to one', () {
      check(DateTimeRange.merge(<DateTimeRange>[r12(), r12(), r12()]).length)
          .equals(1);
    });

    test('merging an already merged set changes nothing', () {
      final SplayTreeSet<DateTimeRange> once = DateTimeRange.merge(
        <DateTimeRange>[r12(), r34(), r45()],
      );
      final SplayTreeSet<DateTimeRange> twice = DateTimeRange.merge(once);
      check(twice.toList()).deepEquals(once.toList());
    });

    test('every input range is contained in some merged range', () {
      final List<DateTimeRange> inputs = fixtures();
      final SplayTreeSet<DateTimeRange> merged = DateTimeRange.merge(inputs);
      for (final input in inputs) {
        check(merged.any((m) => m.containsRange(input))).isTrue();
      }
    });

    test('merged ranges are strictly separated by a gap', () {
      final List<DateTimeRange> merged = DateTimeRange.merge(<DateTimeRange>[
        r12(),
        r45(),
        DateTimeRange(t3, t3),
      ]).toList();
      for (var i = 0; i < merged.length - 1; i++) {
        check(merged[i].endsBeforeStart(merged[i + 1])).isTrue();
      }
    });
  });
}

/// UTC points used across tests, in ascending order.
final DateTime t1 = DateTime.utc(2020);
final DateTime t2 = DateTime.utc(2020, 6);
final DateTime t3 = DateTime.utc(2020, 12, 31);
final DateTime t4 = DateTime.utc(2021, 6);
final DateTime t5 = DateTime.utc(2021, 12, 31);

/// Returns a local-time [DateTime] denoting the same moment as [utc].
DateTime asLocal(DateTime utc) =>
    DateTime.fromMicrosecondsSinceEpoch(utc.microsecondsSinceEpoch);

/// A fresh list with every range fixture.
List<DateTimeRange> fixtures() => <DateTimeRange>[
  r12(),
  r13(),
  r14(),
  r23(),
  r24(),
  r34(),
  r45(),
  DateTimeRange(t2, t2),
];

/// A range [t1, t2].
DateTimeRange r12() => DateTimeRange(t1, t2);

/// A range [t1, t3].
DateTimeRange r13() => DateTimeRange(t1, t3);

/// A range [t1, t4].
DateTimeRange r14() => DateTimeRange(t1, t4);

/// A range [t2, t3].
DateTimeRange r23() => DateTimeRange(t2, t3);

/// A range [t2, t4].
DateTimeRange r24() => DateTimeRange(t2, t4);

/// A range [t3, t4].
DateTimeRange r34() => DateTimeRange(t3, t4);

/// A range [t4, t5].
DateTimeRange r45() => DateTimeRange(t4, t5);

/// Creates a [SplayTreeSet] of [DateTimeRange] from [ranges].
SplayTreeSet<DateTimeRange> rangeSet(Iterable<DateTimeRange> ranges) =>
    SplayTreeSet<DateTimeRange>.of(ranges);
