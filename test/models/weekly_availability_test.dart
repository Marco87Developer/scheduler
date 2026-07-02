import 'package:checks/checks.dart';
import 'package:scheduler/src/enums/day_of_week.dart';
import 'package:scheduler/src/models/time.dart';
import 'package:scheduler/src/models/weekly_availability.dart';
import 'package:test/test.dart';

void main() {
  const DayOfWeek day = DayOfWeek.monday;
  const Time start = Time(9);
  const Time end = Time(17);

  group('WeeklyAvailability()', () {
    test('assigns day, start, and end correctly', () {
      final WeeklyAvailability wa = WeeklyAvailability(day, start, end);
      check(wa.day).equals(day);
      check(wa.start).equals(start);
      check(wa.end).equals(end);
    });

    test('swaps start and end when start > end', () {
      final WeeklyAvailability wa = WeeklyAvailability(day, end, start);
      check(wa.start).equals(start);
      check(wa.end).equals(end);
    });

    test('allows equal start and end', () {
      final WeeklyAvailability wa = WeeklyAvailability(day, start, start);
      check(wa.start).equals(start);
      check(wa.end).equals(start);
    });

    test('is const-constructible', () {
      final WeeklyAvailability wa = WeeklyAvailability(day, start, end);
      check(wa).isA<WeeklyAvailability>();
    });
  });

  group('WeeklyAvailability.fromJson()', () {
    test('parses a valid JSON string', () {
      final WeeklyAvailability wa = WeeklyAvailability.fromJson(
        '{"day":"monday","start":"T09:00:00","end":"T17:00:00"}',
      );
      check(wa.day).equals(DayOfWeek.monday);
      check(wa.start).equals(const Time(9));
      check(wa.end).equals(const Time(17));
    });

    test('throws FormatException for malformed JSON', () {
      check(
        () => WeeklyAvailability.fromJson('not json'),
      ).throws<FormatException>();
    });

    test('throws FormatException when JSON root is not a map', () {
      check(
        () => WeeklyAvailability.fromJson('[1, 2, 3]'),
      ).throws<FormatException>();
    });

    test('throws FormatException when a key has an invalid value', () {
      check(
        () => WeeklyAvailability.fromJson(
          '{"day":"notaday",'
          '"start":"T09:00:00","end":"T17:00:00"}',
        ),
      ).throws<FormatException>();
    });

    test('throws FormatException when a required key is missing', () {
      check(
        () => WeeklyAvailability.fromJson(
          '{"start":"T09:00:00","end":"T17:00:00"}',
        ),
      ).throws<FormatException>();
    });

    test('round-trips through toJson', () {
      final WeeklyAvailability original = WeeklyAvailability(day, start, end);
      final WeeklyAvailability result = WeeklyAvailability.fromJson(
        original.toJson(),
      );
      check(result).equals(original);
    });
  });

  group('WeeklyAvailability.fromMap()', () {
    test('constructs from a valid map', () {
      final WeeklyAvailability wa = WeeklyAvailability.fromMap(
        const <String, Object?>{
          'day': 'monday',
          'start': 'T09:00:00',
          'end': 'T17:00:00',
        },
      );
      check(wa.day).equals(DayOfWeek.monday);
      check(wa.start).equals(const Time(9));
      check(wa.end).equals(const Time(17));
    });

    test('throws FormatException when day key is absent', () {
      check(
        () => WeeklyAvailability.fromMap(const <String, String>{
          'start': 'T09:00:00',
          'end': 'T17:00:00',
        }),
      ).throws<FormatException>();
    });

    test('throws FormatException when start key is absent', () {
      check(
        () => WeeklyAvailability.fromMap(const <String, String>{
          'day': 'monday',
          'end': 'T17:00:00',
        }),
      ).throws<FormatException>();
    });

    test('throws FormatException when end key is absent', () {
      check(
        () => WeeklyAvailability.fromMap(const <String, Object?>{
          'day': 'monday',
          'start': 'T09:00:00',
        }),
      ).throws<FormatException>();
    });

    test('throws FormatException when day value has wrong type', () {
      check(
        () => WeeklyAvailability.fromMap(const <String, Object>{
          'day': 42,
          'start': 'T09:00:00',
          'end': 'T17:00:00',
        }),
      ).throws<FormatException>();
    });

    test('throws FormatException when day value is an invalid string', () {
      check(
        () => WeeklyAvailability.fromMap(const <String, Object?>{
          'day': 'notaday',
          'start': 'T09:00:00',
          'end': 'T17:00:00',
        }),
      ).throws<FormatException>();
    });

    test('throws FormatException when start value is invalid', () {
      check(
        () => WeeklyAvailability.fromMap(const <String, Object?>{
          'day': 'monday',
          'start': 'notatime',
          'end': 'T17:00:00',
        }),
      ).throws<FormatException>();
    });

    test('throws FormatException when end value is invalid', () {
      check(
        () => WeeklyAvailability.fromMap(const <String, Object?>{
          'day': 'monday',
          'start': 'T09:00:00',
          'end': 'notatime',
        }),
      ).throws<FormatException>();
    });

    test('round-trips through toMap', () {
      final WeeklyAvailability original = WeeklyAvailability(day, start, end);
      final WeeklyAvailability result = WeeklyAvailability.fromMap(
        original.toMap(),
      );
      check(result).equals(original);
    });
  });

  group('WeeklyAvailability.parse()', () {
    test('parses a valid pipe-delimited string', () {
      final WeeklyAvailability wa = WeeklyAvailability.parse(
        'monday|T09:00:00|T17:00:00',
      );
      check(wa.day).equals(DayOfWeek.monday);
      check(wa.start).equals(const Time(9));
      check(wa.end).equals(const Time(17));
    });

    test('throws FormatException with fewer than 3 segments', () {
      check(
        () => WeeklyAvailability.parse('monday|T09:00:00'),
      ).throws<FormatException>();
    });

    test('throws FormatException with more than 3 segments', () {
      check(
        () => WeeklyAvailability.parse('monday|T09:00:00|T17:00:00|extra'),
      ).throws<FormatException>();
    });

    test('throws FormatException when day segment is invalid', () {
      check(
        () => WeeklyAvailability.parse('notaday|T09:00:00|T17:00:00'),
      ).throws<FormatException>();
    });

    test('throws FormatException when start segment is invalid', () {
      check(
        () => WeeklyAvailability.parse('monday|notatime|T17:00:00'),
      ).throws<FormatException>();
    });

    test('throws FormatException when end segment is invalid', () {
      check(
        () => WeeklyAvailability.parse('monday|T09:00:00|notatime'),
      ).throws<FormatException>();
    });

    test('round-trips through toString', () {
      final WeeklyAvailability original = WeeklyAvailability(day, start, end);
      final WeeklyAvailability result = WeeklyAvailability.parse(
        original.toString(),
      );
      check(result).equals(original);
    });
  });

  group('hashCode', () {
    test('equal instances have equal hashCode', () {
      final WeeklyAvailability a = WeeklyAvailability(day, start, end);
      final WeeklyAvailability b = WeeklyAvailability(day, start, end);
      check(a.hashCode).equals(b.hashCode);
    });

    test('different day produces different hashCode', () {
      final WeeklyAvailability a = WeeklyAvailability(day, start, end);
      final WeeklyAvailability b = WeeklyAvailability(
        DayOfWeek.tuesday,
        start,
        end,
      );
      check(a.hashCode).not((Subject<int> it) => it.equals(b.hashCode));
    });

    test('different start produces different hashCode', () {
      final WeeklyAvailability a = WeeklyAvailability(day, start, end);
      final WeeklyAvailability b = WeeklyAvailability(day, const Time(10), end);
      check(a.hashCode).not((Subject<int> it) => it.equals(b.hashCode));
    });

    test('different end produces different hashCode', () {
      final WeeklyAvailability a = WeeklyAvailability(day, start, end);
      final WeeklyAvailability b = WeeklyAvailability(
        day,
        start,
        const Time(18),
      );
      check(a.hashCode).not((Subject<int> it) => it.equals(b.hashCode));
    });
  });

  group('operator ==', () {
    test('identical instance equals itself', () {
      final WeeklyAvailability a = WeeklyAvailability(day, start, end);
      check(a == a).isTrue();
    });

    test('instances with the same values are equal', () {
      final WeeklyAvailability a = WeeklyAvailability(day, start, end);
      final WeeklyAvailability b = WeeklyAvailability(day, start, end);
      check(a).equals(b);
    });

    test('instances differing by day are not equal', () {
      final WeeklyAvailability a = WeeklyAvailability(day, start, end);
      final WeeklyAvailability b = WeeklyAvailability(
        DayOfWeek.tuesday,
        start,
        end,
      );
      check(a).not((Subject<WeeklyAvailability> it) => it.equals(b));
    });

    test('instances differing by start are not equal', () {
      final WeeklyAvailability a = WeeklyAvailability(day, start, end);
      final WeeklyAvailability b = WeeklyAvailability(day, const Time(10), end);
      check(a).not((Subject<WeeklyAvailability> it) => it.equals(b));
    });

    test('instances differing by end are not equal', () {
      final WeeklyAvailability a = WeeklyAvailability(day, start, end);
      final WeeklyAvailability b = WeeklyAvailability(
        day,
        start,
        const Time(18),
      );
      check(a).not((Subject<WeeklyAvailability> it) => it.equals(b));
    });
  });

  group('compareTo()', () {
    test('returns 0 for the identical instance', () {
      final WeeklyAvailability a = WeeklyAvailability(day, start, end);
      check(a.compareTo(a)).equals(0);
    });

    test('returns 0 for equal instances', () {
      final WeeklyAvailability a = WeeklyAvailability(day, start, end);
      final WeeklyAvailability b = WeeklyAvailability(day, start, end);
      check(a.compareTo(b)).equals(0);
    });

    test('returns negative when day is earlier', () {
      final WeeklyAvailability a = WeeklyAvailability(
        DayOfWeek.monday,
        start,
        end,
      );
      final WeeklyAvailability b = WeeklyAvailability(
        DayOfWeek.tuesday,
        start,
        end,
      );
      check(a.compareTo(b)).isNegative();
    });

    test('returns positive when day is later', () {
      final WeeklyAvailability a = WeeklyAvailability(
        DayOfWeek.tuesday,
        start,
        end,
      );
      final WeeklyAvailability b = WeeklyAvailability(
        DayOfWeek.monday,
        start,
        end,
      );
      check(a.compareTo(b)).isGreaterThan(0);
    });

    test('returns negative when day is equal but start is earlier', () {
      final WeeklyAvailability a = WeeklyAvailability(day, const Time(8), end);
      final WeeklyAvailability b = WeeklyAvailability(day, const Time(9), end);
      check(a.compareTo(b)).isNegative();
    });

    test('returns negative when day+start are equal but end is earlier', () {
      final WeeklyAvailability a = WeeklyAvailability(
        day,
        start,
        const Time(16),
      );
      final WeeklyAvailability b = WeeklyAvailability(
        day,
        start,
        const Time(17),
      );
      check(a.compareTo(b)).isNegative();
    });
  });

  group('operator <', () {
    test('returns true when this comes before other', () {
      final WeeklyAvailability a = WeeklyAvailability(
        DayOfWeek.monday,
        start,
        end,
      );
      final WeeklyAvailability b = WeeklyAvailability(
        DayOfWeek.friday,
        start,
        end,
      );
      check(a < b).isTrue();
    });

    test('returns false for equal instances', () {
      final WeeklyAvailability a = WeeklyAvailability(day, start, end);
      check(a < a).isFalse();
    });

    test('returns false when this comes after other', () {
      final WeeklyAvailability a = WeeklyAvailability(
        DayOfWeek.friday,
        start,
        end,
      );
      final WeeklyAvailability b = WeeklyAvailability(
        DayOfWeek.monday,
        start,
        end,
      );
      check(a < b).isFalse();
    });
  });

  group('operator <=', () {
    test('returns true for equal instances', () {
      final WeeklyAvailability a = WeeklyAvailability(day, start, end);
      final WeeklyAvailability b = WeeklyAvailability(day, start, end);
      check(a <= b).isTrue();
    });

    test('returns true when this comes before other', () {
      final WeeklyAvailability a = WeeklyAvailability(
        DayOfWeek.monday,
        start,
        end,
      );
      final WeeklyAvailability b = WeeklyAvailability(
        DayOfWeek.tuesday,
        start,
        end,
      );
      check(a <= b).isTrue();
    });

    test('returns false when this comes after other', () {
      final WeeklyAvailability a = WeeklyAvailability(
        DayOfWeek.wednesday,
        start,
        end,
      );
      final WeeklyAvailability b = WeeklyAvailability(
        DayOfWeek.tuesday,
        start,
        end,
      );
      check(a <= b).isFalse();
    });
  });

  group('operator >', () {
    test('returns true when this comes after other', () {
      final WeeklyAvailability a = WeeklyAvailability(
        DayOfWeek.friday,
        start,
        end,
      );
      final WeeklyAvailability b = WeeklyAvailability(
        DayOfWeek.monday,
        start,
        end,
      );
      check(a > b).isTrue();
    });

    test('returns false for equal instances', () {
      final WeeklyAvailability a = WeeklyAvailability(day, start, end);
      check(a > a).isFalse();
    });

    test('returns false when this comes before other', () {
      final WeeklyAvailability a = WeeklyAvailability(
        DayOfWeek.monday,
        start,
        end,
      );
      final WeeklyAvailability b = WeeklyAvailability(
        DayOfWeek.friday,
        start,
        end,
      );
      check(a > b).isFalse();
    });
  });

  group('operator >=', () {
    test('returns true for equal instances', () {
      final WeeklyAvailability a = WeeklyAvailability(day, start, end);
      final WeeklyAvailability b = WeeklyAvailability(day, start, end);
      check(a >= b).isTrue();
    });

    test('returns true when this comes after other', () {
      final WeeklyAvailability a = WeeklyAvailability(
        DayOfWeek.tuesday,
        start,
        end,
      );
      final WeeklyAvailability b = WeeklyAvailability(
        DayOfWeek.monday,
        start,
        end,
      );
      check(a >= b).isTrue();
    });

    test('returns false when this comes before other', () {
      final WeeklyAvailability a = WeeklyAvailability(
        DayOfWeek.monday,
        start,
        end,
      );
      final WeeklyAvailability b = WeeklyAvailability(
        DayOfWeek.tuesday,
        start,
        end,
      );
      check(a >= b).isFalse();
    });
  });

  group('copyWith()', () {
    test('returns an equal instance when no arguments are given', () {
      final WeeklyAvailability original = WeeklyAvailability(day, start, end);
      check(original.copyWith()).equals(original);
    });

    test('replaces day only', () {
      final WeeklyAvailability original = WeeklyAvailability(day, start, end);
      final WeeklyAvailability copy = original.copyWith(day: DayOfWeek.friday);
      check(copy.day).equals(DayOfWeek.friday);
      check(copy.start).equals(start);
      check(copy.end).equals(end);
    });

    test('replaces start only', () {
      final WeeklyAvailability original = WeeklyAvailability(day, start, end);
      const Time newStart = Time(10, 30);
      final WeeklyAvailability copy = original.copyWith(start: newStart);
      check(copy.day).equals(day);
      check(copy.start).equals(newStart);
      check(copy.end).equals(end);
    });

    test('replaces end only', () {
      final WeeklyAvailability original = WeeklyAvailability(day, start, end);
      const Time newEnd = Time(18);
      final WeeklyAvailability copy = original.copyWith(end: newEnd);
      check(copy.day).equals(day);
      check(copy.start).equals(start);
      check(copy.end).equals(newEnd);
    });

    test('replaces all fields', () {
      final WeeklyAvailability original = WeeklyAvailability(day, start, end);
      final WeeklyAvailability copy = original.copyWith(
        day: DayOfWeek.friday,
        start: const Time(10),
        end: const Time(18),
      );
      check(copy.day).equals(DayOfWeek.friday);
      check(copy.start).equals(const Time(10));
      check(copy.end).equals(const Time(18));
    });
  });

  group('toJson()', () {
    test('produces a string containing all expected keys', () {
      final WeeklyAvailability wa = WeeklyAvailability(day, start, end);
      final String json = wa.toJson();
      check(json)
        ..contains('"day"')
        ..contains('"start"')
        ..contains('"end"');
    });

    test('round-trips through fromJson', () {
      final WeeklyAvailability original = WeeklyAvailability(day, start, end);
      final WeeklyAvailability result = WeeklyAvailability.fromJson(
        original.toJson(),
      );
      check(result).equals(original);
    });
  });

  group('toMap()', () {
    test('contains all keys with correct values', () {
      final WeeklyAvailability wa = WeeklyAvailability(day, start, end);
      final Map<String, Object?> map = wa.toMap();
      check(map['day']).equals('monday');
      check(map['start']).equals('T09:00:00');
      check(map['end']).equals('T17:00:00');
    });

    test('emits keys in order: day, end, start', () {
      final WeeklyAvailability wa = WeeklyAvailability(day, start, end);
      final List<String> keys = wa.toMap().keys.toList();
      check(keys).deepEquals(<String>['day', 'end', 'start']);
    });
  });

  group('toString()', () {
    test('produces the pipe-delimited format day|start|end', () {
      final WeeklyAvailability wa = WeeklyAvailability(day, start, end);
      check(wa.toString()).equals('monday|T09:00:00|T17:00:00');
    });

    test('uses lowercase for the day name', () {
      final WeeklyAvailability wa = WeeklyAvailability(
        DayOfWeek.friday,
        start,
        end,
      );
      check(wa.toString()).startsWith('friday');
    });
  });
}
