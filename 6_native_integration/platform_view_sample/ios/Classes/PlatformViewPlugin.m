#import "PlatformViewPlugin.h"
#if __has_include(<platform_view/platform_view-Swift.h>)
#import <platform_view/platform_view-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "platform_view-Swift.h"
#endif

@implementation PlatformViewPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPlatformViewPlugin registerWithRegistrar:registrar];
}
@end
