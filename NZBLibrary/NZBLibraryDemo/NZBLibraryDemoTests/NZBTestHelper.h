#import <ReactiveCocoa/ReactiveCocoa.h>

#define KWMockClass(__CLASS_) ([KWMock mockForClass:[__CLASS_ class]])
#define KWNullMockClass(__CLASS_) ([KWMock nullMockForClass:[__CLASS_ class]])

#define KWMockProtocol(__CLASS_) ([KWMock mockForProtocol:@protocol(__CLASS_)])
#define KWNullMockProtocol(__CLASS_) ([KWMock nullMockForProtocol:@protocol(__CLASS_)])

@interface RACSignal (DGSTestHelper)

- (id)dgs_lastObjectAfterAction:(dispatch_block_t)block;
- (BOOL)dgs_performedAfterAction:(dispatch_block_t)block;

@end
