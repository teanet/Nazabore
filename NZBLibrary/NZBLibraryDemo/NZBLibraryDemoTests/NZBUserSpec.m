#import "NZBUser.h"

static NSString *const kDictionaryKeyId			= @"id";
static NSString *const kDictionaryKeyPower		= @"power";
static NSString *const kDictionaryKeyRating		= @"rating";

SPEC_BEGIN(NZBUserSpec)

describe(@"NZBUser", ^{

	__block NZBUser *user = nil;
	__block NSDictionary *userDictionary = nil;

	beforeEach(^{

		userDictionary = @{ kDictionaryKeyId : kDictionaryKeyId,
							kDictionaryKeyPower : @10,
							kDictionaryKeyRating : @1.5,
							};

		user = [[NZBUser alloc] initWithDictionary:userDictionary];

	});

	context(@"Initialization and deserialization", ^{

		it(@"should init", ^{

			[[user shouldNot] beNil];
			[[user.id should] equal:kDictionaryKeyId];
			[[theValue(user.power) should] equal:@10];
			[[theValue(user.rating) should] equal:1.5 withDelta:DBL_EPSILON];

		});

	});

	context(@"Serialization", ^{

		NSDictionary *representation = user.dictionary;
		[[representation should] equal:userDictionary];

	});

	context(@"Updating", ^{

		beforeEach(^{

			userDictionary = @{ kDictionaryKeyId : @"newId",
								kDictionaryKeyPower : @100,
								kDictionaryKeyRating : @10.5,
								@"visibleRange": @1000,
								};
			
		});

		it(@"should update self with dictionary", ^{

			[user updateWithDictionary:userDictionary];
			NSDictionary *representation = user.dictionary;

			[[user.id should] equal:@"newId"];
			[[theValue(user.power) should] equal:@100];
			[[theValue(user.rating) should] equal:10.5 withDelta:DBL_EPSILON];
			[[representation should] equal:userDictionary];
			
		});

	});
	
});

SPEC_END
