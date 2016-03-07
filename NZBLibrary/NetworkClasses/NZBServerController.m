#import "NZBServerController.h"

#import <AFNetworking/AFNetworking.h>

static NSString *const kNZBAPIBaseURLString			= @"https://api.nazabore.xyz";
//static NSString *const kNZBAPIBaseURLString			= @"http://10.54.7.212:3000";
static NSString *const kNZBAPIHeaderFieldUserIdKey	= @"userid";

@interface NZBServerController ()

@property (nonatomic, strong) AFHTTPRequestOperationManager *requestManager;

@end

@interface NSDictionary (remove_null)

- (NSDictionary *)withot_Null;

@end

@interface NSArray (remove_null)

- (NSDictionary *)withot_Null;

@end

@implementation NZBServerController

+ (instancetype)sharedController
{
	static NZBServerController *controller;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		controller = [[NZBServerController alloc] init];
	});

	return controller;
}

- (instancetype)init
{
	self = [super init];
	if (self == nil) return nil;

	_userID = @"1";
	_requestManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kNZBAPIBaseURLString]];
	_requestManager.requestSerializer = [AFJSONRequestSerializer serializer];
	_requestManager.responseSerializer = [AFJSONResponseSerializer serializer];
	return self;
}

- (RACSignal *)getObjectForURLString:(NSString *)urlString params:(NSDictionary *)params
{
	@weakify(self);

	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		@strongify(self);

		id successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
			NSLog(@"<NZBServerController> Request did successfully complete: %@", operation.request);

			responseObject = [responseObject withot_Null];

			[subscriber sendNext:responseObject];
			[subscriber sendCompleted];
		};

		id failBlock = ^(AFHTTPRequestOperation *operation, NSError *error) {
			NSLog(@"<NZBServerController> REQUEST ERROR: %@", error);
			[subscriber sendError:error];
		};

		AFHTTPRequestOperation *op = [self.requestManager GET:urlString parameters:params success:successBlock failure:failBlock];

		return [RACDisposable disposableWithBlock:^{
			[op cancel];
		}];
	}];
}

- (RACSignal *)postObjectForURLString:(NSString *)urlString params:(NSDictionary *)params
{
	@weakify(self);

	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		@strongify(self);

		id successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
			NSLog(@"<NZBServerController> Request did successfully complete: %@", operation.request);

			responseObject = [responseObject withot_Null];

			[subscriber sendNext:responseObject];
			[subscriber sendCompleted];
		};

		id failBlock = ^(AFHTTPRequestOperation *operation, NSError *error) {
			NSLog(@"<NZBServerController> REQUEST ERROR: %@", error);
			[subscriber sendError:error];
		};

		AFHTTPRequestOperation *op = [self.requestManager POST:urlString parameters:params success:successBlock failure:failBlock];
		return [RACDisposable disposableWithBlock:^{
			[op cancel];
		}];
	}];
}

// MARK: NZBAPIControllerProtocol

- (RACSignal *)fetchBoardsForLocalion:(CLLocation *)location
{
	if (!location) return nil;

	return [[self getObjectForURLString:@"boards" params:@{
												   @"lat": @(location.coordinate.latitude),
												   @"lon": @(location.coordinate.longitude),
												   @"userid": self.userID,
												   @"limit": @"100"
												   }]
			map:^id(NSArray *responseArray) {
				NSMutableArray<NZBBoard *> *boardsArray = nil;
				if ([responseArray isKindOfClass:[NSArray class]])
				{
					boardsArray = [NSMutableArray arrayWithCapacity:responseArray.count];

					for (NSDictionary *boardDictionary in responseArray)
					{
						NZBBoard *board = [[NZBBoard alloc] initWithDictionary:boardDictionary];
						if (board)
						{
							[boardsArray addObject:board];
						}
					}
				}

				return [boardsArray copy];
			}];
}

