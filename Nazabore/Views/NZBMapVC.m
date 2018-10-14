#import "NZBMapVC.h"

#import "NZBDataProvider.h"
#import "MZBBoardAnnotation.h"
#import "NZBAnnotationView.h"
#import "NZBNotifyView.h"
#import "RDRGrowingTextView.h"

#import "Nazabore-Swift.h"

@import ReactiveCocoa;

@interface NZBMapVC ()
<
MKMapViewDelegate,
UIGestureRecognizerDelegate
>

@property (nonatomic, strong, readonly) MKMapView *mapView;
@property (nonatomic, strong) NSArray *annotations;
@property (nonatomic, strong) MKCircle *userCircle;

@end

@implementation NZBMapVC

- (void)dealloc
{
	self.mapView.delegate = nil;
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	@weakify(self);

	_mapView = [[MKMapView alloc] init];
	_mapView.delegate = self;
	_mapView.showsUserLocation = YES;
	[self.view addSubview:_mapView];
	[_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.view);
	}];

	UIButton *centerButton = [[UIButton alloc] init];
	[centerButton setImage:[UIImage imageNamed:@"locationButton-normal"] forState:UIControlStateNormal];
	[centerButton setImage:[UIImage imageNamed:@"locationButton-highlighted"] forState:UIControlStateHighlighted];
	[centerButton addTarget:self action:@selector(centerTap) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:centerButton];

	[centerButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(self.view).with.offset(-16.0);
		make.width.equalTo(@48.0);
		make.height.equalTo(@48.0);
		make.bottom.greaterThanOrEqualTo(self.keyboardView.mas_top).with.offset(-16.0).with.priorityHigh();
	}];

	[[NZBDataProvider sharedProvider].nearestBoardsSignal subscribeNext:^(NSArray *boards) {
		@strongify(self);

//		(boards.count == 0) ? [self showNoMessagesNotification] : [NZBNotifyView dismiss];


	}];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];

	UIPanGestureRecognizer* panRec = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didDragMap:)];
	[panRec setDelegate:self];
	[self.mapView addGestureRecognizer:panRec];

	RACSignal *locationSignal = [[[NZBDataProvider sharedProvider].currentLocationSignal
		takeUntil:self.rac_willDeallocSignal]
		deliverOnMainThread];

	[locationSignal subscribeNext:^(CLLocation *location) {
		@strongify(self);

		[self.markerFetcher getWithC:location cmp:^(NSArray<BoardAnnotation *> * annotations) {

			[self.mapView removeAnnotations:self.annotations];
			self.annotations = annotations;
			[self.mapView addAnnotations:self.annotations];
		}];

		[self.mapView removeOverlay:self.userCircle];
		self.userCircle = [MKCircle circleWithCenterCoordinate:location.coordinate
														radius:[NZBDataProvider sharedProvider].visibleRadius];
		[self.mapView addOverlay:self.userCircle];
	}];

	// [[ Бросаем пользователя на карту
	[[locationSignal
		take:1]
		subscribeNext:^(CLLocation *startLocation) {
			@strongify(self);

			MKCoordinateRegion region;
			region.center = startLocation.coordinate;
			region.span.latitudeDelta  = 0.01;
			region.span.longitudeDelta = 0.01;

			[self.mapView setRegion:region animated:YES];
		}];
	// ]]
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	[self refetchData];
	[self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)didBecomeActive
{
	[self refetchData];
}

- (void)centerTap
{
	[self refetchData];
	[self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
}

- (void)didDragMap:(UIGestureRecognizer*)gestureRecognizer
{
	if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
	{
		[self.textView resignFirstResponder];
	}
}

- (void)showNoMessagesNotification
{
	@weakify(self);
	[NZBNotifyView showInView:self.view text:kNZB_MAP_NO_BOARDS_MESSAGE tapBlock:^{
		@strongify(self);

		[self becomeFirstResponder];
	}];
}

#pragma mark MKMapViewDelegate

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
	MKCircleRenderer *c = [[MKCircleRenderer alloc] initWithCircle:overlay];
	c.fillColor = [[UIColor nzb_darkGreenColor] colorWithAlphaComponent:0.05];
	c.strokeColor = [[UIColor nzb_darkGreenColor] colorWithAlphaComponent:0.5];
	c.lineWidth = 1.0 / [UIScreen mainScreen].scale;
	return c;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(nonnull MKAnnotationView *)view
{
	[mapView deselectAnnotation:view.annotation animated:YES];
	if ([view.annotation isKindOfClass:[BoardAnnotation class]])
	{
		BoardAnnotation *annotation = view.annotation;
		[annotation select];
	}
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
	NSString *identifier = @"pin";
	MKAnnotationView *view = nil;
	MKAnnotationView *dequeuedView = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];

	if ([annotation isKindOfClass:[MKUserLocation class]])
	{
		[(MKUserLocation *)annotation setTitle:nil];
		[(MKUserLocation *)annotation setSubtitle:nil];
		return nil;
	}

	if ([dequeuedView isKindOfClass:[NZBAnnotationView class]])
	{
		dequeuedView.annotation = annotation;
		view = dequeuedView;
	}
	else
	{
		view = [[NZBAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
	}
	view.annotation = annotation;
	
	return view;
}

#pragma mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
	return YES;
}

@end
