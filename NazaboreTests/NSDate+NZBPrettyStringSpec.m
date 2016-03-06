#import "NSDate+NZBPrettyString.h"

SPEC_BEGIN(NSDate_NZBPrettyStringSpec)

describe(@"NSDate+NZBPrettyString", ^{

	const NSTimeInterval nowInterval = 1000000.0;

	beforeEach(^{
		[NSDate stub:@selector(date) andReturn:[NSDate dateWithTimeIntervalSince1970:nowInterval]];
	});

	it(@"should get 'several seconds ago'", ^{

		[[[NSDate nzb_prettyStringFrom:nowInterval - 59.0] should] equal:@"Несколько секунд назад"];

	});

	it(@"should get '2 minutes ago'", ^{

		[[[NSDate nzb_prettyStringFrom:nowInterval - 61.0] should] equal:@"2 минуты назад"];

	});

	it(@"should get '5 minutes ago'", ^{

		[[[NSDate nzb_prettyStringFrom:nowInterval - 5*60.0] should] equal:@"5 минут назад"];

	});
	
	it(@"should get '21 minutes ago'", ^{

		[[[NSDate nzb_prettyStringFrom:nowInterval - 21*60.0] should] equal:@"21 минуты назад"];

	});

	it(@"should get '59 minutes ago'", ^{

		[[[NSDate nzb_prettyStringFrom:nowInterval - 59*60.0] should] equal:@"59 минут назад"];

	});

	it(@"should get '59 minutes ago'", ^{

		[[[NSDate nzb_prettyStringFrom:nowInterval - 59*60.0] should] equal:@"59 минут назад"];

	});


	it(@"should get time string if less then 24 hrs", ^{

		[[[NSDate nzb_prettyStringFrom:nowInterval - 15*60*60.0] should] equal:@"05:46"];

	});
	
	it(@"should get date string if more then 24 hrs", ^{

		[[[NSDate nzb_prettyStringFrom:nowInterval - 25*60*60.0] should] equal:@"11.01.1970"];

	});
	
});

SPEC_END
