/**
* Enumerates [XmlNode] types.
*/
class XmlNodeType {
  final String _type;

  const XmlNodeType(this._type);

  static final Element = const XmlNodeType('Element');
  static final Attribute = const XmlNodeType('Attribute');
  static final Text = const XmlNodeType('Text');
  static final Namespace = const XmlNodeType('Namespace');
  static final CDATA = const XmlNodeType('CDATA');
  static final PI = const XmlNodeType('PI'); //Processing Instruction

  String toString() => _type;
}