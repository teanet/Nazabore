#import "NZBServerController.h"

#import <AFNetworking/AFNetworking.h>
#import <UIDevice-Hardware.h>
#import <NZBEmoji.h>

static NSString *const kNZBAPIBaseURLString			= @"https://api.nazabore.xyz";
extern NSString *const kNZBAPIApplicationToken;

#define CURRENT_VERSION ([[NSBundle bundleForClass:self.class] objectForInfoDictionaryKey:@"CFBundleShortVersionString"])
#define CURRENT_BUILD ([[NSBundle bundleForClass:self.class] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey])

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

	NSCAssert(kNZBAPIApplicationToken.length > 0, @"You should add Application Token for correct work with Nazabore API.");

	_userID = @"1";
	_requestManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kNZBAPIBaseURLString]];
	_requestManager.requestSerializer = [AFJSONRequestSerializer serializer];
	_requestManager.requestSerializer.timeoutInterval = 10.0;
	NSDictionary *headers =
	@{
	  @"X-Current-App-Build" : CURRENT_BUILD,
	  @"X-Current-App-Version" : CURRENT_VERSION,
	  @"X-Mobile-Vendor" : @"Apple",
	  @"X-Mobile-Platform" : @"iOS",
	  @"X-Mobile-Os-Version" : [[UIDevice currentDevice] systemVersion],
	  @"X-Mobile-Model": [[UIDevice currentDevice] modelName],
	  @"X-Absolutely-Secret-Token": kNZBAPIApplicationToken,
	  };
	[headers enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
		[_requestManager.requestSerializer setValue:value forHTTPHeaderField:key];
	}];
	_requestManager.responseSerializer = [AFJSONResponseSerializer serializer];
	return self;
}

- (void)setUserID:(NSString *)userID
{
	NSCParameterAssert(userID);
	_userID = userID;
	[_requestManager.requestSerializer setValue:userID forHTTPHeaderField:@"X-User-Id"];
}

- (RACSignal *)GET:(NSString *)method params:(NSDictionary *)params
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

		AFHTTPRequestOperation *op = [self.requestManager GET:method parameters:params success:successBlock failure:failBlock];

		return [RACDisposable disposableWithBlock:^{
			[op cancel];
		}];
	}];
}

- (RACSignal *)POST:(NSString *)method params:(NSDictionary *)params
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

		AFHTTPRequestOperation *op = [self.requestManager POST:method parameters:params success:successBlock failure:failBlock];
		return [RACDisposable disposableWithBlock:^{
			[op cancel];
		}];
	}];
}

// MARK: NZBAPIControllerProtocol

- (RACSignal *)boardsForLocalion:(CLLocation *)location
{
	NSDictionary *params =
	@{
	  @"lat": @(location.coordinate.latitude),
	  @"lon": @(location.coordinate.longitude),
	  @"limit": @"100",
	  };

	return [[self GET:@"boards" params:params]
		map:^NSArray *(NSArray *responseArray) {
			if (![responseArray isKindOfClass:[NSArray class]]) return nil;

			return [responseArray.rac_sequence map:^NZBBoard *(NSDictionary *boardDictionary) {
				return [[NZBBoard alloc] initWithDictionary:boardDictionary];
			}].array;
		}];
}

- (RACSignal *)messagesForBoard:(NZBBoard *)board
{
	return [[self boardForLocalion:board.location boardID:board.id]
		map:^NSArray<NZBMessage *> *(NZBBoard *board) {
			return board.messages;
		}];
}

- (RACSignal *)boardForLocalion:(CLLocation *)location
{
	return [self boardForLocalion:location boardID:nil];
}

- (RACSignal *)boardForLocalion:(CLLocation *)location boardID:(NSString *)boardID
{
	NSDictionary *params =
	@{
	  @"lat": @(location.coordinate.latitude),
	  @"lon": @(location.coordinate.longitude),
	  @"id": boardID ?: @""
	  };
	return [[self GET:@"board" params:params]
		map:^NZBBoard *(NSDictionary *boardDictionary) {
			NZBBoard *board = nil;

			NSLog(@"boardForLocalion>>%@", boardDictionary);

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
								emoji:(NZBEmoji *)emoji
{
	NSCParameterAssert(emoji);
	NSDictionary *params =
	@{
	  @"body": body ?: @"",
	  @"lat": @(location.coordinate.latitude),
	  @"lon": @(location.coordinate.longitude),
	  @"board": board.id ?: @"",
	  @"icon": emoji.text ? emoji.text : @"0"
	  };
	return [[self POST:@"message" params:params]
		map:^NZBMessage *(NSDictionary *messageDictionary) {
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
	NSCParameterAssert(message.id);
	if (!message.id) return nil;
	NSDictionary *params =
	@{
	  @"message": message.id,
	  @"power": [@(interaction) description],
	  };
	return [[self POST:@"ratemessage" params:params]
		map:^NZBMessage *(NSDictionary *messageDictionary) {
			NZBMessage *message = nil;

			if ([messageDictionary[@"message"] isKindOfClass:[NSDictionary class]])
			{
				message = [NZBMessage messageWithDictionary:messageDictionary[@"message"]];
			}
			return message;
		}];
}

- (RACSignal *)getCurrentUser
{
	return [self getUser:self.userID];
}

- (RACSignal *)getUser:(NSString *)id
{
	NSDictionary *params = @{@"id": id ?: @""};
	return [[self GET:@"user" params:params]
		map:^NZBUser *(NSDictionary *response) {
			return [[NZBUser alloc] initWithDictionary:response[@"user"]];
		}];
}

- (void)setPushToken:(NSData *)pushToken
{
	if (pushToken.length == 0) return;

	NSString *tokenString = [NSString stringWithUTF8String:pushToken.bytes];
	[[[self POST:@"addtoken" params:@{
									  @"token" : tokenString,
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
