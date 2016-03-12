#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (CLLocation)

+ (instancetype)nzb_dictionaryWithLocation:(CLLocation *)location;
- (CLLocation *_Nullable)nzb_location;

@end

NS_ASSUME_NONNULL_END
