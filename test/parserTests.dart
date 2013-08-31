part of test_runner;

parserTests(){
  group('parser', (){
    test('default namespaces are supported',(){
      final parsed = XML.parse('''<foo xmlns='defaultns'><bar></bar></foo>''');
      final bar = parsed.children[0];
      expect('bar', equals(bar.name));
      expect(
        bar
          .namespacesInScope
          .any((XmlNamespace ns) => ns.name.isEmpty && ns.uri == 'defaultns'), isTrue);
    });

    test('namespace attribute appears before xmlns declaration in same tag', (){
      var parsed = XML.parse(xmlnsXml);
    });

    test('no fidelity lost during successive parse/stringify', (){
      var parsed = XML.parse(testXml);
      var str1 = parsed.toString();
      var parsed2 = XML.parse(str1);
      var str2 = parsed2.toString();
      expect(str1, equals(str2));
    });

    test('minimal OK', (){
      var result = XML.parse('<foo></foo>');
      expect(result, new isInstanceOf<XmlElement>());
      expect('foo', equals(result.name));
    });

    test('empty namespaced element', (){
      var xml = '''
        <foo xmlns:test="http://www.dartlang.org">
          <test:bar/>
        </foo>
      ''';
      
      var result = XML.parse(xml);
      expect('foo', equals(result.name));
      
      var element = result.children[0] as XmlElement;
      expect(element.name, equals("test:bar"));
      expect(element.isNamespaceInScope('test'), isTrue);
    });

    test('namespaced element with attributes', (){
      var xml = '''
        <foo xmlns:test="http://www.dartlang.org">
          <test:bar id="1"/>
        </foo>
      ''';
      
      var result = XML.parse(xml);
      expect('foo', equals(result.name));
      
      var element = result.children[0] as XmlElement;
      expect(element.name, equals("test:bar"));
      expect(element.isNamespaceInScope('test'), isTrue);
    });

    test('throw on no close tag', (){
      expect(() => XML.parse('<foo><bar></bar>'), throwsA(new isInstanceOf<XmlException>()));
    });

    test('throw on no open tag', (){
      expect(() => XML.parse('<foo></bar></foo>'), throwsA(new isInstanceOf<XmlException>()));
    });

    test('throw on attribute no quotes', (){
      expect(() => XML.parse('<foo bar=bloo></foo>'), throwsA(new isInstanceOf<XmlException>()));
    });

    test('attribute no quotes OK when in quirks mode', (){
        var result = XML.parse('<foo bar=bloo></foo>', true);
        expect('bloo', equals(result.attributes['bar']));
    });

    test('throw on attributes syntax error in quirks mode', (){
      expect(() => XML.parse('<foo bar=bloo blee bleep="hello"></foo>'), throwsA(new isInstanceOf<XmlException>()));
    });

    test('throw on attribute unbalanced quotes', (){
      expect(() => XML.parse('<foo bar="bloo></foo>'), throwsA(new isInstanceOf<XmlException>()));
      expect(() => XML.parse('<foo bar=bloo"></foo>'), throwsA(new isInstanceOf<XmlException>()));
    });

    test('throw on attribute missing =', (){
      expect(() => XML.parse('<foo bar"bloo"></foo>'), throwsA(new isInstanceOf<XmlException>()));
    });

    test('throw on attribute EOF', (){
      expect(() => XML.parse('<foo bar"bloo'), throwsA(new isInstanceOf<XmlException>()));
    });

    test('all comments stripped', (){
      var parsed = XML.parse(testXml);
      var str = parsed.toString();
      expect(str.contains("<!--") || str.contains("-->"), isFalse);
    });

    test('throw on tag mismatch', (){
      expect(() => XML.parse('<foo><boo></boo></bar>'), throwsA(new isInstanceOf<XmlException>()));
    });

    test('throw on empty', (){
      expect(() => XML.parse('   '), throwsA(new isInstanceOf<XmlException>()));
    });

    test('throw on string in root', (){
      expect(() => XML.parse('hello there <foo></foo>   '), throwsA(new isInstanceOf<XmlException>()));

      //TODO should throw here, fix.
      expect(() => XML.parse('<foo></foo> hello there   '), throwsA(new isInstanceOf<XmlException>()));
    });

    test('throw on CDATA in root', (){
      expect(() => XML.parse('<foo></foo> <![CDATA[ hello world]]>'), throwsA(new isInstanceOf<XmlException>()));
      expect(() => XML.parse('<![CDATA[ hello world]]> <foo></foo>'), throwsA(new isInstanceOf<XmlException>()));
    });

    test('throw on PI in root', (){
      expect(() => XML.parse('<foo></foo><? hello world ?>'), throwsA(new isInstanceOf<XmlException>()));
      expect(() => XML.parse('<? hello world ?> <foo></foo>'), throwsA(new isInstanceOf<XmlException>()));
    });

    test('throw on CDATA not closed', (){
      expect(() => XML.parse('<foo><![CDATA[ hello world'), throwsA(new isInstanceOf<XmlException>()));
    });

    test('throw on PI not closed', (){
      expect(() => XML.parse('<foo><? hello world'), throwsA(new isInstanceOf<XmlException>()));
    });

    test('throw on comment not closed', (){
      expect(() => XML.parse('<foo><!-- hello world'), throwsA(new isInstanceOf<XmlException>()));
    });

    test('throw on nested comments', (){
      expect(() => XML.parse('<foo><!-- blah <!-- blah --> blah  --></foo>'), throwsA(new isInstanceOf<XmlException>()));
    });

    test('throw on invalid tag name', (){
      expect(() => XML.parse('<!foo></!foo>'), throwsA(new isInstanceOf<XmlException>()));
    });

    test('throw on invalid tag open syntax', (){
      expect(() => XML.parse('<foo><bar !></bar></foo>'), throwsA(new isInstanceOf<XmlException>()));
    });

    test('throw on invalid tag open syntax', (){
      expect(() => XML.parse('<foo><bar !></bar></foo>'), throwsA(new isInstanceOf<XmlException>()));
    });

    test('throw on open tag EOF', (){
      expect(() => XML.parse('<foo><bar'), throwsA(new isInstanceOf<XmlException>()));
    });

    test('throw on text node  EOF', (){
      expect(() => XML.parse('<foo>bar'), throwsA(new isInstanceOf<XmlException>()));
    });

    test('throw on namespace out of scope', (){
      expect(() => XML.parse('<foo xmlns:test1="bar" xmlns:test2="bar">'
          '<bar test3:help="me"></bar></foo>'),
        throwsA(new isInstanceOf<XmlException>()));
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