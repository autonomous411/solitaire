#import "LegacyGameBridge.h"

static NSString* const kSavedDataKey = @"savedata";
static NSString* const kFlipCardNumberKey = @"flipcardnumber";

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

    NSData* savedData = [defaults objectForKey:kSavedDataKey];
    BOOL hasSavedBoard = (savedData != nil && [savedData length] > 0);

    return @{
        @"flipCards": flipCards,
        @"uiMode": @"swiftui",
        @"hasSavedBoard": @(hasSavedBoard)
    };
}

+ (void) setFlipCardsNumber:(NSInteger) count
{
    NSInteger clamped = (count == 1) ? 1 : 3;
    NSUserDefaults* defaults = [self sharedDefaults];
    [defaults setObject:@(clamped) forKey:kFlipCardNumberKey];
    [defaults synchronize];
}

@end
