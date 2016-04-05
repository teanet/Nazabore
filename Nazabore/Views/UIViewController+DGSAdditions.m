#import "UIViewController+DGSAdditions.h"

@implementation UIViewController (DGSAdditions)

- (void)dgs_showViewController:(UIViewController *)viewController
						inView:(UIView *)view
				   constraints:(void(^)(MASConstraintMaker *make))block
{
	[self addChildViewController:viewController];
	viewController.view.frame = view.bounds;
	[view addSubview:viewController.view];
	[viewController.view mas_remakeConstraints:block];
	[viewController.view layoutIfNeeded];
	[viewController didMoveToParentViewController:self];
}

- (void)dgs_showViewController:(UIViewController *)viewController inView:(UIView *)view
{
	[self dgs_showViewController:viewController inView:view constraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(view);
	}];
}

- (void)dgs_removeViewController:(UIViewController *)viewController
{
	[viewController dgs_removeViewControllerFromParentVC];
}

- (void)dgs_removeViewControllerFromParentVC
{
	[self willMoveToParentViewController:nil];
	if (self.isViewLoaded)
	{
		[self.view removeFromSuperview];
	}
	[self removeFromParentViewController];
}

- (BOOL)dgs_isVisible
{
	return [self isViewLoaded] && self.view.window;
}

@end
