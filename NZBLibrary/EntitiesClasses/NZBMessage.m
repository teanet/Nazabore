#import "NZBMessage.h"

@implementation NZBRating

+ (instancetype)ratingWithPower:(NSUInteger)power interation:(NZBUserInteraction)interaction
{
	return [[NZBRating alloc] initWithPower:power interation:interaction];
}

- (instancetype)initWithPower:(NSUInteger)power interation:(NZBUserInteraction)interaction
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

@property (nonatomic, copy, readonly) NSString *dbobject;
@property (nonatomic, copy, readonly) NSString *type;
@property (nonatomic, copy, readonly) NSNumber *lat;
@property (nonatomic, copy, readonly) NSNumber *lon;
@property (nonatomic, copy, readonly) NSNumber *pylon;
@property (nonatomic, copy, readonly) NSNumber *power;
@property (nonatomic, copy, readonly) NSNumber *interaction;

@end

@implementation NZBMessage

@synthesize location = _location;
@synthesize rating = _rating;

+ (instancetype)messageWithDictionary:(NSDictionary *)dictionary
{
	return [[NZBMessage alloc] initWithDictionary:dictionary];
}

- (void)updateWithDictionary:(NSDictionary *)dictionary
{
	[super updateWithDictionary:dictionary];
	[self.relatedView nzb_update];
}

- (CLLocation *)location
{
	if (!_location && self.lat && self.lon)
	{
		_location = [[CLLocation alloc] initWithLatitude:self.lat.doubleValue longitude:self.lon.doubleValue];
	}

	return _location;
}

- (NZBRating *)rating
{
	if (!_rating)
	{
		_rating = [[NZBRating alloc] initWithPower:self.power.integerValue
										interation:self.interaction.integerValue];;
	}

	return _rating;
}

- (NZBMessageType)messageType
{
	NZBMessageType type = NZBMessageTypeDefault;

	if ([self.type isEqualToString:@"advert"])
	{
		type = NZBMessageTypeAdvertisement;
	}
	else if ([self.type isEqualToString:@"commercial"])
	{
		type = NZBMessageTypeCommercial;
	}

	return type;
}

- (NSString *)watchCellType
{
	NSString *watchCellType = @"DefaultMessage";
	if ([self.type isEqualToString:@"advert"])
	{
		watchCellType = @"AdsCell";
	}
	else if ([self.type isEqualToString:@"commercial"])
	{
		watchCellType = @"AdsCell";
	}
	return watchCellType;
}

- (NSString *)dbObjectIdentifier
{
	return self.dbobject;
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
