#import "NZBEmojiSelectView.h"

#import "NZBEmojiCell.h"

const NSInteger kEmojiCount = 20;

@interface NZBEmojiSelectView ()
<
UICollectionViewDataSource,
UICollectionViewDelegate
>

@end

@implementation NZBEmojiSelectView

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
	label1.text = @"Выберите приколюшку";
	label1.font = [UIFont nzb_boldFontWithSize:15.0];
	label1.textAlignment = NSTextAlignmentCenter;
	[actionsContentView addSubview:label1];

	UILabel *label2 = [[UILabel alloc] init];
	label2.numberOfLines = 2;
	label2.text = @"Она отобразится на карте\nи около надписи когда-нибудь";
	label2.textColor = [UIColor colorWithWhite:156/255. alpha:1.0];
	label2.textAlignment = NSTextAlignmentCenter;
	label2.font = [UIFont nzb_systemFontWithSize:15.0];
	[actionsContentView addSubview:label2];

	UIButton *button = [[UIButton alloc] init];
	button.layer.cornerRadius = 5.0;
	button.layer.masksToBounds = YES;
	button.backgroundColor = [UIColor greenColor];
	[button setTitle:@"Давай любую" forState:UIControlStateNormal];
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	button.titleLabel.font = [UIFont nzb_boldFontWithSize:14];
	[button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
	button.backgroundColor = [UIColor colorWithRed:1 green:210/255. blue:70/255. alpha:1.0];
	[button addTarget:self action:@selector(buttonTap) forControlEvents:UIControlEventTouchUpInside];
	[button setContentEdgeInsets:UIEdgeInsetsMake(5.0, 20.0, 5.0, 20.0)];
	[actionsContentView addSubview:button];

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

	[button mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(actionsContentView);
		make.height.equalTo(@44);
		make.width.equalTo(@250);
		make.top.equalTo(label2.mas_bottom).with.offset(8.0);
		make.bottom.equalTo(actionsContentView).with.offset(-10.0);
	}];
}

- (void)buttonTap
{
	[self selectEmoji:[@(arc4random()%kEmojiCount) description]];
}

- (void)selectEmoji:(NSString *)emoji
{
	if (self.block)
	{
		self.block(emoji);
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
	[self selectEmoji:[@(indexPath.row) description]];
}

@end
