// point this to wherever your copy of the dart source code is
#import('../../../src/lib/unittest/unittest.dart');
#import('../../../src/lib/unittest/html_enhanced_config.dart');

#import('../xml.dart');
#source('parser.dart');
#source('queries.dart');

void main() {
  useHtmlEnhancedConfiguration();

  parserTests();

  queryTests();
}


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
