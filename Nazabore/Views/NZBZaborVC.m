#import "NZBZaborVC.h"

#import <MapKit/MapKit.h>
#import "NZBServerController.h"
#import "MZBBoardAnnotation.h"
#import "NZBServerController.h"
#import "RDRGrowingTextView.h"
#import "NZBEmojiSelectVC.h"
#import "UIBarButtonItem+NZBBarButtonItem.h"
#import "NZBAnalytics.h"
#import "NZBZaborVM.h"

@interface NZBZaborVC ()

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong, readonly) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSArray<NZBMessage *> *messages;
@property (nonatomic, strong, readonly) UITableViewController *tableViewController;
@property (nonatomic, strong, readonly) UIProgressView *progress;
@property (nonatomic, strong, readonly) NZBZaborVM *viewModel;

@end

@implementation NZBZaborVC

- (instancetype)init
{
	self = [super init];
	if (self == nil) return nil;

	_viewModel = [[NZBZaborVM alloc] init];

	return self;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	@weakify(self);

	[NZBAnalytics logEvent:NZBAOpenBoardEvent parameters:@{NZBABoard: self.board.id ?: @""}];

	UIScreenEdgePanGestureRecognizer *recognizer =
		[[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
	recognizer.edges = UIRectEdgeLeft;
	[self.view addGestureRecognizer:recognizer];

	self.navigationController.interactivePopGestureRecognizer.enabled = NO;
	self.view.backgroundColor = [UIColor whiteColor];
	UIImageView *v = [[UIImageView alloc] initWithImage:self.board.emoji.image];
	v.contentMode = UIViewContentModeScaleAspectFit;
	v.transform = CGAffineTransformMakeScale(0.7, 0.7);
	self.navigationItem.titleView = v;

	_tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
	_tableView.tableFooterView = [UIView new];
	_tableView.rowHeight = UITableViewAutomaticDimension;
	_tableView.estimatedRowHeight = 80.0;
	_tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
	UIEdgeInsets tableSeparatorInsets = UIEdgeInsetsMake(0.f, 16.f, 0.f, 16.f);
	[_tableView setSeparatorInset:tableSeparatorInsets];
	[_tableView setLayoutMargins:tableSeparatorInsets];
	_tableView.separatorColor = [UIColor nzb_lightGrayColor];
	[self.view addSubview:_tableView];
	[_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(@64.0);
		make.edges.equalTo(self.view).with.priorityHigh();
	}];
	[self.viewModel registerTableView:_tableView];
	
	_tableViewController = [[UITableViewController alloc] init];
	_tableViewController.tableView = _tableView;

	_refreshControl = [[UIRefreshControl alloc] init];
	_tableViewController.refreshControl = _refreshControl;
	[_refreshControl addTarget:self action:@selector(refetchData) forControlEvents:UIControlEventValueChanged];

	// [[ Configure navigation bar
	UIBarButtonItem *backButton = [UIBarButtonItem nzb_backBarButtonItem];

	backButton.rac_command =
		[[RACCommand alloc] initWithSignalBlock:^RACSignal *(id _) {
			@strongify(self);

			[self.navigationController popViewControllerAnimated:YES];
			return [RACSignal empty];
		}];

	self.navigationItem.leftBarButtonItem = backButton;
	// ]]

	_progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
	[self.view addSubview:_progress];
	[_progress mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.view);
		make.right.equalTo(self.view);
		make.top.equalTo(@64.0);
	}];

	[self refetchData];
}

- (void)refetchData
{
	@weakify(self);

	self.progress.tintColor = [UIColor nzb_darkGreenColor];
	self.progress.progress = 0.02f;
	self.progress.alpha = 1.0;

	RACSignal *downloadSignal = [[NZBServerController sharedController] messagesForBoard:self.board];
	__block BOOL didFinish = NO;

	__block float addPercent = 0.01;
	NSTimeInterval interval = 1.0 / 60.0;
	[[[RACSignal interval:interval onScheduler:[RACScheduler mainThreadScheduler]]
		takeUntilBlock:^BOOL(id x) {
			@strongify(self);

			return didFinish || (self.progress.progress > 0.99f);
		}]
		subscribeNext:^(id x) {
			@strongify(self);

			addPercent *= 0.989;
			[self.progress setProgress:self.progress.progress + addPercent animated:YES];
		}];

	[[downloadSignal
		deliverOnMainThread]
		subscribeNext:^(NSArray *messages) {
			@strongify(self);

			didFinish = YES;
			[self didLoadMessages:messages];
			[self.progress setProgress:1.0f animated:YES];
			[UIView animateWithDuration:0.3 delay:0.5 options:0 animations:^{
				self.progress.alpha = 0.0;
			} completion:^(BOOL finished) {
			}];
		} error:^(NSError *error) {
			@strongify(self);
			didFinish = YES;

			[self.refreshControl endRefreshing];
			[UIView animateWithDuration:0.3 animations:^{
				[self.progress setProgress:1.0f animated:NO];
			} completion:^(BOOL finished) {
				self.progress.tintColor = [UIColor redColor];
			}];
		}];
}

- (void)didLoadMessages:(NSArray *)messages
{
	self.viewModel.messages = messages;
	[self.tableView reloadData];
	[self.tableView layoutIfNeeded];
	[self.refreshControl endRefreshing];
}

- (void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
	// Костыльнём пока табличку до первого нажатия
	CGFloat height = self.keyboardView.frame.size.height > 0 ? self.keyboardView.frame.size.height : 44.0;
	UIEdgeInsets insets = UIEdgeInsetsMake(0.0, 0.0, height, 0.0);
	self.tableView.contentInset = insets;
	self.tableView.scrollIndicatorInsets = insets;
}

- (void)didSwipe:(UIScreenEdgePanGestureRecognizer *)recognizer
{
	if (recognizer.state == UIGestureRecognizerStateBegan)
	{
		[self.navigationController popViewControllerAnimated:YES];
	}
}

@end
