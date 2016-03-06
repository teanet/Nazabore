#import "NZBDataProvider.h"

#import "NZBMessage.h"
#import "NZBServerController.h"

@interface NZBDataProvider ()
<
CLLocationManagerDelegate
>

@property (nonatomic, strong, readonly) RACSubject *nearestBoardsSubject;
@property (nonatomic, strong, readonly) CLLocationManager *clm;
@property (nonatomic, strong) CLLocation *currentLocation;

@end

@implementation NZBDataProvider

+ (instancetype)sharedProvider {
	static id manager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		manager = [[[self class] alloc] init];
	});
	return manager;
}

- (instancetype)init
{
	self = [super init];
	if (self == nil) return nil;

	_nearestBoardsSubject = [RACSubject subject];
	_nearestBoardsSignal = _nearestBoardsSubject;
	_rows = [NSMutableArray array];

	_clm = [[CLLocationManager alloc] init];
	_clm.delegate = self;
	[_clm requestWhenInUseAuthorization];
	[_clm startUpdatingLocation];
	_currentLocation = _clm.location;
#warning 123

//	_currentLocation = [[CLLocation alloc] initWithLatitude:54.9899035 longitude:82.89718689999999];
	return self;
}

- (RACSignal *)postMessage:(NSString *)message forBoard:(NZBBoard *)board icon:(NSString *)icon
{
	return [[NZBServerController sharedController] postMessageForLocation:self.currentLocation
																 withBody:message
																	board:board
																	 icon:icon];
}

#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	NSLog(@"locationManager,didFailWithError>>%@", error);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
	self.currentLocation = locations.firstObject;
}

- (void)fetchNearestBoard
{
	[[[NZBServerController sharedController] fetchBoardForLocalion:self.currentLocation] subscribeNext:^(NZBBoard *board) {
//		[[NZBWatchConnection sharedConnection] updateCurrentBoard:board];
	}];
}

- (void)fetchNearestBoards
{
	@weakify(self);
	[[[NZBServerController sharedController] fetchBoardsForLocalion:self.currentLocation] subscribeNext:^(NSArray *boards) {
		@strongify(self);

		[self.nearestBoardsSubject sendNext:boards];
	}];
}

- (void)requestData
{
//	[[[NZBServerController sharedController] fetchBoardForLocalion:self.currentLocation] subscribeNext:^(id x) {
//
//	}];
//
//	[[[NZBServerController sharedController] fetchBoardsForLocalion:self.currentLocation] subscribeNext:^(NSArray *boards) {
//
//	}];
	//	_rows =
	//	@[
	//	  @{@"name":@"ремикс", @"id": @"r1.141265769433243"},
	//	  @{@"name":@"x-fit", @"id": @"r1.141265770847007"},
	//	  @{@"name":@"Мята?", @"id": @"r1.70000001006357294"},
	//	  ];
}

@end
