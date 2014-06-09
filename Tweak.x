#import <UIKit/UIKit.h>
#import <CaptainHook/CaptainHook.h>

@interface SBStatusBarStateAggregator : NSObject
- (void)_updateTimeItems;
- (void)_resetTimeItemFormatter;
@end

static BOOL insideTimeItems;
static NSDateFormatter *currentDateFormatter;
static NSDateFormatter *additionalDataFormatter;

%hook SBStatusBarStateAggregator

- (void)_updateTimeItems
{
	%log();
	insideTimeItems = YES;
	%orig();
	insideTimeItems = NO;
}

- (void)_resetTimeItemFormatter
{
	%log();
	%orig();
	NSDateFormatter **_timeItemDateFormatter = CHIvarRef(self, _timeItemDateFormatter, NSDateFormatter *);
	if (_timeItemDateFormatter) {
		[currentDateFormatter release];
		currentDateFormatter = [*_timeItemDateFormatter retain];
		[additionalDataFormatter release];
		additionalDataFormatter = [currentDateFormatter copy];
		[additionalDataFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"US/Eastern"]];
		if ([self respondsToSelector:@selector(_updateTimeItems)]) {
			[self _updateTimeItems];
		}
	}
}

%end

%hook NSDateFormatter

- (NSString *)stringFromDate:(NSDate *)date
{
	if (insideTimeItems && (self == currentDateFormatter)) {
		insideTimeItems = NO;
		return [%orig() stringByAppendingFormat:@"/%@", [additionalDataFormatter stringFromDate:date]];
	}
	return %orig();
}

%end
