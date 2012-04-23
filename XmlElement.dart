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
* Represents an element node of XML.
*/
class XmlElement extends XmlNode {
  final String name;
  final List<XmlNode> _children;
  final Map<String, String> _attributes;

  XmlElement(this.name, [List<XmlNode> elements = const []])
  :
    _children = [],
    _attributes = {},
    super(XmlNodeType.Element)
  {
    addChildren(elements);
  }

  String get text() {
    var tNodes = _children.filter((el) => el is XmlText);
    if (tNodes.isEmpty()) return '';

    var s = new StringBuffer();
    tNodes.forEach((n) => s.add(n.text));
    return s.toString();
  }

  void addChild(XmlNode element){
    //shunt any XmlAttributes into the map
    if (element is XmlAttribute){
      attributes[element.dynamic.name] = element.dynamic.value;
      return;
    }

    element.parent = this;
    _children.add(element);
  }

  void addChildren(List<XmlNode> elements){
    if (!elements.isEmpty()){
      elements.forEach((XmlNode e) => addChild(e));
    }
  }

  List<XmlNode> queryAttributes(Map<String, String> nameValuePairs){

  }

  /**
  * Returns the first node in the tree that matches the given [tagName].
  */
  List<XmlNode> query(String tagName){
    var list = [];

    _queryInternal(tagName, list);

    return list;
  }

  _queryInternal(String tagName, List list){

    if (this.name == tagName){
      list.add(this);
      return;
    }else{
      if (hasChildren){
        children
          .filter((el) => el is XmlElement)
          .forEach((el){
            if (!list.isEmpty()) return;
            el._queryInternal(tagName, list);
          });
      }
    }
  }

  /**
  * Returns a [List] of all nodes in the tree that match the given
  * [tagName].
  */
  List<XmlNode> queryAll(String tagName){
    var list = [];

    _queryAllInternal(tagName, list);

    return list;
  }

  _queryAllInternal(String tagName, List list){
    if (this.name == tagName){
      list.add(this);
    }

    if (hasChildren){
      children
      .filter((el) => el is XmlElement)
      .forEach((el){
        el._queryInternal(tagName, list);
      });
    }
  }

  Map<String, String> get attributes() => _attributes;

  Collection<XmlNode> get children() => _children;

  bool get hasChildren() => !_children.isEmpty();
}






