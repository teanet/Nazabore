#import "NZBZaborVM.h"

#import "NZBAdsCell.h"
#import "NZBMessageCell.h"
#import "NZBPoiCell.h"

@implementation NZBZaborVM

- (void)registerTableView:(UITableView *)tableView
{
	[tableView registerClass:[NZBMessageCell class] forCellReuseIdentifier:@"NZBMessageCell"];
	[tableView registerClass:[NZBAdsCell class] forCellReuseIdentifier:@"NZBAdsCell"];
	[tableView registerClass:[NZBPoiCell class] forCellReuseIdentifier:@"NZBPoiCell"];
	tableView.delegate = self;
	tableView.dataSource = self;
}

#pragma mark WCSessionDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NZBMessage *message = self.messages[indexPath.row];
	UITableViewCell <NZBCellProtocol> *cell = nil;
	switch (message.messageType) {
		case NZBMessageTypeDefault: {
			cell = [tableView dequeueReusableCellWithIdentifier:@"NZBMessageCell"];
		} break;
		case NZBMessageTypeAdvertisement: {
			cell = [tableView dequeueReusableCellWithIdentifier:@"NZBAdsCell"];
		} break;
		case NZBMessageTypeCommercial: {
			cell = [tableView dequeueReusableCellWithIdentifier:@"NZBAdsCell"];
		} break;
		case NZBMessageTypePoi: {
			cell = [tableView dequeueReusableCellWithIdentifier:@"NZBPoiCell"];
		} break;
	}
	cell.message = message;
	return cell;
}

@end
