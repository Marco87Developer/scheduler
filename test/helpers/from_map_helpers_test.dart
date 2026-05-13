import 'dart:collection';

import 'package:scheduler/src/helpers/from_map_helpers.dart';
import 'package:test/test.dart';

void main() {
  group('parseBoolean — bool values', () {
    test('true returns true', () {
      expect(
        parseBoolean(
          className: 'C',
          map: <String, Object?>{'k': true},
          key: 'k',
        ),
        isTrue,
      );
    });

    test('false returns false', () {
      expect(
        parseBoolean(
          className: 'C',
          map: <String, Object?>{'k': false},
          key: 'k',
        ),
        isFalse,
      );
    });
  });

  group('parseBoolean — string values', () {
    test('"true" returns true', () {
      expect(
        parseBoolean(
          className: 'C',
          map: <String, Object?>{'k': 'true'},
          key: 'k',
        ),
        isTrue,
      );
    });

    test('"false" returns false', () {
      expect(
        parseBoolean(
          className: 'C',
          map: <String, Object?>{'k': 'false'},
          key: 'k',
        ),
        isFalse,
      );
    });

    test('"TRUE" returns true (case-insensitive)', () {
      expect(
        parseBoolean(
          className: 'C',
          map: <String, Object?>{'k': 'TRUE'},
          key: 'k',
        ),
        isTrue,
      );
    });

    test('"FALSE" returns false (case-insensitive)', () {
      expect(
        parseBoolean(
          className: 'C',
          map: <String, Object?>{'k': 'FALSE'},
          key: 'k',
        ),
        isFalse,
      );
    });

    test('"True" returns true (mixed case)', () {
      expect(
        parseBoolean(
          className: 'C',
          map: <String, Object?>{'k': 'True'},
          key: 'k',
        ),
        isTrue,
      );
    });

    test('"False" returns false (mixed case)', () {
      expect(
        parseBoolean(
          className: 'C',
          map: <String, Object?>{'k': 'False'},
          key: 'k',
        ),
        isFalse,
      );
    });
  });

  group('parseBoolean — invalid values throw FormatException', () {
    test('null value throws', () {
      expect(
        () => parseBoolean(
          className: 'C',
          map: <String, Object?>{'k': null},
          key: 'k',
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('absent key throws', () {
      expect(
        () => parseBoolean(className: 'C', map: <String, Object?>{}, key: 'k'),
        throwsA(isA<FormatException>()),
      );
    });

    test('int value throws', () {
      expect(
        () => parseBoolean(
          className: 'C',
          map: <String, Object?>{'k': 1},
          key: 'k',
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('"yes" throws', () {
      expect(
        () => parseBoolean(
          className: 'C',
          map: <String, Object?>{'k': 'yes'},
          key: 'k',
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('"null" string throws (not nullable variant)', () {
      expect(
        () => parseBoolean(
          className: 'C',
          map: <String, Object?>{'k': 'null'},
          key: 'k',
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('list value throws', () {
      expect(
        () => parseBoolean(
          className: 'C',
          map: <String, Object?>{
            'k': <Object?>[true],
          },
          key: 'k',
        ),
        throwsA(isA<FormatException>()),
      );
    });
  });

  group('parseBoolean — FormatException details', () {
    test('message contains className', () {
      expect(
        () => parseBoolean(
          className: 'MyClass',
          map: <String, Object?>{'k': null},
          key: 'k',
        ),
        throwsA(_fmtMsgContains('MyClass')),
      );
    });

    test('message contains key', () {
      expect(
        () => parseBoolean(
          className: 'C',
          map: <String, Object?>{'myKey': null},
          key: 'myKey',
        ),
        throwsA(_fmtMsgContains('myKey')),
      );
    });

    test('message has exact format', () {
      expect(
        () => parseBoolean(
          className: 'Cls',
          map: <String, Object?>{'k': null},
          key: 'k',
        ),
        throwsA(_fmtMsgEquals(_msg('Cls', 'k'))),
      );
    });

    test('source is the map', () {
      final Map<String, Object?> m = <String, Object?>{'k': 42};
      expect(
        () => parseBoolean(className: 'C', map: m, key: 'k'),
        throwsA(_fmtSource(m)),
      );
    });
  });

  group('parseBooleanNullable — null values return null', () {
    test('null value returns null', () {
      expect(
        parseBooleanNullable(
          className: 'C',
          map: <String, Object?>{'k': null},
          key: 'k',
        ),
        isNull,
      );
    });

    test('absent key returns null', () {
      expect(
        parseBooleanNullable(
          className: 'C',
          map: <String, Object?>{},
          key: 'k',
        ),
        isNull,
      );
    });

    test('"null" string returns null', () {
      expect(
        parseBooleanNullable(
          className: 'C',
          map: <String, Object?>{'k': 'null'},
          key: 'k',
        ),
        isNull,
      );
    });
  });

  group('parseBooleanNullable — bool values', () {
    test('true returns true', () {
      expect(
        parseBooleanNullable(
          className: 'C',
          map: <String, Object?>{'k': true},
          key: 'k',
        ),
        isTrue,
      );
    });

    test('false returns false', () {
      expect(
        parseBooleanNullable(
          className: 'C',
          map: <String, Object?>{'k': false},
          key: 'k',
        ),
        isFalse,
      );
    });
  });

  group('parseBooleanNullable — string values', () {
    test('"true" returns true', () {
      expect(
        parseBooleanNullable(
          className: 'C',
          map: <String, Object?>{'k': 'true'},
          key: 'k',
        ),
        isTrue,
      );
    });

    test('"false" returns false', () {
      expect(
        parseBooleanNullable(
          className: 'C',
          map: <String, Object?>{'k': 'false'},
          key: 'k',
        ),
        isFalse,
      );
    });

    test('"TRUE" returns true (case-insensitive)', () {
      expect(
        parseBooleanNullable(
          className: 'C',
          map: <String, Object?>{'k': 'TRUE'},
          key: 'k',
        ),
        isTrue,
      );
    });

    test('"FALSE" returns false (case-insensitive)', () {
      expect(
        parseBooleanNullable(
          className: 'C',
          map: <String, Object?>{'k': 'FALSE'},
          key: 'k',
        ),
        isFalse,
      );
    });
  });

  group('parseBooleanNullable — invalid values throw FormatException', () {
    test('int value throws', () {
      expect(
        () => parseBooleanNullable(
          className: 'C',
          map: <String, Object?>{'k': 1},
          key: 'k',
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('"yes" throws', () {
      expect(
        () => parseBooleanNullable(
          className: 'C',
          map: <String, Object?>{'k': 'yes'},
          key: 'k',
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('source is the map', () {
      final Map<String, Object?> m = <String, Object?>{'k': 'bad'};
      expect(
        () => parseBooleanNullable(className: 'C', map: m, key: 'k'),
        throwsA(_fmtSource(m)),
      );
    });
  });

  group('parseClass — valid values', () {
    test('parses int to String via parser', () {
      expect(
        parseClass<String, int>(
          className: 'C',
          map: <String, Object?>{'k': 42},
          key: 'k',
          parser: _intToString,
        ),
        equals('42'),
      );
    });

    test('parser result is returned verbatim', () {
      expect(
        parseClass<int, int>(
          className: 'C',
          map: <String, Object?>{'k': 7},
          key: 'k',
          parser: (final int v) => v * 2,
        ),
        equals(14),
      );
    });

    test('String value with String parser', () {
      expect(
        parseClass<String, String>(
          className: 'C',
          map: <String, Object?>{'k': 'hello'},
          key: 'k',
          parser: _identityString,
        ),
        equals('hello'),
      );
    });
  });

  group('parseClass — invalid values throw FormatException', () {
    test('wrong type throws', () {
      expect(
        () => parseClass<String, int>(
          className: 'C',
          map: <String, Object?>{'k': 'not an int'},
          key: 'k',
          parser: _intToString,
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('null value throws', () {
      expect(
        () => parseClass<String, int>(
          className: 'C',
          map: <String, Object?>{'k': null},
          key: 'k',
          parser: _intToString,
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('absent key throws', () {
      expect(
        () => parseClass<String, int>(
          className: 'C',
          map: <String, Object?>{},
          key: 'k',
          parser: _intToString,
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('"null" string throws (not nullable variant)', () {
      expect(
        () => parseClass<String, int>(
          className: 'C',
          map: <String, Object?>{'k': 'null'},
          key: 'k',
          parser: _intToString,
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('message has exact format', () {
      expect(
        () => parseClass<String, int>(
          className: 'Cls',
          map: <String, Object?>{'k': 'bad'},
          key: 'k',
          parser: _intToString,
        ),
        throwsA(_fmtMsgEquals(_msg('Cls', 'k'))),
      );
    });

    test('source is the map', () {
      final Map<String, Object?> m = <String, Object?>{'k': 'bad'};
      expect(
        () => parseClass<String, int>(
          className: 'C',
          map: m,
          key: 'k',
          parser: _intToString,
        ),
        throwsA(_fmtSource(m)),
      );
    });
  });

  group('parseClassNullable — null values return null', () {
    test('null value returns null', () {
      expect(
        parseClassNullable<String, int>(
          className: 'C',
          map: <String, Object?>{'k': null},
          key: 'k',
          parser: _intToString,
        ),
        isNull,
      );
    });

    test('absent key returns null', () {
      expect(
        parseClassNullable<String, int>(
          className: 'C',
          map: <String, Object?>{},
          key: 'k',
          parser: _intToString,
        ),
        isNull,
      );
    });

    test('"null" string returns null', () {
      expect(
        parseClassNullable<String, int>(
          className: 'C',
          map: <String, Object?>{'k': 'null'},
          key: 'k',
          parser: _intToString,
        ),
        isNull,
      );
    });
  });

  group('parseClassNullable — valid values', () {
    test('int value is parsed', () {
      expect(
        parseClassNullable<String, int>(
          className: 'C',
          map: <String, Object?>{'k': 5},
          key: 'k',
          parser: _intToString,
        ),
        equals('5'),
      );
    });
  });

  group('parseClassNullable — invalid values throw FormatException', () {
    test('wrong type throws', () {
      expect(
        () => parseClassNullable<String, int>(
          className: 'C',
          map: <String, Object?>{'k': 'bad'},
          key: 'k',
          parser: _intToString,
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('source is the map', () {
      final Map<String, Object?> m = <String, Object?>{'k': 3.14};
      expect(
        () => parseClassNullable<String, int>(
          className: 'C',
          map: m,
          key: 'k',
          parser: _intToString,
        ),
        throwsA(_fmtSource(m)),
      );
    });
  });

  group('parseDouble — valid values', () {
    test('double value is returned', () {
      expect(
        parseDouble(
          className: 'C',
          map: <String, Object?>{'k': 3.14},
          key: 'k',
        ),
        equals(3.14),
      );
    });

    test('int value is promoted to double', () {
      expect(
        parseDouble(className: 'C', map: <String, Object?>{'k': 42}, key: 'k'),
        equals(42.0),
      );
    });

    test('promoted int returns a double type', () {
      expect(
        parseDouble(className: 'C', map: <String, Object?>{'k': 1}, key: 'k'),
        isA<double>(),
      );
    });

    test('zero int is promoted to 0.0', () {
      expect(
        parseDouble(className: 'C', map: <String, Object?>{'k': 0}, key: 'k'),
        equals(0.0),
      );
    });

    test('negative double is returned', () {
      expect(
        parseDouble(
          className: 'C',
          map: <String, Object?>{'k': -1.5},
          key: 'k',
        ),
        equals(-1.5),
      );
    });

    test('negative int is promoted to negative double', () {
      expect(
        parseDouble(className: 'C', map: <String, Object?>{'k': -3}, key: 'k'),
        equals(-3.0),
      );
    });
  });

  group('parseDouble — invalid values throw FormatException', () {
    test('null throws', () {
      expect(
        () => parseDouble(
          className: 'C',
          map: <String, Object?>{'k': null},
          key: 'k',
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('absent key throws', () {
      expect(
        () => parseDouble(className: 'C', map: <String, Object?>{}, key: 'k'),
        throwsA(isA<FormatException>()),
      );
    });

    test('string throws', () {
      expect(
        () => parseDouble(
          className: 'C',
          map: <String, Object?>{'k': '1.0'},
          key: 'k',
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('bool throws', () {
      expect(
        () => parseDouble(
          className: 'C',
          map: <String, Object?>{'k': true},
          key: 'k',
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('message has exact format', () {
      expect(
        () => parseDouble(
          className: 'Cls',
          map: <String, Object?>{'k': null},
          key: 'k',
        ),
        throwsA(_fmtMsgEquals(_msg('Cls', 'k'))),
      );
    });

    test('source is the map', () {
      final Map<String, Object?> m = <String, Object?>{'k': 'bad'};
      expect(
        () => parseDouble(className: 'C', map: m, key: 'k'),
        throwsA(_fmtSource(m)),
      );
    });
  });

  group('parseDoubleNullable — null values return null', () {
    test('null value returns null', () {
      expect(
        parseDoubleNullable(
          className: 'C',
          map: <String, Object?>{'k': null},
          key: 'k',
        ),
        isNull,
      );
    });

    test('absent key returns null', () {
      expect(
        parseDoubleNullable(className: 'C', map: <String, Object?>{}, key: 'k'),
        isNull,
      );
    });

    test('"null" string returns null', () {
      expect(
        parseDoubleNullable(
          className: 'C',
          map: <String, Object?>{'k': 'null'},
          key: 'k',
        ),
        isNull,
      );
    });
  });

  group('parseDoubleNullable — valid values', () {
    test('double value is returned', () {
      expect(
        parseDoubleNullable(
          className: 'C',
          map: <String, Object?>{'k': 2.71},
          key: 'k',
        ),
        equals(2.71),
      );
    });

    test('int value is promoted to double', () {
      expect(
        parseDoubleNullable(
          className: 'C',
          map: <String, Object?>{'k': 10},
          key: 'k',
        ),
        equals(10.0),
      );
    });
  });

  group('parseDoubleNullable — invalid values throw FormatException', () {
    test('string throws', () {
      expect(
        () => parseDoubleNullable(
          className: 'C',
          map: <String, Object?>{'k': '2.0'},
          key: 'k',
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('bool throws', () {
      expect(
        () => parseDoubleNullable(
          className: 'C',
          map: <String, Object?>{'k': true},
          key: 'k',
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('source is the map', () {
      final Map<String, Object?> m = <String, Object?>{'k': 'bad'};
      expect(
        () => parseDoubleNullable(className: 'C', map: m, key: 'k'),
        throwsA(_fmtSource(m)),
      );
    });
  });

  group('parseInt — valid values', () {
    test('positive int is returned', () {
      expect(
        parseInt(className: 'C', map: <String, Object?>{'k': 7}, key: 'k'),
        equals(7),
      );
    });

    test('zero is returned', () {
      expect(
        parseInt(className: 'C', map: <String, Object?>{'k': 0}, key: 'k'),
        equals(0),
      );
    });

    test('negative int is returned', () {
      expect(
        parseInt(className: 'C', map: <String, Object?>{'k': -5}, key: 'k'),
        equals(-5),
      );
    });
  });

  group('parseInt — invalid values throw FormatException', () {
    test('double throws (not promoted)', () {
      expect(
        () => parseInt(
          className: 'C',
          map: <String, Object?>{'k': 1.0},
          key: 'k',
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('null throws', () {
      expect(
        () => parseInt(
          className: 'C',
          map: <String, Object?>{'k': null},
          key: 'k',
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('absent key throws', () {
      expect(
        () => parseInt(className: 'C', map: <String, Object?>{}, key: 'k'),
        throwsA(isA<FormatException>()),
      );
    });

    test('string throws', () {
      expect(
        () => parseInt(
          className: 'C',
          map: <String, Object?>{'k': '1'},
          key: 'k',
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('bool throws', () {
      expect(
        () => parseInt(
          className: 'C',
          map: <String, Object?>{'k': true},
          key: 'k',
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('message has exact format', () {
      expect(
        () => parseInt(
          className: 'Cls',
          map: <String, Object?>{'k': null},
          key: 'k',
        ),
        throwsA(_fmtMsgEquals(_msg('Cls', 'k'))),
      );
    });

    test('source is the map', () {
      final Map<String, Object?> m = <String, Object?>{'k': 'bad'};
      expect(
        () => parseInt(className: 'C', map: m, key: 'k'),
        throwsA(_fmtSource(m)),
      );
    });
  });

  group('parseIntNullable — null values return null', () {
    test('null value returns null', () {
      expect(
        parseIntNullable(
          className: 'C',
          map: <String, Object?>{'k': null},
          key: 'k',
        ),
        isNull,
      );
    });

    test('absent key returns null', () {
      expect(
        parseIntNullable(className: 'C', map: <String, Object?>{}, key: 'k'),
        isNull,
      );
    });

    test('"null" string returns null', () {
      expect(
        parseIntNullable(
          className: 'C',
          map: <String, Object?>{'k': 'null'},
          key: 'k',
        ),
        isNull,
      );
    });
  });

  group('parseIntNullable — valid values', () {
    test('positive int is returned', () {
      expect(
        parseIntNullable(
          className: 'C',
          map: <String, Object?>{'k': 99},
          key: 'k',
        ),
        equals(99),
      );
    });

    test('zero is returned', () {
      expect(
        parseIntNullable(
          className: 'C',
          map: <String, Object?>{'k': 0},
          key: 'k',
        ),
        equals(0),
      );
    });

    test('negative int is returned', () {
      expect(
        parseIntNullable(
          className: 'C',
          map: <String, Object?>{'k': -1},
          key: 'k',
        ),
        equals(-1),
      );
    });
  });

  group('parseIntNullable — invalid values throw FormatException', () {
    test('double throws', () {
      expect(
        () => parseIntNullable(
          className: 'C',
          map: <String, Object?>{'k': 1.5},
          key: 'k',
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('string throws', () {
      expect(
        () => parseIntNullable(
          className: 'C',
          map: <String, Object?>{'k': '1'},
          key: 'k',
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('bool throws', () {
      expect(
        () => parseIntNullable(
          className: 'C',
          map: <String, Object?>{'k': false},
          key: 'k',
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('source is the map', () {
      final Map<String, Object?> m = <String, Object?>{'k': 'bad'};
      expect(
        () => parseIntNullable(className: 'C', map: m, key: 'k'),
        throwsA(_fmtSource(m)),
      );
    });
  });

  group('parseObjectListToSplayTreeSet — valid lists', () {
    test('empty list returns empty SplayTreeSet', () {
      expect(
        parseObjectListToSplayTreeSet<num, int>(
          className: 'C',
          map: <String, Object?>{'k': <Object?>[]},
          key: 'k',
          parser: _identityInt,
        ),
        isEmpty,
      );
    });

    test('singleton list returns single-element set', () {
      expect(
        parseObjectListToSplayTreeSet<num, int>(
          className: 'C',
          map: <String, Object?>{
            'k': <Object?>[5],
          },
          key: 'k',
          parser: _identityInt,
        ),
        equals(<int>{5}),
      );
    });

    test('unsorted list is sorted in resulting set', () {
      final SplayTreeSet<num> result = parseObjectListToSplayTreeSet<num, int>(
        className: 'C',
        map: <String, Object?>{
          'k': <Object?>[3, 1, 2],
        },
        key: 'k',
        parser: _identityInt,
      );
      expect(result.toList(), equals(<int>[1, 2, 3]));
    });

    test('duplicates are deduplicated', () {
      final SplayTreeSet<num> result = parseObjectListToSplayTreeSet<num, int>(
        className: 'C',
        map: <String, Object?>{
          'k': <Object?>[1, 1, 2, 2, 3],
        },
        key: 'k',
        parser: _identityInt,
      );
      expect(result.toList(), equals(<int>[1, 2, 3]));
    });

    test('result is a SplayTreeSet', () {
      expect(
        parseObjectListToSplayTreeSet<num, int>(
          className: 'C',
          map: <String, Object?>{
            'k': <Object?>[1, 2],
          },
          key: 'k',
          parser: _identityInt,
        ),
        isA<SplayTreeSet<num>>(),
      );
    });

    test('parser is applied to each element', () {
      final SplayTreeSet<String> result =
          parseObjectListToSplayTreeSet<String, int>(
            className: 'C',
            map: <String, Object?>{
              'k': <Object?>[1, 2, 3],
            },
            key: 'k',
            parser: _intToString,
          );
      expect(result, containsAll(<String>['1', '2', '3']));
    });

    test('negative integers are sorted correctly', () {
      final SplayTreeSet<num> result = parseObjectListToSplayTreeSet<num, int>(
        className: 'C',
        map: <String, Object?>{
          'k': <Object?>[-1, -3, -2],
        },
        key: 'k',
        parser: _identityInt,
      );
      expect(result.toList(), equals(<int>[-3, -2, -1]));
    });
  });

  group('parseObjectListToSplayTreeSet — invalid values throw', () {
    test('null value throws', () {
      expect(
        () => parseObjectListToSplayTreeSet<num, int>(
          className: 'C',
          map: <String, Object?>{'k': null},
          key: 'k',
          parser: _identityInt,
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('absent key throws', () {
      expect(
        () => parseObjectListToSplayTreeSet<num, int>(
          className: 'C',
          map: <String, Object?>{},
          key: 'k',
          parser: _identityInt,
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('non-list value throws', () {
      expect(
        () => parseObjectListToSplayTreeSet<num, int>(
          className: 'C',
          map: <String, Object?>{'k': 42},
          key: 'k',
          parser: _identityInt,
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('list with wrong-type item throws', () {
      expect(
        () => parseObjectListToSplayTreeSet<num, int>(
          className: 'C',
          map: <String, Object?>{
            'k': <Object?>[1, 'bad', 3],
          },
          key: 'k',
          parser: _identityInt,
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('list with null item throws (K=int)', () {
      expect(
        () => parseObjectListToSplayTreeSet<num, int>(
          className: 'C',
          map: <String, Object?>{
            'k': <Object?>[1, null, 3],
          },
          key: 'k',
          parser: _identityInt,
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('message has exact format when outer value is invalid', () {
      expect(
        () => parseObjectListToSplayTreeSet<num, int>(
          className: 'Cls',
          map: <String, Object?>{'k': null},
          key: 'k',
          parser: _identityInt,
        ),
        throwsA(_fmtMsgEquals(_msg('Cls', 'k'))),
      );
    });

    test('source is the map when outer value is invalid', () {
      final Map<String, Object?> m = <String, Object?>{'k': null};
      expect(
        () => parseObjectListToSplayTreeSet<num, int>(
          className: 'C',
          map: m,
          key: 'k',
          parser: _identityInt,
        ),
        throwsA(_fmtSource(m)),
      );
    });

    test('source is the map when item type is wrong', () {
      final Map<String, Object?> m = <String, Object?>{
        'k': <Object?>['bad'],
      };
      expect(
        () => parseObjectListToSplayTreeSet<num, int>(
          className: 'C',
          map: m,
          key: 'k',
          parser: _identityInt,
        ),
        throwsA(_fmtSource(m)),
      );
    });
  });

  group('parseObjectListToSplayTreeSetNullable — null values return null', () {
    test('null value returns null', () {
      expect(
        parseObjectListToSplayTreeSetNullable<num, int>(
          className: 'C',
          map: <String, Object?>{'k': null},
          key: 'k',
          parser: _identityInt,
        ),
        isNull,
      );
    });

    test('absent key returns null', () {
      expect(
        parseObjectListToSplayTreeSetNullable<num, int>(
          className: 'C',
          map: <String, Object?>{},
          key: 'k',
          parser: _identityInt,
        ),
        isNull,
      );
    });

    test('"null" string returns null', () {
      expect(
        parseObjectListToSplayTreeSetNullable<num, int>(
          className: 'C',
          map: <String, Object?>{'k': 'null'},
          key: 'k',
          parser: _identityInt,
        ),
        isNull,
      );
    });
  });

  group('parseObjectListToSplayTreeSetNullable — valid lists', () {
    test('empty list returns empty set', () {
      expect(
        parseObjectListToSplayTreeSetNullable<num, int>(
          className: 'C',
          map: <String, Object?>{'k': <Object?>[]},
          key: 'k',
          parser: _identityInt,
        ),
        isEmpty,
      );
    });

    test('list is sorted in result', () {
      expect(
        parseObjectListToSplayTreeSetNullable<num, int>(
          className: 'C',
          map: <String, Object?>{
            'k': <Object?>[3, 1, 2],
          },
          key: 'k',
          parser: _identityInt,
        ),
        equals(SplayTreeSet<num>.of(<int>[1, 2, 3])),
      );
    });
  });

  group('parseObjectListToSplayTreeSetNullable — invalid values throw', () {
    test('non-list value throws', () {
      expect(
        () => parseObjectListToSplayTreeSetNullable<num, int>(
          className: 'C',
          map: <String, Object?>{'k': 42},
          key: 'k',
          parser: _identityInt,
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('list with wrong-type item throws', () {
      expect(
        () => parseObjectListToSplayTreeSetNullable<num, int>(
          className: 'C',
          map: <String, Object?>{
            'k': <Object?>['bad'],
          },
          key: 'k',
          parser: _identityInt,
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('source is the map', () {
      final Map<String, Object?> m = <String, Object?>{'k': 99};
      expect(
        () => parseObjectListToSplayTreeSetNullable<num, int>(
          className: 'C',
          map: m,
          key: 'k',
          parser: _identityInt,
        ),
        throwsA(_fmtSource(m)),
      );
    });
  });

  group(
    'parseObjectListToSplayTreeSetPossiblyEmpty — null returns empty set',
    () {
      test('null value returns empty set', () {
        expect(
          parseObjectListToSplayTreeSetPossiblyEmpty<num, int>(
            className: 'C',
            map: <String, Object?>{'k': null},
            key: 'k',
            parser: _identityInt,
          ),
          isEmpty,
        );
      });

      test('absent key returns empty set', () {
        expect(
          parseObjectListToSplayTreeSetPossiblyEmpty<num, int>(
            className: 'C',
            map: <String, Object?>{},
            key: 'k',
            parser: _identityInt,
          ),
          isEmpty,
        );
      });

      test('"null" string returns empty set', () {
        expect(
          parseObjectListToSplayTreeSetPossiblyEmpty<num, int>(
            className: 'C',
            map: <String, Object?>{'k': 'null'},
            key: 'k',
            parser: _identityInt,
          ),
          isEmpty,
        );
      });

      test('null returns SplayTreeSet (not just any empty collection)', () {
        expect(
          parseObjectListToSplayTreeSetPossiblyEmpty<num, int>(
            className: 'C',
            map: <String, Object?>{'k': null},
            key: 'k',
            parser: _identityInt,
          ),
          isA<SplayTreeSet<num>>(),
        );
      });
    },
  );

  group('parseObjectListToSplayTreeSetPossiblyEmpty — valid lists', () {
    test('non-null empty list returns empty set', () {
      expect(
        parseObjectListToSplayTreeSetPossiblyEmpty<num, int>(
          className: 'C',
          map: <String, Object?>{'k': <Object?>[]},
          key: 'k',
          parser: _identityInt,
        ),
        isEmpty,
      );
    });

    test('list is sorted in result', () {
      expect(
        parseObjectListToSplayTreeSetPossiblyEmpty<num, int>(
          className: 'C',
          map: <String, Object?>{
            'k': <Object?>[3, 1, 2],
          },
          key: 'k',
          parser: _identityInt,
        ),
        equals(SplayTreeSet<num>.of(<int>[1, 2, 3])),
      );
    });
  });

  group(
    'parseObjectListToSplayTreeSetPossiblyEmpty — invalid values throw',
    () {
      test('non-list, non-null value throws', () {
        expect(
          () => parseObjectListToSplayTreeSetPossiblyEmpty<num, int>(
            className: 'C',
            map: <String, Object?>{'k': true},
            key: 'k',
            parser: _identityInt,
          ),
          throwsA(isA<FormatException>()),
        );
      });

      test('list with wrong-type item throws', () {
        expect(
          () => parseObjectListToSplayTreeSetPossiblyEmpty<num, int>(
            className: 'C',
            map: <String, Object?>{
              'k': <Object?>['bad'],
            },
            key: 'k',
            parser: _identityInt,
          ),
          throwsA(isA<FormatException>()),
        );
      });
    },
  );

  group('parseObjectMapToSplayTreeSet — valid lists', () {
    test('empty list returns empty set', () {
      expect(
        parseObjectMapToSplayTreeSet<String>(
          className: 'C',
          map: <String, Object?>{'k': <Object?>[]},
          key: 'k',
          fromMap: _stringFromMap,
        ),
        isEmpty,
      );
    });

    test('list of maps is parsed and sorted', () {
      final SplayTreeSet<String> result = parseObjectMapToSplayTreeSet<String>(
        className: 'C',
        map: <String, Object?>{
          'k': <Object?>[
            <String, Object?>{'v': 'banana'},
            <String, Object?>{'v': 'apple'},
            <String, Object?>{'v': 'cherry'},
          ],
        },
        key: 'k',
        fromMap: _stringFromMap,
      );
      expect(result.toList(), equals(<String>['apple', 'banana', 'cherry']));
    });

    test('result is a SplayTreeSet', () {
      expect(
        parseObjectMapToSplayTreeSet<String>(
          className: 'C',
          map: <String, Object?>{
            'k': <Object?>[
              <String, Object?>{'v': 'a'},
            ],
          },
          key: 'k',
          fromMap: _stringFromMap,
        ),
        isA<SplayTreeSet<String>>(),
      );
    });

    test('duplicates are deduplicated', () {
      final SplayTreeSet<String> result = parseObjectMapToSplayTreeSet<String>(
        className: 'C',
        map: <String, Object?>{
          'k': <Object?>[
            <String, Object?>{'v': 'a'},
            <String, Object?>{'v': 'a'},
          ],
        },
        key: 'k',
        fromMap: _stringFromMap,
      );
      expect(result.length, equals(1));
    });
  });

  group('parseObjectMapToSplayTreeSet — invalid values throw', () {
    test('null value throws', () {
      expect(
        () => parseObjectMapToSplayTreeSet<String>(
          className: 'C',
          map: <String, Object?>{'k': null},
          key: 'k',
          fromMap: _stringFromMap,
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('absent key throws', () {
      expect(
        () => parseObjectMapToSplayTreeSet<String>(
          className: 'C',
          map: <String, Object?>{},
          key: 'k',
          fromMap: _stringFromMap,
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('non-list value throws', () {
      expect(
        () => parseObjectMapToSplayTreeSet<String>(
          className: 'C',
          map: <String, Object?>{'k': 'not a list'},
          key: 'k',
          fromMap: _stringFromMap,
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('list with non-map item throws', () {
      expect(
        () => parseObjectMapToSplayTreeSet<String>(
          className: 'C',
          map: <String, Object?>{
            'k': <Object?>['not a map'],
          },
          key: 'k',
          fromMap: _stringFromMap,
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('list with null item throws', () {
      expect(
        () => parseObjectMapToSplayTreeSet<String>(
          className: 'C',
          map: <String, Object?>{
            'k': <Object?>[null],
          },
          key: 'k',
          fromMap: _stringFromMap,
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('fromMap throwing propagates as FormatException', () {
      expect(
        () => parseObjectMapToSplayTreeSet<String>(
          className: 'C',
          map: <String, Object?>{
            'k': <Object?>[
              <String, Object?>{'v': 42},
            ],
          },
          key: 'k',
          fromMap: _stringFromMap,
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('message has exact format', () {
      expect(
        () => parseObjectMapToSplayTreeSet<String>(
          className: 'Cls',
          map: <String, Object?>{'k': null},
          key: 'k',
          fromMap: _stringFromMap,
        ),
        throwsA(_fmtMsgEquals(_msg('Cls', 'k'))),
      );
    });

    test('source is the map', () {
      final Map<String, Object?> m = <String, Object?>{'k': 'bad'};
      expect(
        () => parseObjectMapToSplayTreeSet<String>(
          className: 'C',
          map: m,
          key: 'k',
          fromMap: _stringFromMap,
        ),
        throwsA(_fmtSource(m)),
      );
    });
  });

  group('parseObjectMapToSplayTreeSetNullable — null values return null', () {
    test('null value returns null', () {
      expect(
        parseObjectMapToSplayTreeSetNullable<String>(
          className: 'C',
          map: <String, Object?>{'k': null},
          key: 'k',
          fromMap: _stringFromMap,
        ),
        isNull,
      );
    });

    test('absent key returns null', () {
      expect(
        parseObjectMapToSplayTreeSetNullable<String>(
          className: 'C',
          map: <String, Object?>{},
          key: 'k',
          fromMap: _stringFromMap,
        ),
        isNull,
      );
    });

    test('"null" string returns null', () {
      expect(
        parseObjectMapToSplayTreeSetNullable<String>(
          className: 'C',
          map: <String, Object?>{'k': 'null'},
          key: 'k',
          fromMap: _stringFromMap,
        ),
        isNull,
      );
    });
  });

  group('parseObjectMapToSplayTreeSetNullable — valid lists', () {
    test('empty list returns empty set', () {
      expect(
        parseObjectMapToSplayTreeSetNullable<String>(
          className: 'C',
          map: <String, Object?>{'k': <Object?>[]},
          key: 'k',
          fromMap: _stringFromMap,
        ),
        isEmpty,
      );
    });

    test('list is parsed and sorted', () {
      expect(
        parseObjectMapToSplayTreeSetNullable<String>(
          className: 'C',
          map: <String, Object?>{
            'k': <Object?>[
              <String, Object?>{'v': 'b'},
              <String, Object?>{'v': 'a'},
            ],
          },
          key: 'k',
          fromMap: _stringFromMap,
        ),
        equals(SplayTreeSet<String>.of(<String>['a', 'b'])),
      );
    });
  });

  group('parseObjectMapToSplayTreeSetNullable — invalid values throw', () {
    test('non-list, non-null value throws', () {
      expect(
        () => parseObjectMapToSplayTreeSetNullable<String>(
          className: 'C',
          map: <String, Object?>{'k': 42},
          key: 'k',
          fromMap: _stringFromMap,
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('list with non-map item throws', () {
      expect(
        () => parseObjectMapToSplayTreeSetNullable<String>(
          className: 'C',
          map: <String, Object?>{
            'k': <Object?>[42],
          },
          key: 'k',
          fromMap: _stringFromMap,
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('source is the map', () {
      final Map<String, Object?> m = <String, Object?>{'k': true};
      expect(
        () => parseObjectMapToSplayTreeSetNullable<String>(
          className: 'C',
          map: m,
          key: 'k',
          fromMap: _stringFromMap,
        ),
        throwsA(_fmtSource(m)),
      );
    });
  });

  group(
    'parseObjectMapToSplayTreeSetPossiblyEmpty — null returns empty set',
    () {
      test('null value returns empty set', () {
        expect(
          parseObjectMapToSplayTreeSetPossiblyEmpty<String>(
            className: 'C',
            map: <String, Object?>{'k': null},
            key: 'k',
            fromMap: _stringFromMap,
          ),
          isEmpty,
        );
      });

      test('absent key returns empty set', () {
        expect(
          parseObjectMapToSplayTreeSetPossiblyEmpty<String>(
            className: 'C',
            map: <String, Object?>{},
            key: 'k',
            fromMap: _stringFromMap,
          ),
          isEmpty,
        );
      });

      test('"null" string returns empty set', () {
        expect(
          parseObjectMapToSplayTreeSetPossiblyEmpty<String>(
            className: 'C',
            map: <String, Object?>{'k': 'null'},
            key: 'k',
            fromMap: _stringFromMap,
          ),
          isEmpty,
        );
      });

      test('result is a SplayTreeSet', () {
        expect(
          parseObjectMapToSplayTreeSetPossiblyEmpty<String>(
            className: 'C',
            map: <String, Object?>{'k': null},
            key: 'k',
            fromMap: _stringFromMap,
          ),
          isA<SplayTreeSet<String>>(),
        );
      });
    },
  );

  group('parseObjectMapToSplayTreeSetPossiblyEmpty — valid lists', () {
    test('non-null empty list returns empty set', () {
      expect(
        parseObjectMapToSplayTreeSetPossiblyEmpty<String>(
          className: 'C',
          map: <String, Object?>{'k': <Object?>[]},
          key: 'k',
          fromMap: _stringFromMap,
        ),
        isEmpty,
      );
    });

    test('list is parsed and sorted', () {
      expect(
        parseObjectMapToSplayTreeSetPossiblyEmpty<String>(
          className: 'C',
          map: <String, Object?>{
            'k': <Object?>[
              <String, Object?>{'v': 'b'},
              <String, Object?>{'v': 'a'},
            ],
          },
          key: 'k',
          fromMap: _stringFromMap,
        ),
        equals(SplayTreeSet<String>.of(<String>['a', 'b'])),
      );
    });
  });

  group('parseObjectMapToSplayTreeSetPossiblyEmpty — invalid values throw', () {
    test('non-list, non-null value throws', () {
      expect(
        () => parseObjectMapToSplayTreeSetPossiblyEmpty<String>(
          className: 'C',
          map: <String, Object?>{'k': 'bad string'},
          key: 'k',
          fromMap: _stringFromMap,
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('list with non-map item throws', () {
      expect(
        () => parseObjectMapToSplayTreeSetPossiblyEmpty<String>(
          className: 'C',
          map: <String, Object?>{
            'k': <Object?>[99],
          },
          key: 'k',
          fromMap: _stringFromMap,
        ),
        throwsA(isA<FormatException>()),
      );
    });
  });

  group('parseString — valid values', () {
    test('regular string is returned', () {
      expect(
        parseString(
          className: 'C',
          map: <String, Object?>{'k': 'hello'},
          key: 'k',
        ),
        equals('hello'),
      );
    });

    test('empty string is returned', () {
      expect(
        parseString(className: 'C', map: <String, Object?>{'k': ''}, key: 'k'),
        equals(''),
      );
    });

    test('string with whitespace is returned as-is', () {
      expect(
        parseString(
          className: 'C',
          map: <String, Object?>{'k': '  hello  '},
          key: 'k',
        ),
        equals('  hello  '),
      );
    });

    test('"null" string is returned (not nullable variant)', () {
      expect(
        parseString(
          className: 'C',
          map: <String, Object?>{'k': 'null'},
          key: 'k',
        ),
        equals('null'),
      );
    });
  });

  group('parseString — invalid values throw FormatException', () {
    test('null throws', () {
      expect(
        () => parseString(
          className: 'C',
          map: <String, Object?>{'k': null},
          key: 'k',
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('absent key throws', () {
      expect(
        () => parseString(className: 'C', map: <String, Object?>{}, key: 'k'),
        throwsA(isA<FormatException>()),
      );
    });

    test('int throws', () {
      expect(
        () => parseString(
          className: 'C',
          map: <String, Object?>{'k': 42},
          key: 'k',
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('bool throws', () {
      expect(
        () => parseString(
          className: 'C',
          map: <String, Object?>{'k': true},
          key: 'k',
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('double throws', () {
      expect(
        () => parseString(
          className: 'C',
          map: <String, Object?>{'k': 3.14},
          key: 'k',
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('list throws', () {
      expect(
        () => parseString(
          className: 'C',
          map: <String, Object?>{
            'k': <Object?>['a'],
          },
          key: 'k',
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('message has exact format', () {
      expect(
        () => parseString(
          className: 'Cls',
          map: <String, Object?>{'k': null},
          key: 'k',
        ),
        throwsA(_fmtMsgEquals(_msg('Cls', 'k'))),
      );
    });

    test('source is the map', () {
      final Map<String, Object?> m = <String, Object?>{'k': 99};
      expect(
        () => parseString(className: 'C', map: m, key: 'k'),
        throwsA(_fmtSource(m)),
      );
    });
  });

  group('parseStringNullable — null values return null', () {
    test('null value returns null', () {
      expect(
        parseStringNullable(
          className: 'C',
          map: <String, Object?>{'k': null},
          key: 'k',
        ),
        isNull,
      );
    });

    test('absent key returns null', () {
      expect(
        parseStringNullable(className: 'C', map: <String, Object?>{}, key: 'k'),
        isNull,
      );
    });

    test('"null" string returns null', () {
      expect(
        parseStringNullable(
          className: 'C',
          map: <String, Object?>{'k': 'null'},
          key: 'k',
        ),
        isNull,
      );
    });
  });

  group('parseStringNullable — valid values', () {
    test('regular string is returned', () {
      expect(
        parseStringNullable(
          className: 'C',
          map: <String, Object?>{'k': 'world'},
          key: 'k',
        ),
        equals('world'),
      );
    });

    test('empty string is returned', () {
      expect(
        parseStringNullable(
          className: 'C',
          map: <String, Object?>{'k': ''},
          key: 'k',
        ),
        equals(''),
      );
    });

    test('string "nullified" (not exactly "null") is returned', () {
      expect(
        parseStringNullable(
          className: 'C',
          map: <String, Object?>{'k': 'nullified'},
          key: 'k',
        ),
        equals('nullified'),
      );
    });
  });

  group('parseStringNullable — invalid values throw FormatException', () {
    test('int throws', () {
      expect(
        () => parseStringNullable(
          className: 'C',
          map: <String, Object?>{'k': 1},
          key: 'k',
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('bool throws', () {
      expect(
        () => parseStringNullable(
          className: 'C',
          map: <String, Object?>{'k': false},
          key: 'k',
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('double throws', () {
      expect(
        () => parseStringNullable(
          className: 'C',
          map: <String, Object?>{'k': 1.1},
          key: 'k',
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('message has exact format', () {
      expect(
        () => parseStringNullable(
          className: 'Cls',
          map: <String, Object?>{'k': 42},
          key: 'k',
        ),
        throwsA(_fmtMsgEquals(_msg('Cls', 'k'))),
      );
    });

    test('source is the map', () {
      final Map<String, Object?> m = <String, Object?>{'k': 3.14};
      expect(
        () => parseStringNullable(className: 'C', map: m, key: 'k'),
        throwsA(_fmtSource(m)),
      );
    });
  });
}

Matcher _fmtMsgContains(final String text) => isA<FormatException>().having(
  (final FormatException e) => e.message,
  'message',
  contains(text),
);

Matcher _fmtMsgEquals(final String message) => isA<FormatException>().having(
  (final FormatException e) => e.message,
  'message',
  equals(message),
);

Matcher _fmtSource(final Object? expected) => isA<FormatException>().having(
  (final FormatException e) => e.source,
  'source',
  equals(expected),
);

int _identityInt(final int v) => v;

String _identityString(final String v) => v;

String _intToString(final int v) => v.toString();

String _msg(final String className, final String key) =>
    "$className.fromMap: map['$key'] value is invalid.";

String _stringFromMap(final Map<String, Object?> m) {
  final Object? v = m['v'];
  if (v is String) return v;
  throw FormatException('Invalid', m);
}
