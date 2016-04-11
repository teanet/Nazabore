#import "NZBMessage.h"

#import "NSDictionary+CLLocation.h"

static NSString *const kDefaultIconName				= @"0";

static NSString *const kDictionaryKeyBody			= @"body";
static NSString *const kDictionaryKeyTitle			= @"title";
static NSString *const kDictionaryKeyDbObject		= @"dbobject";
static NSString *const kDictionaryKeyIconName		= @"icon";
static NSString *const kDictionaryKeyId				= @"id";
static NSString *const kDictionaryKeyKarma			= @"karma";
static NSString *const kDictionaryKeyPhone			= @"phone";
static NSString *const kDictionaryKeyPower			= @"power";
static NSString *const kDictionaryKeyBoardId		= @"pylon";
static NSString *const kDictionaryKeyTimestamp		= @"timestamp";
static NSString *const kDictionaryKeyType			= @"type";
static NSString *const kDictionaryKeyUserId			= @"userid";
static NSString *const kDictionaryKeyInteraction	= @"interaction";
static NSString *const kDictionaryKeyPoi			= @"poi";
static NSString *const kDictionaryKeyPoiName		= @"name";
static NSString *const kDictionaryKeyPoiPhoto		= @"photo";

static NSString *const kMessageTypeDefault			= @"default";
static NSString *const kMessageTypeCommercial		= @"commercial";
static NSString *const kMessageTypeAdvert			= @"advert";
static NSString *const kMessageTypePoi				= @"poi";


@implementation NZBRating

+ (instancetype)ratingWithPower:(NSUInteger)power interaction:(NZBUserInteraction)interaction
{
	return [[NZBRating alloc] initWithPower:power interaction:interaction];
}

- (instancetype)initWithPower:(NSUInteger)power interaction:(NZBUserInteraction)interaction
{
	self = [super init];
	if (self == nil) return nil;

	_power = power;
	_interaction = interaction;

	return self;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"[ power: %ld | userInteraction: %ld]", (long)self.power, (long)self.interaction];
}

@end


@interface NZBMessage ()

@property (nonatomic, copy, readonly) NSNumber *power;
@property (nonatomic, copy, readonly) NSNumber *interaction;
@property (nonatomic, copy, readonly) NSString *messageTypeString;

@end

@implementation NZBMessage

@synthesize dictionary = _dictionary;

// MARK: Lifecycle

+ (instancetype)messageWithDictionary:(NSDictionary *)dictionary
{
	return [[NZBMessage alloc] initWithDictionary:dictionary];
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
	_body = dictionary[kDictionaryKeyBody];
	_title = dictionary[kDictionaryKeyTitle];
	_dbObjectIdentifier = dictionary[kDictionaryKeyDbObject];
	_id = dictionary[kDictionaryKeyId];
	_karma = dictionary[kDictionaryKeyKarma];
	_phone = dictionary[kDictionaryKeyPhone];
	_power = dictionary[kDictionaryKeyPower];
	_userid = dictionary[kDictionaryKeyUserId];
	_interaction = dictionary[kDictionaryKeyInteraction];
	_boardId = dictionary[kDictionaryKeyBoardId];

	NSString *iconName = dictionary[kDictionaryKeyIconName];
	_iconName = iconName.length > 0 ? iconName : kDefaultIconName;
	_location = [dictionary nzb_location];
	_emoji = [[NZBEmoji alloc] initWithText:_iconName];

	// [[ Timestamp
	NSNumber *timestampNumber = dictionary[kDictionaryKeyTimestamp];

	if (timestampNumber.doubleValue > 0.0)
	{
		_timestamp = timestampNumber.doubleValue;
	}
	else
	{
		NSCAssert(NO, @"<%@> Unexpected message timestamp value: %@", self.class, timestampNumber);
	}
	// ]]

	// [[ Message type
	_messageTypeString = dictionary[kDictionaryKeyType];
	_messageType = NZBMessageTypeDefault;

	if ([_messageTypeString isEqualToString:kMessageTypeAdvert])
	{
		_messageType = NZBMessageTypeAdvertisement;
	}
	else if ([_messageTypeString isEqualToString:kMessageTypeCommercial])
	{
		_messageType = NZBMessageTypeCommercial;
	}
	else if ([_messageTypeString isEqualToString:kMessageTypePoi])
	{
		_messageType = NZBMessageTypePoi;
	}
	else if (![_messageTypeString isEqualToString:kMessageTypeDefault])
	{
		NSCAssert(NO, @"<%@> Unknown message type: %@", self.class, _messageTypeString);
	}
	// ]]

	// [[ Points Of Interest
	NSDictionary *poi = dictionary[kDictionaryKeyPoi];

	_poiName = poi[kDictionaryKeyPoiName];
	_poiImageUrlString = poi[kDictionaryKeyPoiPhoto];
	// ]]

	_rating = [[NZBRating alloc] initWithPower:self.power.integerValue
								   interaction:self.interaction.integerValue];

	// [[ Clear representation cache
	_dictionary = nil;
	// ]]

	[self.relatedView nzb_update];
}

