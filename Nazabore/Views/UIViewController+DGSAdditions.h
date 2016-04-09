@interface UIViewController (DGSAdditions)

- (void)dgs_showViewController:(UIViewController *)viewController
						inView:(UIView *)view
				   constraints:(void(^)(MASConstraintMaker *make))block;
- (void)dgs_showViewController:(UIViewController *)viewController inView:(UIView *)view;
- (void)dgs_removeViewController:(UIViewController *)viewController;
- (void)dgs_removeViewControllerFromParentVC;
- (BOOL)dgs_isVisible;

@end
