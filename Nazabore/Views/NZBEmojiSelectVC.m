#import "NZBEmojiSelectVC.h"

#import "NZBEmojiCell.h"

const NSInteger kEmojiCount = 20;

@interface NZBEmojiSelectVC ()
<
UICollectionViewDataSource,
UICollectionViewDelegate
>

@end

@implementation NZBEmojiSelectVC

- (instancetype)init
{
	self = [super init];
	if (self == nil) return nil;

	self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	self.modalPresentationStyle = UIModalPresentationOverFullScreen;

	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	UIView *contentView = [[UIView alloc] init];
	contentView.layer.cornerRadius = 5.0;
	contentView.layer.masksToBounds = YES;
	contentView.backgroundColor = [UIColor colorWithWhite:247/255. alpha:1.0];
	[self.view addSubview:contentView];

	UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];

	flowLayout.itemSize = CGSizeMake(40, 40);
	flowLayout.minimumInteritemSpacing = 35.0;
	flowLayout.minimumLineSpacing = 35.0;
	flowLayout.sectionInset = UIEdgeInsetsMake(28.0, 17.0, 8.0, 17.0);

	UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
	collectionView.delegate = self;
	collectionView.dataSource = self;
	collectionView.backgroundColor = [UIColor colorWithWhite:247/255. alpha:1.0];
	[collectionView registerClass:[NZBEmojiCell class] forCellWithReuseIdentifier:@"NZBEmojiCell"];
	[contentView addSubview:collectionView];

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
	[sendButton addTarget:self action:@checkselector0(self, sendTap) forControlEvents:UIControlEventTouchUpInside];
	[actionsContentView addSubview:sendButton];

	UIButton *closeButton = [self newButton];
	[closeButton setTitle:kNZB_BUTTON_CANCEL_TITLE forState:UIControlStateNormal];
	[closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[closeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
	closeButton.backgroundColor = [UIColor nzb_lightGrayColor];
	[closeButton addTarget:self action:@checkselector0(self, cancelTap) forControlEvents:UIControlEventTouchUpInside];
	[actionsContentView addSubview:closeButton];

	[contentView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(25.0, 10.0, 25.0, 10.0));
	}];

	[collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(contentView);
		make.right.equalTo(contentView);
		make.top.equalTo(contentView);
		make.bottom.equalTo(actionsContentView.mas_top);
	}];

	[actionsContentView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(contentView);
		make.right.equalTo(contentView);
		make.bottom.equalTo(contentView);
	}];

	[label1 mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(actionsContentView);
		make.right.equalTo(actionsContentView);
		make.top.equalTo(actionsContentView).with.offset(8.0);
	}];

	[label2 mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(actionsContentView);
		make.right.equalTo(actionsContentView);
		make.top.equalTo(label1.mas_bottom).with.offset(8.0);
	}];

	[closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(actionsContentView).with.offset(16.0);
		make.height.equalTo(@44.0);
		make.top.equalTo(label2.mas_bottom).with.offset(8.0);
		make.bottom.equalTo(actionsContentView).with.offset(-10.0);
	}];

	[sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(closeButton.mas_right).with.offset(8.0);
		make.height.equalTo(@44.0);
		make.right.equalTo(actionsContentView).with.offset(-16.0);
		make.centerY.equalTo(closeButton);
		make.width.equalTo(closeButton).with.multipliedBy(2.0);
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

- (void)sendTap
{
	[self selectEmoji:[@(arc4random()%kEmojiCount) description] random:YES];
}

- (void)cancelTap
{
	if (self.didCloseBlock)
	{
		self.didCloseBlock();
	}
}

- (void)selectEmoji:(NSString *)emoji random:(BOOL)random
{
	if (self.didSelectEmojiBlock)
	{
		self.didSelectEmojiBlock(emoji, random);
	}
}

#pragma mark coll

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return kEmojiCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	NZBEmojiCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NZBEmojiCell" forIndexPath:indexPath];
	cell.imageView.image = [UIImage imageNamed:[@(indexPath.row) description]];
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	[collectionView deselectItemAtIndexPath:indexPath animated:YES];
	[self selectEmoji:[@(indexPath.row) description] random:NO];
}

@end
