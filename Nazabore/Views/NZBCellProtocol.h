#import <YMSwipeTableViewCell/UITableViewCell+Swipe.h>

@class NZBMessage;

@protocol NZBCellProtocol <NSObject>

@property (nonatomic, strong) NZBMessage *message;

@end
