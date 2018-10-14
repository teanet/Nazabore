@class NZBBoard, RDRGrowingTextView, Router, MarkerFetcher;

NS_ASSUME_NONNULL_BEGIN

@interface NZBWriteVC : UIViewController

@property (nonatomic, strong, readonly) RDRGrowingTextView *textView;
@property (nonatomic, strong, readonly) UIView *contentView;
@property (nonatomic, strong, readonly) UIView *keyboardView;
@property (nonatomic, strong) NZBBoard *board;
@property (nonatomic, strong, readonly) MarkerFetcher *markerFetcher;

- (instancetype)initWithRouter:(Router *)router markerFetcher:(MarkerFetcher *)markerFetcher NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;
- (void)refetchData;

@end

NS_ASSUME_NONNULL_END
