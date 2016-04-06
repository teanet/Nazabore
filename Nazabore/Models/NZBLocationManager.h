@interface NZBLocationManager : NSObject

/*!	Signal with user choice of Location Service authorization status when it's determined.
 *	Only one value is returned per signal.
 *  \return @(CLAuthorizationStatus).
 **/
@property (nonatomic, strong, readonly) RACSignal *didRecieveUserChoiceAboutLocationSignal;

/*! Signal with CLLocation.
 *	Only _one_ location is returned per signal, or signal ends with error. Then location manager will be disabled.
 *	\return CLLocation.
 **/
@property (nonatomic, strong, readonly) RACSignal *locationSignal;

- (void)start;

@end
