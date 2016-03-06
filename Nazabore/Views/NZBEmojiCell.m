#import "NZBEmojiCell.h"

@implementation NZBEmojiCell

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];

	_imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
	_imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
	_imageView.contentMode = UIViewContentModeCenter;
	[self.contentView addSubview:_imageView];

	return self;
}

@end
