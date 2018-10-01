#import "NZBAnnotationView.h"

#import "MZBBoardAnnotation.h"
#import "Nazabore-Swift.h"

@implementation NZBAnnotationView

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
	if (self)
	{
//		BoardAnnotation *a = annotation;
//		self.image = a.mar;
	}
	return self;
}

- (void)setAnnotation:(id<MKAnnotation>)annotation
{
	[super setAnnotation:annotation];
//	MZBBoardAnnotation *a = annotation;
	self.image = [UIImage imageNamed:@"1"];
}

@end
