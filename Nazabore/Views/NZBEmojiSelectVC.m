#import "NZBEmojiSelectVC.h"

#import "NZBEmojiSelectVM.h"
#import "NZBEmojiPageVC.h"
#import "UIViewController+DGSAdditions.h"

@interface NZBEmojiSelectVC ()
<
UIPageViewControllerDataSource,
UIPageViewControllerDelegate
>

@property (nonatomic, strong, readonly) NZBEmojiSelectVM *viewModel;
@property (nonatomic, copy, readonly) NSMutableDictionary<NSString *, NZBEmojiPageVC *> *pageVCs;
@property (nonatomic, strong, readonly) UIPageViewController *pageViewController;
@property (nonatomic, strong, readonly) UIPageControl *pageControl;

@end

@implementation NZBEmojiSelectVC

- (instancetype)init
{
	self = [super init];
	if (self == nil) return nil;

	self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	self.modalPresentationStyle = UIModalPresentationOverFullScreen;
	_viewModel = [[NZBEmojiSelectVM alloc] init];
	_pageVCs = [NSMutableDictionary dictionary];

	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	@weakify(self);

	[self createInterface];

	[self.pageViewController setViewControllers:@[[self pageVCWithVM:self.viewModel.currentPageVM]]
									  direction:UIPageViewControllerNavigationDirectionForward
									   animated:NO
									 completion:nil];

	[self.viewModel.didSelectEmojiSignal subscribeNext:^(NZBEmoji *emoji) {
		@strongify(self);
		if (self.didSelectEmojiBlock)
		{
			self.didSelectEmojiBlock(emoji);
		}
	}];
}

- (void)createInterface
{
	self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
	UIView *contentView = [[UIView alloc] init];
	contentView.layer.cornerRadius = 5.0;
	contentView.layer.masksToBounds = YES;
	[self.view addSubview:contentView];

	UIView *actionsContentView = [[UIView alloc] init];
	actionsContentView.backgroundColor = [UIColor whiteColor];
	[contentView addSubview:actionsContentView];

	UILabel *label1 = [[UILabel alloc] init];
	label1.text = kNZB_EMOJI_PICKER_TITLE;
	label1.font = [UIFont nzb_boldFontWithSize:15.0];
	label1.textAlignment = NSTextAlignmentCenter;
	[actionsContentView addSubview:label1];

	UILabel *label2 = [[UILabel alloc] init];
	label2.numberOfLines = 2;
	label2.text = kNZB_EMOJI_PICKER_DESCRIPTION;
	label2.textColor = [UIColor colorWithWhite:156/255. alpha:1.0];
	label2.textAlignment = NSTextAlignmentCenter;
	label2.font = [UIFont nzb_systemFontWithSize:15.0];
	[actionsContentView addSubview:label2];

	UIButton *sendButton = [self newButton];
	[sendButton setTitle:kNZB_EMOJI_PICKER_ANY_EMOJI_BUTTON_TITLE forState:UIControlStateNormal];
	[sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[sendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
	sendButton.backgroundColor = [UIColor nzb_yellowColor];
	[sendButton addTarget:self.viewModel action:@checkselector0(self.viewModel, selectRandomEmoji) forControlEvents:UIControlEventTouchUpInside];
	[actionsContentView addSubview:sendButton];

	_pageControl = [[UIPageControl alloc] init];
	_pageControl.pageIndicatorTintColor = [[UIColor nzb_lightGrayColor] colorWithAlphaComponent:0.3];
	_pageControl.currentPageIndicatorTintColor = [UIColor nzb_darkGreenColor];
	_pageControl.numberOfPages = self.viewModel.pagesCount;
	_pageControl.userInteractionEnabled = NO; // Disable taps so we dont need to process them.
	_pageControl.hidesForSinglePage = YES;
	[contentView addSubview:_pageControl];

	UIButton *closeButton = [self newButton];
	[closeButton setTitle:kNZB_BUTTON_CANCEL_TITLE forState:UIControlStateNormal];
	[closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[closeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
	closeButton.backgroundColor = [UIColor nzb_lightGrayColor];
	[closeButton addTarget:self action:@checkselector0(self, cancelTap) forControlEvents:UIControlEventTouchUpInside];
	[actionsContentView addSubview:closeButton];

	_pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
														  navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
																		options:nil];
	_pageViewController.dataSource = self;
	_pageViewController.delegate = self;
	[self dgs_showViewController:_pageViewController inView:contentView constraints:^(MASConstraintMaker *make) {
		make.left.equalTo(contentView);
		make.right.equalTo(contentView);
		make.top.equalTo(contentView);
		make.bottom.equalTo(actionsContentView.mas_top);
	}];

	[contentView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(25.0, 10.0, 25.0, 10.0));
	}];

	[actionsContentView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(contentView);
		make.right.equalTo(contentView);
		make.bottom.equalTo(contentView);
	}];

	[label1 mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(actionsContentView);
		make.right.equalTo(actionsContentView);
		make.top.equalTo(actionsContentView).with.offset(16.0);
	}];

	[label2 mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(actionsContentView);
		make.right.equalTo(actionsContentView);
		make.top.equalTo(label1.mas_bottom).with.offset(4.0);
	}];

	[closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(actionsContentView).with.offset(16.0);
		make.height.equalTo(@44.0);
		make.top.equalTo(label2.mas_bottom).with.offset(12.0);
		make.bottom.equalTo(actionsContentView).with.offset(-10.0);
	}];

	[sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(closeButton.mas_right).with.offset(8.0);
		make.height.equalTo(@44.0);
		make.right.equalTo(actionsContentView).with.offset(-16.0);
		make.centerY.equalTo(closeButton);
		make.width.equalTo(closeButton).with.multipliedBy(2.0);
	}];

	[_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(self.view);
		make.top.equalTo(_pageViewController.view.mas_bottom);
		make.height.equalTo(@20.0);
	}];
}

