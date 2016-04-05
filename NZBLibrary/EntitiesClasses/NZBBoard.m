#import "NZBBoard.h"

#import "NSMutableArray+NZBSafeAddObject.h"
#import "NSDictionary+CLLocation.h"

static NSString *const kDictionaryKeyId				= @"id";
static NSString *const kDictionaryKeyMessagesCount	= @"messagesCount";
static NSString *const kDictionaryKeyIconName		= @"icon";
static NSString *const kDictionaryKeyMessages		= @"messages";

@interface NZBBoard ()

@property (nonatomic, copy, readonly) NSArray<NSDictionary *> *messageDictionariesArray;
@property (nonatomic, copy, readonly) NSString *iconName;

@end

@implementation NZBBoard

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
	_iconName = dictionary[kDictionaryKeyIconName];
	_emoji = [[NZBEmoji alloc] initWithText:_iconName];
	_location = [dictionary nzb_location];
	[self setMessagesDictionaryArray:dictionary[kDictionaryKeyMessages]];
}

- (NSDictionary *)dictionary
{
	NSMutableDictionary *dictionaryRepresentation = [NSMutableDictionary dictionary];
	[dictionaryRepresentation setValue:self.id forKey:kDictionaryKeyId];
	[dictionaryRepresentation setValue:self.messagesCount forKey:kDictionaryKeyMessagesCount];
	[dictionaryRepresentation setValue:self.iconName forKey:kDictionaryKeyIconName];
	[dictionaryRepresentation setValue:self.messageDictionariesArray forKey:kDictionaryKeyMessages];
	[dictionaryRepresentation addEntriesFromDictionary:[NSDictionary nzb_dictionaryWithLocation:self.location]];
	return dictionaryRepresentation;
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
	NSMutableArray *messageDictionariesArray = [NSMutableArray arrayWithCapacity:self.messages.count];
	[self.messages enumerateObjectsUsingBlock:^(NZBMessage *message, NSUInteger _, BOOL *s) {
		[messageDictionariesArray nzb_safeAddObject:message.dictionary];
	}];
	return messageDictionariesArray;
}

@end
