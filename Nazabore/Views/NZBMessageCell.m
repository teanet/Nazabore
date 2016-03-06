#import "NZBMessageCell.h"

#import "NZBServerController.h"
#import "NZBDataProvider.h"

@interface NZBMessageCell ()

@property (nonatomic, strong, readonly) UILabel *messageLabel;
@property (nonatomic, strong, readonly) UILabel *timeLabel;
@property (nonatomic, strong, readonly) UIImageView *iconView;
@property (nonatomic, strong, readonly) UILabel *powerLabel;

@end

@implementation NZBMessageCell
{
	UIButton *dislikeButton;
	UIButton *likeButton;
}

@synthesize message = _message;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self == nil) return nil;

	@weakify(self);

	self.contentView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
	self.selectionStyle = UITableViewCellSelectionStyleNone;

	_messageLabel = [[UILabel alloc] init];
	_messageLabel.numberOfLines = 0;
	[self.contentView addSubview:_messageLabel];

	_timeLabel = [[UILabel alloc] init];
	[self.contentView addSubview:_timeLabel];

	_iconView = [[UIImageView alloc] init];
	_iconView.contentMode = UIViewContentModeScaleAspectFit;
	[self.contentView addSubview:_iconView];

	_powerLabel = [[UILabel alloc] init];
	_powerLabel.textAlignment = NSTextAlignmentRight;
	[self.contentView addSubview:_powerLabel];

	dislikeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 90)];
	dislikeButton.backgroundColor = [UIColor darkGrayColor];
	[dislikeButton setImage:[UIImage imageNamed:@"dislike_icon"] forState:UIControlStateNormal];
	[self addLeftView:dislikeButton];

	likeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 90)];
	likeButton.backgroundColor = [UIColor darkGrayColor];
	[likeButton setImage:[UIImage imageNamed:@"like_icon"] forState:UIControlStateNormal];
	[self addRightView:likeButton];

	[_messageLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
	[_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.contentView).with.offset(17.0);
		make.top.equalTo(self.contentView).with.offset(15.0);
		make.right.equalTo(self.contentView).with.offset(-17.0);
		make.bottom.equalTo(_timeLabel.mas_top).with.offset(-5.0);
	}];

	[_timeLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
	[_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.contentView).with.offset(17.0);
		make.height.equalTo(@20);
		make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-8.0);
	}];

	[_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(self.contentView).with.offset(-13.0);
		make.height.equalTo(@15.0);
		make.width.equalTo(@15.0);
		make.centerY.equalTo(_timeLabel);
	}];

	[_powerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(_iconView.mas_left).with.offset(-5.0);
		make.centerY.equalTo(_timeLabel);
	}];

	self.swipeEffect = YATableSwipeEffectTrail;
	[self setModeWillChangeBlock:^(UITableViewCell *cell, YATableSwipeMode mode) {
		NSLog(@">>%ld", (long)mode);
		if (mode == YATableSwipeModeDefault) return;
		@strongify(self);

		NZBUserInteraction interaction = (mode == YATableSwipeModeLeftON) ? NZBUserInteractionDislike : NZBUserInteractionLike;
		[[[NZBServerController sharedController] rateMessage:self.message withInteraction:interaction] subscribeNext:^(NZBMessage *message) {

			self.message = message;
			
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
				[self resetSwipe:^(BOOL finished) {

				} withAnimation:YES];

			});

		}];

	}];

	return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	CGFloat h = self.bounds.size.height;
	likeButton.frame = CGRectMake(0, 0, 100, h);
	dislikeButton.frame = CGRectMake(0, 0, 100, h);
}

- (void)nzb_update
{
	self.messageLabel.text = self.message.messageForWatch;
	self.powerLabel.text = self.message.powerString;
	self.timeLabel.text = self.message.timeString;
	self.swipingEnabled = (self.message.rating.interaction == NZBUserInteractionNone);
	self.iconView.image = [UIImage imageNamed:self.message.icon];
}

- (void)setMessage:(NZBMessage *)message
{
	_message = message;
	_message.relatedView = self;
	[self nzb_update];
}

@end
