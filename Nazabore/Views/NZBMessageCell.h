#import <UIKit/UIKit.h>
#import "NZBMessage.h"
#import "NZBCellProtocol.h"

@interface NZBMessageCell : UITableViewCell
<NZBCellProtocol, NZBUpdateProtocol>

@end
