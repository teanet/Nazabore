#import "NZBUser.h"

static NSString *const kDictionaryKeyId				= @"id";
static NSString *const kDictionaryKeyPower			= @"power";
static NSString *const kDictionaryKeyRating			= @"rating";
static NSString *const kDictionaryKeyVisibleRange	= @"visibleRange";

@implementation NZBUser

// MARK: Lifecycle

+ (instancetype)userWithDictionary:(NSDictionary *)dictionary
{
	return [[NZBUser alloc] initWithDictionary:dictionary];
}

// MARK: Lifecycle and NZBSerializableProtocol

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if (self == nil) return nil;

	[self updateWithDictionary:dictionary];

	return self;
}

- (void)updateWithDictionary:(NSDictionary *)dictionary
{
	_id = dictionary[kDictionaryKeyId];
	_power = [dictionary[kDictionaryKeyPower] integerValue];
	_rating = [dictionary[kDictionaryKeyRating] doubleValue];
	_visibleRange = [dictionary[kDictionaryKeyVisibleRange] doubleValue];
}

- (NSDictionary *)dictionary
{
	NSMutableDictionary *dictionaryRepresentation = [NSMutableDictionary dictionary];
	[dictionaryRepresentation setValue:self.id forKey:kDictionaryKeyId];
	[dictionaryRepresentation setValue:@(self.power) forKey:kDictionaryKeyPower];
	[dictionaryRepresentation setValue:@(self.rating) forKey:kDictionaryKeyRating];
	[dictionaryRepresentation setValue:@(self.visibleRange) forKey:kDictionaryKeyVisibleRange];
	return dictionaryRepresentation;
}

@end
