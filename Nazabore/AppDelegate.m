#import "AppDelegate.h"

#import "NZBMapVC.h"
#import "NZBPreferences.h"
#import <NZBServerController.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[NZBServerController sharedController].userID = [NZBPreferences defaultPreferences].userId;

	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[NZBMapVC alloc] init]];
	[self.window makeKeyAndVisible];

	return YES;
}

@end
