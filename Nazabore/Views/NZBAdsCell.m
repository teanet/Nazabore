#import "NZBAdsCell.h"

@interface NZBAdsCell ()

@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UILabel *messageLabel;
@property (nonatomic, strong, readonly) UIImageView *iconView;

@end

@implementation NZBAdsCell
{
	UIButton *callButton;
	UIButton *gisButton;
}

@synthesize message = _message;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self == nil) return nil;

	self.contentView.backgroundColor = [UIColor nzb_adsBGColor];
	self.selectionStyle = UITableViewCellSelectionStyleNone;

	UIView *height = [UIView new];
	[self.contentView addSubview:height];
	[height mas_makeConstraints:^(MASConstraintMaker *make) {
		make.height.greaterThanOrEqualTo(@60.0).with.priorityHigh();
		make.top.equalTo(self.contentView);
		make.bottom.equalTo(self.contentView);
	}];

	_messageLabel = [[UILabel alloc] init];
	_messageLabel.numberOfLines = 0;
	[self.contentView addSubview:_messageLabel];

	UIView *greenView = [[UIView alloc] init];
	greenView.backgroundColor = [UIColor nzb_darkGreenColor];
	[self.contentView addSubview:greenView];

	_titleLabel = [[UILabel alloc] init];
	_titleLabel.textColor = [UIColor nzb_darkGreenColor];
	_titleLabel.numberOfLines = 1;
	[self.contentView addSubview:_titleLabel];

	_iconView = [[UIImageView alloc] init];
	_iconView.backgroundColor = [UIColor redColor];
	[self.contentView addSubview:_iconView];

	UIView *content = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 90)];

	gisButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 90)];
	[gisButton addTarget:self action:@selector(gisTap) forControlEvents:UIControlEventTouchUpInside];
	gisButton.backgroundColor = [UIColor darkGrayColor];
	[gisButton setImage:[UIImage imageNamed:@"2gis_watch"] forState:UIControlStateNormal];
	[content addSubview:gisButton];

	callButton = [[UIButton alloc] initWithFrame:CGRectMake(60, 0, 60, 90)];
	[callButton addTarget:self action:@selector(callTap) forControlEvents:UIControlEventTouchUpInside];
	callButton.backgroundColor = [UIColor darkGrayColor];
	[callButton setImage:[UIImage imageNamed:@"call"] forState:UIControlStateNormal];
	[content addSubview:callButton];
	[self addRightView:content];

	[greenView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.contentView);
		make.top.equalTo(self.contentView);
		make.bottom.equalTo(self.contentView);
		make.width.equalTo(@5);
	}];

	[_messageLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
	[_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.contentView).with.offset(17.0);
		make.top.equalTo(self.contentView).with.offset(14.0);
		make.right.equalTo(self.contentView).with.offset(-8.0);
		make.bottom.equalTo(_titleLabel.mas_top).with.offset(-4.0);
	}];

	[_titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
	[_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.contentView).with.offset(17.0);
		make.bottom.equalTo(self.contentView).with.offset(-8.0);
		make.right.equalTo(self.contentView).with.offset(-8.0);
	}];

	[_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(self.contentView).with.offset(-8.0);
		make.centerY.equalTo(self.contentView).with.offset(-20.0);
	}];

	[self setModeWillChangeBlock:^(UITableViewCell *cell, YATableSwipeMode mode) {
		NSLog(@">>%ld", (long)mode);
	}];

	return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	CGFloat h = self.bounds.size.height;
	gisButton.frame = CGRectMake(0, 0, 60, h);
	callButton.frame = CGRectMake(60, 0, 60, h);
}

- (void)callTap
{
	NSString *urlString = [NSString stringWithFormat:@"tel://%@", self.message.phone];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
	});
}

- (void)gisTap
{
	NSString *urlString = [NSString stringWithFormat:@"grymmobile://opencard?dbObject=%@", self.message.dbObjectIdentifier];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

- (void)setMessage:(NZBMessage *)message
{
	_message = message;
	callButton.enabled = (message.phone.length > 0);
	gisButton.enabled = (message.dbObjectIdentifier.length > 0);

	self.titleLabel.text = message.title;
	self.messageLabel.text = message.messageForWatch;
	self.swipingEnabled = (message.rating.interaction == NZBUserInteractionNone);
}

@end
