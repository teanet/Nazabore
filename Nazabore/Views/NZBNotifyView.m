#import "NZBNotifyView.h"

static NZBNotifyView *notifyView = nil;

@interface NZBNotifyView ()

@property (nonatomic, copy) dispatch_block_t didTapBlock;

@end

@implementation NZBNotifyView

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self == nil) return nil;

	self.backgroundColor = [[UIColor nzb_brightGrayColor] colorWithAlphaComponent:0.85];
	self.titleLabel.numberOfLines = 0;
	self.titleLabel.font = [UIFont systemFontOfSize:14.0];
	self.titleLabel.textAlignment = NSTextAlignmentCenter;
	self.layer.cornerRadius = 4.0;
	self.contentEdgeInsets = UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0);
	[self addTarget:self action:@selector(dismissTap) forControlEvents:UIControlEventTouchUpInside];

	return self;
}

- (void)dismissTap
{
	if (self.didTapBlock)
	{
		self.didTapBlock();
	}
	[self dismiss];
}

- (void)dismiss
{
	self.didTapBlock = nil;
	[UIView animateWithDuration:0.5
						  delay:0.0
		 usingSpringWithDamping:0.5
		  initialSpringVelocity:0.7
						options:UIViewAnimationOptionCurveEaseIn animations:^{
							[notifyView hideFromScreen];
						} completion:^(BOOL finished) {
							[notifyView removeFromSuperview];
						}];
}

- (void)hideFromScreen
{
	self.transform = CGAffineTransformMakeTranslation(0.0, -CGRectGetHeight(notifyView.frame) - 30.0);
}

+ (void)showInView:(UIView *)view text:(NSString *)text tapBlock:(dispatch_block_t)tapBlock
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		notifyView = [[NZBNotifyView alloc] init];
	});
	[notifyView setTitle:text forState:UIControlStateNormal];
	notifyView.didTapBlock = tapBlock;
	[view addSubview:notifyView];
	[notifyView mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.width.equalTo(view).with.offset(-32.0);
		make.centerX.equalTo(view);
		make.top.equalTo(view).with.offset(28.0);
	}];
	[notifyView layoutIfNeeded];

	[notifyView hideFromScreen];
	[UIView animateWithDuration:0.5
						  delay:0.0
		 usingSpringWithDamping:0.5
		  initialSpringVelocity:0.7
						options:UIViewAnimationOptionCurveEaseIn animations:^{
							notifyView.transform = CGAffineTransformIdentity;
						} completion:nil];
}

+ (void)dismiss
{
	[notifyView dismiss];
}

@end
