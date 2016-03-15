#import "NSDictionary+CLLocation.h"

static NSString *const kDictionaryKeyLat = @"lat";
static NSString *const kDictionaryKeyLon = @"lon";

@implementation NSDictionary (CLLocation)

+ (instancetype)nzb_dictionaryWithLocation:(CLLocation *)location
{
	NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionaryWithCapacity:2];

	[returnDictionary setValue:@(location.coordinate.latitude) forKey:kDictionaryKeyLat];
	[returnDictionary setValue:@(location.coordinate.longitude) forKey:kDictionaryKeyLon];

	return [returnDictionary copy];
}

- (CLLocation *)nzb_location
{
	CLLocation *resultLocation = nil;

	// [[ Location
	NSNumber *lat = self[kDictionaryKeyLat];
	NSNumber *lon = self[kDictionaryKeyLon];

	if (lat != nil && lon != nil)
	{
		resultLocation = [[CLLocation alloc] initWithLatitude:lat.doubleValue longitude:lon.doubleValue];
	}
	else
	{
		NSCAssert(NO, @"<%@> Can't reveal location in values: (lat = %@, lon = %@)", self.class, lat, lon);
	}
	// ]]
	return resultLocation;
}

@end
