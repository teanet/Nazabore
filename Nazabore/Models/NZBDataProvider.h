#import <Foundation/Foundation.h>
#import <ReactiveCocoa.h>
#import "NZBMessage.h"
#import "NZBBoard.h"

@interface NZBDataProvider : NSObject

@property (nonatomic, strong, readonly) RACSignal *nearestBoardsSignal;
@property (nonatomic, strong, readonly) NSMutableArray<NZBMessage *> *rows;
@property (nonatomic, strong, readonly) CLLocation *currentLocation;

+ (instancetype)sharedProvider;
- (void)requestData;

- (RACSignal *)postMessage:(NSString *)message forBoard:(NZBBoard *)board icon:(NSString *)icon;
- (void)fetchNearestBoards;

@end
