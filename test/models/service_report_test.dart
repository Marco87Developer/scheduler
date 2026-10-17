import 'package:checks/checks.dart';
import 'package:scheduler/src/exceptions/exception_messages.dart';
import 'package:scheduler/src/models/hour_credit.dart';
import 'package:scheduler/src/models/service_report.dart';
import 'package:test/scaffolding.dart';

void main() {
  final sampleHourCredit = HourCredit(
    'Auxiliary pioneer',
    30,
    tags: const <String>['pioneer'],
  );

  group('ServiceReport constructor', () {
    test('sets bibleStudies, comments, hourCredit, and hours defaults', () {
      final report = ServiceReport(month: 5, sharedMinistry: false, year: 2024);
      check(report.bibleStudies).equals(0);
      check(report.comments).equals('');
      check(report.hourCredit).isNull();
      check(report.hours).isNull();
    });
    test('sets year, month, and the given fields', () {
      final report = ServiceReport(
        bibleStudies: 3,
        comments: 'Note',
        hourCredit: sampleHourCredit,
        hours: 12,
        month: 5,
        sharedMinistry: false,
        year: 2024,
      );
      check(report.bibleStudies).equals(3);
      check(report.comments).equals('Note');
      check(report.hourCredit).equals(sampleHourCredit);
      check(report.hours).equals(12);
      check(report.month).equals(5);
      check(report.year).equals(2024);
    });
    test('keeps month unchanged when between 1 and 12', () {
      for (var m = 1; m <= 12; m++) {
        final report = ServiceReport(
          month: m,
          sharedMinistry: false,
          year: 2024,
        );
        check(report.month).equals(m);
      }
    });
    test('wraps month 13 to 1', () {
      final report = ServiceReport(
        month: 13,
        sharedMinistry: false,
        year: 2024,
      );
      check(report.month).equals(1);
    });
    test('wraps month 24 to 12', () {
      final report = ServiceReport(
        month: 24,
        sharedMinistry: false,
        year: 2024,
      );
      check(report.month).equals(12);
    });
    test('wraps month 25 to 1', () {
      final report = ServiceReport(
        month: 25,
        sharedMinistry: false,
        year: 2024,
      );
      check(report.month).equals(1);
    });
    test('wraps month 0 to 12', () {
      final report = ServiceReport(month: 0, sharedMinistry: false, year: 2024);
      check(report.month).equals(12);
    });
    test('wraps a negative month using Euclidean modulo', () {
      final report = ServiceReport(
        month: -1,
        sharedMinistry: false,
        year: 2024,
      );
      check(report.month).equals(11);
    });
    test('keeps sharedMinistry false when every input is falsy', () {
      final report = ServiceReport(month: 5, sharedMinistry: false, year: 2024);
      check(report.sharedMinistry).isFalse();
    });
    test('keeps sharedMinistry true when explicitly true', () {
      final report = ServiceReport(month: 5, sharedMinistry: true, year: 2024);
      check(report.sharedMinistry).isTrue();
    });
    test('forces sharedMinistry true when hours is positive', () {
      const report = ServiceReport(
        hours: 1,
        month: 5,
        sharedMinistry: false,
        year: 2024,
      );
      check(report.sharedMinistry).isTrue();
    });
    test('keeps sharedMinistry false when hours is zero', () {
      const report = ServiceReport(
        hours: 0,
        month: 5,
        sharedMinistry: false,
        year: 2024,
      );
      check(report.sharedMinistry).isFalse();
    });
    test('keeps sharedMinistry false when hours is null', () {
      final report = ServiceReport(month: 5, sharedMinistry: false, year: 2024);
      check(report.sharedMinistry).isFalse();
    });
    test('forces sharedMinistry true when bibleStudies is positive', () {
      final report = ServiceReport(
        bibleStudies: 1,
        month: 5,
        sharedMinistry: false,
        year: 2024,
      );
      check(report.sharedMinistry).isTrue();
    });
    test('keeps sharedMinistry false when bibleStudies is zero', () {
      final report = ServiceReport(month: 5, sharedMinistry: false, year: 2024);
      check(report.sharedMinistry).isFalse();
    });
  });

  group('ServiceReport.className', () {
    test('is "ServiceReport"', () {
      check(ServiceReport.className).equals('ServiceReport');
    });
  });

  group('ServiceReport.fromJson', () {
    test('creates an instance from a valid JSON string', () {
      final original = ServiceReport(
        bibleStudies: 2,
        comments: 'Note',
        hourCredit: sampleHourCredit,
        hours: 10,
        month: 5,
        sharedMinistry: false,
        year: 2024,
      );
      final parsed = ServiceReport.fromJson(original.toJson());
      check(parsed).equals(original);
    });
    test('throws a FormatException for a malformed JSON string', () {
      const badJson = 'not-json';
      final String expected = fromJsonFormatExceptionMessage(
        ServiceReport.className,
        badJson,
      );
      check(() => ServiceReport.fromJson(badJson))
          .throws<FormatException>()
          .has((e) => e.message, 'message')
          .equals(expected);
    });
    test('throws a FormatException when the JSON is not an object', () {
      const arrayJson = '[1,2,3]';
      final String expected = fromJsonFormatExceptionMessage(
        ServiceReport.className,
        arrayJson,
      );
      check(() => ServiceReport.fromJson(arrayJson))
          .throws<FormatException>()
          .has((e) => e.message, 'message')
          .equals(expected);
    });
    test('throws a FormatException using the fromJson message when the '
        'decoded map is invalid', () {
      const json = '{"year": 2024}';
      final String expected = fromJsonFormatExceptionMessage(
        ServiceReport.className,
        json,
      );
      check(() => ServiceReport.fromJson(json))
          .throws<FormatException>()
          .has((e) => e.message, 'message')
          .equals(expected);
    });
  });

  group('ServiceReport.fromMap', () {
    Map<String, Object?> validMap() => <String, Object?>{
      'bibleStudies': 2,
      'comments': 'Note',
      'hourCredit': sampleHourCredit.toString(),
      'hours': 10,
      'month': 5,
      'sharedMinistry': false,
      'year': 2024,
    };
    test('creates an instance from a fully populated map', () {
      final report = ServiceReport.fromMap(validMap());
      check(report.bibleStudies).equals(2);
      check(report.comments).equals('Note');
      check(report.hourCredit).equals(sampleHourCredit);
      check(report.hours).equals(10);
      check(report.month).equals(5);
      check(report.year).equals(2024);
    });
    test('parses sharedMinistry from a case-insensitive string', () {
      final Map<String, Object?> map = validMap();
      map['sharedMinistry'] = 'TRUE';
      final report = ServiceReport.fromMap(map);
      check(report.sharedMinistry).isTrue();
    });
    test('treats a missing hourCredit key as null', () {
      final Map<String, Object?> map = validMap()..remove('hourCredit');
      final report = ServiceReport.fromMap(map);
      check(report.hourCredit).isNull();
    });
    test('treats a missing hours key as null', () {
      final Map<String, Object?> map = validMap()..remove('hours');
      final report = ServiceReport.fromMap(map);
      check(report.hours).isNull();
    });
    test('throws a FormatException when hourCredit has the wrong type', () {
      final Map<String, Object?> map = validMap();
      map['hourCredit'] = 42;
      final String expected = fromMapFormatExceptionMessage(
        ServiceReport.className,
        'hourCredit',
      );
      check(() => ServiceReport.fromMap(map))
          .throws<FormatException>()
          .has((e) => e.message, 'message')
          .equals(expected);
    });
    for (final key in <String>[
      'bibleStudies',
      'comments',
      'month',
      'sharedMinistry',
      'year',
    ]) {
      test('throws a FormatException when "$key" is missing', () {
        final Map<String, Object?> map = validMap()..remove(key);
        final String expected = fromMapFormatExceptionMessage(
          ServiceReport.className,
          key,
        );
        check(() => ServiceReport.fromMap(map))
            .throws<FormatException>()
            .has((e) => e.message, 'message')
            .equals(expected);
      });
    }
  });

  group('ServiceReport.parse', () {
    test('parses a formatted string with a null hourCredit', () {
      final report = ServiceReport.parse('2024|5|true|2|null|10|Note');
      check(report.year).equals(2024);
      check(report.month).equals(5);
      check(report.sharedMinistry).isTrue();
      check(report.bibleStudies).equals(2);
      check(report.hourCredit).isNull();
      check(report.hours).equals(10);
      check(report.comments).equals('Note');
    });
    test('parses a formatted string with an untagged hourCredit', () {
      final report = ServiceReport.parse(
        '2024|5|true|2|Auxiliary pioneer|30|10|Note',
      );
      check(report.hourCredit).equals(HourCredit('Auxiliary pioneer', 30));
      check(report.hours).equals(10);
    });
    test('parses a formatted string with a tagged hourCredit', () {
      final report = ServiceReport.parse(
        '2024|5|true|2|Auxiliary pioneer|30|pioneer|10|Note',
      );
      check(report.hourCredit).equals(sampleHourCredit);
    });
    test('leaves hours as null when it cannot be parsed', () {
      final report = ServiceReport.parse(
        '2024|5|true|2|null|not-a-number|Note',
      );
      check(report.hours).isNull();
    });
    test('trims surrounding whitespace before splitting', () {
      final report = ServiceReport.parse('  2024|5|true|2|null|10|Note  ');
      check(report.year).equals(2024);
    });
    test('throws a FormatException for an unexpected field count', () {
      const formattedString = '2024|5|true';
      final String expected = parseFormatExceptionMessage(
        ServiceReport.className,
        formattedString,
      );
      check(() => ServiceReport.parse(formattedString))
          .throws<FormatException>()
          .has((e) => e.message, 'message')
          .equals(expected);
    });
    test('throws a FormatException for a non-numeric year', () {
      const formattedString = 'abcd|5|true|2|null|10|Note';
      final String expected = parseFormatExceptionMessage(
        ServiceReport.className,
        formattedString,
      );
      check(() => ServiceReport.parse(formattedString))
          .throws<FormatException>()
          .has((e) => e.message, 'message')
          .equals(expected);
    });
    test('throws a FormatException for an invalid boolean', () {
      const formattedString = '2024|5|maybe|2|null|10|Note';
      final String expected = parseFormatExceptionMessage(
        ServiceReport.className,
        formattedString,
      );
      check(() => ServiceReport.parse(formattedString))
          .throws<FormatException>()
          .has((e) => e.message, 'message')
          .equals(expected);
    });
  });

  group('ServiceReport.date', () {
    test('returns a DateTime built from year and month', () {
      final report = ServiceReport(month: 5, sharedMinistry: false, year: 2024);
      check(report.date).equals(DateTime(2024, 5));
    });
  });

  group('ServiceReport equality and hashCode', () {
    test('is equal to itself', () {
      final report = ServiceReport(month: 5, sharedMinistry: false, year: 2024);
      check(report).equals(report);
    });
    test('is equal to a distinct instance with the same field values', () {
      final a = ServiceReport(
        bibleStudies: 2,
        comments: 'Note',
        hourCredit: sampleHourCredit,
        hours: 10,
        month: 5,
        sharedMinistry: false,
        year: 2024,
      );
      final b = ServiceReport(
        bibleStudies: 2,
        comments: 'Note',
        hourCredit: HourCredit(
          'Auxiliary pioneer',
          30,
          tags: const <String>['pioneer'],
        ),
        hours: 10,
        month: 5,
        sharedMinistry: false,
        year: 2024,
      );
      check(a).equals(b);
      check(a.hashCode).equals(b.hashCode);
    });
    test('is not equal to an instance with a different bibleStudies', () {
      final a = ServiceReport(
        bibleStudies: 1,
        month: 5,
        sharedMinistry: false,
        year: 2024,
      );
      final b = ServiceReport(
        bibleStudies: 2,
        month: 5,
        sharedMinistry: false,
        year: 2024,
      );
      check(a == b).isFalse();
    });
    test('is not equal to an object of a different type', () {
      final report = ServiceReport(month: 5, sharedMinistry: false, year: 2024);
      check(report == 'not a report').isFalse();
    });
  });

  group('ServiceReport comparison operators', () {
    final earlier = ServiceReport(month: 1, sharedMinistry: false, year: 2024);
    final later = ServiceReport(month: 2, sharedMinistry: false, year: 2024);
    final sameAsEarlier = ServiceReport(
      month: 1,
      sharedMinistry: false,
      year: 2024,
    );
    test('< returns true when this comes before other', () {
      check(earlier < later).isTrue();
    });
    test('< returns false when this comes after other', () {
      check(later < earlier).isFalse();
    });
    test('< returns false when both are equal', () {
      check(earlier < sameAsEarlier).isFalse();
    });
    test('<= returns true when this comes before other', () {
      check(earlier <= later).isTrue();
    });
    test('<= returns true when both are equal', () {
      check(earlier <= sameAsEarlier).isTrue();
    });
    test('<= returns false when this comes after other', () {
      check(later <= earlier).isFalse();
    });
    test('> returns true when this comes after other', () {
      check(later > earlier).isTrue();
    });
    test('> returns false when this comes before other', () {
      check(earlier > later).isFalse();
    });
    test('> returns false when both are equal', () {
      check(earlier > sameAsEarlier).isFalse();
    });
    test('>= returns true when this comes after other', () {
      check(later >= earlier).isTrue();
    });
    test('>= returns true when both are equal', () {
      check(earlier >= sameAsEarlier).isTrue();
    });
    test('>= returns false when this comes before other', () {
      check(earlier >= later).isFalse();
    });
  });

  group('ServiceReport.compareTo', () {
    test('returns 0 for identical instances', () {
      final report = ServiceReport(month: 5, sharedMinistry: false, year: 2024);
      check(report.compareTo(report)).equals(0);
    });
    test('compares by year first', () {
      final a = ServiceReport(month: 5, sharedMinistry: false, year: 2023);
      final b = ServiceReport(month: 5, sharedMinistry: false, year: 2024);
      check(a.compareTo(b)).isLessThan(0);
      check(b.compareTo(a)).isGreaterThan(0);
    });
    test('compares by month when the year is equal', () {
      final a = ServiceReport(month: 4, sharedMinistry: false, year: 2024);
      final b = ServiceReport(month: 5, sharedMinistry: false, year: 2024);
      check(a.compareTo(b)).isLessThan(0);
    });
    test('ranks sharedMinistry true after false', () {
      final a = ServiceReport(month: 5, sharedMinistry: false, year: 2024);
      final b = ServiceReport(month: 5, sharedMinistry: true, year: 2024);
      check(a.compareTo(b)).isLessThan(0);
      check(b.compareTo(a)).isGreaterThan(0);
    });
    test('ranks a null hours before a non-null hours', () {
      final a = ServiceReport(
        bibleStudies: 1,
        month: 5,
        sharedMinistry: false,
        year: 2024,
      );
      final b = ServiceReport(
        bibleStudies: 1,
        hours: 5,
        month: 5,
        sharedMinistry: false,
        year: 2024,
      );
      check(a.compareTo(b)).isLessThan(0);
      check(b.compareTo(a)).isGreaterThan(0);
    });
    test('compares hours numerically when both are non-null', () {
      final a = ServiceReport(
        bibleStudies: 1,
        hours: 5,
        month: 5,
        sharedMinistry: false,
        year: 2024,
      );
      final b = ServiceReport(
        bibleStudies: 1,
        hours: 10,
        month: 5,
        sharedMinistry: false,
        year: 2024,
      );
      check(a.compareTo(b)).isLessThan(0);
    });
    test('ranks a null hourCredit before a non-null hourCredit', () {
      final a = ServiceReport(
        bibleStudies: 1,
        month: 5,
        sharedMinistry: false,
        year: 2024,
      );
      final b = ServiceReport(
        bibleStudies: 1,
        hourCredit: sampleHourCredit,
        month: 5,
        sharedMinistry: false,
        year: 2024,
      );
      check(a.compareTo(b)).isLessThan(0);
      check(b.compareTo(a)).isGreaterThan(0);
    });
    test('compares hourCredit values when both are non-null', () {
      final a = ServiceReport(
        bibleStudies: 1,
        hourCredit: HourCredit('Auxiliary', 10),
        month: 5,
        sharedMinistry: false,
        year: 2024,
      );
      final b = ServiceReport(
        bibleStudies: 1,
        hourCredit: HourCredit('Regular', 10),
        month: 5,
        sharedMinistry: false,
        year: 2024,
      );
      check(a.compareTo(b)).isLessThan(0);
    });
    test('compares by bibleStudies when other fields are equal', () {
      final a = ServiceReport(
        bibleStudies: 1,
        month: 5,
        sharedMinistry: false,
        year: 2024,
      );
      final b = ServiceReport(
        bibleStudies: 2,
        month: 5,
        sharedMinistry: false,
        year: 2024,
      );
      check(a.compareTo(b)).isLessThan(0);
    });
    test('compares by comments as the final tiebreaker', () {
      final a = ServiceReport(
        bibleStudies: 1,
        comments: 'A',
        month: 5,
        sharedMinistry: false,
        year: 2024,
      );
      final b = ServiceReport(
        bibleStudies: 1,
        comments: 'B',
        month: 5,
        sharedMinistry: false,
        year: 2024,
      );
      check(a.compareTo(b)).isLessThan(0);
    });
    test('returns 0 when every field is equal', () {
      final a = ServiceReport(
        bibleStudies: 1,
        comments: 'Note',
        month: 5,
        sharedMinistry: false,
        year: 2024,
      );
      final b = ServiceReport(
        bibleStudies: 1,
        comments: 'Note',
        month: 5,
        sharedMinistry: false,
        year: 2024,
      );
      check(a.compareTo(b)).equals(0);
    });
  });

  group('ServiceReport.copyWith', () {
    final original = ServiceReport(
      bibleStudies: 2,
      comments: 'Note',
      hourCredit: sampleHourCredit,
      hours: 10,
      month: 5,
      sharedMinistry: false,
      year: 2024,
    );
    test('returns an equivalent instance when called with no arguments', () {
      check(original.copyWith()).equals(original);
    });
    test('replaces bibleStudies', () {
      final ServiceReport copy = original.copyWith(bibleStudies: 9);
      check(copy.bibleStudies).equals(9);
      check(original.bibleStudies).equals(2);
    });
    test('replaces comments', () {
      final ServiceReport copy = original.copyWith(comments: 'Other');
      check(copy.comments).equals('Other');
      check(original.comments).equals('Note');
    });
    test('replaces hourCredit with a new value', () {
      final newCredit = HourCredit('Regular pioneer', 50);
      final ServiceReport copy = original.copyWith(hourCredit: () => newCredit);
      check(copy.hourCredit).equals(newCredit);
      check(original.hourCredit).equals(sampleHourCredit);
    });
    test('replaces hourCredit with null', () {
      final ServiceReport copy = original.copyWith(hourCredit: () => null);
      check(copy.hourCredit).isNull();
      check(original.hourCredit).equals(sampleHourCredit);
    });
    test('replaces hours with a new value', () {
      final ServiceReport copy = original.copyWith(hours: () => 20);
      check(copy.hours).equals(20);
      check(original.hours).equals(10);
    });
    test('replaces hours with null', () {
      final ServiceReport copy = original.copyWith(hours: () => null);
      check(copy.hours).isNull();
      check(original.hours).equals(10);
    });
    test('replaces month', () {
      final ServiceReport copy = original.copyWith(month: 8);
      check(copy.month).equals(8);
      check(original.month).equals(5);
    });
    test('replaces sharedMinistry', () {
      final ServiceReport copy = original.copyWith(sharedMinistry: true);
      check(copy.sharedMinistry).isTrue();
    });
    test('replaces year', () {
      final ServiceReport copy = original.copyWith(year: 2025);
      check(copy.year).equals(2025);
      check(original.year).equals(2024);
    });
  });

  group('ServiceReport.toJson', () {
    test('produces a JSON string decodable back to the same map', () {
      final report = ServiceReport(
        bibleStudies: 2,
        comments: 'Note',
        hourCredit: sampleHourCredit,
        hours: 10,
        month: 5,
        sharedMinistry: false,
        year: 2024,
      );
      final roundTripped = ServiceReport.fromJson(report.toJson());
      check(roundTripped).equals(report);
    });
  });

  group('ServiceReport.toMap', () {
    test('contains every field under its expected key', () {
      final report = ServiceReport(
        bibleStudies: 2,
        comments: 'Note',
        hourCredit: sampleHourCredit,
        hours: 10,
        month: 5,
        sharedMinistry: false,
        year: 2024,
      );
      final Map<String, Object?> map = report.toMap();
      check(map['bibleStudies']).equals(2);
      check(map['comments']).equals('Note');
      check(map['hourCredit']).equals(sampleHourCredit.toString());
      check(map['hours']).equals(10);
      check(map['month']).equals(5);
      check(map['sharedMinistry']).equals(true);
      check(map['year']).equals(2024);
    });
    test('serializes a null hourCredit as null', () {
      final report = ServiceReport(month: 5, sharedMinistry: false, year: 2024);
      check(report.toMap()['hourCredit']).isNull();
    });
  });

  group('ServiceReport.toString', () {
    test('formats every field separated by a pipe', () {
      final report = ServiceReport(
        bibleStudies: 2,
        comments: 'Note',
        hourCredit: sampleHourCredit,
        hours: 10,
        month: 5,
        sharedMinistry: false,
        year: 2024,
      );
      check(report.toString())
          .equals('2024|5|true|2|$sampleHourCredit|10|Note');
    });
    test('prints "null" for a missing hourCredit and hours', () {
      final report = ServiceReport(month: 5, sharedMinistry: false, year: 2024);
      check(report.toString()).equals('2024|5|false|0|null|null|');
    });
  });

  group('ServiceReport.tryParse', () {
    // Adjust these two strings if your `HourCredit.parse` expects
    // other values. Formats: `description|hours[|tags]`.
    const creditText = 'Credit|5';
    const creditWithTagsText = 'Credit|5|tag1,tag2';
    final credit = HourCredit.parse(creditText);
    final creditWithTags = HourCredit.parse(creditWithTagsText);

    group('7 fields (no hour credit)', () {
      test('parses a complete report', () {
        check(ServiceReport.tryParse('2024|5|true|2|null|10|Note')).equals(
          ServiceReport(
            bibleStudies: 2,
            comments: 'Note',
            hours: 10,
            month: 5,
            sharedMinistry: true,
            year: 2024,
          ),
        );
      });

      test('parses a minimal report', () {
        check(ServiceReport.tryParse('2024|5|false|0|null|null|'))
            .equals(ServiceReport(month: 5, sharedMinistry: false, year: 2024));
      });

      test('parses null hours', () {
        final ServiceReport? report = ServiceReport.tryParse(
          '2024|5|true|1|null|null|Note',
        );
        check(report).isNotNull().has((r) => r.hours, 'hours').isNull();
      });

      test('parses zero hours', () {
        final ServiceReport? report = ServiceReport.tryParse(
          '2024|5|false|0|null|0|',
        );
        check(report).isNotNull().has((r) => r.hours, 'hours').equals(0);
      });

      test('parses empty comments', () {
        final ServiceReport? report = ServiceReport.tryParse(
          '2024|5|true|1|null|3|',
        );
        check(report).isNotNull().has((r) => r.comments, 'comments').equals('');
      });

      test('keeps spaces inside the comments', () {
        final ServiceReport? report = ServiceReport.tryParse(
          '2024|5|true|1|null|3|a  b c',
        );
        check(report)
            .isNotNull()
            .has((r) => r.comments, 'comments')
            .equals('a  b c');
      });

      test('keeps non-Latin characters in the comments', () {
        final ServiceReport? report = ServiceReport.tryParse(
          '2024|5|true|1|null|3|¶ 1º ª',
        );
        check(report)
            .isNotNull()
            .has((r) => r.comments, 'comments')
            .equals('¶ 1º ª');
      });

      test('returns a null hour credit', () {
        final ServiceReport? report = ServiceReport.tryParse(
          '2024|5|true|1|null|3|Note',
        );
        check(report)
            .isNotNull()
            .has((r) => r.hourCredit, 'hourCredit')
            .isNull();
      });

      test('returns null if the credit field is not "null"', () {
        check(ServiceReport.tryParse('2024|5|true|1|Credit|3|Note')).isNull();
        check(ServiceReport.tryParse('2024|5|true|1||3|Note')).isNull();
        check(ServiceReport.tryParse('2024|5|true|1|NULL|3|Note')).isNull();
      });
    });

    group('8 fields (hour credit without tags)', () {
      test('parses a complete report', () {
        check(ServiceReport.tryParse('2024|5|true|2|$creditText|10|Note'))
            .equals(
              ServiceReport(
                bibleStudies: 2,
                comments: 'Note',
                hourCredit: credit,
                hours: 10,
                month: 5,
                sharedMinistry: true,
                year: 2024,
              ),
            );
      });

      test('parses null hours', () {
        final ServiceReport? report = ServiceReport.tryParse(
          '2024|5|true|2|$creditText|null|Note',
        );
        check(report).isNotNull()
          ..has((r) => r.hours, 'hours').isNull()
          ..has((r) => r.hourCredit, 'hourCredit').equals(credit);
      });

      test('parses empty comments', () {
        final ServiceReport? report = ServiceReport.tryParse(
          '2024|5|true|2|$creditText|10|',
        );
        check(report).isNotNull().has((r) => r.comments, 'comments').equals('');
      });

      test('returns null if the hour credit is invalid', () {
        check(ServiceReport.tryParse('2024|5|true|2|x|y|10|Note')).isNull();
      });
    });

    group('9 fields (hour credit with tags)', () {
      test('parses a complete report', () {
        check(
          ServiceReport.tryParse('2024|5|true|2|$creditWithTagsText|10|Note'),
        ).equals(
          ServiceReport(
            bibleStudies: 2,
            comments: 'Note',
            hourCredit: creditWithTags,
            hours: 10,
            month: 5,
            sharedMinistry: true,
            year: 2024,
          ),
        );
      });

      test('parses null hours and empty comments', () {
        final ServiceReport? report = ServiceReport.tryParse(
          '2024|5|true|2|$creditWithTagsText|null|',
        );
        check(report).isNotNull()
          ..has((r) => r.hours, 'hours').isNull()
          ..has((r) => r.comments, 'comments').equals('')
          ..has((r) => r.hourCredit, 'hourCredit').equals(creditWithTags);
      });

      test('returns null if the hour credit is invalid', () {
        check(ServiceReport.tryParse('2024|5|true|2|x|y|z|10|Note')).isNull();
      });
    });

    group('field values', () {
      test('wraps the month around', () {
        for (final (int input, int expected) in <(int, int)>[
          (1, 1),
          (12, 12),
          (13, 1),
          (24, 12),
          (25, 1),
          (0, 12),
          (-1, 11),
        ]) {
          final ServiceReport? report = ServiceReport.tryParse(
            '2024|$input|false|0|null|null|',
          );
          check(report)
              .isNotNull()
              .has((r) => r.month, 'month')
              .equals(expected);
        }
      });

      test('accepts a negative year', () {
        final ServiceReport? report = ServiceReport.tryParse(
          '-5|1|false|0|null|null|',
        );
        check(report).isNotNull().has((r) => r.year, 'year').equals(-5);
      });

      test('accepts a signed integer', () {
        final ServiceReport? report = ServiceReport.tryParse(
          '+2024|1|false|0|null|null|',
        );
        check(report).isNotNull().has((r) => r.year, 'year').equals(2024);
      });

      test('derives sharedMinistry from Bible studies', () {
        final ServiceReport? report = ServiceReport.tryParse(
          '2024|5|false|1|null|null|',
        );
        check(report)
            .isNotNull()
            .has((r) => r.sharedMinistry, 'sharedMinistry')
            .isTrue();
      });

      test('derives sharedMinistry from hours', () {
        final ServiceReport? report = ServiceReport.tryParse(
          '2024|5|false|0|null|1|',
        );
        check(report)
            .isNotNull()
            .has((r) => r.sharedMinistry, 'sharedMinistry')
            .isTrue();
      });

      test('keeps sharedMinistry false without activity', () {
        final ServiceReport? report = ServiceReport.tryParse(
          '2024|5|false|0|null|0|',
        );
        check(report)
            .isNotNull()
            .has((r) => r.sharedMinistry, 'sharedMinistry')
            .isFalse();
      });

      test('treats an invalid hours field as null hours', () {
        final ServiceReport? report = ServiceReport.tryParse(
          '2024|5|true|1|null|abc|Note',
        );
        check(report).isNotNull().has((r) => r.hours, 'hours').isNull();
      });
    });

    group('whitespace', () {
      test('trims leading and trailing whitespace', () {
        check(ServiceReport.tryParse('  2024|5|true|2|null|10|Note \n')).equals(
          ServiceReport(
            bibleStudies: 2,
            comments: 'Note',
            hours: 10,
            month: 5,
            sharedMinistry: true,
            year: 2024,
          ),
        );
      });

      test('returns null for whitespace-only input', () {
        check(ServiceReport.tryParse('   \n\t')).isNull();
      });
    });

    group('invalid input', () {
      test('returns null for an empty string', () {
        check(ServiceReport.tryParse('')).isNull();
      });

      test('returns null for a single separator', () {
        check(ServiceReport.tryParse('|')).isNull();
      });

      test('returns null for too few fields', () {
        check(ServiceReport.tryParse('2024')).isNull();
        check(ServiceReport.tryParse('2024|5|true|2|null|10')).isNull();
      });

      test('returns null for too many fields', () {
        check(ServiceReport.tryParse('2024|5|true|2|a|b|c|d|10|Note')).isNull();
      });

      test('returns null for an invalid year', () {
        check(ServiceReport.tryParse('x|5|true|2|null|10|Note')).isNull();
        check(ServiceReport.tryParse('|5|true|2|null|10|Note')).isNull();
        check(ServiceReport.tryParse('20.5|5|true|2|null|10|N')).isNull();
      });

      test('returns null for an invalid month', () {
        check(ServiceReport.tryParse('2024|x|true|2|null|10|Note')).isNull();
        check(ServiceReport.tryParse('2024||true|2|null|10|Note')).isNull();
      });

      test('returns null for an invalid sharedMinistry', () {
        check(ServiceReport.tryParse('2024|5|yes|2|null|10|Note')).isNull();
        check(ServiceReport.tryParse('2024|5||2|null|10|Note')).isNull();
        check(ServiceReport.tryParse('2024|5|1|2|null|10|Note')).isNull();
      });

      test('is case sensitive for sharedMinistry', () {
        check(ServiceReport.tryParse('2024|5|True|2|null|10|Note')).isNull();
        check(ServiceReport.tryParse('2024|5|FALSE|2|null|10|N')).isNull();
      });

      test('returns null for invalid Bible studies', () {
        check(ServiceReport.tryParse('2024|5|true|x|null|10|Note')).isNull();
        check(ServiceReport.tryParse('2024|5|true||null|10|Note')).isNull();
      });

      test('never throws', () {
        for (final input in <String>[
          '',
          '|',
          '||||||',
          '|||||||',
          '||||||||',
          '|||||||||',
          'null',
          '2024|5|true|2|null|10|Note|extra',
        ]) {
          check(() => ServiceReport.tryParse(input)).returnsNormally();
        }
      });
    });

    group('round trip', () {
      test('restores a report without hour credit', () {
        final report = ServiceReport(
          bibleStudies: 3,
          comments: 'Note',
          hours: 12,
          month: 7,
          sharedMinistry: true,
          year: 2025,
        );
        check(ServiceReport.tryParse(report.toString())).equals(report);
      });

      test('restores a report with hour credit', () {
        final report = ServiceReport(
          bibleStudies: 3,
          comments: 'Note',
          hourCredit: credit,
          hours: 12,
          month: 7,
          sharedMinistry: true,
          year: 2025,
        );
        check(ServiceReport.tryParse(report.toString())).equals(report);
      });

      test('restores a report with tagged hour credit', () {
        final report = ServiceReport(
          bibleStudies: 3,
          comments: 'Note',
          hourCredit: creditWithTags,
          hours: 12,
          month: 7,
          sharedMinistry: true,
          year: 2025,
        );
        check(ServiceReport.tryParse(report.toString())).equals(report);
      });

      test('restores a report with null hours and empty comments', () {
        final report = ServiceReport(
          month: 1,
          sharedMinistry: false,
          year: 2025,
        );
        check(ServiceReport.tryParse(report.toString())).equals(report);
      });
    });

    group('consistency with parse', () {
      test('parse returns the same report as tryParse', () {
        const input = '2024|5|true|2|null|10|Note';
        check(ServiceReport.parse(input))
            .equals(ServiceReport.tryParse(input)!);
      });

      test('parse throws where tryParse returns null', () {
        const input = 'invalid';
        check(ServiceReport.tryParse(input)).isNull();
        check(() => ServiceReport.parse(input)).throws<FormatException>();
      });
    });
  });
}
