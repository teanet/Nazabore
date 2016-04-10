#import <Foundation/Foundation.h>
#import <ReactiveCocoa.h>
#import "NZBMessage.h"
#import "NZBBoard.h"
#import <NZBUser.h>

@class NZBEmoji;

@interface NZBDataProvider : NSObject

@property (nonatomic, strong, readonly) RACSignal *nearestBoardsSignal;
@property (nonatomic, strong, readonly) CLLocation *currentLocation;
@property (nonatomic, strong, readonly) NZBUser *user;
@property (nonatomic, assign, readonly) double visibleRadius;

+ (instancetype)sharedProvider;

- (RACSignal *)postMessage:(NSString *)message forBoard:(NZBBoard *)board emoji:(NZBEmoji *)emoji;
- (void)fetchNearestBoards;

@end
