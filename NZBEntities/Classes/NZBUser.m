#import "NZBUser.h"

@implementation NZBUser

+ (instancetype)userWithDictionary:(NSDictionary *)dictionary
{
	return [[NZBUser alloc] initWithDictionary:dictionary];
}

@end
