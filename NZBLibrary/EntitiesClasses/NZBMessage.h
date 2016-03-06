#import <CoreLocation/CoreLocation.h>

#import "NZBSerializable.h"

typedef NS_ENUM(NSInteger, NZBMessageType) {
	NZBMessageTypeDefault		= 0,
	NZBMessageTypeAdvertisement = 1,
	NZBMessageTypeCommercial	= 2,
};

typedef NS_ENUM(NSInteger, NZBUserInteraction) {
	NZBUserInteractionDislike	= -1,
	NZBUserInteractionNone		= 0,
	NZBUserInteractionLike		= 1,
};


@interface NZBRating : NSObject

@property (nonatomic, assign, readonly) NSInteger power;
@property (nonatomic, assign, readonly) NZBUserInteraction interaction;

+ (instancetype)ratingWithPower:(NSUInteger)power interation:(NZBUserInteraction)interaction;

@end

@protocol NZBUpdateProtocol <NSObject>

- (void)nzb_update;

@end


@interface NZBMessage : NZBSerializable

@property (nonatomic, copy, readonly) NSString *id;
@property (nonatomic, assign, readonly) NZBMessageType messageType;
@property (nonatomic, strong, readonly) CLLocation *location;
@property (nonatomic, copy, readonly) NSString *body;
@property (nonatomic, assign, readonly) NSTimeInterval timestamp;
@property (nonatomic, copy, readonly) NZBRating *rating;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *icon;
@property (nonatomic, copy, readonly) NSString *phone;
@property (nonatomic, copy, readonly) NSString *dbObjectIdentifier;
@property (nonatomic, copy, readonly) NSNumber *karma;
@property (nonatomic, weak) id<NZBUpdateProtocol> relatedView;
@property (nonatomic, strong) NSDictionary *boardD;

+ (instancetype)messageWithDictionary:(NSDictionary *)dictionary;

- (void)updateWithDictionary:(NSDictionary *)dictionary;
- (NSString *)messageForWatch;
- (NSString *)timeString;
- (NSString *)watchCellType;
- (NSString *)powerString;

//- (NSAttributedString *)watchPowerString;
//- (NSAttributedString *)phonePowerString;
//
//- (UIFont *)messageFont;
//- (UIColor *)messageColor;

@end
