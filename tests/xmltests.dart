// point this to wherever your copy of the dart source code is
#import('../../../src/lib/unittest/unittest.dart');
#import('../../../src/lib/unittest/html_enhanced_config.dart');

#import('../xml.dart');
#source('parserTests.dart');
#source('queryTests.dart');

void main() {
  useHtmlEnhancedConfiguration();

  parserTests();

  queryTests();
}


final String dbXml =
'''
<books>
  <book id='1'>
    <title>ABCs</title>
    <subject>Self Help</subject>
    <author>Sydney O'Shannahan</author>
  </book>
  <book id='2'>
    <title>Build A House</title>
    <subject>Self Help</subject>
    <author>Marko Stajic</author>
  </book>
  <book id='3'>
    <title>A Bridge Too Expensive</title>
    <subject>Fiction</subject>
    <author>Stefan Handsomly</author>
  </book>
  <book id='4'>
    <title>My Cousin Ed</title>
    <subject>Fiction</subject>
    <author>Jasna Bradshaw</author>
  </book>
  <book id='5'>
    <title>Boring Places</title>
    <subject>Travel & Leisure</subject>
    <author>John Henryson</author>
  </book>
  <book id='6'>
    <title>Ice 10</title>
    <subject>Fiction</subject>
    <author>Stefan Handsomly</author>
  </book>
</books>
''';

final String testXml =
'''
<!-- comment -->
<StackPanel>
<?hello world?>
   <TextBlock text='hello' fontSize="12" />
   <TextBlock text="hello world!" fontSize="12"></TextBlock>
   <foo bar="nested 'quotes 'are' cool' and are 'ok'"></foo>
   <foo bar='nested "quotes "are" cool" and are "ok"'></foo>
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
