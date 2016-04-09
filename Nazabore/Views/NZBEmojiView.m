#import "NZBEmojiView.h"

@implementation NZBEmojiView

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self == nil) return nil;

	self.imageView.contentMode = UIViewContentModeScaleAspectFit;
	self.imageView.clipsToBounds = NO;
	self.userInteractionEnabled = NO;
	self.contentMode = UIViewContentModeCenter;

	[self setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
	[self setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

	return self;
}

- (void)setEmoji:(NZBEmoji *)emoji
{
	_emoji = emoji;
	[self setImage:emoji.image forState:UIControlStateNormal];
}

@end
