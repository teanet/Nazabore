#import <ReactiveCocoa/ReactiveCocoa.h>

#import "NZBBoard.h"
#import "NZBMessage.h"

@protocol NZBAPIControllerProtocol <NSObject>

/*! \return @[NZBBoard without messages] */
- (RACSignal *)fetchBoardsForLocalion:(CLLocation *)location;

/*! \return NZBBoard with messages */
- (RACSignal *)fetchBoardForLocalion:(CLLocation *)location;

/*! \return @[NZBMessage] */
- (RACSignal *)fetchMessagesForBoard:(NZBBoard *)board;

/*! \return posted NZBMessage */
- (RACSignal *)postMessageForLocation:(CLLocation *)location
							 withBody:(NSString *)body
								board:(NZBBoard *)board
								 icon:(NSString *)icon;

/*! \return @(new power for message) - НЕ РАБОТАЕТ (`error = "you're wrong"`) */
- (RACSignal *)rateMessage:(NZBMessage *)message withInteraction:(NZBUserInteraction)interaction;

/*! Безусловно ищет (заводит) пользователя и ассоциирует его с токеном */
- (void)setPushToken:(NSData *)pushToken;

@end

@interface NZBServerController : NSObject <NZBAPIControllerProtocol>

@property (nonatomic, copy) NSString *userID;

+ (instancetype)sharedController;

@end
