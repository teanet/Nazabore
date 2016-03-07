#import "NZBUser.h"

#import "NSMutableDictionary+NZBSafeSetObject.h"

static NSString *const kDictionaryKeyId			= @"id";
static NSString *const kDictionaryKeyPower		= @"power";
static NSString *const kDictionaryKeyRating		= @"rating";

@implementation NZBUser

@synthesize dictionary = _dictionary;

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

	_dictionary = nil;
}

- (NSDictionary *)dictionary
{
	if (!_dictionary)
	{
		NSMutableDictionary *dictionaryRepresentation = [NSMutableDictionary dictionary];

		[dictionaryRepresentation nzb_safeSetObject:self.id forKey:kDictionaryKeyId];
		[dictionaryRepresentation nzb_safeSetObject:@(self.power) forKey:kDictionaryKeyPower];
		[dictionaryRepresentation nzb_safeSetObject:@(self.rating) forKey:kDictionaryKeyRating];

		_dictionary = dictionaryRepresentation;
	}

	return _dictionary;
}

@end
