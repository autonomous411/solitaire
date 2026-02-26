//
//  SolitaireSettings.m
//  Solitaire Watch
//
//  Created by Shayne Guiliano on 4/25/15.
//  Copyright (c) 2015 Shayne Guiliano. All rights reserved.
//

#import "SolitaireSettings.h"

@implementation SolitaireSettings
- (void)willActivate {
    if ([[SolitaireSettings getUISetting] isEqualToString:VOICEANDMOVES])
    {
        [self.voiceAndMoves setEnabled:NO];
        [self.voiceOnly setEnabled:YES];
        [self.touchTwo setEnabled:YES];
        [self.touchOne setEnabled:YES];
        [self.voiceOnly setOn:NO];
        [self.touchTwo setOn:NO];
        [self.touchOne setOn:NO];
        [self.voiceAndMoves setOn:YES];
    }
    
    if ([[SolitaireSettings getUISetting] isEqualToString:VOICEONLY])
    {
        [self.voiceAndMoves setOn:NO];
        [self.voiceAndMoves setEnabled:YES];
        [self.touchOne setEnabled:YES];
        [self.touchTwo setEnabled:YES];
        [self.voiceOnly setEnabled:NO];
        [self.touchOne setOn:NO];
        [self.touchTwo setOn:NO];
        [self.voiceOnly setOn:YES];
    }
    
    if ([[SolitaireSettings getUISetting] isEqualToString:TOUCHONE])
    {
        [self.voiceAndMoves setOn:NO];
        [self.voiceOnly setOn:NO];
        [self.voiceAndMoves setEnabled:YES];
        [self.voiceOnly setEnabled:YES];
        [self.touchOne setEnabled:NO];
        [self.touchOne setOn:YES];
        [self.touchTwo setEnabled:YES];
        [self.touchTwo setOn:NO];
    }
    if ([[SolitaireSettings getUISetting] isEqualToString:TOUCHTWO])
    {
        [self.voiceAndMoves setOn:NO];
        [self.voiceOnly setOn:NO];
        [self.voiceAndMoves setEnabled:YES];
        [self.voiceOnly setEnabled:YES];
        [self.touchTwo setEnabled:NO];
        [self.touchTwo setOn:YES];
        [self.touchOne setEnabled:YES];
        [self.touchOne setOn:NO];
    }
}
+(NSString*) getUISetting
{
    NSString* saved = [[NSUserDefaults standardUserDefaults] objectForKey:@"solitairesetting"];
    if (saved)
    {
        return [[NSUserDefaults standardUserDefaults] objectForKey:@"solitairesetting"];
    }
    else
    {
        return TOUCHTWO;
    }
}
- (IBAction)switchVoiceOnly:(BOOL)on
{
    [self.voiceAndMoves setOn:NO];
    [self.voiceAndMoves setEnabled:YES];
    [self.touchOne setEnabled:YES];
    [self.touchTwo setEnabled:YES];
    [self.voiceOnly setEnabled:NO];
    [self.touchOne setOn:NO];
    [self.touchTwo setOn:NO];
     [[NSUserDefaults standardUserDefaults] setObject:VOICEONLY forKey:@"solitairesetting"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (IBAction)switchVoiceAndMoves:(BOOL)on
{
    [self.voiceAndMoves setEnabled:NO];
    [self.voiceOnly setEnabled:YES];
    [self.touchOne setEnabled:YES];
    [self.touchTwo setEnabled:YES];
    [self.voiceOnly setOn:NO];
    [self.touchOne setOn:NO];
    [self.touchTwo setOn:NO];
    [[NSUserDefaults standardUserDefaults] setObject:VOICEANDMOVES forKey:@"solitairesetting"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (IBAction)switchTouchOne:(BOOL)on
{
    [self.voiceAndMoves setOn:NO];
    [self.voiceOnly setOn:NO];
    [self.voiceAndMoves setEnabled:YES];
    [self.voiceOnly setEnabled:YES];
    [self.touchOne setEnabled:NO];
    [self.touchTwo setEnabled:YES];
    [self.touchTwo setOn:NO];
    [[NSUserDefaults standardUserDefaults] setObject:TOUCHONE forKey:@"solitairesetting"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (IBAction)switchTouchTwo:(BOOL)on
{
    [self.voiceAndMoves setOn:NO];
    [self.voiceOnly setOn:NO];
    [self.voiceAndMoves setEnabled:YES];
    [self.voiceOnly setEnabled:YES];
    [self.touchOne setEnabled:YES];
    [self.touchTwo setEnabled:NO];
    [self.touchOne setOn:NO];
    [[NSUserDefaults standardUserDefaults] setObject:TOUCHTWO forKey:@"solitairesetting"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
