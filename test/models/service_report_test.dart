import 'package:checks/checks.dart';
import 'package:scheduler/src/exceptions/exception_messages.dart';
import 'package:scheduler/src/models/hour_credit.dart';
import 'package:scheduler/src/models/service_report.dart';
import 'package:test/scaffolding.dart';

void main() {
  final HourCredit sampleHourCredit = HourCredit(
    'Auxiliary pioneer',
    30,
    tags: const <String>['pioneer'],
  );

  group('ServiceReport constructor', () {
    test('sets bibleStudies, comments, hourCredit, and hours defaults', () {
      const ServiceReport report = ServiceReport(
        month: 5,
        sharedMinistry: false,
        year: 2024,
      );
      check(report.bibleStudies).equals(0);
      check(report.comments).equals('');
      check(report.hourCredit).isNull();
      check(report.hours).isNull();
    });
    test('sets year, month, and the given fields', () {
      final ServiceReport report = ServiceReport(
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
      for (int m = 1; m <= 12; m++) {
        final ServiceReport report = ServiceReport(
          month: m,
          sharedMinistry: false,
          year: 2024,
        );
        check(report.month).equals(m);
      }
    });
    test('wraps month 13 to 1', () {
      const ServiceReport report = ServiceReport(
        month: 13,
        sharedMinistry: false,
        year: 2024,
      );
      check(report.month).equals(1);
    });
    test('wraps month 24 to 12', () {
      const ServiceReport report = ServiceReport(
        month: 24,
        sharedMinistry: false,
        year: 2024,
      );
      check(report.month).equals(12);
    });
    test('wraps month 25 to 1', () {
      const ServiceReport report = ServiceReport(
        month: 25,
        sharedMinistry: false,
        year: 2024,
      );
      check(report.month).equals(1);
    });
    test('wraps month 0 to 12', () {
      const ServiceReport report = ServiceReport(
        month: 0,
        sharedMinistry: false,
        year: 2024,
      );
      check(report.month).equals(12);
    });
    test('wraps a negative month using Euclidean modulo', () {
      const ServiceReport report = ServiceReport(
        month: -1,
        sharedMinistry: false,
        year: 2024,
      );
      check(report.month).equals(11);
    });
    test('keeps sharedMinistry false when every input is falsy', () {
      const ServiceReport report = ServiceReport(
        month: 5,
        sharedMinistry: false,
        year: 2024,
      );
      check(report.sharedMinistry).isFalse();
    });
    test('keeps sharedMinistry true when explicitly true', () {
      const ServiceReport report = ServiceReport(
        month: 5,
        sharedMinistry: true,
        year: 2024,
      );
      check(report.sharedMinistry).isTrue();
    });
    test('forces sharedMinistry true when hours is positive', () {
      const ServiceReport report = ServiceReport(
        hours: 1,
        month: 5,
        sharedMinistry: false,
        year: 2024,
      );
      check(report.sharedMinistry).isTrue();
    });
    test('keeps sharedMinistry false when hours is zero', () {
      const ServiceReport report = ServiceReport(
        hours: 0,
        month: 5,
        sharedMinistry: false,
        year: 2024,
      );
      check(report.sharedMinistry).isFalse();
    });
    test('keeps sharedMinistry false when hours is null', () {
      const ServiceReport report = ServiceReport(
        month: 5,
        sharedMinistry: false,
        year: 2024,
      );
      check(report.sharedMinistry).isFalse();
    });
    test('forces sharedMinistry true when bibleStudies is positive', () {
      const ServiceReport report = ServiceReport(
        bibleStudies: 1,
        month: 5,
        sharedMinistry: false,
        year: 2024,
      );
      check(report.sharedMinistry).isTrue();
    });
    test('keeps sharedMinistry false when bibleStudies is zero', () {
      const ServiceReport report = ServiceReport(
        month: 5,
        sharedMinistry: false,
        year: 2024,
      );
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
      final ServiceReport original = ServiceReport(
        bibleStudies: 2,
        comments: 'Note',
        hourCredit: sampleHourCredit,
        hours: 10,
        month: 5,
        sharedMinistry: false,
        year: 2024,
      );
      final ServiceReport parsed = ServiceReport.fromJson(original.toJson());
      check(parsed).equals(original);
    });
    test('throws a FormatException for a malformed JSON string', () {
      const String badJson = 'not-json';
      final String expected = fromJsonFormatExceptionMessage(
        ServiceReport.className,
        badJson,
      );
      check(() => ServiceReport.fromJson(badJson))
          .throws<FormatException>()
          .has((final FormatException e) => e.message, 'message')
          .equals(expected);
    });
    test('throws a FormatException when the JSON is not an object', () {
      const String arrayJson = '[1,2,3]';
      final String expected = fromJsonFormatExceptionMessage(
        ServiceReport.className,
        arrayJson,
      );
      check(() => ServiceReport.fromJson(arrayJson))
          .throws<FormatException>()
          .has((final FormatException e) => e.message, 'message')
          .equals(expected);
    });
    test('throws a FormatException using the fromJson message when the '
        'decoded map is invalid', () {
      const String json = '{"year": 2024}';
      final String expected = fromJsonFormatExceptionMessage(
        ServiceReport.className,
        json,
      );
      check(() => ServiceReport.fromJson(json))
          .throws<FormatException>()
          .has((final FormatException e) => e.message, 'message')
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
      final ServiceReport report = ServiceReport.fromMap(validMap());
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
      final ServiceReport report = ServiceReport.fromMap(map);
      check(report.sharedMinistry).isTrue();
    });
    test('treats a missing hourCredit key as null', () {
      final Map<String, Object?> map = validMap()..remove('hourCredit');
      final ServiceReport report = ServiceReport.fromMap(map);
      check(report.hourCredit).isNull();
    });
    test('treats a missing hours key as null', () {
      final Map<String, Object?> map = validMap()..remove('hours');
      final ServiceReport report = ServiceReport.fromMap(map);
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
          .has((final FormatException e) => e.message, 'message')
          .equals(expected);
    });
    for (final String key in <String>[
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
            .has((final FormatException e) => e.message, 'message')
            .equals(expected);
      });
    }
  });

  group('ServiceReport.parse', () {
    test('parses a formatted string with a null hourCredit', () {
      final ServiceReport report = ServiceReport.parse(
        '2024|5|true|2|null|10|Note',
      );
      check(report.year).equals(2024);
      check(report.month).equals(5);
      check(report.sharedMinistry).isTrue();
      check(report.bibleStudies).equals(2);
      check(report.hourCredit).isNull();
      check(report.hours).equals(10);
      check(report.comments).equals('Note');
    });
    test('parses a formatted string with an untagged hourCredit', () {
      final ServiceReport report = ServiceReport.parse(
        '2024|5|true|2|Auxiliary pioneer|30|10|Note',
      );
      check(report.hourCredit).equals(HourCredit('Auxiliary pioneer', 30));
      check(report.hours).equals(10);
    });
    test('parses a formatted string with a tagged hourCredit', () {
      final ServiceReport report = ServiceReport.parse(
        '2024|5|true|2|Auxiliary pioneer|30|pioneer|10|Note',
      );
      check(report.hourCredit).equals(sampleHourCredit);
    });
    test('leaves hours as null when it cannot be parsed', () {
      final ServiceReport report = ServiceReport.parse(
        '2024|5|true|2|null|not-a-number|Note',
      );
      check(report.hours).isNull();
    });
    test('trims surrounding whitespace before splitting', () {
      final ServiceReport report = ServiceReport.parse(
        '  2024|5|true|2|null|10|Note  ',
      );
      check(report.year).equals(2024);
    });
    test('throws a FormatException for an unexpected field count', () {
      const String formattedString = '2024|5|true';
      final String expected = parseFormatExceptionMessage(
        ServiceReport.className,
        formattedString,
      );
      check(() => ServiceReport.parse(formattedString))
          .throws<FormatException>()
          .has((final FormatException e) => e.message, 'message')
          .equals(expected);
    });
    test('throws a FormatException for a non-numeric year', () {
      const String formattedString = 'abcd|5|true|2|null|10|Note';
      final String expected = parseFormatExceptionMessage(
        ServiceReport.className,
        formattedString,
      );
      check(() => ServiceReport.parse(formattedString))
          .throws<FormatException>()
          .has((final FormatException e) => e.message, 'message')
          .equals(expected);
    });
    test('throws a FormatException for an invalid boolean', () {
      const String formattedString = '2024|5|maybe|2|null|10|Note';
      final String expected = parseFormatExceptionMessage(
        ServiceReport.className,
        formattedString,
      );
      check(() => ServiceReport.parse(formattedString))
          .throws<FormatException>()
          .has((final FormatException e) => e.message, 'message')
          .equals(expected);
    });
  });

  group('ServiceReport.date', () {
    test('returns a DateTime built from year and month', () {
      const ServiceReport report = ServiceReport(
        month: 5,
        sharedMinistry: false,
        year: 2024,
      );
      check(report.date).equals(DateTime(2024, 5));
    });
  });

  group('ServiceReport equality and hashCode', () {
    test('is equal to itself', () {
      const ServiceReport report = ServiceReport(
        month: 5,
        sharedMinistry: false,
        year: 2024,
      );
      check(report).equals(report);
    });
    test('is equal to a distinct instance with the same field values', () {
      final ServiceReport a = ServiceReport(
        bibleStudies: 2,
        comments: 'Note',
        hourCredit: sampleHourCredit,
        hours: 10,
        month: 5,
        sharedMinistry: false,
        year: 2024,
      );
      final ServiceReport b = ServiceReport(
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
      const ServiceReport a = ServiceReport(
        bibleStudies: 1,
        month: 5,
        sharedMinistry: false,
        year: 2024,
      );
      const ServiceReport b = ServiceReport(
        bibleStudies: 2,
        month: 5,
        sharedMinistry: false,
        year: 2024,
      );
      check(a == b).isFalse();
    });
    test('is not equal to an object of a different type', () {
      const ServiceReport report = ServiceReport(
        month: 5,
        sharedMinistry: false,
        year: 2024,
      );
      check(report == 'not a report').isFalse();
    });
  });

  group('ServiceReport comparison operators', () {
    const ServiceReport earlier = ServiceReport(
      month: 1,
      sharedMinistry: false,
      year: 2024,
    );
    const ServiceReport later = ServiceReport(
      month: 2,
      sharedMinistry: false,
      year: 2024,
    );
    const ServiceReport sameAsEarlier = ServiceReport(
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
      const ServiceReport report = ServiceReport(
        month: 5,
        sharedMinistry: false,
        year: 2024,
      );
      check(report.compareTo(report)).equals(0);
    });
    test('compares by year first', () {
      const ServiceReport a = ServiceReport(
        month: 5,
        sharedMinistry: false,
        year: 2023,
      );
      const ServiceReport b = ServiceReport(
        month: 5,
        sharedMinistry: false,
        year: 2024,
      );
      check(a.compareTo(b)).isLessThan(0);
      check(b.compareTo(a)).isGreaterThan(0);
    });
    test('compares by month when the year is equal', () {
      const ServiceReport a = ServiceReport(
        month: 4,
        sharedMinistry: false,
        year: 2024,
      );
      const ServiceReport b = ServiceReport(
        month: 5,
        sharedMinistry: false,
        year: 2024,
      );
      check(a.compareTo(b)).isLessThan(0);
    });
    test('ranks sharedMinistry true after false', () {
      const ServiceReport a = ServiceReport(
        month: 5,
        sharedMinistry: false,
        year: 2024,
      );
      const ServiceReport b = ServiceReport(
        month: 5,
        sharedMinistry: true,
        year: 2024,
      );
      check(a.compareTo(b)).isLessThan(0);
      check(b.compareTo(a)).isGreaterThan(0);
    });
    test('ranks a null hours before a non-null hours', () {
      const ServiceReport a = ServiceReport(
        bibleStudies: 1,
        month: 5,
        sharedMinistry: false,
        year: 2024,
      );
      const ServiceReport b = ServiceReport(
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
      const ServiceReport a = ServiceReport(
        bibleStudies: 1,
        hours: 5,
        month: 5,
        sharedMinistry: false,
        year: 2024,
      );
      const ServiceReport b = ServiceReport(
        bibleStudies: 1,
        hours: 10,
        month: 5,
        sharedMinistry: false,
        year: 2024,
      );
      check(a.compareTo(b)).isLessThan(0);
    });
    test('ranks a null hourCredit before a non-null hourCredit', () {
      const ServiceReport a = ServiceReport(
        bibleStudies: 1,
        month: 5,
        sharedMinistry: false,
        year: 2024,
      );
      final ServiceReport b = ServiceReport(
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
      final ServiceReport a = ServiceReport(
        bibleStudies: 1,
        hourCredit: HourCredit('Auxiliary', 10),
        month: 5,
        sharedMinistry: false,
        year: 2024,
      );
      final ServiceReport b = ServiceReport(
        bibleStudies: 1,
        hourCredit: HourCredit('Regular', 10),
        month: 5,
        sharedMinistry: false,
        year: 2024,
      );
      check(a.compareTo(b)).isLessThan(0);
    });
    test('compares by bibleStudies when other fields are equal', () {
      const ServiceReport a = ServiceReport(
        bibleStudies: 1,
        month: 5,
        sharedMinistry: false,
        year: 2024,
      );
      const ServiceReport b = ServiceReport(
        bibleStudies: 2,
        month: 5,
        sharedMinistry: false,
        year: 2024,
      );
      check(a.compareTo(b)).isLessThan(0);
    });
    test('compares by comments as the final tiebreaker', () {
      const ServiceReport a = ServiceReport(
        bibleStudies: 1,
        comments: 'A',
        month: 5,
        sharedMinistry: false,
        year: 2024,
      );
      const ServiceReport b = ServiceReport(
        bibleStudies: 1,
        comments: 'B',
        month: 5,
        sharedMinistry: false,
        year: 2024,
      );
      check(a.compareTo(b)).isLessThan(0);
    });
    test('returns 0 when every field is equal', () {
      const ServiceReport a = ServiceReport(
        bibleStudies: 1,
        comments: 'Note',
        month: 5,
        sharedMinistry: false,
        year: 2024,
      );
      const ServiceReport b = ServiceReport(
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
    final ServiceReport original = ServiceReport(
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
      final HourCredit newCredit = HourCredit('Regular pioneer', 50);
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
      final ServiceReport report = ServiceReport(
        bibleStudies: 2,
        comments: 'Note',
        hourCredit: sampleHourCredit,
        hours: 10,
        month: 5,
        sharedMinistry: false,
        year: 2024,
      );
      final ServiceReport roundTripped = ServiceReport.fromJson(
        report.toJson(),
      );
      check(roundTripped).equals(report);
    });
  });

  group('ServiceReport.toMap', () {
    test('contains every field under its expected key', () {
      final ServiceReport report = ServiceReport(
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
      const ServiceReport report = ServiceReport(
        month: 5,
        sharedMinistry: false,
        year: 2024,
      );
      check(report.toMap()['hourCredit']).isNull();
    });
  });

  group('ServiceReport.toString', () {
    test('formats every field separated by a pipe', () {
      final ServiceReport report = ServiceReport(
        bibleStudies: 2,
        comments: 'Note',
        hourCredit: sampleHourCredit,
        hours: 10,
        month: 5,
        sharedMinistry: false,
        year: 2024,
      );
      check(
        report.toString(),
      ).equals('2024|5|true|2|$sampleHourCredit|10|Note');
    });
    test('prints "null" for a missing hourCredit and hours', () {
      const ServiceReport report = ServiceReport(
        month: 5,
        sharedMinistry: false,
        year: 2024,
      );
      check(report.toString()).equals('2024|5|false|0|null|null|');
    });
  });
}
