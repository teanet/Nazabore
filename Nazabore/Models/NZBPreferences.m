#import "NZBPreferences.h"

static NSString *const kPreferencesUserId = @"userId";

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

- (NSString *)userId
{
	NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:kPreferencesUserId];

	if (!userId.length)
	{
		userId = [NSUUID UUID].UUIDString;
		[[NSUserDefaults standardUserDefaults] setObject:userId forKey:kPreferencesUserId];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}

	return userId;
}

@end
