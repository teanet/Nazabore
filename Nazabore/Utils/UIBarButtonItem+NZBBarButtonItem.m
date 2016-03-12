#import "UIBarButtonItem+NZBBarButtonItem.h"

@implementation UIBarButtonItem (NZBBarButtonItem)

+ (instancetype)nzb_backBarButtonItem
{
	UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backButton"]
															   style:UIBarButtonItemStylePlain
															  target:nil
															  action:nil];
	return button;
}

@end
