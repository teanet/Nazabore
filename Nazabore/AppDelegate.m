#import "AppDelegate.h"

#import "NZBMapVC.h"
#import "NZBPreferences.h"
#import <NZBServerController.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <SSKeychain.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[SSKeychain setAccessibilityType:kSecAttrAccessibleAlwaysThisDeviceOnly];
	[NZBServerController sharedController].userID = [NZBPreferences defaultPreferences].userId;
	[[Fabric sharedSDK] setDebug:YES];
	[Fabric with:@[[Crashlytics class], [Answers class]]];

	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[NZBMapVC alloc] init]];
	[self.window makeKeyAndVisible];

	return YES;
}

@end
