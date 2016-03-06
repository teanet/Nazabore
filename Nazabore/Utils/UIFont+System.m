#import "UIFont+System.h"

@implementation UIFont (System)

+ (UIFont *)nzb_boldFontWithSize:(CGFloat)size
{
	return [UIFont fontWithName:@"HelveticaNeue-Bold" size:size];
}
+ (UIFont *)nzb_systemFontWithSize:(CGFloat)size
{
	return [UIFont fontWithName:@"HelveticaNeue-Medium" size:size];
}

@end
