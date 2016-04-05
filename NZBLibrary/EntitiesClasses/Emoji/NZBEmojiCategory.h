#import <NZBEmoji.h>

@interface NZBEmojiCategory : NSObject

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSArray<NZBEmoji *> *emoji;

+ (instancetype)defaultCategory;
- (instancetype)initWithTitle:(NSString *)title text:(NSString *)text NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

@end
