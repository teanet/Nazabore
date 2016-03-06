#import "NZBAnnotationView.h"

#import "MZBBoardAnnotation.h"

@implementation NZBAnnotationView

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
	if (self)
	{
		MZBBoardAnnotation *a = annotation;
		self.image = a.board.iconImage;
	}
	return self;
}

- (void)setAnnotation:(id<MKAnnotation>)annotation
{
	[super setAnnotation:annotation];
	MZBBoardAnnotation *a = annotation;
	self.image = a.board.iconImage;
}

@end
