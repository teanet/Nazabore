#import <Foundation/Foundation.h>
#import <ReactiveCocoa.h>
#import "NZBMessage.h"
#import "NZBBoard.h"

@class NZBEmoji;

@interface NZBDataProvider : NSObject

@property (nonatomic, strong, readonly) RACSignal *nearestBoardsSignal;
@property (nonatomic, strong, readonly) NSMutableArray<NZBMessage *> *rows;
@property (nonatomic, strong, readonly) CLLocation *currentLocation;

+ (instancetype)sharedProvider;

- (RACSignal *)postMessage:(NSString *)message forBoard:(NZBBoard *)board emoji:(NZBEmoji *)emoji;
- (void)fetchNearestBoards;

@end
