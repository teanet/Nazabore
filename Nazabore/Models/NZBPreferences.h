@interface NZBPreferences : NSObject

@property (nonatomic, copy, readonly) NSString *userId;
@property (nonatomic, assign, readwrite) BOOL userDidSelectAuthorizationStatus;

+ (instancetype)defaultPreferences;

@end
