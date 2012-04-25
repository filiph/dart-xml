
parserTests(){

  group('parser', (){
    test('no fidelity lost during successive parse/stringify', (){
      var parsed = XML.parse(testXml);
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

    test('attribute no quotes OK when in quirks mode', (){
        var result = XML.parse('<foo bar=bloo></foo>', true);
        Expect.equals('bloo', result.attributes['bar']);
    });

    test('throw on attributes syntax error in quirks mode', (){
      Expect.throws(
        () => XML.parse('<foo bar=bloo blee bleep="hello"></foo>'),
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

    test('throw on attribute missing =', (){
      Expect.throws(
        () => XML.parse('<foo bar"bloo"></foo>'),
        (e) => e is XmlException);
    });

    test('throw on attribute EOF', (){
      Expect.throws(
        () => XML.parse('<foo bar"bloo'),
        (e) => e is XmlException);
    });

    test('all comments stripped', (){
      var parsed = XML.parse(testXml);
      var str = parsed.toString();
      Expect.isFalse(str.contains("<!--") || str.contains("-->"));
    });

    test('throw on tag mismatch', (){
      Expect.throws(
        () => XML.parse('<foo><boo></boo></bar>'),
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
        () => XML.parse('<foo></foo> <![CDATA[ hello world]]>'),
        (e) => e is XmlException);

      Expect.throws(
        () => XML.parse('<![CDATA[ hello world]]> <foo></foo>'),
        (e) => e is XmlException);
    });

    test('throw on PI in root', (){
      Expect.throws(
        () => XML.parse('<foo></foo><? hello world ?>'),
        (e) => e is XmlException);

      Expect.throws(
        () => XML.parse('<? hello world ?> <foo></foo>'),
        (e) => e is XmlException);
    });

    test('throw on CDATA not closed', (){
      Expect.throws(
        () => XML.parse('<foo><![CDATA[ hello world'),
        (e) => e is XmlException);
    });

    test('throw on PI not closed', (){
      Expect.throws(
        () => XML.parse('<foo><? hello world'),
        (e) => e is XmlException);
    });

    test('throw on comment not closed', (){
      Expect.throws(
        () => XML.parse('<foo><!-- hello world'),
        (e) => e is XmlException);
    });

    test('throw on nested comments', (){
      Expect.throws(
        () => XML.parse('<foo><!-- blah <!-- blah --> blah  --></foo>'),
        (e) => e is XmlException);
    });

    test('throw on invalid tag name', (){
      Expect.throws(
        () => XML.parse('<!foo></!foo>'),
        (e) => e is XmlException);
    });

    test('throw on invalid tag open syntax', (){
      Expect.throws(
        () => XML.parse('<foo><bar !></bar></foo>'),
        (e) => e is XmlException);
    });

    test('throw oninvalid tag open syntax', (){
      Expect.throws(
        () => XML.parse('<foo><bar !></bar></foo>'),
        (e) => e is XmlException);
    });

    test('throw on open tag EOF', (){
      Expect.throws(
        () => XML.parse('<foo><bar'),
        (e) => e is Exception);
    });

    test('throw on text node  EOF', (){
      Expect.throws(
        () => XML.parse('<foo>bar'),
        (e) => e is Exception);
    });

    test('throw on namespace out of scope', (){
      Expect.throws(
        () => XML.parse('<foo xmlns:test1="bar" xmlns:test2="bar">'
          '<bar test3:help="me"></bar></foo>'),
        (e) => e is Exception);
    });
  });

}