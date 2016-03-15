#import "NZBMessage.h"

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

@interface NZBMessage ()

@property (nonatomic, copy, readonly) NSNumber *power;
@property (nonatomic, copy, readonly) NSNumber *interaction;
@property (nonatomic, copy, readonly) NSString *messageTypeString;

@end

SPEC_BEGIN(NZBMessageSpec)

describe(@"NZBMessage", ^{

	__block NZBMessage *message = nil;
	__block NSDictionary *messageDictionary = nil;

	beforeEach(^{

		messageDictionary = @{ kDictionaryKeyBody : kDictionaryKeyBody,
							   kDictionaryKeyTitle : kDictionaryKeyTitle,
							   kDictionaryKeyDbObject : kDictionaryKeyDbObject,
							   kDictionaryKeyLat : @0,
							   kDictionaryKeyLon : @0,
							   kDictionaryKeyPhone : kDictionaryKeyPhone,
							   kDictionaryKeyId : kDictionaryKeyId,
							   kDictionaryKeyKarma : @7,
							   kDictionaryKeyIconName : kDictionaryKeyIconName,
							   kDictionaryKeyPower : @5,
							   kDictionaryKeyBoardId : kDictionaryKeyBoardId,
							   kDictionaryKeyTimestamp : @1.0,
							   kDictionaryKeyType : kMessageTypeDefault,
							   kDictionaryKeyUserId : kDictionaryKeyUserId,
							   kDictionaryKeyInteraction : @1,
							   };

		message = [NZBMessage messageWithDictionary:messageDictionary];

	});

	context(@"Initialization deserialization", ^{

		it(@"should create", ^{

			[[message should] beNonNil];
			[[message.id should] equal:kDictionaryKeyId];
			[[theValue(message.messageType) should] equal:theValue(NZBMessageTypeDefault)];
			[[message.location shouldNot] beNil];
			[[message.body should] equal:kDictionaryKeyBody];
			[[theValue(message.rating.power) should] equal:theValue(5)];
			[[theValue(message.rating.interaction) should] equal:theValue(1)];
			[[message.title should] equal:kDictionaryKeyTitle];
			[[message.iconName should] equal:kDictionaryKeyIconName];
			[[message.phone should] equal:kDictionaryKeyPhone];
			[[message.dbObjectIdentifier should] equal:kDictionaryKeyDbObject];
			[[message.karma should] equal:@7];
			[[theValue(message.timestamp) should] equal:1.0 withDelta:DBL_EPSILON];
			[[message.userid should] equal:kDictionaryKeyUserId];
			[[message.boardId should] equal:kDictionaryKeyBoardId];
			
		});

	});

	context(@"Serialization", ^{

		it(@"should return correct dictionary representation", ^{

			NSDictionary *representation = message.dictionary;
			[[representation should] equal:messageDictionary];

		});
		
	});

	context(@"Updating", ^{

		beforeEach(^{

			messageDictionary = @{ kDictionaryKeyBody : @"newBody",
								   kDictionaryKeyTitle : @"newTitle",
								   kDictionaryKeyDbObject : kDictionaryKeyDbObject,
								   kDictionaryKeyLat : @5,
								   kDictionaryKeyLon : @15,
								   kDictionaryKeyPhone : @"phone",
								   kDictionaryKeyId : kDictionaryKeyId,
								   kDictionaryKeyKarma : @10,
								   kDictionaryKeyIconName : @"newIconName",
								   kDictionaryKeyPower : @15,
								   kDictionaryKeyBoardId : kDictionaryKeyBoardId,
								   kDictionaryKeyTimestamp : @10.0,
								   kDictionaryKeyType : kMessageTypeAdvert,
								   kDictionaryKeyUserId : kDictionaryKeyUserId,
								   kDictionaryKeyInteraction : @0,
								   };

		});

		it(@"should update self with dictionary", ^{

			[message updateWithDictionary:messageDictionary];
			NSDictionary *representation = message.dictionary;

			[[message.body should] equal:@"newBody"];
			[[message.title should] equal:@"newTitle"];
			[[message.dbObjectIdentifier should] equal:kDictionaryKeyDbObject];
			[[message.location shouldNot] beNil];
			[[message.phone should] equal:@"phone"];
			[[message.id should] equal:kDictionaryKeyId];
			[[message.karma should] equal:@10];
			[[message.iconName should] equal:@"newIconName"];
			[[theValue(message.rating.power) should] equal:theValue(15)];
			[[message.boardId should] equal:kDictionaryKeyBoardId];
			[[theValue(message.timestamp) should] equal:10.0 withDelta:DBL_EPSILON];
			[[theValue(message.messageType) should] equal:theValue(NZBMessageTypeAdvertisement)];
			[[message.userid should] equal:kDictionaryKeyUserId];
			[[theValue(message.rating.interaction) should] equal:theValue(0)];
			[[representation should] equal:messageDictionary];
			
		});
		
	});

});

SPEC_END
