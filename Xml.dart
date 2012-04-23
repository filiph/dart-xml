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


// A lightweight, NOT standards-compliant xml parser and emitter.
// Does not support DTD or WSD validation.
// See README.md for more info.

#library('Xml');
#source('XmlElement.dart');
#source('XmlParser.dart');
#source('XmlTokenizer.dart');
#source('XmlStringifier.dart');
#source('XmlNode.dart');
#source('XmlNodeType.dart');
#source('XmlText.dart');
#source('XmlAttribute.dart');
#source('XmlDocument.dart');
#source('XmlException.dart');
#source('XmlCDATA.dart');
#source('XmlProcessingInstruction.dart');


/**
* Utility class to work with XML data.
*/
class XML
{

  /**
  * Returns a [XmlElement] tree representing the raw XML fragment [String].
  */
  static XmlElement parse(String xml) => XmlParser._parse(xml.trim());

  /**
  * Returns a stringified version of an [XmlNode] tree.
  * You can also call .toString() on any [XmlNode].
  */
  static String stringify(XmlNode node) => node.toString();

}


