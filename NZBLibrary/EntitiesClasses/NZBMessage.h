#import <CoreLocation/CoreLocation.h>

#import "NZBSerializableProtocol.h"
#import "NZBEmoji.h"

typedef NS_ENUM(NSInteger, NZBMessageType) {
	NZBMessageTypeDefault		= 0,
	NZBMessageTypeAdvertisement = 1,
	NZBMessageTypeCommercial	= 2,
	NZBMessageTypePoi			= 3,
};

typedef NS_ENUM(NSInteger, NZBUserInteraction) {
	NZBUserInteractionDislike	= -1,
	NZBUserInteractionNone		= 0,
	NZBUserInteractionLike		= 1,
};


@protocol NZBUpdateProtocol <NSObject>

- (void)nzb_update;

@end


@interface NZBRating : NSObject

@property (nonatomic, assign, readonly) NSInteger power;
@property (nonatomic, assign, readonly) NZBUserInteraction interaction;

+ (instancetype)ratingWithPower:(NSUInteger)power interaction:(NZBUserInteraction)interaction;

@end


@interface NZBMessage : NSObject <NZBSerializableProtocol>

@property (nonatomic, copy, readonly) NSString *id;
@property (nonatomic, assign, readonly) NZBMessageType messageType;
@property (nonatomic, strong, readonly) CLLocation *location;
@property (nonatomic, copy, readonly) NSString *body;
@property (nonatomic, assign, readonly) NSTimeInterval timestamp;
@property (nonatomic, copy, readonly) NZBRating *rating;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *iconName;
@property (nonatomic, copy, readonly) NSString *phone;
@property (nonatomic, copy, readonly) NSString *dbObjectIdentifier;
@property (nonatomic, copy, readonly) NSNumber *karma;
@property (nonatomic, copy, readonly) NSString *userid;
@property (nonatomic, copy, readonly) NSString *boardId;
@property (nonatomic, copy, readonly) NSString *poiName;
@property (nonatomic, copy, readonly) NSString *poiImageUrlString;
@property (nonatomic, weak) id<NZBUpdateProtocol> relatedView;
@property (nonatomic, strong) NSDictionary *boardD;
@property (nonatomic, strong, readonly) NZBEmoji *emoji;

+ (instancetype)messageWithDictionary:(NSDictionary *)dictionary;
- (instancetype)init NS_UNAVAILABLE;

- (NSString *)messageForWatch;
- (NSString *)timeString;
- (NSString *)watchCellType;
- (NSString *)powerString;

@end
