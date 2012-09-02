#import('package:unittest/unittest.dart');
#import('package:unittest/vm_config.dart');

#import('../xml.dart');

#source('parserTests.dart');
#source('queryTests.dart');
#source('test_data.dart');

main() {
  useVmConfiguration();
  groupSep = ' - ';

  parserTests();
  queryTests();
}
