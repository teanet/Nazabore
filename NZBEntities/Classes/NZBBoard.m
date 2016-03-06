#import "NZBBoard.h"

@interface NZBBoard ()

@property (nonatomic, copy, readonly) NSNumber *lat;
@property (nonatomic, copy, readonly) NSNumber *lon;
@property (nonatomic, copy, readwrite) NSArray<NSDictionary *> *messageDictionariesArray;

@end

@implementation NZBBoard

@synthesize location = _location;


- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super initWithDictionary:dictionary];
	if (self == nil) return nil;

	NSArray *messages = dictionary[@"messages"];
	[self setMessagesDictionaryArray:messages];

	return self;
}

- (CLLocation *)location
{
	if (!_location && self.lat && self.lon)
	{
		_location = [[CLLocation alloc] initWithLatitude:self.lat.doubleValue longitude:self.lon.doubleValue];
	}

	return _location;
}

- (void)setMessagesDictionaryArray:(NSArray<NSDictionary *> *)messagesDictionaryArray
{
	_messageDictionariesArray = messagesDictionaryArray;

	NSMutableArray *messages = [NSMutableArray arrayWithCapacity:messagesDictionaryArray.count];
	for (NSDictionary *messageDictionary in messagesDictionaryArray)
	{
		NZBMessage *message = [NZBMessage messageWithDictionary:messageDictionary];
		if (message)
		{
			[messages addObject:message];
		}
	}

	_messages = [messages copy];
}

- (UIImage *)iconImage
{
	UIImage *defaultIcon = [UIImage imageNamed:@"0"];
	if (self.icon.length > 0)
	{
		return ([UIImage imageNamed:self.icon]) ?: defaultIcon;
	}
	else
	{
		return defaultIcon;
	}
}

@end
