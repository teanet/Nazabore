#import "NZBBoard.h"

#import "NZBTestHelper.h"

static NSString *const kDictionaryKeyId				= @"id";
static NSString *const kDictionaryKeyMessagesCount	= @"messagesCount";
static NSString *const kDictionaryKeyIconName		= @"icon";
static NSString *const kDictionaryKeyLat			= @"lat";
static NSString *const kDictionaryKeyLon			= @"lon";
static NSString *const kDictionaryKeyMessages		= @"messages";

@interface NZBBoard ()

@property (nonatomic, copy, readonly) NSString *iconName;

@end

SPEC_BEGIN(NZBBoardSpec)

describe(@"NZBBoard", ^{

	__block NZBBoard *board = nil;
	__block NSDictionary *boardDictionary = nil;

	beforeEach(^{

		boardDictionary = @{ kDictionaryKeyId : kDictionaryKeyId,
							 kDictionaryKeyMessagesCount : @0,
							 kDictionaryKeyIconName : kDictionaryKeyIconName,
							 kDictionaryKeyLat : @0,
							 kDictionaryKeyLon : @0,
							 kDictionaryKeyMessages : @[],
							};

		board = [[NZBBoard alloc] initWithDictionary:boardDictionary];

	});

	context(@"Initialization deserialization", ^{

		it(@"should init", ^{

			[[board shouldNot] beNil];
			[[board.location shouldNot] beNil];
			[[board.id should] equal:kDictionaryKeyId];
			[[board.messagesCount should] equal:@0];
			[[board.iconName should] equal:kDictionaryKeyIconName];
			[[board.messages should] haveCountOf:0];

		});

	});

	context(@"Serialization", ^{

		it(@"should return correct dictionary representation", ^{

			NSDictionary *representation = board.dictionary;
			[[representation should] equal:boardDictionary];

		});

	});

	context(@"Updating", ^{

		__block NZBMessage *message = nil;

		beforeEach(^{

			boardDictionary = @{ kDictionaryKeyId : @"newId",
								 kDictionaryKeyMessagesCount : @1,
								 kDictionaryKeyIconName : @"newIconName",
								 kDictionaryKeyLat : @1,
								 kDictionaryKeyLon : @1,
								 kDictionaryKeyMessages : @[ @{} ],
								 };

			message = KWNullMockClass(NZBMessage);
			[message stub:@selector(dictionary) andReturn:@{}];
			[NZBMessage stub:@selector(messageWithDictionary:) andReturn:message];

		});

		it(@"should update self with dictionary", ^{

			[board updateWithDictionary:boardDictionary];
			NSDictionary *representation = board.dictionary;

			[[board.id should] equal:@"newId"];
			[[board.iconName should] equal:@"newIconName"];
			[[board.messages should] haveCountOf:1];
			[[board.messages.firstObject should] equal:message];
			[[representation should] equal:boardDictionary];

		});

	});
	
});

SPEC_END
