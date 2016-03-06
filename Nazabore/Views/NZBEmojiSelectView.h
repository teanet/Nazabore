typedef void(^NZBDidSelectEmojiBlock)(NSString *emoji);

@interface NZBEmojiSelectView : UIViewController

@property (nonatomic, copy) NZBDidSelectEmojiBlock block;

@end
