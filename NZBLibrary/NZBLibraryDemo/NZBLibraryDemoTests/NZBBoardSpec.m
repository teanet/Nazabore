#import "NZBBoard.h"

SPEC_BEGIN(NZBBoardSpec)

describe(@"NZBBoard", ^{

	__block NZBBoard *board = nil;

	beforeEach(^{

		board = [[NZBBoard alloc] init];

	});

	context(@"Initialization", ^{

		it(@"should init", ^{

			[[board shouldNot] beNil];

		});

	});
	
});

SPEC_END
