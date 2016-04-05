#import "NZBEmojiSelectVM.h"

@interface NZBEmojiSelectVM (Private)

@property (nonatomic, copy, readonly) NSArray<NZBEmojiPageVM *> *pages;

@end

SPEC_BEGIN(NZBEmojiSelectVMSpec)

describe(@"NZBEmojiSelectVM", ^{

	__block NZBEmojiSelectVM *instance = nil;

	beforeEach(^{
		instance = [[NZBEmojiSelectVM alloc] init];
	});

	it(@"should create", ^{

		[instance.pages enumerateObjectsUsingBlock:^(NZBEmojiPageVM *page, NSUInteger idx, BOOL * _Nonnull stop) {
			[page.category.emoji enumerateObjectsUsingBlock:^(NZBEmoji *emoji, NSUInteger idx, BOOL * _Nonnull stop) {
				[[emoji.image should] beNonNil];
			}];
		}];

	});

});

SPEC_END
