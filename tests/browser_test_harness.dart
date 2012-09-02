// point this to wherever your copy of the dart source code is
#import('package:unittest/unittest.dart');
#import('package:unittest/html_enhanced_config.dart');

#import('../xml.dart');
#source('test_data.dart');
#source('parserTests.dart');
#source('queryTests.dart');

void main() {
  useHtmlEnhancedConfiguration();

  parserTests();

  queryTests();
}
