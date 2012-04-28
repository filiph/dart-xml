
parserTests(){

  group('parser', (){
    test('no fidelity lost during successive parse/stringify', (){
      var parsed = XML.parse(testXml);
      var str1 = parsed.toString();
      var parsed2 = XML.parse(str1);
      var str2 = parsed2.toString();
      print(str1);
      print('');
      print(str2);
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

    test('line breaks (all whitespace) ignored in tag parsing.', (){
      var p = XML.parse(
'''
<

  foo
  bar='hello'
  bloo 
 =   
'hello again'

  >
</foo>
'''
);
    });

    test('comments with line breaks', (){
      var p = XML.parse('''
  <!--
  some comments 
with line breaks

  -->
  <foo></foo>
  ''');
    });

    test('last test', (){
      var p = XML.parse(
        '''<!--
        This demo shows how easy it is to build a simple, but interactive 
        UI without having to write any code.

        The controls on the left side are adjusting the properties of the
        boarder in the display area.  This is accomplished through 
        declarative element-to-element binding.
        -->

        <stackpanel margin="5">
          <textblock fontsize="24" text='This demo is written entirely with Buckshot XML - no code.'></textblock>
          <stackpanel width="650" orientation="horizontal">
          
            <grid margin="5" width="210">
              <columndefinitions>
                <columndefinition width="*1"></columndefinition>
                <columndefinition width="*2"></columndefinition>
                <columndefinition width="*.5"></columndefinition>
              </columndefinitions>
              <rowdefinitions>
                <rowdefinition height="auto"></rowdefinition>
                <rowdefinition height="auto"></rowdefinition>
                <rowdefinition height="auto"></rowdefinition>
                <rowdefinition height="auto"></rowdefinition>
                <rowdefinition height="auto"></rowdefinition>
              </rowdefinitions>
            
              <!-- labels -->
              <textblock text="Color:"></textblock>
              <textblock grid.row="1" text="Width:"></textblock>
              <textblock grid.row="2" text="Height:"></textblock>
              <textblock grid.row="3" text="Corner:"></textblock>
            
              <!-- controls -->

              <dropdownlist name="ddlColors" width="100" grid.column="1">
                <items>
                  <dropdownlistitem name="Red"></dropdownlistitem>
                  <dropdownlistitem name="Green"></dropdownlistitem>
                  <dropdownlistitem name="Blue"></dropdownlistitem>
                  <dropdownlistitem name="LightBlue"></dropdownlistitem>
                  <dropdownlistitem name="Tan"></dropdownlistitem>
                  <dropdownlistitem name="Orange"></dropdownlistitem>
                  <dropdownlistitem name="Purple"></dropdownlistitem>
                  <dropdownlistitem name="Lime"></dropdownlistitem>
                  <dropdownlistitem name="DarkGreen"></dropdownlistitem>
                  <dropdownlistitem name="Yellow"></dropdownlistitem>
                </items>
              </dropdownlist>
              <slider name="slWidth" grid.row="1" grid.column="1" min="20" max="300" value="150" width="100"></slider>
              <slider name="slHeight" grid.row="2" grid.column="1" min="20" max="300" value="150" width="100"></slider>
              <slider name="slCorner" grid.row="3" grid.column="1" min="1" max="20" value="1" width="100"></slider>
            
              <!-- value labels, bound to controls via element binding -->
              <textblock grid.column="2" grid.row="1" text="{element slWidth.value}"></textblock>
              <textblock grid.column="2" grid.row="2" text="{element slHeight.value}"></textblock>
              <textblock grid.column="2" grid.row="3" text="{element slCorner.value}"></textblock>

              <!-- using declarative actions, we reset the values of the controls when the user clicks the button -->
              <button grid.row="4" content='Reset'>
                <actions>
                  <setpropertyaction event="click" targetName="slWidth" property="value" value="150"></setpropertyaction>
                  <setpropertyaction event="click" targetName="slHeight" property="value" value="150"></setpropertyaction>
                  <setpropertyaction event="click" targetName="slCorner" property="value" value="1"></setpropertyaction>
                </actions>
              </button>

            </grid>
           
            <border margin="5" width="400" height="400" borderthickness="1" bordercolor="Black">
              <!-- this border is bound to the controls via element binding -->
              <border horizontalalignment="center" 
                      verticalalignment="center" 
                      bordercolor="Black" 
                      cornerradius="{element slCorner.value}" 
                      width="{element slWidth.value}" 
                      height="{element slHeight.value}" 
                      background="{element ddlColors.selectedItem.name}">
              </border>
            </border>
          </stackpanel>
          <textblock margin="10,0,0,0" text="Video On How Element Binding Works:"></textblock>
          <youtube width="300" height="250" videoid="WC25C5AHYAI"></youtube>
        </stackpanel>''');
    });


  });


}