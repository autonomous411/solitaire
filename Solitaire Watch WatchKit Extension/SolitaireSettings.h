//
//  SolitaireSettings.h
//  Solitaire Watch
//
//  Created by Shayne Guiliano on 4/25/15.
//  Copyright (c) 2015 Shayne Guiliano. All rights reserved.
//

#import <WatchKit/WatchKit.h>
static NSString* VOICEANDMOVES = @"voiceandmoves";
static NSString* VOICEONLY = @"voiceonly";
static NSString* TOUCHTWO = @"touchtwo";
static NSString* TOUCHONE = @"touchone";
@interface SolitaireSettings : WKInterfaceController
+(NSString*) getUISetting;
@property IBOutlet WKInterfaceSwitch* voiceAndMoves;
@property IBOutlet WKInterfaceSwitch* voiceOnly;
@property IBOutlet WKInterfaceSwitch* touchTwo;
@property IBOutlet WKInterfaceSwitch* touchOne;
@end
