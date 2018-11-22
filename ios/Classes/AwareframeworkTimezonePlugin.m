#import "AwareframeworkTimezonePlugin.h"
#import <awareframework_timezone/awareframework_timezone-Swift.h>

@implementation AwareframeworkTimezonePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAwareframeworkTimezonePlugin registerWithRegistrar:registrar];
}
@end
