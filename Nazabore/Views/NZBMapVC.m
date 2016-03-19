#import "NZBMapVC.h"

#import "NZBDataProvider.h"
#import "MZBBoardAnnotation.h"
#import "NZBAnnotationView.h"

@interface NZBMapVC ()
<
MKMapViewDelegate,
UIGestureRecognizerDelegate
>

@property (nonatomic, strong, readonly) MKMapView *mapView;
@property (nonatomic, strong) NSArray *annotations;

@end

@implementation NZBMapVC

- (void)dealloc
{
	[self.mapView removeFromSuperview];
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

	[self.mapView.userLocation addObserver:self
								forKeyPath:@"location"
								   options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld)
								   context:nil];

	UIButton *centerButton = [[UIButton alloc] init];
	[centerButton setImage:[UIImage imageNamed:@"map_center_icon"] forState:UIControlStateNormal];
	[centerButton addTarget:self action:@selector(centerTap) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:centerButton];
	[centerButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(self.view).with.offset(-10.0);
		make.width.equalTo(@44.0);
		make.height.equalTo(@44.0);
		make.bottom.greaterThanOrEqualTo(self.keyboardView.mas_top).with.offset(-40.0).with.priorityHigh();
	}];

	[[NZBDataProvider sharedProvider].nearestBoardsSignal subscribeNext:^(NSArray *boards) {
		@strongify(self);

		[self.mapView removeAnnotations:self.annotations];
		self.annotations = [[[boards rac_sequence]
			map:^id(id value) {
				return [[MZBBoardAnnotation alloc] initWithBoard:value];
			}] array];

		[self.mapView addAnnotations:self.annotations];
	}];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];

	UIPanGestureRecognizer* panRec = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didDragMap:)];
	[panRec setDelegate:self];
	[self.mapView addGestureRecognizer:panRec];

	// [[ Configure UINavigationBar
	[[UINavigationBar appearance] setBarTintColor:[UIColor nzb_brightGrayColor]];
	[[UINavigationBar appearance] setTintColor:[UIColor nzb_santasGrayColor]];
	[[UINavigationBar appearance] setTranslucent:YES];
	[[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
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
	[self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if (self.mapView.userLocation == nil) return;

	MKCoordinateRegion region;
	region.center = self.mapView.userLocation.coordinate;

	MKCoordinateSpan span;
	span.latitudeDelta  = 0.01;
	span.longitudeDelta = 0.01;
	region.span = span;

	[self.mapView setRegion:region animated:YES];
	[self.mapView.userLocation removeObserver:self forKeyPath:@"location"];
}

- (void)didDragMap:(UIGestureRecognizer*)gestureRecognizer
{
	if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
	{
		[self.textView resignFirstResponder];
	}
}

#pragma mark MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(nonnull MKAnnotationView *)view
{
	[mapView deselectAnnotation:view.annotation animated:YES];
	if ([view.annotation isKindOfClass:[MZBBoardAnnotation class]])
	{
		MZBBoardAnnotation *annotation = view.annotation;
		[self showBoard:annotation.board];
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
