part of test_runner;

const String dbXml =
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

const String xmlnsXml =
'''
<StackPanel 
 nstest:bar='this should work even though it appears before the xmlns declaration'
 xmlns:nstest='http://www.lucastudios.com/'>
  <?hello world?>
   <TextBlock nstest:foo='namespace attribute' text='hello' fontSize="12" />
</StackPanel>
''';

const String testXml =
'''
<!-- comment -->
<StackPanel xmlns:test='http://www.lucastudios.com/'>
<?hello world?>
   <TextBlock test:foo='namespace attribute' text='hello' fontSize="12" />
   <TextBlock text="hello world!" fontSize="12"></TextBlock>
   <foo bar="nested 'quotes 'are' cool' and are 'ok'"></foo>
   <test:blah test:attr="rtta" flower="power"></test:blah>
   <foo bar='nested "quotes "are" cool" and are "ok"'></foo>
   <bar baz=' one space before, two after  '></bar>
   <bar baz=" one space before, two after  "></bar>
   text node
   <Border xmlns:foons='http://www.foo.org' xmlns:barns='http://www.bar.org'>
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
