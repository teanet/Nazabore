NS_ASSUME_NONNULL_BEGIN

extern NSString *const NZBAPostMessageEvent;
extern NSString *const NZBAOpenBoardEvent;
extern NSString *const NZBARateMessage;
extern NSString *const NZBAUserDidChoiceLocationAuthorizationStatus;

extern NSString *const NZBAStatus;
extern NSString *const NZBASmile;
extern NSString *const NZBABoard;
extern NSString *const NZBAInteraction;

@interface NZBAnalytics : NSObject

+ (void)logEvent:(NSString * _Nonnull)event parameters:(NSDictionary *_Nullable)parameters;

@end
NS_ASSUME_NONNULL_END
