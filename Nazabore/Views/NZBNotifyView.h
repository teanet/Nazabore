@interface NZBNotifyView : UIButton

+ (void)showInView:(UIView *)view text:(NSString *)text tapBlock:(dispatch_block_t)tapBlock;
+ (void)dismiss;

@end
