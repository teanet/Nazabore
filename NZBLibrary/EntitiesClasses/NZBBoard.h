#import <CoreLocation/CoreLocation.h>

#import "NZBSerializableProtocol.h"
#import "NZBMessage.h"

@interface NZBBoard : NSObject <NZBSerializableProtocol>

@property (nonatomic, copy, readonly) NSString *id;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) CLLocation *location;
@property (nonatomic, copy, readonly) NSNumber *messagesCount;
@property (nonatomic, copy, readonly) NSArray<NZBMessage *> *messages;

- (UIImage *)iconImage;

@end
