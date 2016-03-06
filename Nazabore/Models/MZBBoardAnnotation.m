#import "MZBBoardAnnotation.h"

@implementation MZBBoardAnnotation

- (instancetype)initWithBoard:(NZBBoard *)board
{
	self = [super init];
	if (self == nil) return nil;

	_board = board;

	return self;
}

- (CLLocationCoordinate2D)coordinate
{
	return self.board.location.coordinate;
}

- (NSString *)title
{
	return self.board.id;
}

@end
