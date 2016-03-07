#import "NZBMessage.h"

SPEC_BEGIN(NZBMessageSpec)

describe(@"NZBMessage", ^{

	__block NZBMessage *instance = nil;

	beforeEach(^{
		instance = [[NZBMessage alloc] init];
	});

	it(@"should create", ^{

		[[instance should] beNonNil];

	});

});

SPEC_END
