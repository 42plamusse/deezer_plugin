#import "DeezerPlugin.h"
#if __has_include(<deezer_plugin/deezer_plugin-Swift.h>)
#import <deezer_plugin/deezer_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "deezer_plugin-Swift.h"
#endif

@implementation DeezerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftDeezerPlugin registerWithRegistrar:registrar];
}
@end
