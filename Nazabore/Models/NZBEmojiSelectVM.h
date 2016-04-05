#import "NZBEmojiPageVM.h"

@interface NZBEmojiSelectVM : NSObject

@property (nonatomic, strong, readonly) RACSignal *didSelectEmojiSignal;
@property (nonatomic, assign) NSInteger currentPageIndex;
@property (nonatomic, assign, readonly) NSInteger pagesCount;
@property (nonatomic, strong, readonly) NZBEmojiPageVM *currentPageVM;

- (void)selectRandomEmoji;

- (NZBEmojiPageVM *)pageAfterPage:(NZBEmojiPageVM *)pageVM;
- (NZBEmojiPageVM *)pageBeforePage:(NZBEmojiPageVM *)pageVM;
- (NSUInteger)indexOfPage:(NZBEmojiPageVM *)pageVM;

@end
