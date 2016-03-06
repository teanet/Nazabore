#import "RDRGrowingTextView.h"
#import "NZBBoard.h"

@interface NZBWriteVC : UIViewController

@property (nonatomic, strong, readonly) RDRGrowingTextView *textView;
@property (nonatomic, strong, readonly) UIView *contentView;
@property (nonatomic, strong, readonly) UIView *keyboardView;
@property (nonatomic, strong) NZBBoard *board;

- (void)refetchData;
- (void)showBoard:(NZBBoard *)b;

@end
