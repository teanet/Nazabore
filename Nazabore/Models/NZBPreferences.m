#import "NZBPreferences.h"

#import <SSKeychain.h>

static NSString *const kPreferencesUserId = @"userId";
static NSString *const kPreferencesUserDidSelectAuthorizationStatus = @"userDidSelectAuthorizationStatus";

@implementation NZBPreferences

+ (instancetype)defaultPreferences
{
	static dispatch_once_t onceToken;
	static NZBPreferences *preferences = nil;
	dispatch_once(&onceToken, ^{
		preferences =[[NZBPreferences alloc] init];
	});

	return preferences;
}

+ (NSString *)appName
{
	return [NSBundle bundleForClass:self.class].infoDictionary[@"CFBundleName"];
}

- (NSString *)userId
{
	NSString *appName = [self.class appName];
	//Check if we have UUID already
	NSString *retrieveuuid = [SSKeychain passwordForService:appName account:kPreferencesUserId];
	if (retrieveuuid.length > 0) return retrieveuuid;

	retrieveuuid = [[NSUserDefaults standardUserDefaults] stringForKey:kPreferencesUserId];
	if (retrieveuuid.length == 0)
	{
		//Create new key for this app/device
		CFUUIDRef newUniqueId = CFUUIDCreate(kCFAllocatorDefault);
		retrieveuuid = (__bridge_transfer NSString*)CFUUIDCreateString(kCFAllocatorDefault, newUniqueId);
		CFRelease(newUniqueId);
	}
	//Save key to Keychain
	[SSKeychain setPassword:retrieveuuid forService:appName account:kPreferencesUserId];

	return retrieveuuid;
}

- (BOOL)userDidSelectAuthorizationStatus
{
	return [[NSUserDefaults standardUserDefaults] boolForKey:kPreferencesUserDidSelectAuthorizationStatus];
}

- (void)setUserDidSelectAuthorizationStatus:(BOOL)userDidSelectAuthorizationStatus
{
	[[NSUserDefaults standardUserDefaults] setBool:userDidSelectAuthorizationStatus
											forKey:kPreferencesUserDidSelectAuthorizationStatus];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

@end
