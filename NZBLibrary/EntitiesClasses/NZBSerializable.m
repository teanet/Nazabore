//#import "NZBSerializable.h"

//@implementation NZBSerializable
//
//- (instancetype)initWithDictionary:(NSDictionary *)dictionary
//{
//	self = [super init];
//	if (self == nil) return nil;
//
//	[self updateWithDictionary:dictionary];
//
//	return self;
//}
//
//- (void)updateWithDictionary:(NSDictionary *)dictionary
//{
//	NSCAssert(NO, @"Method should be implemented in subclass");
//	NSMutableDictionary *initDictionary = [dictionary mutableCopy];
//	[initDictionary removeObjectForKey:@"_id"];
//	[dictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//		if ([obj isEqual:[NSNull null]]) {
//			[initDictionary removeObjectForKey:key];
//		}
//	}];
//	_dictionary = [initDictionary copy];
//	[self setValuesForKeysWithDictionary:initDictionary];
//}
//
//- (void)setValue:(id)value forUndefinedKey:(NSString *)key
//{
//	NSLog(@"<%@> ERROR: value: %@ for undefined key: %@", self.class, value, key);
//}
//
//@end
