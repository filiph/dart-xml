/**
* Represents a base class for XML nodes.  This node is essentially
* read-only.  Use [XmlElement] for manipulating attributes
* and heirarchies.
*/
class XmlNode {
  final XmlNodeType type;
  XmlElement parent;

  XmlNode(this.type);

  void remove(){
    if (parent == null) return;

    var i = parent._children.indexOf(this);
    if (i == -1){
      throw const XmlException('Element not found.');
    }

    parent._children._removeRange(i, 1);
  }

  /// Returns a text representation of the XmlNode tree.
  String toString() {
    StringBuffer s = new StringBuffer();
    _stringifyInternal(s, this, 0);
    return s.toString();
  }

  static void _stringifyInternal(StringBuffer b, XmlElement n, int indent){
    switch(n.type){
      case XmlNodeType.Element:
        b.add('\r${_space(indent)}<${n.name}');

        if (n.namespaces.length > 0){
          n.namespaces.forEach((k, v) =>
              b.add(new XmlNamespace(k, v).toString()));
        }

        if (n.attributes.length > 0){
          n.attributes.forEach((k, v) =>
              b.add(new XmlAttribute(k, v).toString()));
        }

        b.add('>');

        if (n.hasChildren){
          n.children.forEach((e) =>
              _stringifyInternal(b, e, indent + 3));
        }

        if (n.children.length > 0){
          b.add('\r${_space(indent)}</${n.name}>');
        }else{
          b.add('</${n.name}>');
        }

        break;
      case XmlNodeType.Namespace:
      case XmlNodeType.Attribute:
        b.add(n.toString());
        break;
      case XmlNodeType.Text:
        b.add('\r${_space(indent)}$n');
        break;
      case XmlNodeType.PI:
      case XmlNodeType.CDATA:
        b.add('\r$n');
        break;
      default:
        throw new XmlException("Node Type ${n.type} is not supported.");
    }
  }

  static String _space(int amount) {
    StringBuffer s = new StringBuffer();
    for (int i = 0; i < amount; i++){
      s.add(' ');
    }
    return s.toString();
   }
}