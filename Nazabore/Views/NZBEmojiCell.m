#import "NZBEmojiCell.h"

#import "NZBEmojiView.h"

@interface NZBEmojiCell ()

@property (nonatomic, strong, readonly) NZBEmojiView *emojiView;

@end

@implementation NZBEmojiCell

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];

	_emojiView = [[NZBEmojiView alloc] initWithFrame:self.contentView.bounds];
	_emojiView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
	[self.contentView addSubview:_emojiView];

	return self;
}

- (void)setHighlighted:(BOOL)highlighted
{
	[super setHighlighted:highlighted];
	[self.emojiView setHighlighted:highlighted];
}

- (void)setEmoji:(NZBEmoji *)emoji
{
	_emoji = emoji;
	self.emojiView.emoji = emoji;
}

@end
