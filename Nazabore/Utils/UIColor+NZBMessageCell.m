#import "UIColor+NZBMessageCell.h"

#import "UIColor+System.h"

@implementation UIColor (NZBMessageCell)

+ (instancetype)nzb_powerColorForPowerString:(NSString *)powerString
{
	NSInteger powerValue = [powerString integerValue];
	UIColor *powerLabelColor = [UIColor nzb_lightGrayColor];

	if (powerValue < 0)
	{
		powerLabelColor = [UIColor nzb_redColor];
	}
	else if (powerValue > 0)
	{
		powerLabelColor = [UIColor nzb_darkGreenColor];
	}

	return powerLabelColor;
}

@end
