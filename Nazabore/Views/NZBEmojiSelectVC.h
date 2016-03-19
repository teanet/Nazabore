typedef void(^NZBDidSelectEmojiBlock)(NSString *emoji);

@interface NZBEmojiSelectVC : UIViewController

@property (nonatomic, copy) NZBDidSelectEmojiBlock didSelectEmojiBlock;
@property (nonatomic, copy) dispatch_block_t didCloseBlock;

@end
