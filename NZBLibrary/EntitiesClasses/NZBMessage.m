#import "NZBMessage.h"

#import "NSMutableDictionary+NZBSafeSetObject.h"

static NSString *const kDefaultIconName				= @"0";

static NSString *const kDictionaryKeyBody			= @"body";
static NSString *const kDictionaryKeyTitle			= @"title";
static NSString *const kDictionaryKeyDbObject		= @"dbobject";
static NSString *const kDictionaryKeyIconName		= @"icon";
static NSString *const kDictionaryKeyId				= @"id";
static NSString *const kDictionaryKeyKarma			= @"karma";
static NSString *const kDictionaryKeyLat			= @"lat";
static NSString *const kDictionaryKeyLon			= @"lon";
static NSString *const kDictionaryKeyPhone			= @"phone";
static NSString *const kDictionaryKeyPower			= @"power";
static NSString *const kDictionaryKeyBoardId		= @"pylon";
static NSString *const kDictionaryKeyTimestamp		= @"timestamp";
static NSString *const kDictionaryKeyType			= @"type";
static NSString *const kDictionaryKeyUserId			= @"userid";
static NSString *const kDictionaryKeyInteraction	= @"interaction";

static NSString *const kMessageTypeDefault			= @"default";
static NSString *const kMessageTypeCommercial		= @"commercial";
static NSString *const kMessageTypeAdvert			= @"advert";


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
	else if (![_messageTypeString isEqualToString:kMessageTypeDefault])
	{
		NSCAssert(NO, @"<%@> Unknown message type: %@", self.class, _messageTypeString);
	}
	// ]]

	// [[ Location
	NSNumber *lat = dictionary[kDictionaryKeyLat];
	NSNumber *lon = dictionary[kDictionaryKeyLon];

	if (lat != nil && lon != nil)
	{
		_location = [[CLLocation alloc] initWithLatitude:lat.doubleValue longitude:lon.doubleValue];
	}
	else
	{
		NSCAssert(NO, @"<%@> Can't reveal location in values: (lat = %@, lon = %@)", self.class, lat, lon);
	}
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

		[dictionaryRepresentation nzb_safeSetObject:self.body forKey:kDictionaryKeyBody];
		[dictionaryRepresentation nzb_safeSetObject:self.title forKey:kDictionaryKeyTitle];
		[dictionaryRepresentation nzb_safeSetObject:self.dbObjectIdentifier forKey:kDictionaryKeyDbObject];
		[dictionaryRepresentation nzb_safeSetObject:self.id forKey:kDictionaryKeyId];
		[dictionaryRepresentation nzb_safeSetObject:self.karma forKey:kDictionaryKeyKarma];
		[dictionaryRepresentation nzb_safeSetObject:self.phone forKey:kDictionaryKeyPhone];
		[dictionaryRepresentation nzb_safeSetObject:self.userid forKey:kDictionaryKeyUserId];
		[dictionaryRepresentation nzb_safeSetObject:self.boardId forKey:kDictionaryKeyBoardId];
		[dictionaryRepresentation nzb_safeSetObject:self.iconName forKey:kDictionaryKeyIconName];
		[dictionaryRepresentation nzb_safeSetObject:@(self.timestamp) forKey:kDictionaryKeyTimestamp];
		[dictionaryRepresentation nzb_safeSetObject:self.messageTypeString forKey:kDictionaryKeyType];
		[dictionaryRepresentation nzb_safeSetObject:@(self.location.coordinate.latitude) forKey:kDictionaryKeyLat];
		[dictionaryRepresentation nzb_safeSetObject:@(self.location.coordinate.longitude) forKey:kDictionaryKeyLon];
		[dictionaryRepresentation nzb_safeSetObject:self.power forKey:kDictionaryKeyPower];
		[dictionaryRepresentation nzb_safeSetObject:self.interaction forKey:kDictionaryKeyInteraction];

		_dictionary = dictionaryRepresentation;
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
	}

	NSCAssert(NO, @"<%@> Watch OS: Unexpected message type: %ld", self.class, (long)self.messageType);
	
	return watchCellType;
}

- (NSString *)messageForWatch
{
	return self.body.length ? self.body : @"Х...Й";
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

//- (UIColor *)powerColor
//{
//	if (self.power.integerValue == 0) {
//		return [UIColor colorWithWhite:205/255. alpha:1.0];
//	}
//	else if (self.power.integerValue > 0) {
//		return [UIColor nzb_darkGreenColor];
//	}
//	else {
//		return [UIColor nzb_redColor];
//	}
//}
//- (NSAttributedString *)watchPowerString
//{
//	return [[NSAttributedString alloc] initWithString:[self powerString]
//										   attributes:@{
//														NSFontAttributeName: [UIFont systemFontOfSize:15.0],
//														NSForegroundColorAttributeName : self.powerColor,
//														}];
//}
//
//- (NSAttributedString *)phonePowerString
//{
//	return [[NSAttributedString alloc] initWithString:[self powerString]
//										   attributes:@{
//														NSFontAttributeName: [UIFont nzb_systemFontWithSize:14.0],
//														NSForegroundColorAttributeName : self.powerColor,
//														}];
//}
//
//- (UIFont *)messageFont
//{
//	if (self.karma.integerValue > 5) {
//		return [UIFont nzb_boldFontWithSize:15.0];
//	}
//	else {
//		return [UIFont nzb_systemFontWithSize:15.0];
//	}
//}
//
//- (UIColor *)messageColor
//{
//	if (self.karma.integerValue > 0) {
//		return [UIColor blackColor];
//	}
//	else {
//		return [UIColor nzb_lightGrayColor];
//	}
//}

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
