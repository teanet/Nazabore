#import <NZBEmojiCategory.h>

@interface NZBEmojiPageVM : NSObject
<
UICollectionViewDataSource,
UICollectionViewDelegate
>

@property (nonatomic, strong, readonly) UICollectionViewLayout *viewLayout;
@property (nonatomic, strong, readonly) NZBEmojiCategory *category;
@property (nonatomic, strong, readonly) RACSignal *didSelectEmojiSignal;
@property (nonatomic, copy, readonly) NSString *key;

+ (instancetype)defaultVM;
- (instancetype)initWithCategory:(NZBEmojiCategory *)category NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;
- (void)registerCollectionView:(UICollectionView *)collectionView;
- (void)selectRandomEmoji;

@end
