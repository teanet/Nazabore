#import <UIKit/UIKit.h>

@protocol NZBUserVCDelegate;

@interface NZBUserVC : UIViewController

@property (nonatomic, weak) id<NZBUserVCDelegate> delegate;

@end

@protocol NZBUserVCDelegate <NSObject>

- (void)userVCDidFinish:(NZBUserVC *)userVC;

@end
