#import "NZBEmojiPageVM.h"

@interface NZBEmojiPageVC : UICollectionViewController

@property (nonatomic, strong, readonly) NZBEmojiPageVM *viewModel;

- (instancetype)initWithVM:(NZBEmojiPageVM *)viewModel;

@end
