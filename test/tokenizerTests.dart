part of test_runner;

tokenizerTests(){
  final t = new XmlTokenizer(testXml);

  group('tokenizer', (){
    test('indexOfToken() return -1 if not found.', (){
      var result = t.indexOfToken(new XmlToken(XmlToken.IGNORE));
      Expect.equals(-1, result, 'Match should not be found.');
    });

    test('indexOfToken() return correct index if token found.', (){
      var result = t.indexOfToken(new XmlToken(XmlToken.LT));
      Expect.equals(3, result, 'Match should be found for LT');
    });

    test('indexOfToken() return correct index if string token found.', (){
      var result = t.indexOfToken(new XmlToken.string('StackPanel'));
      Expect.equals(4, result, 'Match should be found for StackPanel');
    });

    test('indexOfToken() return correct index if double quote found', (){
      var result = t.indexOfToken(new XmlToken.quote(XmlTokenizer.QUOTE));
      Expect.equals(36, result, 'Match should be found.');
    });

    test('indexOfToken() return correct index if single quote found', (){
      var result = t.indexOfToken(new XmlToken.quote(XmlTokenizer.SQUOTE));
      Expect.equals(8, result, 'Match should be found.');
    });

    test('indexOfToken() return correct index if single quote found with start index offset', (){
      var result = t.indexOfToken(new XmlToken.quote(XmlTokenizer.SQUOTE), start: 7);
      Expect.equals(8, result, 'Match should be found.');
    });

    test('indexOfToken() last token index correct', (){
      var result = t.indexOfToken(new XmlToken(XmlToken.END_COMMENT), start: 183);
      Expect.equals(183, result, 'Match should be found.');
    });

    test('lookAheadMatch() false when token not found.', (){
      var result = t.lookAheadMatch([new XmlToken(XmlToken.IGNORE)]);
      Expect.isFalse(result, 'Match should not be found.');
    });

    test('lookAheadMatch() single token', (){
      var result = t.lookAheadMatch([new XmlToken(XmlToken.LT)]);
      Expect.isTrue(result, 'Match should be found.');
    });

    test('lookAheadMatch() returns false on incorrect token sequence', (){
      var result = t.lookAheadMatch(
          [new XmlToken(XmlToken.LT),
           new XmlToken.string('StackPanel'),
           new XmlToken(XmlToken.IGNORE)]);
      Expect.isFalse(result, 'Match should not be found.');
    });

    test('lookAheadMatch() token sequence', (){
      var result = t.lookAheadMatch(
          [new XmlToken(XmlToken.LT),
           new XmlToken.string('StackPanel'),
           new XmlToken(XmlToken.NAMESPACE),
           new XmlToken.string('test')]);
      Expect.isTrue(result, 'Match should be found.');
    });

    test('lookAheadMatch() returns false when token sequence is ahead of until sequence', (){
      var result = t.lookAheadMatch(
          [new XmlToken(XmlToken.LT),
           new XmlToken.string('StackPanel'),
           new XmlToken(XmlToken.NAMESPACE),
           new XmlToken.string('test')],
          until:[new XmlToken(XmlToken.END_COMMENT)
                 ]);
      Expect.isFalse(result, 'Match should not be found.');
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

      Expect.isTrue(t.lookAheadMatch(pattern, index: 0),
          'Match should not be found.');
    });
  });
}
