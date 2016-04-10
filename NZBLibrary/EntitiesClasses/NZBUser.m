#import "NZBUser.h"

static NSString *const kDictionaryKeyId				= @"id";
static NSString *const kDictionaryKeyPower			= @"power";
static NSString *const kDictionaryKeyKarma			= @"karma";
static NSString *const kDictionaryKeyRating			= @"rating";
static NSString *const kDictionaryKeyVisibleRadius	= @"visibleRadius";
static NSString *const kDictionaryKeyMessagesCount	= @"messagesCount";

static double const kMinimumVisibleRadius = 50.0;
static double const kDefaultVisibleRadius = 2000.0;

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
	_karma = [dictionary[kDictionaryKeyKarma] integerValue];
	_messagesCount = [dictionary[kDictionaryKeyMessagesCount] integerValue];
	double visibleRadius = [dictionary[kDictionaryKeyVisibleRadius] doubleValue];
	_visibleRadius = visibleRadius > kMinimumVisibleRadius ? visibleRadius : kDefaultVisibleRadius;
}

- (NSDictionary *)dictionary
{
	NSMutableDictionary *dictionaryRepresentation = [NSMutableDictionary dictionary];
	[dictionaryRepresentation setValue:self.id forKey:kDictionaryKeyId];
	[dictionaryRepresentation setValue:@(self.power) forKey:kDictionaryKeyPower];
	[dictionaryRepresentation setValue:@(self.karma) forKey:kDictionaryKeyKarma];
	[dictionaryRepresentation setValue:@(self.messagesCount) forKey:kDictionaryKeyMessagesCount];
	[dictionaryRepresentation setValue:@(self.visibleRadius) forKey:kDictionaryKeyVisibleRadius];
	return dictionaryRepresentation;
}

@end
