import 'package:scheduler/src/models/assignment.dart';
import 'package:test/test.dart';

void main() {
  final DateTime earlier = DateTime.utc(2026, 1, 1, 9);
  final DateTime later = DateTime.utc(2026, 1, 1, 10);

  group('Assignment — default constructor', () {
    test('stores the title as given', () {
      final Assignment a = Assignment(
        title: 'Talk',
        start: earlier,
        end: later,
      );
      expect(a.title, equals('Talk'));
    });

    test('stores start and end unchanged when already in order', () {
      final Assignment a = Assignment(
        title: 'Talk',
        start: earlier,
        end: later,
      );
      expect(a.start, equals(earlier));
      expect(a.end, equals(later));
    });

    test('swaps start and end when passed in reverse order', () {
      final Assignment a = Assignment(
        title: 'Talk',
        start: later,
        end: earlier,
      );
      expect(a.start, equals(earlier));
      expect(a.end, equals(later));
    });

    test('accepts equal start and end (zero-length assignment)', () {
      final Assignment a = Assignment(
        title: 'Talk',
        start: earlier,
        end: earlier,
      );
      expect(a.start, equals(earlier));
      expect(a.end, equals(earlier));
    });

    test('accepts an empty title', () {
      final Assignment a = Assignment(title: '', start: earlier, end: later);
      expect(a.title, equals(''));
    });
  });

  group('Assignment.className', () {
    test('is "Assignment"', () {
      expect(Assignment.className, equals('Assignment'));
    });
  });

  group('Assignment.fromMap', () {
    test('parses a valid map', () {
      final Map<String, Object?> map = <String, Object?>{
        'title': 'Talk',
        'start': earlier.toIso8601String(),
        'end': later.toIso8601String(),
      };
      final Assignment a = Assignment.fromMap(map);
      expect(a.title, equals('Talk'));
      expect(a.start, equals(earlier));
      expect(a.end, equals(later));
    });

    test('normalizes reversed start/end from the map', () {
      final Map<String, Object?> map = <String, Object?>{
        'title': 'Talk',
        'start': later.toIso8601String(),
        'end': earlier.toIso8601String(),
      };
      final Assignment a = Assignment.fromMap(map);
      expect(a.start, equals(earlier));
      expect(a.end, equals(later));
    });

    test('throws FormatException when title is missing', () {
      final Map<String, Object?> map = <String, Object?>{
        'start': earlier.toIso8601String(),
        'end': later.toIso8601String(),
      };
      expect(() => Assignment.fromMap(map), throwsA(isA<FormatException>()));
    });

    test('throws FormatException when title has the wrong type', () {
      final Map<String, Object?> map = <String, Object?>{
        'title': 1,
        'start': earlier.toIso8601String(),
        'end': later.toIso8601String(),
      };
      expect(() => Assignment.fromMap(map), throwsA(isA<FormatException>()));
    });

    test('throws FormatException when start is missing', () {
      final Map<String, Object?> map = <String, Object?>{
        'title': 'Talk',
        'end': later.toIso8601String(),
      };
      expect(() => Assignment.fromMap(map), throwsA(isA<FormatException>()));
    });

    test('throws FormatException when end is missing', () {
      final Map<String, Object?> map = <String, Object?>{
        'title': 'Talk',
        'start': earlier.toIso8601String(),
      };
      expect(() => Assignment.fromMap(map), throwsA(isA<FormatException>()));
    });

    test('throws FormatException when start is not a parseable date', () {
      final Map<String, Object?> map = <String, Object?>{
        'title': 'Talk',
        'start': 'not-a-date',
        'end': later.toIso8601String(),
      };
      expect(() => Assignment.fromMap(map), throwsA(isA<FormatException>()));
    });

    test('throws FormatException when end is not a parseable date', () {
      final Map<String, Object?> map = <String, Object?>{
        'title': 'Talk',
        'start': earlier.toIso8601String(),
        'end': 'not-a-date',
      };
      expect(() => Assignment.fromMap(map), throwsA(isA<FormatException>()));
    });
  });

  group('Assignment.fromJson', () {
    test('parses a valid JSON string', () {
      final Assignment original = Assignment(
        title: 'Talk',
        start: earlier,
        end: later,
      );
      final Assignment parsed = Assignment.fromJson(original.toJson());
      expect(parsed, equals(original));
    });

    test('throws FormatException for malformed JSON', () {
      expect(
        () => Assignment.fromJson('{not valid json'),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws FormatException when JSON decodes to a non-map', () {
      expect(
        () => Assignment.fromJson('[1, 2, 3]'),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws FormatException when JSON decodes to a string', () {
      expect(
        () => Assignment.fromJson('"just a string"'),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws FormatException when JSON decodes to a number', () {
      expect(() => Assignment.fromJson('42'), throwsA(isA<FormatException>()));
    });

    test('throws FormatException when JSON map is missing fields', () {
      expect(
        () => Assignment.fromJson('{"title": "Talk"}'),
        throwsA(isA<FormatException>()),
      );
    });

    test('FormatException message contains the class name', () {
      expect(
        () => Assignment.fromJson('{not valid json'),
        throwsA(
          isA<FormatException>().having(
            (final FormatException e) => e.message,
            'message',
            contains('Assignment'),
          ),
        ),
      );
    });
  });

  group('Assignment.parse', () {
    test('parses a valid formatted string', () {
      final String formatted =
          'Talk|${earlier.toIso8601String()}|${later.toIso8601String()}';
      final Assignment a = Assignment.parse(formatted);
      expect(a.title, equals('Talk'));
      expect(a.start, equals(earlier));
      expect(a.end, equals(later));
    });

    test('trims surrounding whitespace before splitting', () {
      final String formatted =
          '  Talk|${earlier.toIso8601String()}|'
          '${later.toIso8601String()}  ';
      final Assignment a = Assignment.parse(formatted);
      expect(a.title, equals('Talk'));
    });

    test('normalizes reversed start/end', () {
      final String formatted =
          'Talk|${later.toIso8601String()}|${earlier.toIso8601String()}';
      final Assignment a = Assignment.parse(formatted);
      expect(a.start, equals(earlier));
      expect(a.end, equals(later));
    });

    test('throws FormatException when there are too few segments', () {
      expect(
        () => Assignment.parse('Talk|${earlier.toIso8601String()}'),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws FormatException when there are too many segments', () {
      final String formatted =
          'Talk|${earlier.toIso8601String()}|'
          '${later.toIso8601String()}|extra';
      expect(
        () => Assignment.parse(formatted),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws FormatException for empty string', () {
      expect(() => Assignment.parse(''), throwsA(isA<FormatException>()));
    });

    test('throws FormatException when start is not a valid date', () {
      final String formatted = 'Talk|not-a-date|${later.toIso8601String()}';
      expect(
        () => Assignment.parse(formatted),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws FormatException when end is not a valid date', () {
      final String formatted = 'Talk|${earlier.toIso8601String()}|not-a-date';
      expect(
        () => Assignment.parse(formatted),
        throwsA(isA<FormatException>()),
      );
    });

    test('FormatException message contains the class name', () {
      expect(
        () => Assignment.parse(''),
        throwsA(
          isA<FormatException>().having(
            (final FormatException e) => e.message,
            'message',
            contains('Assignment'),
          ),
        ),
      );
    });

    test('FormatException source is the original string', () {
      expect(
        () => Assignment.parse('invalid'),
        throwsA(
          isA<FormatException>().having(
            (final FormatException e) => e.source,
            'source',
            equals('invalid'),
          ),
        ),
      );
    });
  });

  group('Assignment — parse/toString round-trip', () {
    test('an assignment survives a parse(toString()) round-trip', () {
      final Assignment original = Assignment(
        title: 'Talk',
        start: earlier,
        end: later,
      );
      final Assignment parsed = Assignment.parse(original.toString());
      expect(parsed, equals(original));
    });
  });

  group('Assignment — fromMap/toMap round-trip', () {
    test('an assignment survives a fromMap(toMap()) round-trip', () {
      final Assignment original = Assignment(
        title: 'Talk',
        start: earlier,
        end: later,
      );
      final Assignment parsed = Assignment.fromMap(original.toMap());
      expect(parsed, equals(original));
    });
  });

  group('Assignment — fromJson/toJson round-trip', () {
    test('an assignment survives a fromJson(toJson()) round-trip', () {
      final Assignment original = Assignment(
        title: 'Talk',
        start: earlier,
        end: later,
      );
      final Assignment parsed = Assignment.fromJson(original.toJson());
      expect(parsed, equals(original));
    });
  });

  group('Assignment.toMap', () {
    test('returns a map with the expected keys', () {
      final Assignment a = Assignment(
        title: 'Talk',
        start: earlier,
        end: later,
      );
      expect(
        a.toMap(),
        equals(<String, Object?>{
          'title': 'Talk',
          'start': earlier.toIso8601String(),
          'end': later.toIso8601String(),
        }),
      );
    });
  });

  group('Assignment.toString', () {
    test('joins title, start, and end with a pipe separator', () {
      final Assignment a = Assignment(
        title: 'Talk',
        start: earlier,
        end: later,
      );
      expect(
        a.toString(),
        equals('Talk|${earlier.toIso8601String()}|${later.toIso8601String()}'),
      );
    });
  });

  group('Assignment.copyWith', () {
    final Assignment original = Assignment(
      title: 'Talk',
      start: earlier,
      end: later,
    );

    test('returns an identical copy when no arguments are given', () {
      expect(original.copyWith(), equals(original));
    });

    test('replaces only the title', () {
      final Assignment copy = original.copyWith(title: 'Meeting');
      expect(copy.title, equals('Meeting'));
      expect(copy.start, equals(original.start));
      expect(copy.end, equals(original.end));
    });

    test('replaces only the start', () {
      final DateTime newStart = DateTime.utc(2026, 1, 1, 8);
      final Assignment copy = original.copyWith(start: newStart);
      expect(copy.start, equals(newStart));
      expect(copy.title, equals(original.title));
      expect(copy.end, equals(original.end));
    });

    test('replaces only the end', () {
      final DateTime newEnd = DateTime.utc(2026, 1, 1, 11);
      final Assignment copy = original.copyWith(end: newEnd);
      expect(copy.end, equals(newEnd));
      expect(copy.title, equals(original.title));
      expect(copy.start, equals(original.start));
    });

    test('replaces all fields at once', () {
      final DateTime newStart = DateTime.utc(2026, 2, 1, 8);
      final DateTime newEnd = DateTime.utc(2026, 2, 1, 9);
      final Assignment copy = original.copyWith(
        title: 'Meeting',
        start: newStart,
        end: newEnd,
      );
      expect(copy.title, equals('Meeting'));
      expect(copy.start, equals(newStart));
      expect(copy.end, equals(newEnd));
    });

    test('normalizes a reversed start/end passed to copyWith', () {
      final Assignment copy = original.copyWith(start: later, end: earlier);
      expect(copy.start, equals(earlier));
      expect(copy.end, equals(later));
    });

    test('does not mutate the original instance', () {
      original.copyWith(title: 'Meeting');
      expect(original.title, equals('Talk'));
    });
  });

  group('Assignment.compareTo', () {
    test('an assignment compared to itself returns 0', () {
      final Assignment a = Assignment(
        title: 'Talk',
        start: earlier,
        end: later,
      );
      expect(a.compareTo(a), equals(0));
    });

    test('two distinct but identical assignments return 0', () {
      final Assignment a = Assignment(
        title: 'Talk',
        start: earlier,
        end: later,
      );
      final Assignment b = Assignment(
        title: 'Talk',
        start: earlier,
        end: later,
      );
      expect(a.compareTo(b), equals(0));
    });

    test('compares by title first', () {
      final Assignment a = Assignment(
        title: 'Alpha',
        start: earlier,
        end: later,
      );
      final Assignment b = Assignment(
        title: 'Beta',
        start: earlier,
        end: later,
      );
      expect(a.compareTo(b), isNegative);
      expect(b.compareTo(a), isPositive);
    });

    test('compares by start when titles are equal', () {
      final DateTime earlierStart = DateTime.utc(2026, 1, 1, 8);
      final Assignment a = Assignment(
        title: 'Talk',
        start: earlierStart,
        end: later,
      );
      final Assignment b = Assignment(
        title: 'Talk',
        start: earlier,
        end: later,
      );
      expect(a.compareTo(b), isNegative);
      expect(b.compareTo(a), isPositive);
    });

    test('compares by end when titles and starts are equal', () {
      final DateTime laterEnd = DateTime.utc(2026, 1, 1, 11);
      final Assignment a = Assignment(
        title: 'Talk',
        start: earlier,
        end: later,
      );
      final Assignment b = Assignment(
        title: 'Talk',
        start: earlier,
        end: laterEnd,
      );
      expect(a.compareTo(b), isNegative);
      expect(b.compareTo(a), isPositive);
    });

    test('is antisymmetric', () {
      final Assignment a = Assignment(
        title: 'Alpha',
        start: earlier,
        end: later,
      );
      final Assignment b = Assignment(
        title: 'Beta',
        start: earlier,
        end: later,
      );
      expect(a.compareTo(b).sign, equals(-b.compareTo(a).sign));
    });

    test('is transitive', () {
      final Assignment a = Assignment(
        title: 'Alpha',
        start: earlier,
        end: later,
      );
      final Assignment b = Assignment(
        title: 'Beta',
        start: earlier,
        end: later,
      );
      final Assignment c = Assignment(
        title: 'Gamma',
        start: earlier,
        end: later,
      );
      expect(a.compareTo(b), isNegative);
      expect(b.compareTo(c), isNegative);
      expect(a.compareTo(c), isNegative);
    });
  });

  group('Assignment operator <', () {
    final Assignment a = Assignment(title: 'Alpha', start: earlier, end: later);
    final Assignment b = Assignment(title: 'Beta', start: earlier, end: later);

    test('is true when this assignment comes before the other', () {
      expect(a < b, isTrue);
    });

    test('is false when this assignment comes after the other', () {
      expect(b < a, isFalse);
    });

    test('is false when the assignments are equal', () {
      expect(a < a, isFalse);
    });
  });

  group('Assignment operator <=', () {
    final Assignment a = Assignment(title: 'Alpha', start: earlier, end: later);
    final Assignment b = Assignment(title: 'Beta', start: earlier, end: later);

    test('is true when this assignment comes before the other', () {
      expect(a <= b, isTrue);
    });

    test('is false when this assignment comes after the other', () {
      expect(b <= a, isFalse);
    });

    test('is true when the assignments are equal', () {
      expect(a <= a, isTrue);
    });
  });

  group('Assignment operator >', () {
    final Assignment a = Assignment(title: 'Alpha', start: earlier, end: later);
    final Assignment b = Assignment(title: 'Beta', start: earlier, end: later);

    test('is true when this assignment comes after the other', () {
      expect(b > a, isTrue);
    });

    test('is false when this assignment comes before the other', () {
      expect(a > b, isFalse);
    });

    test('is false when the assignments are equal', () {
      expect(a > a, isFalse);
    });
  });

  group('Assignment operator >=', () {
    final Assignment a = Assignment(title: 'Alpha', start: earlier, end: later);
    final Assignment b = Assignment(title: 'Beta', start: earlier, end: later);

    test('is true when this assignment comes after the other', () {
      expect(b >= a, isTrue);
    });

    test('is false when this assignment comes before the other', () {
      expect(a >= b, isFalse);
    });

    test('is true when the assignments are equal', () {
      expect(a >= a, isTrue);
    });
  });

  group('Assignment operator ==', () {
    test('an assignment is equal to itself', () {
      final Assignment a = Assignment(
        title: 'Talk',
        start: earlier,
        end: later,
      );
      expect(a == a, isTrue);
    });

    test('two distinct instances with the same fields are equal', () {
      final Assignment a = Assignment(
        title: 'Talk',
        start: earlier,
        end: later,
      );
      final Assignment b = Assignment(
        title: 'Talk',
        start: earlier,
        end: later,
      );
      expect(a == b, isTrue);
    });

    test('assignments with different titles are not equal', () {
      final Assignment a = Assignment(
        title: 'Talk',
        start: earlier,
        end: later,
      );
      final Assignment b = Assignment(
        title: 'Meeting',
        start: earlier,
        end: later,
      );
      expect(a == b, isFalse);
    });

    test('assignments with different starts are not equal', () {
      final DateTime otherStart = DateTime.utc(2026, 1, 1, 8);
      final Assignment a = Assignment(
        title: 'Talk',
        start: earlier,
        end: later,
      );
      final Assignment b = Assignment(
        title: 'Talk',
        start: otherStart,
        end: later,
      );
      expect(a == b, isFalse);
    });

    test('assignments with different ends are not equal', () {
      final DateTime otherEnd = DateTime.utc(2026, 1, 1, 11);
      final Assignment a = Assignment(
        title: 'Talk',
        start: earlier,
        end: later,
      );
      final Assignment b = Assignment(
        title: 'Talk',
        start: earlier,
        end: otherEnd,
      );
      expect(a == b, isFalse);
    });

    test('an assignment is not equal to an unrelated type', () {
      final Assignment a = Assignment(
        title: 'Talk',
        start: earlier,
        end: later,
      );
      // ignore: unrelated_type_equality_checks
      expect(a == 'Talk', isFalse);
    });

    test('an assignment is not equal to null', () {
      final Assignment a = Assignment(
        title: 'Talk',
        start: earlier,
        end: later,
      );
      // ignore: unnecessary_null_comparison
      expect(a == null, isFalse);
    });
  });

  group('Assignment.hashCode', () {
    test('equal assignments have equal hash codes', () {
      final Assignment a = Assignment(
        title: 'Talk',
        start: earlier,
        end: later,
      );
      final Assignment b = Assignment(
        title: 'Talk',
        start: earlier,
        end: later,
      );
      expect(a.hashCode, equals(b.hashCode));
    });

    test('is stable across multiple accesses', () {
      final Assignment a = Assignment(
        title: 'Talk',
        start: earlier,
        end: later,
      );
      expect(a.hashCode, equals(a.hashCode));
    });

    test('differing assignments are likely to have different hash codes', () {
      final Assignment a = Assignment(
        title: 'Talk',
        start: earlier,
        end: later,
      );
      final Assignment b = Assignment(
        title: 'Meeting',
        start: earlier,
        end: later,
      );
      expect(a.hashCode, isNot(equals(b.hashCode)));
    });
  });

  group('Assignment — set membership consistency', () {
    test('a Set treats equal assignments as duplicates', () {
      final Assignment a = Assignment(
        title: 'Talk',
        start: earlier,
        end: later,
      );
      final Assignment b = Assignment(
        title: 'Talk',
        start: earlier,
        end: later,
      );
      final Set<Assignment> set = <Assignment>{a, b};
      expect(set, hasLength(1));
    });

    test('sorting by compareTo orders by title, start, and end', () {
      final Assignment a = Assignment(
        title: 'Beta',
        start: earlier,
        end: later,
      );
      final Assignment b = Assignment(
        title: 'Alpha',
        start: earlier,
        end: later,
      );
      final List<Assignment> sorted = List<Assignment>.from(<Assignment>[a, b])
        ..sort((final Assignment x, final Assignment y) => x.compareTo(y));
      expect(sorted, equals(<Assignment>[b, a]));
    });
  });
}
