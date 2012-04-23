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

/** XML Parser */
class XmlParser {
  final String _xml;
  final Queue<XmlElement> _scopes;
  XmlElement _root;

  static XmlElement _parse(String xml)
  {
    XmlParser p = new XmlParser._internal(xml);

    final XmlTokenizer t = new XmlTokenizer(p._xml);

    p._parseElement(t);

    return p._root;
  }

  static XmlDocument _parseDocument(String xml)
  {
    throw const NotImplementedException();

    //TODO implement

    XmlParser p = new XmlParser._internal(xml);

    final XmlTokenizer t = new XmlTokenizer(p._xml);

    p._parseElement(t);

    return p._root.dynamic;
  }

  XmlParser._internal(this._xml)
  :
    _scopes = new Queue<XmlElement>()
  ;

  void _parseElement(XmlTokenizer t){

    _XmlToken tok = t.next();

    while(tok != null){

      switch(tok.kind){
        case _XmlToken.START_COMMENT:
          _processComment(t);
          break;
        case _XmlToken.START_CDATA:
          _processCDATA(t);
          break;
        case _XmlToken.LT:
          _processTag(t);
          // finished.
          if (_scopes.isEmpty()) return;
          break;
        case _XmlToken.STRING:
          if (_scopes.isEmpty()){
            //throw this error if at top level
            _assertKind(tok, _XmlToken.LT);
          }else{
            _processTextNode(t, tok._str);
            _processTag(t);
          }
          break;
      }
      tok = t.next();
    }

    if (!_scopes.isEmpty()){
      throw const XmlException('Unexpected end of file.  Not all tags were'
        ' closed.');
    }
  }

  _processCDATA(XmlTokenizer t){
    //in CDATA node all tokens until ']]>' are joined to a single string
    StringBuffer s = new StringBuffer();

    _XmlToken next = t.next();

    while(next.kind != _XmlToken.END_CDATA){

      s.add(next.toStringLiteral());

      next = t.next();

      if (next == null){
        throw const XmlException('Unexpected end of file.');
      }
    }

    if (_scopes.isEmpty()){
      throw const XmlException('CDATA nodes are not yet supported in the top'
        ' level.');
    }

    _peek().addChild(new XmlCDATA(s.toString()));
  }

  //TODO create and XMLComment object instead of just ignoring?
  _processComment(XmlTokenizer t){
    _XmlToken next = t.next();

    while (next.kind != _XmlToken.END_COMMENT){

      if (next.kind == _XmlToken.START_COMMENT){
        throw new XmlException.withDebug('Nested comments not allowed.',
          _xml, next._location);
      }
      next = t.next();

      if (next == null){
        throw const XmlException('Unexpected end of file.');
      }
    }
  }

  _processTag(XmlTokenizer t){
    _XmlToken next = t.next();

    if (next.kind == _XmlToken.SLASH){
      // this is a close tag

      next = t.next();
      _assertKind(next, _XmlToken.STRING);

      if (_peek().tagName != next._str){
        throw new XmlException.withDebug(
        'Expected closing tag "${_peek().tagName}"'
        ' but found "${next._str}" instead.', _xml, next._location);
      }

      next = t.next();
      _assertKind(next, _XmlToken.GT);

      _pop();

      return;
    }

    //otherwise this is an open tag

    _assertKind(next, _XmlToken.STRING);

    //TODO check tag name for invalid chars

    XmlElement newElement = new XmlElement(next._str);

    if (_root == null){
      //set to root and push
      _root = newElement;
      _push(_root);
    } else{
      //add child to current scope
      _peek().addChild(newElement);
      _push(newElement);
    }

    next = t.next();

    while(next != null){

      switch(next.kind){
        case _XmlToken.STRING:
          _processAttributes(t, next._str);
          break;
        case _XmlToken.GT:
          next = t.next();
          if (next.kind == _XmlToken.STRING){
            _processTextNode(t, next._str);
            _processTag(t);
          }else if (next.kind == _XmlToken.LT){
            _processTag(t);
          }else if (next.kind == _XmlToken.START_COMMENT){
            _processComment(t);
          }else if (next.kind == _XmlToken.START_CDATA){
            _processCDATA(t);
          }
          else
          {
            throw new XmlException('Unexpected item "${next}" found.');
          }

          return;
        case _XmlToken.SLASH:
          next = t.next();
          _assertKind(next, _XmlToken.GT);
          _pop();
          return;
        default:
          throw new XmlException.withDebug(
            'Invalid xml ${next} found at this location.',
            _xml,
            next._location);
      }

      next = t.next();

      if (next == null){
        throw const Exception('Unexpected end of file.');
      }
    }
  }

  void _processTextNode(XmlTokenizer t, String text){
    //in text node all tokens until < are joined to a single string
    StringBuffer s = new StringBuffer();

    s.add(text);

    _XmlToken next = t.next();

    while(next.kind != _XmlToken.LT){

      if (next.kind == _XmlToken.START_COMMENT){
        _processComment(t);
      }else if (next.kind == _XmlToken.START_CDATA){
        _processCDATA(t);
      }else{
        s.add(next.toStringLiteral());
      }
      next = t.next();

      if (next == null){
        throw const XmlException('Unexpected end of file.');
      }
    }

    _peek().addChild(new XmlText(s.toString()));
  }

  void _processAttributes(XmlTokenizer t, String attributeName){
    XmlElement el = _peek();

    void setAttribute(String name, String value){
      el.addChild(new XmlAttribute(name, value));
    }

    _XmlToken next = t.next();
    _assertKind(next, _XmlToken.EQ, "Must have an = after an"
      " attribute name.");

    //require quotes
    next = t.next();
    _assertKind(next, _XmlToken.QUOTE, "Quotes are required around"
      " attribute values.");

    next = t.next();
    StringBuffer s = new StringBuffer();

    while (next.kind != _XmlToken.QUOTE){

      s.add(next.toStringLiteral());

      next = t.next();

      if (next == null){
        throw const XmlException('Unexpected end of file.');
      }
    }

    setAttribute(attributeName, s.toString());
  }


  void _push(XmlElement element){
  //  print('pushing element ${element.tagName}');
    _scopes.addFirst(element);
  }
  XmlElement _pop(){
  //  print('popping element ${_peek().tagName}');
    _scopes.removeFirst();
  }
  XmlElement _peek() => _scopes.first();


  void _assertKind(_XmlToken tok, int matchID, [String info = null]){
    _XmlToken match = new _XmlToken(matchID);

    var msg = 'Expected ${match}, but found ${tok}. ${info == null ? "" :
      "\r$info"}';

    if (tok.kind != match.kind) {
      throw new XmlException.withDebug(msg, _xml, tok._location);
    }
  }
}
