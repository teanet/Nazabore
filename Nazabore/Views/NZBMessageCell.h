#import <UIKit/UIKit.h>
#import "NZBCellProtocol.h"
#import <NZBMessage.h>

@interface NZBMessageCell : UITableViewCell
<NZBCellProtocol, NZBUpdateProtocol>

@end
