#import "NZBEmojiCategory.h"

@implementation NZBEmojiCategory

+ (instancetype)defaultCategory
{
	NSMutableArray *emojis = [NSMutableArray arrayWithCapacity:kNZBDefaultEmojiCount];
	for (NSInteger i = 0; i < kNZBDefaultEmojiCount; i++)
	{
		[emojis addObject:[[NZBEmoji alloc] initWithText:[@(i) description]]];
	}
	return [[self alloc] initWithTitle:@"" emoji:emojis];
}

- (instancetype)initWithTitle:(NSString *)title emoji:(NSArray<NZBEmoji *> *)emoji
{
	self = [super init];
	if (self == nil) return nil;

	_title = [title copy];
	_emoji = [emoji copy];

	return self;
}

- (instancetype)initWithTitle:(NSString *)title text:(NSString *)text
{
	NSMutableArray *emojis = [NSMutableArray arrayWithCapacity:text.length];
	text = [[text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
		componentsJoinedByString:@""];

	[text enumerateSubstringsInRange:NSMakeRange(0, text.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
		[emojis addObject:[[NZBEmoji alloc] initWithText:substring]];
	}];
	return [self initWithTitle:title emoji:emojis];
}

@end
