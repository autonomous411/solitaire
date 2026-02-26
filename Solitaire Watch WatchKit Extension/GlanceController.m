//
//  GlanceController.m
//  Solitaire Watch WatchKit Extension
//
//  Created by Shayne Guiliano on 3/31/15.
//  Copyright (c) 2015 Shayne Guiliano. All rights reserved.
//

#import "GlanceController.h"


@interface GlanceController()
@property (nonatomic,strong) NSTimer* changeColorTimer;
@property (nonatomic,strong) IBOutlet WKInterfaceGroup* headerGroup;
@end

static int colorIndex = 0;
static NSArray* colors;
static BOOL isVisible = false;
@implementation GlanceController

-(void) changeColor
{
    
    if (colors == nil)
    {
        colors = @[[UIColor colorWithRed:130.0f/255.0f green:0.0f/255.0f blue:1.0f/255.0f alpha:1.0],[UIColor colorWithRed:39.0f/255.0f green:112.0f/255.0f blue:51.0f/255.0f alpha:1.0]];
    }
    
    [self.headerGroup setBackgroundColor:[colors objectAtIndex:colorIndex]];
    colorIndex++;
    if (colorIndex >= [colors count])
    {
        colorIndex = 0;
    }
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //[self performSelector:@selector(changeColor) withObject:nil afterDelay:.25f];
        //NSDate* dateCheck = [NSDate date];
        //while([NSDate date].timeIntervalSince1970 - dateCheck.timeIntervalSince1970 < .25f)
        //{
        [NSThread sleepForTimeInterval:.5];
        //}
        [self performSelectorOnMainThread:@selector(changeColor)
                               withObject:nil waitUntilDone:YES];
    });
}

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    
    // Configure interface objects here.
    //[WKInterfaceController openParentApplication:@{@"command":@"init"} reply:^(NSDictionary *replyInfo, NSError *error) {
        //code
    
    //}];
    //NSArray* backgroundHeader = @[[UIImage imageNamed:@"glanceanim0"],[UIImage imageNamed:@"glanceanim1"]];
    //UIImage* animated = [UIImage animatedImageWithImages:backgroundHeader duration:1];
    //[self.headerGroup setBackgroundImage:animated];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    isVisible = YES;
    //[self changeColor];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //[self performSelector:@selector(changeColor) withObject:nil afterDelay:.25f];
        [self performSelectorOnMainThread:@selector(changeColor)
                               withObject:nil waitUntilDone:YES];
    });
    //[self.headerGroup setBackgroundImageNamed:@"glanceanim1"];
    //[self.headerGroup startAnimating];
         //NSArray* backgroundHeader = @[[UIImage imageNamed:@"glanceanim0"],[UIImage imageNamed:@"glanceanim1"]];
         //UIImage* animated = [UIImage animatedImageWithImages:backgroundHeader duration:1];
         //[self.headerGroup setBackgroundImage:animated];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
    isVisible = NO;
   // [self.changeColorTimer invalidate];
}

@end



