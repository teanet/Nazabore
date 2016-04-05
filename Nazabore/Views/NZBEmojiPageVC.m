#import "NZBEmojiPageVC.h"

@implementation NZBEmojiPageVC

- (instancetype)initWithVM:(NZBEmojiPageVM *)viewModel
{
	NSCParameterAssert(viewModel);
	NSCParameterAssert(viewModel.viewLayout);
	self = [super initWithCollectionViewLayout:viewModel.viewLayout];
	if (self == nil) return nil;
	_viewModel = viewModel;
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.collectionView.backgroundColor = [UIColor colorWithWhite:247/255.0 alpha:1.0];
	[self.viewModel registerCollectionView:self.collectionView];
}

@end
