//
//  ModalHelperClass.h
//  Watch Tweeter
//
//  Created by Shayne Guiliano on 12/24/14.
//  Copyright (c) 2014 Shayne Guiliano. All rights reserved.
//

#import <WatchKit/WatchKit.h>

@interface ModalHelperClass : WKInterfaceController
@property (strong, nonatomic) NSTimer* colorTimer;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel* labelWon;
-(IBAction)done:(id)sender;
@end
