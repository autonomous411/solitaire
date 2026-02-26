//
//  SizeToScreen.m
//  Solitaire Watch
//
//  Created by Shayne Guiliano on 3/13/15.
//  Copyright (c) 2015 Shayne Guiliano. All rights reserved.
//

#import "SizeToScreen.h"

@implementation SizeToScreen

-(void) myInitialization
{
   self.frame = [UIScreen mainScreen].bounds;
   // self.content
}
-  (id)initWithFrame:(CGRect)aRect
{
    self = [super initWithFrame:aRect];
    
    if (self)
    {
        [self myInitialization];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self myInitialization];
    }
    
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
