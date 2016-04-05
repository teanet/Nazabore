#import <NZBEmoji.h>

typedef void(^NZBDidSelectEmojiBlock)(NZBEmoji *emoji);

@interface NZBEmojiSelectVC : UIViewController

@property (nonatomic, copy) NZBDidSelectEmojiBlock didSelectEmojiBlock;
@property (nonatomic, copy) dispatch_block_t didCloseBlock;

@end
