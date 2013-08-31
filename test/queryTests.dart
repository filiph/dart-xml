part of test_runner;



queryTests(){
  group('query', (){
    test('single tag name query succeeds', (){
      var parsed = XML.parse(testXml);
      var result = parsed.query('TextBlock');
      expect(1, equals(result.length));
      expect('hello', equals(((result[0] as XmlElement) as XmlElement).attributes['text']));
    });

    test('single XmlNodeType query succeeds', (){
      var parsed = XML.parse(testXml);

      var result = parsed.query(XmlNodeType.CDATA);
      expect(1, equals(result.length));
      expect(result[0] is XmlCDATA, isTrue);
    });

    test('single attribute match query succeeds', (){
      var parsed = XML.parse(testXml);

      var result = parsed.query({'text':'hello world!'});

      expect(1, equals(result.length));
      expect('hello world!', equals((result[0] as XmlElement).attributes['text']));
    });

    test('all on tag name succeeds', (){
      var parsed = XML.parse(testXml);

      var result = parsed.queryAll('TextBlock');
      expect(2, equals(result.length));
      expect('hello', equals((result[0] as XmlElement).attributes['text']));
      expect('hello world!', equals((result[1] as XmlElement).attributes['text']));
    });

    test('leading and trailing spaces on tag attributes are respected', (){
      var parsed = XML.parse(testXml);

      var result = parsed.queryAll({'baz':' one space before, two after  '});
      expect(2, equals(result.length));
    });

    test('all on XmlNodeType succeeds', (){
      var parsed = XML.parse(testXml);

      var result = parsed.queryAll(XmlNodeType.PI);
      expect(2, equals(result.length));
      expect(result[0] is XmlProcessingInstruction, isTrue);
      expect(result[1] is XmlProcessingInstruction, isTrue);
      expect('hello world', equals((result[0] as XmlProcessingInstruction).text));
      expect('PI entry #2', equals((result[1] as XmlProcessingInstruction).text));
    });

    test('all on attributes succeeds', (){
      var parsed = XML.parse(testXml);

      var result = parsed.queryAll({'fontSize':'12'});
      expect(2, equals(result.length));
      expect((result[0] as XmlElement) is XmlElement, isTrue);
      expect((result[1] as XmlElement) is XmlElement, isTrue);
      expect('12', equals((result[0] as XmlElement).attributes['fontSize']));
      expect('12', equals((result[1] as XmlElement).attributes['fontSize']));
      expect('hello', equals((result[0] as XmlElement).attributes['text']));
      expect('hello world!', equals((result[1] as XmlElement).attributes['text']));
    });

    test('Xml DB query', (){
      XmlElement books = XML.parse(dbXml);

      //any book by author 'Stefan Handsomly'
      var result = books
                    .queryAll('book')
                    .where((e) =>
                        ((e as XmlElement).query('author')[0] as XmlElement)
                        .text == 'Stefan Handsomly').toList();

//      expect(result is XmlCollection, isTrue);
      expect(2, equals(result.length));
      expect('book', equals((result[0] as XmlElement).name));
    });

  });

}