// A lightweight, XML parser and emitter.
// See README.md for more info on features and limitations.

#library('xml_utils_prujohn');
#source('lib/element.dart');
#source('lib/parser.dart');
#source('lib/tokenizer.dart');
#source('lib/node.dart');
#source('lib/node_type.dart');
#source('lib/text.dart');
#source('lib/attribute.dart');
#source('lib/exception.dart');
#source('lib/cdata.dart');
#source('lib/processing_instruction.dart');
#source('lib/collection.dart');
#source('lib/namespace.dart');

/**
* Utility class to work with XML data.
*/
class XML
{

  /**
  * Returns a [XmlElement] tree representing the raw XML fragment [String].
  *
  * Optional parameter [withQuirks] will allow the following when set to true:
  *
  * * Optional quotes for simple attribute values (no spaces).
  */
  static XmlElement parse(String xml, [withQuirks = false]) =>
      XmlParser._parse(xml.trim(), withQuirks);

  /**
  * Returns a stringified version of an [XmlElement] tree.
  * You can also call .toString() on any [XmlElement].
  */
  static String stringify(XmlElement element) => element.toString();

}


