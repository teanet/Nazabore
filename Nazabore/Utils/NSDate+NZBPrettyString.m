#import "NSDate+NZBPrettyString.h"

@implementation NSDate (NZBPrettyString)

+ (NSString *)nzb_prettyStringFrom:(NSTimeInterval)interval
{
	static NSDateFormatter *dateFormatter = nil;
	static dispatch_once_t onceToken1;
	dispatch_once(&onceToken1, ^{
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"dd.MM.yyyy"];
	});

	static NSDateFormatter *timeFormatter = nil;
	static dispatch_once_t onceToken2;
	dispatch_once(&onceToken2, ^{
		timeFormatter = [[NSDateFormatter alloc] init];
		[timeFormatter setDateFormat:@"HH:mm"];
	});

	NSDate *now = [NSDate date];
	NSTimeInterval sinceNowInterval = now.timeIntervalSince1970 - interval;

	if (sinceNowInterval <= 60.0) return kNZB_DATE_FEW_SECONDS_AGO;

	NSInteger minutes = ceilf(sinceNowInterval / 60.0);
	NSInteger firstMinutes = minutes % 10;

	if (minutes < 60)
	{
		if (firstMinutes < 5)
		{
			return [NSString stringWithFormat:kNZB_DATE_FEW_MINUTES_AGO, (long)minutes];
		}
		else
		{
			return [NSString stringWithFormat:kNZB_DATE_SEVERAL_MINUTES_AGO, (long)minutes];
		}
	}

	NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
	if (minutes < 24 * 60) return [timeFormatter stringFromDate:date];

	return [dateFormatter stringFromDate:date];
}

@end
