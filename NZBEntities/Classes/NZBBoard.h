#import <CoreLocation/CoreLocation.h>

#import "NZBSerializable.h"
#import "NZBMessage.h"

@interface NZBBoard : NZBSerializable

@property (nonatomic, copy, readonly) NSString *id;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *icon;
@property (nonatomic, copy, readonly) CLLocation *location;
@property (nonatomic, copy, readonly) NSNumber *messagesCount;
@property (nonatomic, copy, readonly) NSArray<NZBMessage *> *messages;
@property (nonatomic, copy, readonly) NSArray<NSDictionary *> *messageDictionariesArray;

- (UIImage *)iconImage;

@end
