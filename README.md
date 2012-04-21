## Dart Xml ##
Dart Xml is a lightweight library for parsing and emitting xml.

## API ##
    #import('Xml.dart');

### Parsing ###
    // Returns a strongly-typed XmlNode tree
    XmlElement myXmlTree = Xml.parse(myXmlString);
	
### Serialization ###
	// Returns a stringified xml document from a given XmlNode tree
	String myXmlString = Xml.stringify(myXmlNode);
	
	// or...
	String myXmlString = myXmlNode.toString();

## Limitations ##
* Doesn't enforce DTD
* Doesn't enforce any local schema declarations
* Doesn't yet support namespaces
* Nested quotes in attributes are not yet supported.
* Comment nodes are not yet supported.
	
## License ##
Apache 2.0