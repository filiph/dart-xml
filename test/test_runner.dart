library test_runner;

import 'package:unittest/unittest.dart';
//import 'package:xml/xml.dart';
import '../lib/xml.dart';

part 'parserTests.dart';
part 'queryTests.dart';
part 'tokenizerTests.dart';
part 'test_data.dart';

void runXmlTests() {
  groupSep = ' - ';

  tokenizerTests();
  parserTests();
  queryTests();
}
