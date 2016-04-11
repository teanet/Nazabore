@class NZBMessage;

@interface NZBZaborVM : NSObject
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, strong) NSArray<NZBMessage *> *messages;

- (void)registerTableView:(UITableView *)tableView;

@end