- (NSDictionary *)dictionary
{
	if (!_dictionary)
	{
		NSMutableDictionary *dictionaryRepresentation = [NSMutableDictionary dictionary];

		[dictionaryRepresentation setValue:self.body forKey:kDictionaryKeyBody];
		[dictionaryRepresentation setValue:self.title forKey:kDictionaryKeyTitle];
		[dictionaryRepresentation setValue:self.dbObjectIdentifier forKey:kDictionaryKeyDbObject];
		[dictionaryRepresentation setValue:self.id forKey:kDictionaryKeyId];
		[dictionaryRepresentation setValue:self.karma forKey:kDictionaryKeyKarma];
		[dictionaryRepresentation setValue:self.phone forKey:kDictionaryKeyPhone];
		[dictionaryRepresentation setValue:self.userid forKey:kDictionaryKeyUserId];
		[dictionaryRepresentation setValue:self.boardId forKey:kDictionaryKeyBoardId];
		[dictionaryRepresentation setValue:self.iconName forKey:kDictionaryKeyIconName];
		[dictionaryRepresentation setValue:@(self.timestamp) forKey:kDictionaryKeyTimestamp];
		[dictionaryRepresentation setValue:self.messageTypeString forKey:kDictionaryKeyType];
		[dictionaryRepresentation setValue:self.power forKey:kDictionaryKeyPower];
		[dictionaryRepresentation setValue:self.interaction forKey:kDictionaryKeyInteraction];
		[dictionaryRepresentation addEntriesFromDictionary:[NSDictionary nzb_dictionaryWithLocation:self.location]];

		_dictionary = [dictionaryRepresentation copy];
	}

	return _dictionary;
}

// Public

- (NSString *)watchCellType
{
	NSString *watchCellType = @"DefaultMessage";

	switch (self.messageType)
	{
		case NZBMessageTypeCommercial		: return @"AdsCell";
		case NZBMessageTypeAdvertisement	: return @"AdsCell";
		case NZBMessageTypeDefault			: return @"DefaultMessage";
		case NZBMessageTypePoi				: return @"Poi";
	}

	NSCAssert(NO, @"<%@> Watch OS: Unexpected message type: %ld", self.class, (long)self.messageType);
	
	return watchCellType;
}

- (NSString *)messageForWatch
{
	return self.body.length ? self.body : @"Что-то пошло не так =(";
}

- (NSString *)timeString
{
	static NSDateFormatter *formatter = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		formatter = [[NSDateFormatter alloc] init];
		[formatter setDateStyle:NSDateFormatterNoStyle];
		[formatter setTimeStyle:NSDateFormatterShortStyle];
	});
	return [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.timestamp * 0.001]];
}

- (NSString *)powerString
{
	return self.power ? [self.power description] : @"0";
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"[[ Message:\n"
			"id: %@\n"
			"type: %ld\n"
			"location: [ lon: %f | lat: %f ]\n"
			"body: %@\n"
			"timestamp: %@\n"
			"rating: %@\n"
			"title: %@\n"
			"phone: %@\n"
			"dbObject: %@ ]]\n", self.id, (long)self.messageType, self.location.coordinate.longitude, self.location.coordinate.latitude,
			self.body, [NSDate dateWithTimeIntervalSince1970:(self.timestamp / 1000)], self.rating, self.title, self.phone,
			self.dbObjectIdentifier];
}

@end
