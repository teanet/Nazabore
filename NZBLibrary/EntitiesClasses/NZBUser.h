#import "NZBSerializableProtocol.h"

@interface NZBUser : NSObject <NZBSerializableProtocol>

@property (nonatomic, copy, readonly) NSString *id;
@property (nonatomic, assign, readonly) NSInteger power;
@property (nonatomic, assign, readonly) double rating;
@property (nonatomic, assign, readonly) double visibleRange;

+ (instancetype)userWithDictionary:(NSDictionary *)dictionary;
- (instancetype)init NS_UNAVAILABLE;

@end
