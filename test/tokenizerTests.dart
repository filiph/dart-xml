part of test_runner;

tokenizerTests(){
  final t = new XmlTokenizer(testXml);

  group('tokenizer', (){
    test('indexOfToken() return -1 if not found.', (){
      var result = t.indexOfToken(new XmlToken(XmlToken.IGNORE));
      expect(-1, equals(result), reason:'Match should not be found.');
    });

    test('indexOfToken() return correct index if token found.', (){
      var result = t.indexOfToken(new XmlToken(XmlToken.LT));
      expect(3, equals(result), reason:'Match should be found for LT');
    });

    test('indexOfToken() return correct index if string token found.', (){
      var result = t.indexOfToken(new XmlToken.string('StackPanel'));
      expect(4, equals(result), reason:'Match should be found for StackPanel');
    });

    test('indexOfToken() return correct index if double quote found', (){
      var result = t.indexOfToken(new XmlToken.quote(XmlTokenizer.QUOTE));
      expect(31, equals(result), reason:'Match should be found.');
    });

    test('indexOfToken() return correct index if single quote found', (){
      var result = t.indexOfToken(new XmlToken.quote(XmlTokenizer.SQUOTE));
      expect(8, equals(result), reason:'Match should be found.');
    });

    test('indexOfToken() return correct index if single quote found with start index offset', (){
      var result = t.indexOfToken(new XmlToken.quote(XmlTokenizer.SQUOTE), start: 7);
      expect(8, equals(result), reason:'Match should be found.');
    });

    test('indexOfToken() last token index correct', (){
      var result = t.indexOfToken(new XmlToken(XmlToken.END_COMMENT), start: 171);
      expect(171, equals(result), reason:'Match should be found.');
    });

    test('lookAheadMatch() false when token not found.', (){
      var result = t.lookAheadMatch([new XmlToken(XmlToken.IGNORE)]);
      expect(result, isFalse, reason:'Match should not be found.');
    });

    test('lookAheadMatch() single token', (){
      var result = t.lookAheadMatch([new XmlToken(XmlToken.LT)]);
      expect(result, isTrue, reason:'Match should be found.');
    });

    test('lookAheadMatch() returns false on incorrect token sequence', (){
      var result = t.lookAheadMatch(
          [new XmlToken(XmlToken.LT),
           new XmlToken.string('StackPanel'),
           new XmlToken(XmlToken.IGNORE)]);
      expect(result, isFalse, reason:'Match should not be found.');
    });

    test('lookAheadMatch() token sequence', (){
      var result = t.lookAheadMatch(
          [new XmlToken(XmlToken.LT),
           new XmlToken.string('StackPanel'),
           new XmlToken(XmlToken.NAMESPACE),
           new XmlToken.string('test')]);
      expect(result, isTrue, reason:'Match should be found.');
    });

    test('lookAheadMatch() returns false when token sequence is ahead of until sequence', (){
      var result = t.lookAheadMatch(
          [new XmlToken(XmlToken.LT),
           new XmlToken.string('StackPanel'),
           new XmlToken(XmlToken.NAMESPACE),
           new XmlToken.string('test')],
          until:[new XmlToken(XmlToken.END_COMMENT)
                 ]);
      expect(result, isFalse, reason:'Match should not be found.');
    });

    test('lookAheadMatch() ending sequence', (){
      final pattern =
      [
       new XmlToken(XmlToken.LT),
       new XmlToken(XmlToken.SLASH),
       new XmlToken.string('StackPanel'),
       new XmlToken(XmlToken.GT),
       new XmlToken(XmlToken.START_COMMENT),
       new XmlToken.string(' comment '),
       new XmlToken(XmlToken.END_COMMENT)
      ];

      expect(t.lookAheadMatch(pattern, index: 0), isTrue, reason:'Match should not be found.');
    });
  });
}
