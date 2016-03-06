#import <Foundation/Foundation.h>
#import <ReactiveCocoa.h>
#import "NZBMessage.h"
#import "NZBBoard.h"

@interface NZBDataProvider : NSObject

@property (nonatomic, strong, readonly) RACSignal *nearestBoardsSignal;
@property (nonatomic, strong, readonly) NSMutableArray<NZBMessage *> *rows;

+ (instancetype)sharedProvider;
- (void)requestData;
- (void)fetchNearestBoard;

- (RACSignal *)postMessage:(NSString *)message forBoard:(NZBBoard *)board icon:(NSString *)icon;
- (void)fetchNearestBoards;

@end
