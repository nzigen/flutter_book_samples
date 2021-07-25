#import "PlatformChannelPlugin.h"
#if __has_include(<platform_channel/platform_channel-Swift.h>)
#import <platform_channel/platform_channel-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "platform_channel-Swift.h"
#endif

@implementation PlatformChannelPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPlatformChannelPlugin registerWithRegistrar:registrar];
}
@end
