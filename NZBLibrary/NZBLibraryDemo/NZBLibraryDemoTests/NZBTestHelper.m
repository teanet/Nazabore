#import "NZBTestHelper.h"

@implementation RACSignal (DGSTestHelper)

- (id)dgs_lastObjectAfterAction:(dispatch_block_t)block
{
	__block id _x;
	[self subscribeNext:^(id x) {
		_x = x;
	}];
	if (block)
	{
		block();
	}
	return _x;
}

- (BOOL)dgs_performedAfterAction:(dispatch_block_t)block
{
	__block BOOL wasPerformed = NO;
	[self subscribeNext:^(id _) {
		wasPerformed = YES;
	}];
	if (block)
	{
		wasPerformed = NO;
		block();
	}
	return wasPerformed;
}

@end
