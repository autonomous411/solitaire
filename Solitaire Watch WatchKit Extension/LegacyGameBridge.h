#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LegacyGameBridge : NSObject
+ (NSDictionary<NSString*, id>*) snapshot;
+ (void) setUIModeToLegacy;
+ (void) setUIModeToSwiftUI;
+ (void) setFlipCardsNumber:(NSInteger) count;
@end

NS_ASSUME_NONNULL_END
