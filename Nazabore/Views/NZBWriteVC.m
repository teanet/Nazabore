#import "NZBWriteVC.h"

#import "NZBEmojiSelectView.h"
#import "NZBDataProvider.h"
#import "NZBZaborVC.h"

static CGFloat const MaxToolbarHeight = 200.0;

@interface NZBWriteVC ()

@property (nonatomic, strong, readonly) UIToolbar *toolbar;

@end

@implementation NZBWriteVC

- (void)viewDidLoad
{
	[super viewDidLoad];

	_contentView = [[UIView alloc] init];
	[self.view addSubview:_contentView];
	[_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.view);
		make.right.equalTo(self.view);
		make.top.equalTo(self.view);
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

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self handleKeyboard:nil];
}

- (void)handleKeyboard:(NSNotification *)n
{
	CGRect frame = [n.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
	[self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.height.equalTo(@(self.view.frame.size.height - frame.size.height));
	}];
	frame.size.height = MAX(frame.size.height, _toolbar.frame.size.height);
	self.keyboardView.frame = frame;
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

	NZBEmojiSelectView *view = [[NZBEmojiSelectView alloc] init];

	view.block = ^(NSString *emoji) {
		@strongify(self);

		[self dismissViewControllerAnimated:YES completion:nil];

		[[[NZBDataProvider sharedProvider] postMessage:self.textView.text forBoard:self.board icon:emoji] subscribeNext:^(NZBMessage *m) {
			@strongify(self);

			if (m.boardD) {
				NZBBoard *b = [[NZBBoard alloc] initWithDictionary:m.boardD];
				[self showBoard:b];
			}

			self.textView.text = @"";
			[self refetchData];

		} error:^(NSError *error) {
			[[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
		}];
	};
	view.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	view.modalPresentationStyle = UIModalPresentationOverFullScreen;
	[self presentViewController:view animated:YES completion:nil];
}

- (void)refetchData
{
	[[NZBDataProvider sharedProvider] fetchNearestBoards];
}

#pragma mark - Overrides

- (BOOL)canBecomeFirstResponder
{
	return YES;
}

- (UIView *)inputAccessoryView
{
	if (_toolbar) return _toolbar;

	_toolbar = [UIToolbar new];
	_toolbar.backgroundColor = [UIColor whiteColor];

	UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
	[b addTarget:self action:@selector(sendTap:) forControlEvents:UIControlEventTouchUpInside];
	[b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[b setContentEdgeInsets:UIEdgeInsetsMake(2.0, 5.0, 2.0, 5.0)];
	[b setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
	[b setTitle:@"Написать" forState:UIControlStateNormal];
	b.layer.masksToBounds = YES;
	b.layer.cornerRadius = 4.0f;
	b.backgroundColor = [UIColor colorWithRed:255/255. green:210/255. blue:70/255. alpha:1.0];

	[_toolbar addSubview:b];

	_textView = [RDRGrowingTextView new];
	_textView.font = [UIFont systemFontOfSize:17.0f];
	_textView.textContainerInset = UIEdgeInsetsMake(4.0f, 3.0f, 3.0f, 3.0f);
	_textView.layer.borderColor = [UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:205.0f/255.0f alpha:1.0f].CGColor;
	_textView.layer.borderWidth = 1.0f;
	_textView.layer.masksToBounds = YES;
	_textView.layer.cornerRadius = 4.0f;
	[_toolbar addSubview:_textView];

	[b mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(_toolbar.mas_right).with.offset(-8.0);
		make.centerY.equalTo(_toolbar.mas_bottom).with.offset(-22.0);
	}];

	[_textView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(_toolbar).with.offset(8.0);
		make.top.equalTo(_toolbar).with.offset(8.0);
		make.bottom.equalTo(_toolbar).with.offset(-8.0);
		make.right.equalTo(b.mas_left).with.offset(-8.0);
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
