//
//  ModalHelperClass.m
//  Watch Tweeter
//
//  Created by Shayne Guiliano on 12/24/14.
//  Copyright (c) 2014 Shayne Guiliano. All rights reserved.
//

#import "ModalHelperClass.h"

@implementation ModalHelperClass
-(IBAction)done:(id)sender
{
    NSLog(@"done!");
    [self dismissController];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    self.colorTimer = [NSTimer scheduledTimerWithTimeInterval:.2f target:self selector:@selector(changeBackgroundColorRandomly) userInfo:nil repeats:YES];
}

-(void) changeBackgroundColorRandomly
{
    float hue = (float)arc4random_uniform(255);
    float huenormal = hue / 255.0f;
    [self.labelWon setTextColor:[UIColor colorWithHue:huenormal saturation:1 brightness:1 alpha:1]];
    //int blue = arc4random_uniform((u_int32_t )[self.masterDeck count]);
    //int green
    // Get 3 random numbers!
   // [self set]
    
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
    
    [self.colorTimer invalidate];
    self.colorTimer = nil;
}

@end
