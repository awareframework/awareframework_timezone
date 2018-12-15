import 'package:test/test.dart';
import 'package:awareframework_timezone/awareframework_timezone.dart';

void main(){
  test("test sensor config", (){
    var config = TimezoneSensorConfig();
    expect(config.debug, false);
  });
}