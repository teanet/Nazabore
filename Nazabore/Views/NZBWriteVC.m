#import "NZBWriteVC.h"

#import "NZBEmojiSelectVC.h"
#import "NZBDataProvider.h"
#import "NZBZaborVC.h"
#import "UIColor+System.h"
#import "NZBAnalytics.h"
#import "Nazabore-Swift.h"

static CGFloat const MaxToolbarHeight = 200.0;

@interface NZBWriteVC ()

@property (nonatomic, strong, readonly) UIView *toolbar;
@property (nonatomic, strong) MASConstraint *hightContraint;

@end

@implementation NZBWriteVC

@synthesize toolbar = _toolbar;

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.view bringSubviewToFront:self.toolbar];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	@weakify(self);

	_contentView = [[UIView alloc] init];
	[self.view addSubview:_contentView];
	[_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.right.left.equalTo(self.view);
	}];

	[self.view addSubview:self.toolbar];
	[self.toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.equalTo(self.view);
		self.hightContraint = make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
	}];

	FrameObservingInputAccessoryView *accessoryView = [[FrameObservingInputAccessoryView alloc] init];
	self.textView.inputAccessoryView = accessoryView;
	[accessoryView setOnFrameChanged:^(CGRect frame) {
		@strongify(self);
		[self.hightContraint setOffset:-frame.size.height];
	}];

	_keyboardView = [[UIView alloc] init];
	_keyboardView.hidden = YES;
	[self.view addSubview:_keyboardView];

	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleKeyboard:)
												 name:UIKeyboardWillShowNotification
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleKeyboard:)
												 name:UIKeyboardWillHideNotification
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleKeyboard:)
												 name:UIKeyboardDidChangeFrameNotification
											   object:nil];
}

- (void)handleKeyboard:(NSNotification *)n
{
	CGRect frame = [n.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];

	[self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.height.equalTo(@(self.view.frame.size.height - frame.size.height));
	}];

	frame.size.height = MAX(frame.size.height, _toolbar.frame.size.height);
	self.keyboardView.frame = frame;

	static BOOL skipFirstTimeAnimation;
	if (skipFirstTimeAnimation)
	{
		[UIView animateWithDuration:0.3 animations:^{
			[self.view layoutIfNeeded];
		}];
	}
	skipFirstTimeAnimation = YES;
}

- (void)showBoard:(NZBBoard *)b
{
	if ([self.board.id isEqualToString:b.id]) return;

	NZBZaborVC *zaborVC = [[NZBZaborVC alloc] init];
	zaborVC.board = b;
	[self.navigationController pushViewController:zaborVC animated:YES];
}

- (void)sendTap:(UIButton *)b
{
	@weakify(self);

	[self.textView resignFirstResponder];

	NSString *textWithoutSpaces = [self.textView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
	if (textWithoutSpaces.length == 0) return;

	NZBEmojiSelectVC *emojiSelectVC = [[NZBEmojiSelectVC alloc] init];
	emojiSelectVC.didSelectEmojiBlock = ^(NZBEmoji *emoji) {
		@strongify(self);
		NSCParameterAssert(emoji);
		[self dismissViewControllerAnimated:YES completion:nil];
		[[[NZBDataProvider sharedProvider] postMessage:self.textView.text forBoard:self.board emoji:emoji] subscribeNext:^(NZBMessage *m) {
			@strongify(self);

			if (m.boardD)
			{
				NZBBoard *b = [[NZBBoard alloc] initWithDictionary:m.boardD];
				[self showBoard:b];
			}
			self.textView.text = @"";
			[self refetchData];
			[NZBAnalytics logEvent:NZBAPostMessageEvent parameters:@{NZBAStatus: @YES,
																	 NZBASmile: emoji.textForAnalytics}];
		} error:^(NSError *error) {
			[NZBAnalytics logEvent:NZBAPostMessageEvent parameters:@{NZBAStatus: @NO,
																	 NZBASmile: emoji.textForAnalytics}];
			[[[UIAlertView alloc] initWithTitle:kNZB_ERROR_ALERT_TITLE
										message:error.localizedDescription
									   delegate:nil
							  cancelButtonTitle:kNZB_ERROR_ALERT_BUTTON_OK_TITLE
							  otherButtonTitles:nil] show];
		}];
	};
	emojiSelectVC.didCloseBlock = ^{
		@strongify(self);

		[self dismissViewControllerAnimated:YES completion:nil];
	};
	[self presentViewController:emojiSelectVC animated:YES completion:nil];
}

- (void)refetchData
{
	[[NZBDataProvider sharedProvider] fetchNearestBoards];
}

#pragma mark - Overrides

- (UIView *)toolbar
{
	if (_toolbar) return _toolbar;

	_toolbar = [UIView new];
	_toolbar.backgroundColor = [UIColor nzb_toolBarColor];

	UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[sendButton addTarget:self action:@selector(sendTap:) forControlEvents:UIControlEventTouchUpInside];
	[sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[sendButton setContentEdgeInsets:UIEdgeInsetsMake(2.0, 4.0, 2.0, 4.0)];
	[sendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
	[sendButton setTitle:kNZB_INPUT_BUTTON_TITLE forState:UIControlStateNormal];
	sendButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
	sendButton.layer.masksToBounds = YES;
	sendButton.layer.cornerRadius = 4.0f;
	sendButton.backgroundColor = [UIColor nzb_yellowColor];

	[_toolbar addSubview:sendButton];

	_textView = [[RDRGrowingTextView alloc] init];
	_textView.font = [UIFont systemFontOfSize:14.0f];
	_textView.textContainerInset = UIEdgeInsetsMake(4.0f, 3.0f, 3.0f, 3.0f);
	_textView.layer.borderColor = [UIColor colorWithRed:229.0f/255.0f green:229.0f/255.0f blue:229.0f/255.0f alpha:1.0f].CGColor;
	_textView.layer.borderWidth = 1.0f;
	_textView.layer.masksToBounds = YES;
	_textView.layer.cornerRadius = 4.0f;
	[_toolbar addSubview:_textView];

	UILabel *placeholderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	placeholderLabel.text = kNZB_INPUT_TEXT_PLACEHOLDER;
	placeholderLabel.font = [UIFont systemFontOfSize:14.0];
	placeholderLabel.textColor = [UIColor nzb_lightGrayColor];
	placeholderLabel.textAlignment = NSTextAlignmentLeft;
	[_toolbar addSubview:placeholderLabel];

	RAC(placeholderLabel, alpha) = [RACObserve(_textView, text)
		map:^NSNumber *(NSString *text) {
			return text.length > 0 ? @0.0 : @1.0;
		}];

	[sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(_toolbar.mas_right).with.offset(-8.0);
		make.centerY.equalTo(_toolbar.mas_bottom).with.offset(-22.0);
		make.height.equalTo(@28.0);
		make.width.equalTo(@96.0);
	}];

	[_textView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(_toolbar).with.offset(8.0);
		make.top.equalTo(_toolbar).with.offset(8.0);
		make.bottom.equalTo(_toolbar).with.offset(-8.0);
		make.right.equalTo(sendButton.mas_left).with.offset(-8.0);
	}];

	[placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(_textView);
		make.left.equalTo(_textView).with.offset(8.0);
	}];

	[_toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
		make.height.lessThanOrEqualTo(@(MaxToolbarHeight));
	}];

	[_textView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
	[_textView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
	[_toolbar setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];

	return _toolbar;
}

@end
