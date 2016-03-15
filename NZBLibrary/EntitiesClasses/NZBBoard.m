#import "NZBBoard.h"

#import "NSMutableArray+NZBSafeAddObject.h"
#import "NSDictionary+CLLocation.h"

static NSString *const kDefaultIconName				= @"0";

static NSString *const kDictionaryKeyId				= @"id";
static NSString *const kDictionaryKeyMessagesCount	= @"messagesCount";
static NSString *const kDictionaryKeyIconName		= @"icon";
static NSString *const kDictionaryKeyMessages		= @"messages";

@interface NZBBoard ()

@property (nonatomic, copy, readonly) NSString *iconName;
@property (nonatomic, copy, readonly) NSArray<NSDictionary *> *messageDictionariesArray;

@end

@implementation NZBBoard

@synthesize dictionary = _dictionary;
@synthesize messageDictionariesArray = _messageDictionariesArray;

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
	_messagesCount = dictionary[kDictionaryKeyMessagesCount];

	NSString *iconName = dictionary[kDictionaryKeyIconName];
	_iconName = iconName.length > 0 ? iconName : kDefaultIconName;
	_location = [dictionary nzb_location];

	// [[ Messages
	NSArray *messages = dictionary[kDictionaryKeyMessages];
	[self setMessagesDictionaryArray:messages];
	// ]]

	// [[ Clear cache of representations
	_dictionary = nil;
	_messageDictionariesArray = nil;
	// ]]
}

- (NSDictionary *)dictionary
{
	if (!_dictionary)
	{
		NSMutableDictionary *dictionaryRepresentation = [NSMutableDictionary dictionary];

		[dictionaryRepresentation setValue:self.id forKey:kDictionaryKeyId];
		[dictionaryRepresentation setValue:self.messagesCount forKey:kDictionaryKeyMessagesCount];
		[dictionaryRepresentation setValue:self.iconName forKey:kDictionaryKeyIconName];
		[dictionaryRepresentation setValue:self.messageDictionariesArray forKey:kDictionaryKeyMessages];
		[dictionaryRepresentation addEntriesFromDictionary:[NSDictionary nzb_dictionaryWithLocation:self.location]];

		_dictionary = [dictionaryRepresentation copy];
	}

	return _dictionary;
}

// MARK: Public

- (UIImage *)iconImage
{
	return [UIImage imageNamed:self.iconName];
}

// MARK: Private

- (void)setMessagesDictionaryArray:(NSArray<NSDictionary *> *)messagesDictionaryArray
{
	NSMutableArray *messages = [NSMutableArray arrayWithCapacity:messagesDictionaryArray.count];
	[messagesDictionaryArray enumerateObjectsUsingBlock:^(NSDictionary *messageDictionary, NSUInteger _, BOOL *s) {
		NZBMessage *message = [NZBMessage messageWithDictionary:messageDictionary];
		[messages nzb_safeAddObject:message];
	}];

	_messages = [messages copy];
}

- (NSArray<NSDictionary *> *)messageDictionariesArray
{
	if (!_messageDictionariesArray)
	{
		NSMutableArray *messageDictionariesArray = [NSMutableArray arrayWithCapacity:self.messages.count];
		[self.messages enumerateObjectsUsingBlock:^(NZBMessage *message, NSUInteger _, BOOL *s) {
			[messageDictionariesArray nzb_safeAddObject:message.dictionary];
		}];

		_messageDictionariesArray = [messageDictionariesArray copy];
	}

	return _messageDictionariesArray;
}

@end
