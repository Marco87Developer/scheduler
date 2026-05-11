import 'package:scheduler/src/extensions/string_extension.dart';
import 'package:test/test.dart';

void main() {
  group('StringExtension.collapseWhitespace', () {
    group('— empty and blank strings', () {
      test('empty string returns empty string', () {
        expect(''.collapseWhitespace(), equals(''));
      });

      test('single space returns empty string', () {
        expect(' '.collapseWhitespace(), equals(''));
      });

      test('multiple spaces return empty string', () {
        expect('   '.collapseWhitespace(), equals(''));
      });

      test('single tab returns empty string', () {
        expect('\t'.collapseWhitespace(), equals(''));
      });

      test('single newline returns empty string', () {
        expect('\n'.collapseWhitespace(), equals(''));
      });

      test('mixed whitespace-only returns empty string', () {
        expect(' \t\n\r '.collapseWhitespace(), equals(''));
      });
    });

    group('— strings without whitespace', () {
      test('single word is returned unchanged', () {
        expect('hello'.collapseWhitespace(), equals('hello'));
      });

      test('numeric string is returned unchanged', () {
        expect('12345'.collapseWhitespace(), equals('12345'));
      });

      test('string with punctuation is returned unchanged', () {
        expect('hello,world!'.collapseWhitespace(), equals('hello,world!'));
      });
    });

    group('— leading and trailing whitespace', () {
      test('leading single space is trimmed', () {
        expect(' hello'.collapseWhitespace(), equals('hello'));
      });

      test('trailing single space is trimmed', () {
        expect('hello '.collapseWhitespace(), equals('hello'));
      });

      test('leading and trailing spaces are trimmed', () {
        expect(' hello '.collapseWhitespace(), equals('hello'));
      });

      test('multiple leading spaces are trimmed', () {
        expect('   hello'.collapseWhitespace(), equals('hello'));
      });

      test('multiple trailing spaces are trimmed', () {
        expect('hello   '.collapseWhitespace(), equals('hello'));
      });

      test('leading tab is trimmed', () {
        expect('\thello'.collapseWhitespace(), equals('hello'));
      });

      test('leading newline is trimmed', () {
        expect('\nhello'.collapseWhitespace(), equals('hello'));
      });

      test('mixed leading whitespace is trimmed', () {
        expect('\t \n hello'.collapseWhitespace(), equals('hello'));
      });

      test('mixed trailing whitespace is trimmed', () {
        expect('hello\t \n '.collapseWhitespace(), equals('hello'));
      });
    });

    group('— internal whitespace collapsing', () {
      test('two words with single space are unchanged', () {
        expect('hello world'.collapseWhitespace(), equals('hello world'));
      });

      test('two words with multiple spaces collapse to one', () {
        expect('hello  world'.collapseWhitespace(), equals('hello world'));
      });

      test('multiple spaces between words collapse to one', () {
        expect('hello   world'.collapseWhitespace(), equals('hello world'));
      });

      test('tab between words collapses to single space', () {
        expect('hello\tworld'.collapseWhitespace(), equals('hello world'));
      });

      test('newline between words collapses to single space', () {
        expect('hello\nworld'.collapseWhitespace(), equals('hello world'));
      });

      test('carriage return between words collapses to single space', () {
        expect('hello\rworld'.collapseWhitespace(), equals('hello world'));
      });

      test('mixed whitespace between words collapses to single space', () {
        expect('hello \t\n world'.collapseWhitespace(), equals('hello world'));
      });

      test('three words with multiple spaces collapse correctly', () {
        expect(
          'one   two   three'.collapseWhitespace(),
          equals('one two three'),
        );
      });
    });

    group('— combination of leading, internal, and trailing', () {
      test('spaces all around collapse and trim correctly', () {
        expect('  hello   world  '.collapseWhitespace(), equals('hello world'));
      });

      test('tabs and newlines around and inside collapse correctly', () {
        expect(
          '\t hello \n world \t'.collapseWhitespace(),
          equals('hello world'),
        );
      });

      test('complex multi-line string is fully normalised', () {
        expect(
          '  foo\t\tbar\n\nbaz  '.collapseWhitespace(),
          equals('foo bar baz'),
        );
      });
    });

    group('— Unicode whitespace', () {
      test('non-breaking space (U+00A0) is collapsed', () {
        expect('hello\u00A0world'.collapseWhitespace(), equals('hello world'));
      });

      test('em space (U+2003) between words collapses to single space', () {
        expect('hello\u2003world'.collapseWhitespace(), equals('hello world'));
      });

      test('zero-width space (U+200B) is NOT treated as whitespace', () {
        // U+200B is a Format character (Cf), not a Space Separator (Zs),
        // so \s does not match it even in Unicode mode.
        const String s = '\u200Bhello\u200Bworld\u200B';
        expect(s.collapseWhitespace(), equals(s));
      });
    });

    group('— idempotency', () {
      test('already-collapsed string is idempotent', () {
        const String s = 'hello world';
        expect(s.collapseWhitespace().collapseWhitespace(), equals(s));
      });

      test('applying twice equals applying once', () {
        const String s = '  hello   world  ';
        expect(
          s.collapseWhitespace().collapseWhitespace(),
          equals(s.collapseWhitespace()),
        );
      });
    });
  });

  group('StringExtension.removeAllWhitespace', () {
    group('— empty and blank strings', () {
      test('empty string returns empty string', () {
        expect(''.removeAllWhitespace(), equals(''));
      });

      test('single space returns empty string', () {
        expect(' '.removeAllWhitespace(), equals(''));
      });

      test('multiple spaces return empty string', () {
        expect('   '.removeAllWhitespace(), equals(''));
      });

      test('single tab returns empty string', () {
        expect('\t'.removeAllWhitespace(), equals(''));
      });

      test('single newline returns empty string', () {
        expect('\n'.removeAllWhitespace(), equals(''));
      });

      test('mixed whitespace-only returns empty string', () {
        expect(' \t\n\r '.removeAllWhitespace(), equals(''));
      });
    });

    group('— strings without whitespace', () {
      test('single word is returned unchanged', () {
        expect('hello'.removeAllWhitespace(), equals('hello'));
      });

      test('numeric string is returned unchanged', () {
        expect('12345'.removeAllWhitespace(), equals('12345'));
      });

      test('string with punctuation is returned unchanged', () {
        expect('hello,world!'.removeAllWhitespace(), equals('hello,world!'));
      });
    });

    group('— leading and trailing whitespace', () {
      test('leading single space is removed', () {
        expect(' hello'.removeAllWhitespace(), equals('hello'));
      });

      test('trailing single space is removed', () {
        expect('hello '.removeAllWhitespace(), equals('hello'));
      });

      test('leading and trailing spaces are removed', () {
        expect(' hello '.removeAllWhitespace(), equals('hello'));
      });

      test('multiple leading spaces are removed', () {
        expect('   hello'.removeAllWhitespace(), equals('hello'));
      });

      test('multiple trailing spaces are removed', () {
        expect('hello   '.removeAllWhitespace(), equals('hello'));
      });

      test('leading tab is removed', () {
        expect('\thello'.removeAllWhitespace(), equals('hello'));
      });

      test('leading newline is removed', () {
        expect('\nhello'.removeAllWhitespace(), equals('hello'));
      });

      test('mixed leading whitespace is removed', () {
        expect('\t \n hello'.removeAllWhitespace(), equals('hello'));
      });
    });

    group('— internal whitespace removal', () {
      test('single internal space is removed', () {
        expect('hello world'.removeAllWhitespace(), equals('helloworld'));
      });

      test('multiple internal spaces are removed', () {
        expect('hello   world'.removeAllWhitespace(), equals('helloworld'));
      });

      test('internal tab is removed', () {
        expect('hello\tworld'.removeAllWhitespace(), equals('helloworld'));
      });

      test('internal newline is removed', () {
        expect('hello\nworld'.removeAllWhitespace(), equals('helloworld'));
      });

      test('internal carriage return is removed', () {
        expect('hello\rworld'.removeAllWhitespace(), equals('helloworld'));
      });

      test('mixed internal whitespace is removed', () {
        expect('hello \t\n world'.removeAllWhitespace(), equals('helloworld'));
      });

      test('three words with spaces all concatenate', () {
        expect('one two three'.removeAllWhitespace(), equals('onetwothree'));
      });
    });

    group('— combination of all whitespace positions', () {
      test('spaces all around and inside are removed', () {
        expect('  hello   world  '.removeAllWhitespace(), equals('helloworld'));
      });

      test('complex multi-line string is stripped', () {
        expect(
          '  foo\t\tbar\n\nbaz  '.removeAllWhitespace(),
          equals('foobarbaz'),
        );
      });
    });

    group('— Unicode whitespace', () {
      test('non-breaking space (U+00A0) is removed', () {
        expect('hello\u00A0world'.removeAllWhitespace(), equals('helloworld'));
      });

      test('em space (U+2003) is removed', () {
        expect('hello\u2003world'.removeAllWhitespace(), equals('helloworld'));
      });

      test('zero-width space (U+200B) is NOT removed', () {
        const String s = '\u200Bhello\u200Bworld\u200B';
        expect(s.removeAllWhitespace(), equals(s));
      });
    });

    group('— idempotency', () {
      test('already-stripped string is idempotent', () {
        const String s = 'helloworld';
        expect(s.removeAllWhitespace().removeAllWhitespace(), equals(s));
      });

      test('applying twice equals applying once', () {
        const String s = '  hello   world  ';
        expect(
          s.removeAllWhitespace().removeAllWhitespace(),
          equals(s.removeAllWhitespace()),
        );
      });
    });
  });

  group('StringExtension — interaction between methods', () {
    test(
      'removeAllWhitespace then collapseWhitespace leaves no whitespace',
      () {
        const String s = '  hello   world  ';
        expect(
          s.removeAllWhitespace().collapseWhitespace(),
          equals('helloworld'),
        );
      },
    );

    test('collapseWhitespace then removeAllWhitespace equals '
        'removeAllWhitespace alone', () {
      const String s = '  hello   world  ';
      expect(
        s.collapseWhitespace().removeAllWhitespace(),
        equals(s.removeAllWhitespace()),
      );
    });

    test('collapseWhitespace result contains no leading whitespace', () {
      expect('  hello'.collapseWhitespace().startsWith(' '), isFalse);
    });

    test('collapseWhitespace result contains no trailing whitespace', () {
      expect('hello  '.collapseWhitespace().endsWith(' '), isFalse);
    });

    test('removeAllWhitespace result contains no whitespace at all', () {
      const String s = '  hello   world  ';
      final String result = s.removeAllWhitespace();
      expect(result.contains(RegExp(r'\s')), isFalse);
    });
  });
}
