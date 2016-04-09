#import "NZBEmoji.h"

SPEC_BEGIN(NZBEmojiSpec)

describe(@"NZBEmoji", ^{

	beforeEach(^{
	});

	it(@"should get emoji with type image for 0", ^{

		NZBEmoji *emoji = [[NZBEmoji alloc] initWithText:@"0"];
		[[theValue(emoji.type) should] equal:theValue(NZBEmojiImage)];

	});
	
	it(@"should get emoji with type image for 20", ^{

		NZBEmoji *emoji = [[NZBEmoji alloc] initWithText:@"20"];
		[[theValue(emoji.type) should] equal:theValue(NZBEmojiImage)];

	});

	it(@"should get emoji with type text for 👍🏿", ^{

		NZBEmoji *emoji = [[NZBEmoji alloc] initWithText:@"👍🏿"];
		[[theValue(emoji.type) should] equal:theValue(NZBEmojiText)];

	});

	it(@"should get emoji with type text for 0️⃣", ^{

		NZBEmoji *emoji = [[NZBEmoji alloc] initWithText:@"0️⃣"];
		[[theValue(emoji.type) should] equal:theValue(NZBEmojiText)];

	});

});

SPEC_END
