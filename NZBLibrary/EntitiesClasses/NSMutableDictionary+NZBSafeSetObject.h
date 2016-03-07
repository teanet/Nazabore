@interface NSMutableDictionary (NZBSafeSetObject)

- (void)nzb_safeSetObject:(id)anObject forKey:(id<NSCopying>)aKey;

@end
