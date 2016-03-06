#import "NZBUserVC.h"

@implementation NZBUserVC

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
	
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backTap)];
}

- (void)backTap
{
	[self.delegate userVCDidFinish:self];
}

@end
