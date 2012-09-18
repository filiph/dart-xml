

queryTests(){
  group('query', (){
    test('single tag name query succeeds', (){
      var parsed = XML.parse(testXml);
      var result = parsed.query('TextBlock');
      Expect.equals(1, result.length);
      Expect.equals('hello', result[0].attributes['text']);
    });

    test('single XmlNodeType query succeeds', (){
      var parsed = XML.parse(testXml);

      var result = parsed.query(XmlNodeType.CDATA);
      Expect.equals(1, result.length);
      Expect.isTrue(result[0] is XmlCDATA);
    });

    test('single attribute match query succeeds', (){
      var parsed = XML.parse(testXml);

      var result = parsed.query({'text':'hello world!'});

      Expect.equals(1, result.length);
      Expect.equals('hello world!', result[0].attributes['text']);
    });

    test('all on tag name succeeds', (){
      var parsed = XML.parse(testXml);

      var result = parsed.queryAll('TextBlock');
      Expect.equals(2, result.length);
      Expect.equals('hello', result[0].attributes['text']);
      Expect.equals('hello world!', result[1].attributes['text']);
    });

    test('all on XmlNodeType succeeds', (){
      var parsed = XML.parse(testXml);

      var result = parsed.queryAll(XmlNodeType.PI);
      Expect.equals(2, result.length);
      Expect.isTrue(result[0] is XmlProcessingInstruction);
      Expect.isTrue(result[1] is XmlProcessingInstruction);
      Expect.equals('hello world', result[0].text);
      Expect.equals('PI entry #2', result[1].text);
    });

    test('all on attributes succeeds', (){
      var parsed = XML.parse(testXml);

      var result = parsed.queryAll({'fontSize':'12'});
      Expect.equals(2, result.length);
      Expect.isTrue(result[0] is XmlElement);
      Expect.isTrue(result[1] is XmlElement);
      Expect.equals('12', result[0].attributes['fontSize']);
      Expect.equals('12', result[1].attributes['fontSize']);
      Expect.equals('hello', result[0].attributes['text']);
      Expect.equals('hello world!', result[1].attributes['text']);
    });

    test('Xml DB query', (){
      XmlElement books = XML.parse(dbXml);

      //any book by author 'Stefan Handsomly'
      var result = books
                    .queryAll('book')
                    .filter((e) =>
                        (e as XmlElement).query('author')[0].text == 'Stefan Handsomly');

      Expect.isTrue(result is XmlCollection);
      Expect.equals(2, result.length);
      Expect.equals('book', result[0].name);
    });

  });

}