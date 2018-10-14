#import <Foundation/Foundation.h>
#import <ReactiveCocoa.h>
#import "NZBMessage.h"
#import "NZBBoard.h"
#import <NZBUser.h>

@class NZBEmoji;
NS_ASSUME_NONNULL_BEGIN


@interface NZBDataProvider : NSObject

@property (nonatomic, strong, readonly) CLLocation *currentLocation;
@property (nonatomic, strong, readonly) RACSignal *nearestBoardsSignal;
@property (nonatomic, strong, readonly) NZBUser *user;
@property (nonatomic, assign, readonly) double visibleRadius;
@property (nonatomic, strong, readonly) RACSignal *currentLocationSignal;

+ (instancetype)sharedProvider;

- (RACSignal *)postMessage:(NSString *)message forBoard:(NZBBoard *)board emoji:(NZBEmoji *)emoji;
- (void)fetchNearestBoards;

@end

NS_ASSUME_NONNULL_END
