typedef NS_ENUM(NSInteger, NZBEmojiType) {
	NZBEmojiImage = 0,
	NZBEmojiText,
};
extern NSInteger const kNZBDefaultEmojiCount;

@interface NZBEmoji : NSObject

@property (nonatomic, copy, readonly) NSString *text;
@property (nonatomic, assign, readonly) NZBEmojiType type;
@property (nonatomic, strong, readonly) UIImage *image;
@property (nonatomic, assign) BOOL random;

- (instancetype)initWithText:(NSString *)text NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

- (NSString *)textForAnalytics;

+ (UIImage *)imageForEmoji:(NZBEmoji *)emoji;

@end
