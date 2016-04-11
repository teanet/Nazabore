#import "NZBPoiCell.h"

@interface NZBPoiCell ()

@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UILabel *messageLabel;
@property (nonatomic, strong, readonly) UIImageView *iconView;
@property (nonatomic, strong, readonly) UIActivityIndicatorView *spinner;

@end

@implementation NZBPoiCell

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

	UIView *sideView = [[UIView alloc] init];
	sideView.backgroundColor = [UIColor nzb_santasGrayColor];
	[self.contentView addSubview:sideView];

	_titleLabel = [[UILabel alloc] init];
	_titleLabel.textColor = [UIColor nzb_brightGrayColor];
	_titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
	_titleLabel.numberOfLines = 0;
	[self.contentView addSubview:_titleLabel];

	_iconView = [[UIImageView alloc] init];
	_iconView.backgroundColor = [UIColor nzb_lightGrayColor];
	_iconView.contentMode = UIViewContentModeScaleAspectFill;
	_iconView.clipsToBounds = YES;
	[self.contentView addSubview:_iconView];

	_spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	_spinner.hidesWhenStopped = YES;
	[_iconView addSubview:_spinner];

	UIView *content = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 90)];

	[self addRightView:content];

	[sideView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.contentView);
		make.top.equalTo(self.contentView);
		make.bottom.equalTo(self.contentView);
		make.width.equalTo(@3.0);
	}];

	[_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.contentView);
		make.leading.equalTo(@3.0);
		make.trailing.equalTo(self.contentView);
		make.height.equalTo(@150);
	}];

	[_titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
	[_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.contentView).with.offset(16.0);
		make.top.equalTo(_iconView.mas_bottom).with.offset(8.0);
		make.right.equalTo(self.contentView).with.offset(-8.0);
	}];

	[_messageLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
	[_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.contentView).with.offset(16.0);
		make.top.equalTo(_titleLabel.mas_bottom).with.offset(8.0);
		make.right.equalTo(self.contentView).with.offset(-8.0);
		make.bottom.equalTo(self.contentView).with.offset(-8.0);
	}];

	[_spinner mas_makeConstraints:^(MASConstraintMaker *make) {
		make.center.equalTo(_iconView);
	}];
	return self;
}

- (void)setMessage:(NZBMessage *)message
{
	@weakify(self);

	_message = message;

	self.titleLabel.text = message.poiName;
	self.messageLabel.text = message.messageForWatch;
	self.swipingEnabled = NO;
	self.iconView.alpha = 0.0;
	NSURL *imageURL = [NSURL URLWithString:message.poiImageUrlString];

	if (imageURL.absoluteString.length == 0) return;

	[self.spinner startAnimating];
	[[[NSData rac_readContentsOfURL:imageURL options:NSDataReadingMappedIfSafe scheduler:[RACScheduler scheduler]]
		deliverOnMainThread]
		subscribeNext:^(NSData *imageData) {
			@strongify(self);

			[self.spinner stopAnimating];
			if (imageData.length > 0 && [message isEqual:self.message])
			{
				UIImage *image = [UIImage imageWithData:imageData];
				[UIView animateWithDuration:0.3 animations:^{
					[self.iconView setImage:image];
					self.iconView.alpha = 1.0;
				}];
			}
		} error:^(NSError *error) {
			[self.spinner stopAnimating];
		}];
}

@end
