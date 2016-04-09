#import "NZBEmoji.h"

NSInteger const kNZBDefaultEmojiCount = 21;
static NSCache *_imageCache = nil;

@implementation NZBEmoji

- (instancetype)initWithText:(NSString *)text
{
	self = [super init];
	if (self == nil) return nil;
	NSCParameterAssert(text);
	
	_text = [text copy];

	static NSMutableSet *avaliableImages = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		avaliableImages = [NSMutableSet set];
		for (int i = 0; i <= kNZBDefaultEmojiCount; i++)
		{
			[avaliableImages addObject:[@(i) description]];
		}
	});

	_type = [avaliableImages containsObject:text] ? NZBEmojiImage : NZBEmojiText;
	return self;
}

- (UIImage *)image
{
	return [NZBEmoji imageForEmoji:self];
}

- (NSString *)textForAnalytics
{
	return (self.random) ? @"random" : self.text;
}

+ (UIImage *)imageForEmoji:(NZBEmoji *)emoji
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_imageCache = [[NSCache alloc] init];
	});
	@synchronized (self)
	{
		UIImage *image = [_imageCache objectForKey:emoji.text];
		if (image) return image;

		switch (emoji.type) {
			case NZBEmojiText:
			{
				image = [self imageWithText:emoji.text];
				break;
			}
			case NZBEmojiImage:
			{
				image = [UIImage imageNamed:emoji.text];
				break;
			}
		}
		if (image)
		{
			[_imageCache setObject:image forKey:emoji.text];
		}
		return image;
	}
}

+ (UIImage *)imageWithText:(NSString *)text
{
	UIImage *image = nil;

	static NSString *imageDir = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		imageDir = [NSTemporaryDirectory() stringByAppendingPathComponent:@"icons"];
		if (![[NSFileManager defaultManager] fileExistsAtPath:imageDir])
		{
			[[NSFileManager defaultManager] createDirectoryAtPath:imageDir withIntermediateDirectories:YES attributes:@{} error:nil];
		}
	});

	NSString *path = [imageDir stringByAppendingPathComponent:text];
	if ([[NSFileManager defaultManager] fileExistsAtPath:path])
	{
		NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
		image = [UIImage imageWithData:data scale:[UIScreen mainScreen].scale];
	}

	if (image) return image;

	CGRect frame = CGRectMake(0.0, 0.0, 44.0, 44.0);
	UIGraphicsBeginImageContextWithOptions(frame.size, NO, 0.0);
	[text drawInRect:frame withAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:40.0]}];
	image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		[UIImagePNGRepresentation(image) writeToFile:path atomically:YES];
	});

	return image;
}

@end
