#import <MapKit/MapKit.h>
#import "NZBBoard.h"

@interface MZBBoardAnnotation : NSObject
<
MKAnnotation
>

@property (nonatomic, strong, readonly) NZBBoard *board;

- (instancetype)initWithBoard:(NZBBoard *)board;

@end
