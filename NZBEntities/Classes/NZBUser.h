#import "NZBSerializable.h"

@interface NZBUser : NZBSerializable

@property (nonatomic, copy, readonly) NSString *id;
@property (nonatomic, assign, readonly) NSInteger power;
@property (nonatomic, assign, readonly) double rating;

+ (instancetype)userWithDictionary:(NSDictionary *)dictionary;

@end
