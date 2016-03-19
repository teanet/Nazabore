#import "NZBMessageCell.h"

#import "NZBServerController.h"
#import "NZBDataProvider.h"
#import "NSDate+NZBPrettyString.h"
#import "NZBPreferences.h"
#import "UIColor+NZBMessageCell.h"
#import "NSString+NZBMessageCell.h"

@interface NZBMessageCell ()

@property (nonatomic, strong, readonly) UILabel *messageLabel;
@property (nonatomic, strong, readonly) UILabel *timeLabel;
@property (nonatomic, strong, readonly) UIImageView *iconView;
@property (nonatomic, strong, readonly) UILabel *powerLabel;
@property (nonatomic, strong, readonly) UILabel *myMessageLabel;

@property (nonatomic, assign, readonly) BOOL isCurrentUser;


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

	[self setSwipeContainerViewBackgroundColor:[UIColor nzb_brightGrayColor]];

	_myMessageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	_myMessageLabel.text = @"Моё сообщение";
	_myMessageLabel.font = [UIFont systemFontOfSize:10.0];
	_myMessageLabel.textAlignment = NSTextAlignmentRight;
	_myMessageLabel.textColor = [UIColor nzb_lightGrayColor];
	[self.contentView addSubview:_myMessageLabel];

	_messageLabel = [[UILabel alloc] init];
	_messageLabel.numberOfLines = 0;
	[self.contentView addSubview:_messageLabel];

	_timeLabel = [[UILabel alloc] init];
	_timeLabel.textColor = [UIColor nzb_lightGrayColor];
	_timeLabel.font = [UIFont systemFontOfSize:14.0];
	[self.contentView addSubview:_timeLabel];

	_iconView = [[UIImageView alloc] init];
	_iconView.contentMode = UIViewContentModeScaleAspectFit;
	[self.contentView addSubview:_iconView];

	_powerLabel = [[UILabel alloc] init];
	_powerLabel.textAlignment = NSTextAlignmentRight;
	_powerLabel.font = [UIFont systemFontOfSize:14.0];
	[self.contentView addSubview:_powerLabel];

	dislikeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 90)];
	dislikeButton.backgroundColor = [UIColor nzb_brightGrayColor];

	UIImageView *dislikeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dislike_icon"]];
	[dislikeButton addSubview:dislikeImageView];
	[dislikeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(dislikeButton);
		make.centerY.equalTo(dislikeButton);
	}];

	[self addLeftView:dislikeButton];

	likeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 90)];
	likeButton.backgroundColor = [UIColor nzb_brightGrayColor];

	UIImageView *likeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"like_icon"]];
	[likeButton addSubview:likeImageView];
	[likeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(likeButton);
		make.centerY.equalTo(likeButton);
	}];

	[self addRightView:likeButton];

	[_myMessageLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
	[_myMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.contentView).with.offset(16.0);
		make.top.equalTo(self.contentView.mas_top).with.offset(8.0);
		make.right.equalTo(self.contentView).with.offset(-16.0);
		make.bottom.equalTo(_messageLabel.mas_top);
	}];

	[_messageLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
	[_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.contentView).with.offset(16.0);
		make.right.equalTo(self.contentView).with.offset(-16.0);
		make.bottom.equalTo(_timeLabel.mas_top).with.offset(-4.0);
	}];

	[_timeLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
	[_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.contentView).with.offset(16.0);
		make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-8.0);
	}];

	[_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(self.contentView).with.offset(-16.0);
		make.height.equalTo(@16.0);
		make.width.equalTo(@16.0);
		make.centerY.equalTo(_timeLabel);
	}];

	[_powerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(_iconView.mas_left).with.offset(-4.0);
		make.centerY.equalTo(_timeLabel);
	}];

	self.swipeEffect = YATableSwipeEffectTrail;
	[self setModeWillChangeBlock:^(UITableViewCell *cell, YATableSwipeMode mode) {

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

- (void)updateConstraints
{
	[self.myMessageLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		if (!self.isCurrentUser)
		{
			make.height.equalTo(@0);
		}
	}];

	[super updateConstraints];
}

- (void)nzb_update
{
	BOOL hasUserInteraction = (self.message.rating.interaction != NZBUserInteractionNone);

	self.contentView.backgroundColor = [UIColor colorWithWhite:hasUserInteraction ? 0.95 : 1.0 alpha:1.0];
	self.messageLabel.text = self.message.messageForWatch;

	self.powerLabel.textColor = [UIColor nzb_powerColorForPowerString:self.message.powerString];
	self.powerLabel.text = [self.message.powerString nzb_prettyPowerString];
	self.timeLabel.text = [NSDate nzb_prettyStringFrom:self.message.timestamp * 0.001];
	self.swipingEnabled = !hasUserInteraction;
	self.iconView.image = [UIImage imageNamed:self.message.iconName];

	[self updateConstraintsIfNeeded];
	[self layoutIfNeeded];
}

- (void)setMessage:(NZBMessage *)message
{
	_message = message;
	_message.relatedView = self;
	_isCurrentUser = [[NZBPreferences defaultPreferences].userId isEqualToString:self.message.userid];
	[self nzb_update];
}

@end