- (RACSignal *)fetchMessagesForBoard:(NZBBoard *)board
{
	if (!board.location) return nil;

	return [[self fetchBoardForLocalion:board.location boardID:board.id]
			map:^NSArray<NZBMessage *> *(NZBBoard *board) {
				return board.messages;
			}];
}

- (RACSignal *)fetchBoardForLocalion:(CLLocation *)location
{
	return [self fetchBoardForLocalion:location boardID:nil];
}

- (RACSignal *)fetchBoardForLocalion:(CLLocation *)location boardID:(NSString *)boardID
{
	if (!location) return nil;

	return [[self getObjectForURLString:@"board" params:@{
												   @"lat": @(location.coordinate.latitude),
												   @"lon": @(location.coordinate.longitude),
												   @"userid": self.userID,
												   @"id": boardID ?: @""
												   }]
		map:^id(NSDictionary *boardDictionary) {
			NZBBoard *board = nil;

			NSLog(@"fetchBoardForLocalion>>%@", boardDictionary);

			if ([boardDictionary isKindOfClass:[NSDictionary class]])
			{
				NSMutableDictionary *d = [boardDictionary[@"board"] mutableCopy];
				d[@"messages"] = boardDictionary[@"messages"];
				board = [[NZBBoard alloc] initWithDictionary:d];
			}

			return board;
		}];
}

- (RACSignal *)postMessageForLocation:(CLLocation *)location
							 withBody:(NSString *)body
								board:(NZBBoard *)board
								 icon:(NSString *)icon
{
	return [[self postObjectForURLString:@"message" params:@{@"body": body ?: @"",
															 @"lat": @(location.coordinate.latitude),
															 @"lon": @(location.coordinate.longitude),
															 @"userid": self.userID,
															 @"board": board.id ?: @"",
															 @"icon": icon ?: @"0"}]
			 map:^id(NSDictionary *messageDictionary) {
				 NZBMessage *message = nil;

				 if ([messageDictionary isKindOfClass:[NSDictionary class]])
				 {
					 message = [NZBMessage messageWithDictionary:messageDictionary[@"message"]];
				 }
				 message.boardD = messageDictionary[@"board"];
				 return message;
			 }];
}

- (RACSignal *)rateMessage:(NZBMessage *)message withInteraction:(NZBUserInteraction)interaction
{
	if (!message.id) return nil;

	return [[self postObjectForURLString:@"ratemessage" params:@{
														 @"message": message.id,
														 @"power": [@(interaction) description],
														 @"user": self.userID
														 }]
	 map:^id(NSDictionary *messageDictionary) {
		 NZBMessage *message = nil;

			if ([messageDictionary[@"message"] isKindOfClass:[NSDictionary class]])
			{
				message = [NZBMessage messageWithDictionary:messageDictionary[@"message"]];
			}
			return message;
	 }];
}

- (void)setPushToken:(NSData *)pushToken
{
	if (pushToken.length == 0) return;

	NSString *tokenString = [NSString stringWithUTF8String:pushToken.bytes];
	[[[self postObjectForURLString:@"addtoken" params:@{
													  @"token" : tokenString,
													  @"userid" : self.userID,
													  }] publish] connect];
}

@end

@implementation NSDictionary (remove_null)

- (NSDictionary *)withot_Null
{
	NSMutableDictionary *d = [self mutableCopy];
	[self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
		if ([obj isEqual:[NSNull null]]) {
			[d removeObjectForKey:key];
		}
		else if ([obj isKindOfClass:[NSDictionary class]]) {
			d[key] = [obj withot_Null];
		}
		else if ([obj isKindOfClass:[NSArray class]]) {
			d[key] = [obj withot_Null];
		}
	}];
	return d;
}

@end

@implementation NSArray (remove_null)

- (NSArray *)withot_Null
{
	NSMutableArray *a = [NSMutableArray array];
	[self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		if (![obj isEqual:[NSNull null]]) {
			[a addObject:[obj withot_Null]];
		}
	}];
	return a;
}

@end
