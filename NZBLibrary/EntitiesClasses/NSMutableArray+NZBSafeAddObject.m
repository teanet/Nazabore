#import "NSMutableArray+NZBSafeAddObject.h"

@implementation NSMutableArray (NZBSafeAddObject)

- (void)nzb_safeAddObject:(id)anObject
{
	if (anObject != nil)
	{
		[self addObject:anObject];
	}
}

@end
