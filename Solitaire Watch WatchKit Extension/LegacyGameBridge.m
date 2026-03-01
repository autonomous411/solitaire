#import "LegacyGameBridge.h"

static NSString* const kSavedDataKey = @"savedata";
static NSString* const kFlipCardNumberKey = @"flipcardnumber";
static NSString* const kWatchUIModeKey = @"watch_ui_mode";
static NSString* const kWatchUIModeLegacy = @"legacy";
static NSString* const kWatchUIModeSwiftUI = @"swiftui";

@implementation LegacyGameBridge

+ (NSUserDefaults*)sharedDefaults
{
    NSUserDefaults* defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.solitaire"];
    if (defaults == nil)
    {
        defaults = [NSUserDefaults standardUserDefaults];
    }
    return defaults;
}

+ (NSDictionary<NSString*, id>*) snapshot
{
    NSUserDefaults* defaults = [self sharedDefaults];
    NSNumber* flipCards = [defaults objectForKey:kFlipCardNumberKey];
    if (flipCards == nil || [flipCards integerValue] <= 0)
    {
        flipCards = @3;
    }

    NSString* uiMode = [defaults objectForKey:kWatchUIModeKey];
    if (![uiMode isEqualToString:kWatchUIModeLegacy] && ![uiMode isEqualToString:kWatchUIModeSwiftUI])
    {
        uiMode = kWatchUIModeLegacy;
    }

    NSData* savedData = [defaults objectForKey:kSavedDataKey];
    BOOL hasSavedBoard = (savedData != nil && [savedData length] > 0);

    return @{
        @"flipCards": flipCards,
        @"uiMode": uiMode,
        @"hasSavedBoard": @(hasSavedBoard)
    };
}

+ (void) setUIModeToLegacy
{
    NSUserDefaults* defaults = [self sharedDefaults];
    [defaults setObject:kWatchUIModeLegacy forKey:kWatchUIModeKey];
    [defaults synchronize];
}

+ (void) setUIModeToSwiftUI
{
    NSUserDefaults* defaults = [self sharedDefaults];
    [defaults setObject:kWatchUIModeSwiftUI forKey:kWatchUIModeKey];
    [defaults synchronize];
}

+ (void) setFlipCardsNumber:(NSInteger) count
{
    NSInteger clamped = (count == 1) ? 1 : 3;
    NSUserDefaults* defaults = [self sharedDefaults];
    [defaults setObject:@(clamped) forKey:kFlipCardNumberKey];
    [defaults synchronize];
}

@end
