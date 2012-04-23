//   Copyright (c) 2012, John Evans
//
//   http://www.lucastudios.com/contact
//   John: https://plus.google.com/u/0/115427174005651655317/about
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.


/**
* Represents a base class for XML nodes.  This node is essentially
* read-only.  Use [XmlElement] for working with attributes and heirarchies.
*/
class XmlNode {
  final List<XmlNode> _children;
  final XmlNodeType type;
  XmlElement parent;

  XmlNode(this.type, this._children);

  void remove(){
    var i = parent._children.indexOf(this);
    if (i == -1){
      throw const Exception('Element not found.');
    }

    parent._children.removeRange(i, 1);
  }


  List<XmlNode> queryAttributes(Map<String, String> nameValuePairs){

  }

  /**
  * Returns the first node in the tree that matches the given [queryString].
  */
  List<XmlNode> queryFirst(String queryString){

  }

  /**
  * Returns a [List] of all nodes in the tree that match the given
  * [queryString].
  */
  List<XmlNode> query(String queryString){

  }

  Collection<XmlNode> get attributes()
  => _children == null ? [] : _children.filter((el) => el is XmlAttribute);

  Collection<XmlNode> get elements()
  => _children == null ? [] : _children.filter((el) => el is! XmlAttribute);

  bool hasChildNodes() => _children != null && !_children.isEmpty();

  /// Returns a text representation of the XmlNode tree.
  String toString() {
    StringBuffer s = new StringBuffer();
    _stringifyInternal(s, this, 0);
    return s.toString();
  }

  static void _stringifyInternal(StringBuffer b, XmlNode n, int indent){
    switch(n.type){
      case XmlNodeType.PI:
        b.add('\r<?\r${n.dynamic.text}\r?>');
        break;
      case XmlNodeType.CDATA:
        b.add('\r<![CDATA[\r${n.dynamic.text}\r]]>');
        break;
      case XmlNodeType.Element:
        b.add('\r${_space(indent)}<${n.dynamic.tagName}');
        if (n.hasChildNodes()){
          n.dynamic.attributes.forEach((a) =>
              _stringifyInternal(b, a, indent));
          b.add('>');
          n.dynamic.elements.forEach((e) =>
              _stringifyInternal(b, e, indent + 3));
        }else{
          b.add('>');
        }

        if (n.dynamic.elements.length > 0){
          b.add('\r${_space(indent)}</${n.dynamic.tagName}>');
        }else{
          b.add('</${n.dynamic.tagName}>');
        }

        break;
      case XmlNodeType.Attribute:
        b.add(' ${n.dynamic.name}="${n.dynamic.value}"');
        break;
      case XmlNodeType.Text:
        b.add('\r${_space(indent)}${n.dynamic.text}');
        break;
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