## Dart Xml ##
Dart Xml is a lightweight library for parsing and emitting xml.

## API ##
    #import('Xml.dart');

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

Though it's probably easier to let the parser do the work for you:

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

## Limitations ##
* Doesn't enforce DTD
* Doesn't enforce any local schema declarations
* Doesn't yet support namespaces
* Nested quotes in attributes are not yet supported.
* Comment nodes are not yet supported.
* XmlNodes are not yet queryable.
	
## License ##
Apache 2.0