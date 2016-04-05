#import "NSDate+NZBPrettyString.h"

#import "NZBLocalizableConstants.h"

SPEC_BEGIN(NSDate_NZBPrettyStringSpec)

describe(@"NSDate+NZBPrettyString", ^{

	const NSTimeInterval nowInterval = 1000000.0;

	beforeEach(^{
		[NSDate stub:@selector(date) andReturn:[NSDate dateWithTimeIntervalSince1970:nowInterval]];
	});

	it(@"should get time string if less then 24 hrs", ^{

		[[[NSDate nzb_prettyStringFrom:nowInterval - 15*60*60.0] should] equal:@"05:46"];

	});
	
	it(@"should get date string if more then 24 hrs", ^{

		[[[NSDate nzb_prettyStringFrom:nowInterval - 25*60*60.0] should] equal:@"11.01.1970"];

	});
	
});

SPEC_END