- (UIButton *)newButton
{
	UIButton *newButton = [[UIButton alloc] init];
	newButton.layer.cornerRadius = 5.0;
	newButton.layer.masksToBounds = YES;
	newButton.titleLabel.font = [UIFont nzb_boldFontWithSize:14];
	[newButton setContentEdgeInsets:UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0)];
	return newButton;
}

- (void)cancelTap
{
	if (self.didCloseBlock)
	{
		self.didCloseBlock();
	}
}

// MARK: UIPageViewControllerDataSource

- (NZBEmojiPageVC *)pageVCWithVM:(NZBEmojiPageVM *)pageVM
{
	NZBEmojiPageVC *pageVC = self.pageVCs[pageVM.key];
	if (pageVC == nil)
	{
		pageVC = [[NZBEmojiPageVC alloc] initWithVM:pageVM];
		self.pageVCs[pageVM.key] = pageVC;
	}
	return pageVC;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
	  viewControllerBeforeViewController:(NZBEmojiPageVC *)emojiPageVC
{
	return [self pageVCWithVM:[self.viewModel pageBeforePage:emojiPageVC.viewModel]];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
	   viewControllerAfterViewController:(NZBEmojiPageVC *)emojiPageVC
{
	return [self pageVCWithVM:[self.viewModel pageAfterPage:emojiPageVC.viewModel]];
}

// MARK: UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController
		didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers
	   transitionCompleted:(BOOL)completed
{
	NZBEmojiPageVC *nextPanelVC = [pageViewController.viewControllers firstObject];
	NSInteger currentPageIndex = [self.viewModel indexOfPage:nextPanelVC.viewModel];
	if (currentPageIndex != NSNotFound)
	{
		self.viewModel.currentPageIndex = currentPageIndex;
		self.pageControl.currentPage = currentPageIndex;
	}
}

@end
