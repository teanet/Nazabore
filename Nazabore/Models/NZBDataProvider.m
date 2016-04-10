#import "NZBDataProvider.h"

#import "NZBMessage.h"
#import "NZBServerController.h"
#import "NZBLocationManager.h"

static NSString *const kUserKey = @"user";
static double const kDistanceToRefetchBoards = 100.0;

@interface NZBDataProvider ()
<
CLLocationManagerDelegate
>

@property (nonatomic, strong, readonly) RACSubject *nearestBoardsSubject;
@property (nonatomic, strong, readonly) NZBLocationManager *clm;
@property (nonatomic, strong, readwrite) CLLocation *currentLocation;
@property (nonatomic, strong, readwrite) CLLocation *lastFetchLocation;
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

	[[[NZBServerController sharedController] getCurrentUser] subscribeNext:^(NZBUser *user) {
		@strongify(self);
		self.user = user;
	}];
	_clm = [[NZBLocationManager alloc] init];
	_currentLocationSignal = [_clm.locationSignal ignore:nil];
	[[[[_currentLocationSignal
		doNext:^(CLLocation *location) {
			@strongify(self)

			self.currentLocation = location;
		}]
		throttle:0.5]
		filter:^BOOL(CLLocation *location) {
			CLLocationDistance distance =
				MKMetersBetweenMapPoints(MKMapPointForCoordinate(self.lastFetchLocation.coordinate),
										 MKMapPointForCoordinate(location.coordinate));
			return (self.lastFetchLocation == nil || distance > kDistanceToRefetchBoards);
		}]
		subscribeNext:^(id _) {
			@strongify(self);

			[self fetchNearestBoards];
		}];
	[_clm start];
	
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

- (void)fetchNearestBoards
{
	@weakify(self);
	CLLocation *fetchLocation = self.currentLocation;
	[[[NZBServerController sharedController] boardsForLocalion:fetchLocation] subscribeNext:^(NSArray *boards) {
		@strongify(self);

		self.lastFetchLocation = fetchLocation;
		[self.nearestBoardsSubject sendNext:boards];
	}];
}

- (double)visibleRadius
{
	return self.user.visibleRadius;
}

@end
