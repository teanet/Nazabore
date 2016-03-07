#import "NSMutableDictionary+NZBSafeSetObject.h"

@implementation NSMutableDictionary (NZBSafeSetObject)

- (void)nzb_safeSetObject:(id)anObject forKey:(id<NSCopying>)aKey
{
	if (anObject != nil && aKey != nil)
	{
		[self setObject:anObject forKey:aKey];
	}
}

@end
