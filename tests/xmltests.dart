// point this to wherever your copy of the dart source code is
#import('../../../src/lib/unittest/unittest.dart');
#import('../../../src/lib/unittest/html_enhanced_config.dart');

#import('../xml.dart');

void main() {
  useHtmlEnhancedConfiguration();

  group('xml tests', (){
    test('test test', () => Expect.isTrue(true));
    test('test fail', () => Expect.fail('test fail'));
  });


}
