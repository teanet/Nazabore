#import <ReactiveCocoa/ReactiveCocoa.h>

#import "NZBBoard.h"
#import "NZBMessage.h"
#import "NZBUser.h"
@class NZBEmoji;

@protocol NZBAPIControllerProtocol <NSObject>

/*! \return @[NZBBoard without messages] */
- (RACSignal *)boardsForLocalion:(CLLocation *)location;

/*! \return NZBBoard with messages */
- (RACSignal *)boardForLocalion:(CLLocation *)location;

/*! \return @[NZBMessage] */
- (RACSignal *)messagesForBoard:(NZBBoard *)board;

/*! \return posted NZBMessage */
- (RACSignal *)postMessageForLocation:(CLLocation *)location
							 withBody:(NSString *)body
								board:(NZBBoard *)board
								emoji:(NZBEmoji *)emoji;

/*! \return @(new power for message) - НЕ РАБОТАЕТ (`error = "you're wrong"`) */
- (RACSignal *)rateMessage:(NZBMessage *)message withInteraction:(NZBUserInteraction)interaction;

/*! Безусловно ищет (заводит) пользователя и ассоциирует его с токеном */
- (void)setPushToken:(NSData *)pushToken;

- (RACSignal *)getCurrentUser;
- (RACSignal *)getUser:(NSString *)id;

@end

@interface NZBServerController : NSObject <NZBAPIControllerProtocol>

@property (nonatomic, copy) NSString *userID;

+ (instancetype)sharedController;

@end
