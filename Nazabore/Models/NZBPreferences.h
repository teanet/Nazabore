@interface NZBPreferences : NSObject

@property (nonatomic, copy, readonly) NSString *userId;

+ (instancetype)defaultPreferences;

@end
