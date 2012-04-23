// point this to wherever your copy of the dart source code is
#import('../../../src/lib/unittest/unittest.dart');
#import('../../../src/lib/unittest/html_enhanced_config.dart');

#import('../xml.dart');

void main() {
  useHtmlEnhancedConfiguration();

  var parsed = XML.parse(testXml);

  group('syntax tests', (){
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

  group('query tests', (){
    test('single tag name query succeeds', (){
      var result = parsed.query('TextBlock');
      Expect.equals(1, result.length);
      Expect.equals('hello', result[0].attributes['text']);
    });

    test('single XmlNodeType query succeeds', (){
      var result = parsed.query(XmlNodeType.CDATA);
      Expect.equals(1, result.length);
      Expect.isTrue(result[0] is XmlCDATA);
    });

    test('single attribute match query succeeds', (){
      var result = parsed.query({'text':'hello world!'});

      Expect.equals(1, result.length);
      Expect.equals('hello world!', result[0].attributes['text']);
    });

    test('query all on tag name succeeds', (){
      var result = parsed.queryAll('TextBlock');
      Expect.equals(2, result.length);
      Expect.equals('hello', result[0].attributes['text']);
      Expect.equals('hello world!', result[1].attributes['text']);
    });

    test('query all on XmlNodeType succeeds', (){
      var result = parsed.queryAll(XmlNodeType.PI);
      Expect.equals(2, result.length);
      Expect.isTrue(result[0] is XmlProcessingInstruction);
      Expect.isTrue(result[1] is XmlProcessingInstruction);
      Expect.equals('hello world', result[0].text);
      Expect.equals('PI entry #2', result[1].text);
    });

    test('query all on attributes succeeds', (){
      var result = parsed.queryAll({'fontSize':'12'});
      Expect.equals(2, result.length);
      Expect.isTrue(result[0] is XmlElement);
      Expect.isTrue(result[1] is XmlElement);
      Expect.equals('12', result[0].attributes['fontSize']);
      Expect.equals('12', result[1].attributes['fontSize']);
      Expect.equals('hello', result[0].attributes['text']);
      Expect.equals('hello world!', result[1].attributes['text']);
    });

  });
}


final String testXml =
'''
<!-- comment -->
<StackPanel>
<?hello world?>
   <TextBlock text='hello' fontSize="12" />
   <TextBlock text="hello world!" fontSize="12"></TextBlock>
   text node
   <Border>
<![CDATA[
the markup below should be escaped
<greeting>hello world</greeting>
]]>
      <!-- comment -->
      <Image>
         Now is the time for all good people to blah blah blah
      </Image>
      <!-- comment -->
   </Border>
 another text node
<? PI entry #2 ?>
</StackPanel>
<!-- comment -->
''';
