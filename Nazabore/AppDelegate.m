#import "AppDelegate.h"

#import "NZBMapVC.h"
#import "NZBPreferences.h"
#import <NZBServerController.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <SSKeychain.h>
#import "Nazabore-Swift.h"

@interface AppDelegate()

@property (nonatomic, strong, readonly) Container *container;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[SSKeychain setAccessibilityType:kSecAttrAccessibleAlwaysThisDeviceOnly];
	[NZBServerController sharedController].userID = [NZBPreferences defaultPreferences].userId;

	[[Fabric sharedSDK] setDebug:YES];
	[Fabric with:@[[Crashlytics class], [Answers class]]];

	[self configureWindow];
	return YES;
}

- (void)configureWindow
{
	_container = [[Container alloc] init];
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window.rootViewController = self.container.rootVC;
	[self.window makeKeyAndVisible];

	[[UINavigationBar appearance] setBarTintColor:[UIColor nzb_brightGrayColor]];
	[[UINavigationBar appearance] setTintColor:[UIColor nzb_santasGrayColor]];
	[[UINavigationBar appearance] setTranslucent:YES];
	[[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
}

@end
