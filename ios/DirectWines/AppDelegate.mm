#import "AppDelegate.h"

#import <React/RCTBundleURLProvider.h>
#import <Firebase/Firebase.h>
#import <React/RCTLinkingManager.h>



@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  [FIRApp configure];
  self.moduleName = @"DirectWines";
  // You can add your custom initial props in the dictionary below.
  // They will be passed down to the ViewController used by React Native.
  self.initialProps = @{};
  

  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}
// Handle deep links when the app is in the foreground
- (BOOL)application:(UIApplication *)application
openURL:(NSURL *)url
options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    NSLog(@"Received deep link in foreground: %@", url.absoluteString);
    return [RCTLinkingManager application:application openURL:url options:options];
}

// Handle Universal Links (background or app cold start)
- (BOOL)application:(UIApplication *)application
continueUserActivity:(NSUserActivity *)userActivity
restorationHandler:(void (^)(NSArray *))restorationHandler
{
    // Check if the incoming activity is a web link
    if ([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
        NSURL *url = userActivity.webpageURL;
        NSLog(@"Received deep link or Universal Link in background: %@", url.absoluteString);
        return [RCTLinkingManager application:application continueUserActivity:userActivity restorationHandler:restorationHandler];
    }
    return NO;
}

// Ensure you add this to support launching from background with the custom URL scheme (for custom schemes, e.g., "yourappscheme://")
- (BOOL)application:(UIApplication *)application
openURL:(NSURL *)url
sourceApplication:(NSString *)sourceApplication
annotation:(id)annotation
{
    // This is another way to handle deep links, for older iOS versions
    NSLog(@"Received deep link with scheme: %@", url.absoluteString);
    return [RCTLinkingManager application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}

// Other standard methods for initialization, like didFinishLaunchingWithOptions, remain unchanged.


- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge
{
  return [self bundleURL];
}

- (NSURL *)bundleURL
{
#if DEBUG
  return [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index"];
#else
  return [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
#endif
}

@end
