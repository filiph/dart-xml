## Using the library ##
In your pubspec.yaml:

    dependencies:
      xml: any

Then in your application import the library:
	
    import 'package:xml/xml.dart';

## API ##
	
### Parsing ###
    // Returns a strongly-typed XmlNode tree
    XmlElement myXmlTree = XML.parse(myXmlString);
	
### Serialization ###
	// Returns a stringified xml document from a given XmlNode tree
	String myXmlString = XML.stringify(myXmlNode);
	
	// or...
	String myXmlString = myXmlNode.toString();

### Creating XML in Code ###
XML trees can be created manually in code:

    XmlElement test = new XmlElement('StackPanel',
        [new XmlElement('TextBlock',
           [
            new XmlAttribute('text', 'hello world!'),
            new XmlAttribute('fontSize', '12')
           ]),
         new XmlElement('Border',
           [
            new XmlElement('Image',
              [
               new XmlText('The quick brown fox jumped over the lazy dog.')
              ])
           ])
    ]);

... or you can let the parser do the work for you:

    XmlElement test = 
    XML.parse(
    ''' <stackpanel>
    		<textblock text='Hello World!' fontSize='12'></textblock>
    		<border>
    			<image>
    				The quick brown fox jumped over the lazy dog.
    			</image>
    		</border>
   		</stackpanel>
	'''
	);

### Queries ###
** Experimental **

Any XmlElement can be queried a number of ways.  All queries return 
XmlCollection&lt;XmlElement&gt;, even the first-occurrence queries.
Query functions support these parameter types:

* String (match tag name)
* XmlNodeType (match XmlNodeType)
* Map (match one or more attribute/value pairs)

#### Example Queries ####
    // By tag name
    // returns the first occurrence of any XmlElement matching the given tagName
    myXmlElement.query('div');
    myXmlElement.queryAll('div'); //returns all matches
    
    // By xml node type
    // returns the first occurrence of any XmlElement matching the XmlNodeType
    myXmlElement.query(XmlNodeType.CDATA);
    myXmlElement.queryAll(XmlNodeType.CDATA); //returns all matches

    // By attribute
    // returns the first occurrence of any XmlElement that contains all of
    // the provided attributes and matching values
    myXmlElement.query({'id':'foo', 'style':'bar'});
    myXmlElement.queryAll({'id':'foo', 'style':'bar'}); //returns all matches	

    
All queries are case-sensitive.

### Quirks Mode ###
Quirks mode is off by default, but can be enabled like so:

    XML.parse('<foo></foo>', withQuirks:true);

Currently quirks mode allows:

* Optional quotes around attribute values where a single word is the value.

#### Example ####
    // this is ok in quirks mode
    <foo bar=bloo></foo>
    
    // otherwise it would have to be
    <foo bar='bloo'></foo>
    
    // multiple words must be in quotes
    <foo bar='blee bloo'></foo>
