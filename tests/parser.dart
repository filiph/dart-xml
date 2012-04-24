
parserTests(){
  var parsed = XML.parse(testXml);

  group('parser', (){
    test('no fidelity lost during successive parse/stringify', (){
      var str1 = parsed.toString();
      var parsed2 = XML.parse(str1);
      var str2 = parsed2.toString();
      Expect.equals(str1, str2);
    });

    test('minimal OK', (){
      var result = XML.parse('<foo></foo>');
      Expect.isTrue(result is XmlElement);
      Expect.equals('foo', result.name);
    });

    test('throw on no close tag', (){
      Expect.throws(
        () => XML.parse('<foo><bar></bar>'),
        (e) => e is XmlException);
    });

    test('throw on no open tag', (){
      Expect.throws(
        () => XML.parse('<foo></bar></foo>'),
        (e) => e is XmlException);
    });

    test('throw on attribute no quotes', (){
      Expect.throws(
        () => XML.parse('<foo bar=bloo></foo>'),
        (e) => e is XmlException);
    });

    test('throw on attribute unbalanced quotes', (){
      Expect.throws(
        () => XML.parse('<foo bar="bloo></foo>'),
        (e) => e is XmlException);

      Expect.throws(
        () => XML.parse('<foo bar=bloo"></foo>'),
        (e) => e is XmlException);
    });

    test('all comments stripped', (){
      var str = parsed.toString();
      Expect.isFalse(str.contains("<!--") || str.contains("-->"));
    });

    test('throw on tag mismatch', (){
      Expect.throws(
        () => XML.parse('<foo></bar>'),
        (e) => e is XmlException);
    });

    test('throw on empty', (){
      Expect.throws(
        () => XML.parse('   '),
        (e) => e is XmlException);
    });

    test('throw on string in root', (){
      Expect.throws(
        () => XML.parse('hello there <foo></foo>   '),
        (e) => e is XmlException);

      //TODO should throw here, fix.
      Expect.throws(
        () => XML.parse('<foo></foo> hello there   '),
        (e) => e is XmlException);
    });

    test('throw on CDATA in root', (){
      Expect.throws(
        () => XML.parse('<![CDATA[ hello world]]>'),
        (e) => e is XmlException);
    });

    test('throw on PI in root', (){
      Expect.throws(
        () => XML.parse('<? hello world ?>'),
        (e) => e is XmlException);
    });
  });

}