#import "NZBDataProvider.h"

#import "NZBMessage.h"
#import "NZBServerController.h"

static NSString *const kUserKey = @"user";

@interface NZBDataProvider ()
<
CLLocationManagerDelegate
>

@property (nonatomic, strong, readonly) RACSubject *nearestBoardsSubject;
@property (nonatomic, strong, readonly) CLLocationManager *clm;
@property (nonatomic, strong, readwrite) CLLocation *currentLocation;
@property (nonatomic, strong, readwrite) NZBUser *user;

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
	@weakify(self);

	_nearestBoardsSubject = [RACSubject subject];
	_nearestBoardsSignal = _nearestBoardsSubject;

	_user = [[NZBUser alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:kUserKey]];
	_clm = [[CLLocationManager alloc] init];
	_clm.delegate = self;
	[_clm requestWhenInUseAuthorization];
	[_clm startUpdatingLocation];
	_currentLocation = _clm.location;

	[[[NZBServerController sharedController] getCurrentUser] subscribeNext:^(NZBUser *user) {
		@strongify(self);
		self.user = user;
	}];

	return self;
}

- (RACSignal *)postMessage:(NSString *)message forBoard:(NZBBoard *)board emoji:(NZBEmoji *)emoji
{
	return [[NZBServerController sharedController] postMessageForLocation:self.currentLocation
																 withBody:message
																	board:board
																	emoji:emoji];
}

- (void)setUser:(NZBUser *)user
{
	_user = user;
	[[NSUserDefaults standardUserDefaults] setValue:user.dictionary forKey:kUserKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	NSLog(@"locationManager,didFailWithError>>%@", error);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
	CLLocation *location = locations.firstObject;
	CLLocationDistance distance =
		MKMetersBetweenMapPoints(MKMapPointForCoordinate(self.currentLocation.coordinate),
								 MKMapPointForCoordinate(location.coordinate));
	if (self.currentLocation == nil || distance > 200.0)
	{
		self.currentLocation = location;
		[self fetchNearestBoards];
	}
}

- (void)fetchNearestBoards
{
	@weakify(self);
	[[[NZBServerController sharedController] boardsForLocalion:self.currentLocation] subscribeNext:^(NSArray *boards) {
		@strongify(self);
		[self.nearestBoardsSubject sendNext:boards];
	}];
}

- (double)visibleRadius
{
	return self.user.visibleRadius;
}

@end
