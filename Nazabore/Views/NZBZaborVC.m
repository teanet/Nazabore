#import "NZBZaborVC.h"

#import <MapKit/MapKit.h>
#import "NZBServerController.h"
#import "MZBBoardAnnotation.h"
#import "NZBServerController.h"
#import "NZBMessageCell.h"
#import "RDRGrowingTextView.h"
#import "NZBEmojiSelectView.h"
#import "NZBAdsCell.h"

@interface NZBZaborVC ()
<
UITableViewDataSource,
UITableViewDelegate,
UITextViewDelegate
>

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong, readonly) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSArray<NZBMessage *> *messages;

@end

@implementation NZBZaborVC
{
	UITableViewController *tableViewController;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	self.navigationController.interactivePopGestureRecognizer.enabled = NO;
	self.view.backgroundColor = [UIColor whiteColor];
	UIImageView *v = [[UIImageView alloc] initWithImage:self.board.iconImage];
	v.contentMode = UIViewContentModeScaleAspectFit;
	v.transform = CGAffineTransformMakeScale(0.7, 0.7);
	self.navigationItem.titleView = v;

	_tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
	[_tableView registerClass:[NZBMessageCell class] forCellReuseIdentifier:@"NZBMessageCell"];
	[_tableView registerClass:[NZBAdsCell class] forCellReuseIdentifier:@"NZBAdsCell"];
	_tableView.tableFooterView = [UIView new];
	_tableView.rowHeight = UITableViewAutomaticDimension;
	_tableView.estimatedRowHeight = 80.0;
	_tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
	_tableView.delegate = self;
	_tableView.dataSource = self;
	[self.view addSubview:_tableView];
	[_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(@64);
		make.edges.equalTo(self.view).with.priorityHigh();
	}];

	tableViewController = [[UITableViewController alloc] init];
	tableViewController.tableView = _tableView;

	_refreshControl = [[UIRefreshControl alloc] init];
	tableViewController.refreshControl = _refreshControl;
	[_refreshControl addTarget:self action:@selector(refetchData) forControlEvents:UIControlEventValueChanged];
//	[_tableView addSubview:_refreshControl];

	[self refetchData];
}

- (void)refetchData
{
	@weakify(self);

	[[[NZBServerController sharedController] fetchMessagesForBoard:self.board] subscribeNext:^(NSArray *messages) {
		@strongify(self);

		self.messages = messages;
		[self.tableView reloadData];
		[self.tableView layoutIfNeeded];
		[self.refreshControl endRefreshing];
	}];
}

- (void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
	UIEdgeInsets insets = UIEdgeInsetsMake(0.0, 0.0, self.keyboardView.frame.size.height, 0.0);
	self.tableView.contentInset = insets;
	self.tableView.scrollIndicatorInsets = insets;
	NSLog(@">>%@", self.tableView);
}

#pragma mark WCSessionDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NZBMessage *message = self.messages[indexPath.row];
	UITableViewCell <NZBCellProtocol> *cell = nil;
	switch (message.messageType) {

		case NZBMessageTypeDefault: {
			cell = [tableView dequeueReusableCellWithIdentifier:@"NZBMessageCell"];
		} break;
		case NZBMessageTypeAdvertisement: {
			cell = [tableView dequeueReusableCellWithIdentifier:@"NZBAdsCell"];
		} break;
		case NZBMessageTypeCommercial: {
			cell = [tableView dequeueReusableCellWithIdentifier:@"NZBAdsCell"];
		} break;
	}
	cell.message = message;
	return cell;
}

@end
