import 'package:scheduler/src/models/time.dart';
import 'package:test/test.dart';

void main() {
  group('Constructors', () {
    test('default constructor creates midnight', () {
      const Time time = Time();
      expect(time.inSeconds, equals(0));
      expect(time.hours, equals(0));
      expect(time.minutes, equals(0));
      expect(time.seconds, equals(0));
    });
    test('constructor sets time correctly with valid inputs', () {
      const Time time = Time(14, 30, 15);
      expect(time.hours, equals(14));
      expect(time.minutes, equals(30));
      expect(time.seconds, equals(15));
    });
    test('constructor wraps around if greater than 24h', () {
      const Time time = Time(25, 61, 61);
      expect(time.hours, equals(2));
      expect(time.minutes, equals(2));
      expect(time.seconds, equals(1));
    });
    test('constructor handles negative values correctly', () {
      const Time time = Time(-1, -1, -1);
      expect(time.hours, equals(22));
      expect(time.minutes, equals(58));
      expect(time.seconds, equals(59));
    });
    test('fromDateTime uses hour, minute, second', () {
      final DateTime dt = DateTime(2023, 1, 1, 15, 45, 30);
      final Time time = Time.fromDateTime(dt);
      expect(time.hours, equals(15));
      expect(time.minutes, equals(45));
      expect(time.seconds, equals(30));
    });
    test('fromDuration converts duration to time', () {
      const Duration duration = Duration(hours: 10, minutes: 20);
      final Time time = Time.fromDuration(duration);
      expect(time.hours, equals(10));
      expect(time.minutes, equals(20));
      expect(time.seconds, equals(0));
    });
    test('fromMinutes converts minutes and wraps correctly', () {
      final Time time = Time.fromMinutes(90);
      expect(time.hours, equals(1));
      expect(time.minutes, equals(30));
      expect(time.seconds, equals(0));
    });
    test('fromMinutes handles fractional values', () {
      final Time time = Time.fromMinutes(90.5);
      expect(time.hours, equals(1));
      expect(time.minutes, equals(30));
      expect(time.seconds, equals(30));
    });
    test('fromSeconds converts seconds correctly', () {
      final Time time = Time.fromSeconds(3665);
      expect(time.hours, equals(1));
      expect(time.minutes, equals(1));
      expect(time.seconds, equals(5));
    });
    test('fromSeconds handles fractional values via rounding', () {
      final Time time1 = Time.fromSeconds(3665.4);
      expect(time1.seconds, equals(5));
      final Time time2 = Time.fromSeconds(3665.6);
      expect(time2.seconds, equals(6));
    });
    test('parse handles valid Thh:mm:ss format', () {
      final Time time = Time.parse('T14:30:15');
      expect(time.hours, equals(14));
      expect(time.minutes, equals(30));
      expect(time.seconds, equals(15));
    });
    test('parse handles valid hh:mm format', () {
      final Time time = Time.parse('14:30');
      expect(time.hours, equals(14));
      expect(time.minutes, equals(30));
      expect(time.seconds, equals(0));
    });
    test('parse throws FormatException on invalid input', () {
      expect(() => Time.parse('invalid'), throwsFormatException);
    });
  });

  group('Constants', () {
    test('static constants have correct values', () {
      expect(Time.className, equals('Time'));
      expect(Time.hoursPerDay, equals(24));
      expect(Time.minutesPerDay, equals(1440));
      expect(Time.minutesPerHour, equals(60));
      expect(Time.secondsPerDay, equals(86400));
      expect(Time.secondsPerHour, equals(3600));
      expect(Time.secondsPerMinute, equals(60));
    });
  });

  group('Properties and Getters', () {
    test('inHours rounds down if minutes are less than 30', () {
      const Time time = Time(10, 29);
      expect(time.inHours, equals(10));
    });
    test('inHours rounds up if minutes are 30 or more', () {
      const Time time = Time(10, 30);
      expect(time.inHours, equals(11));
    });
    test('inHours wraps to 0 if rounding up from 23:30', () {
      const Time time = Time(23, 30);
      expect(time.inHours, equals(0));
    });
    test('inSeconds returns total elapsed seconds', () {
      const Time time = Time(1, 1, 1);
      expect(time.inSeconds, equals(3661));
    });
    test('hashCode is consistent for identical times', () {
      const Time t1 = Time(1, 1, 1);
      const Time t2 = Time(1, 1, 1);
      expect(t1.hashCode, equals(t2.hashCode));
    });
  });

  group('Operators', () {
    test('operator * multiplies time correctly', () {
      const Time t1 = Time(1);
      final Time t2 = t1 * 2;
      expect(t2.hours, equals(2));
    });
    test('operator + adds two times and wraps', () {
      const Time t1 = Time(23);
      const Time t2 = Time(2);
      final Time t3 = t1 + t2;
      expect(t3.hours, equals(1));
    });
    test('operator - subtracts times and wraps backwards', () {
      const Time t1 = Time(1);
      const Time t2 = Time(2);
      final Time t3 = t1 - t2;
      expect(t3.hours, equals(23));
    });
    test('operator / divides time correctly', () {
      const Time t1 = Time(2);
      final Time t2 = t1 / 2;
      expect(t2.hours, equals(1));
    });
    test('relational operators work correctly', () {
      const Time t1 = Time(1);
      const Time t2 = Time(2);
      expect(t1 < t2, isTrue);
      expect(t1 <= t2, isTrue);
      expect(t2 > t1, isTrue);
      expect(t2 >= t1, isTrue);
    });
    test('operator == identifies identical times', () {
      const Time t1 = Time(1, 2, 3);
      const Time t2 = Time(1, 2, 3);
      const Time t3 = Time(1, 2, 4);
      expect(t1 == t2, isTrue);
      expect(t1 == t3, isFalse);
    });
  });

  group('Methods', () {
    test('compareTo returns zero for equal times', () {
      const Time t1 = Time(5);
      const Time t2 = Time(5);
      expect(t1.compareTo(t2), equals(0));
    });
    test('compareTo returns negative for earlier time', () {
      const Time t1 = Time(4);
      const Time t2 = Time(5);
      expect(t1.compareTo(t2), isNegative);
    });
    test('compareTo returns positive for later time', () {
      const Time t1 = Time(6);
      const Time t2 = Time(5);
      expect(t1.compareTo(t2), isPositive);
    });
    test('copyWith modifies specified fields only', () {
      const Time t1 = Time(1, 2, 3);
      final Time t2 = t1.copyWith(hours: 4, seconds: 5);
      expect(t2.hours, equals(4));
      expect(t2.minutes, equals(2));
      expect(t2.seconds, equals(5));
    });
    test('copyWith retains old fields when omitted', () {
      const Time t1 = Time(1, 2, 3);
      final Time t2 = t1.copyWith();
      expect(t2, equals(t1));
    });
    test('difference calculates correct duration', () {
      const Time t1 = Time(3);
      const Time t2 = Time(1);
      expect(t1.difference(t2).inHours, equals(2));
    });
    test('isAfter, isAfterOrEqual, isBefore, isBeforeOrEqual work', () {
      const Time t1 = Time(1);
      const Time t2 = Time(2);
      expect(t1.isBefore(t2), isTrue);
      expect(t1.isBeforeOrEqual(t2), isTrue);
      expect(t2.isAfter(t1), isTrue);
      expect(t2.isAfterOrEqual(t1), isTrue);
    });
    test('toDuration transforms into valid duration object', () {
      const Time time = Time(1, 30);
      expect(time.toDuration().inMinutes, equals(90));
    });
    test('toString formats to Thh:mm:ss consistently', () {
      const Time time = Time(5, 7, 9);
      expect(time.toString(), equals('T05:07:09'));
    });
    test('toStringHHMM formats and rounds minutes correctly', () {
      const Time t1 = Time(5, 7, 29);
      expect(t1.toStringHHMM(), equals('05:07'));
      const Time t2 = Time(5, 7, 30);
      expect(t2.toStringHHMM(), equals('05:08'));
    });
    test('toStringHHMM wraps around at end of day', () {
      const Time time = Time(23, 59, 30);
      expect(time.toStringHHMM(), equals('00:00'));
    });
    test('toStringHMM formats without leading hour zero', () {
      const Time time = Time(5, 7, 30);
      expect(time.toStringHMM(), equals('5:08'));
    });
    test('toStringHMM wraps around at end of day', () {
      const Time time = Time(23, 59, 30);
      expect(time.toStringHMM(), equals('0:00'));
    });
    test('toStringMMSS formats correctly', () {
      const Time time = Time(5, 7, 9);
      expect(time.toStringMMSS(), equals('07:09'));
    });
  });

  group('Static Methods', () {
    test('max returns the later time', () {
      const Time t1 = Time(1);
      const Time t2 = Time(2);
      expect(Time.max(t1, t2), equals(t2));
    });
    test('min returns the earlier time', () {
      const Time t1 = Time(1);
      const Time t2 = Time(2);
      expect(Time.min(t1, t2), equals(t1));
    });
    test('tryParse returns null for invalid strings', () {
      expect(Time.tryParse('invalid'), isNull);
      expect(Time.tryParse('12:ab'), isNull);
      expect(Time.tryParse('12:34:56:78'), isNull);
    });
    test('tryParse handles internal whitespaces safely', () {
      final Time? time = Time.tryParse(' T 14 : 30 ');
      expect(time?.hours, equals(14));
      expect(time?.minutes, equals(30));
    });
  });
}
