#import "NZBBoard.h"

#import "NSMutableDictionary+NZBSafeSetObject.h"

static NSString *const kDefaultIconName = @"0";

static NSString *const kDictionaryKeyId				= @"id";
static NSString *const kDictionaryKeyMessagesCount	= @"messagesCount";
static NSString *const kDictionaryKeyIconName		= @"icon";
static NSString *const kDictionaryKeyLat			= @"lat";
static NSString *const kDictionaryKeyLon			= @"lon";
static NSString *const kDictionaryKeyMessages		= @"messages";

@interface NZBBoard ()

@property (nonatomic, copy, readonly) NSString *iconName;
@property (nonatomic, copy, readonly) NSArray<NSDictionary *> *messageDictionariesArray;

@end

@implementation NZBBoard

@synthesize dictionary = _dictionary;
@synthesize messageDictionariesArray = _messageDictionariesArray;

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
	_messagesCount = dictionary[kDictionaryKeyMessagesCount];

	NSString *iconName = dictionary[kDictionaryKeyIconName];
	_iconName = iconName.length > 0 ? iconName : kDefaultIconName;

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

	// [[ Messages
	NSArray *messages = dictionary[kDictionaryKeyMessages];
	[self setMessagesDictionaryArray:messages];
	// ]]
}

- (NSDictionary *)dictionary
{
	if (!_dictionary)
	{
		NSMutableDictionary *dictionaryRepresentation = [NSMutableDictionary dictionary];

		[dictionaryRepresentation nzb_safeSetObject:self.id forKey:kDictionaryKeyId];
		[dictionaryRepresentation nzb_safeSetObject:self.messagesCount forKey:kDictionaryKeyMessagesCount];
		[dictionaryRepresentation nzb_safeSetObject:self.iconName forKey:kDictionaryKeyIconName];
		[dictionaryRepresentation nzb_safeSetObject:@(self.location.coordinate.latitude) forKey:kDictionaryKeyLat];
		[dictionaryRepresentation nzb_safeSetObject:@(self.location.coordinate.longitude) forKey:kDictionaryKeyLon];
		[dictionaryRepresentation nzb_safeSetObject:self.messageDictionariesArray forKey:kDictionaryKeyMessages];

		_dictionary = dictionaryRepresentation;
	}

	return _dictionary;
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

- (NSArray<NSDictionary *> *)messageDictionariesArray
{
	return nil;
}

- (UIImage *)iconImage
{
	return [UIImage imageNamed:self.iconName];
}

@end
