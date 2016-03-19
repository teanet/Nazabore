#import "NSString+NZBMessageCell.h"

@implementation NSString (NZBMessageCell)

- (instancetype)nzb_prettyPowerString
{
	NSInteger powerValue = [self integerValue];
	return powerValue > 0 ? [@"+" stringByAppendingString:self] : self;
}

@end
