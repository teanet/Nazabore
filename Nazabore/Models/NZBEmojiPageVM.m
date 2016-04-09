#import "NZBEmojiPageVM.h"

#import "NZBEmojiCell.h"

@interface NZBEmojiPageVM ()

@property (nonatomic, strong, readwrite) UICollectionViewFlowLayout *viewLayout;
@property (nonatomic, strong, readonly) RACSubject *didSelectEmojiSubject;

@end

@implementation NZBEmojiPageVM

- (instancetype)initWithCategory:(NZBEmojiCategory *)category
{
	self = [super init];
	if (self == nil) return nil;

	_didSelectEmojiSubject = [RACSubject subject];
	_didSelectEmojiSignal = _didSelectEmojiSubject;
	_key = [NSUUID UUID].UUIDString;
	_category = category;
	_viewLayout = [[UICollectionViewFlowLayout alloc] init];
	_viewLayout.itemSize = CGSizeMake(44.0, 44.0);
	_viewLayout.minimumInteritemSpacing = 8.0;
	_viewLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
	_viewLayout.minimumLineSpacing = 8.0;
	_viewLayout.sectionInset = UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0);

	return self;
}

+ (instancetype)defaultVM
{
	NZBEmojiPageVM *emojiPageVM = [[NZBEmojiPageVM alloc] initWithCategory:[NZBEmojiCategory defaultCategory]];
	UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
	flowLayout.itemSize = CGSizeMake(44.0, 44.0);
	flowLayout.minimumInteritemSpacing = 8.0;
	flowLayout.minimumLineSpacing = 8.0;
	flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
	flowLayout.sectionInset = UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0);
	emojiPageVM.viewLayout = flowLayout;
	return emojiPageVM;
}

- (void)registerCollectionView:(UICollectionView *)collectionView
{
	collectionView.delegate = self;
	collectionView.dataSource = self;
	[collectionView registerClass:[NZBEmojiCell class] forCellWithReuseIdentifier:@"NZBEmojiCell"];
}

- (void)selectRandomEmoji
{
	NSArray<NZBEmoji *> *emoji = self.category.emoji;
	[self selectEmoji:emoji[arc4random()%emoji.count] random:YES];
}

- (void)selectEmoji:(NZBEmoji *)emoji random:(BOOL)random
{
	emoji.random = random;
	[self.didSelectEmojiSubject sendNext:emoji];
}

#pragma mark coll

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return self.category.emoji.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	NZBEmojiCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NZBEmojiCell" forIndexPath:indexPath];
	cell.emoji = self.category.emoji[indexPath.item];
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	[collectionView deselectItemAtIndexPath:indexPath animated:YES];
	[self selectEmoji:self.category.emoji[indexPath.item] random:NO];
}

@end
