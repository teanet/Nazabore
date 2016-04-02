#import "NZBAnalytics.h"

#import <Crashlytics/Crashlytics.h>

NSString *const NZBAPostMessageEvent = @"PostMessage";
NSString *const NZBAOpenBoardEvent = @"OpenBoard";
NSString *const NZBARateMessage = @"RateMessage";

NSString *const NZBAStatus = @"Status";
NSString *const NZBASmile = @"Smile";
NSString *const NZBABoard = @"Board";
NSString *const NZBAInteraction = @"Interaction";

@implementation NZBAnalytics

+ (void)logEvent:(NSString * _Nonnull)event parameters:(NSDictionary *_Nullable)parameters
{
	[Answers logCustomEventWithName:event customAttributes:parameters];
}

@end
