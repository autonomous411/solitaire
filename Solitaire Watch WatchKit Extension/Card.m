//
//  Card.m
//  Solitaire Watch
//
//  Created by Shayne Guiliano on 12/28/14.
//  Copyright (c) 2014 Shayne Guiliano. All rights reserved.
//

#import "Card.h"

@implementation Card
static NSArray* cardNames = nil;
-(NSString*) cardName
{
    if (cardNames == nil)
    {
        cardNames = @[@"Unknown",@"Ace",@"Two",@"Three",@"Four",@"Five",@"Six",@"Seven",@"Eight",@"Nine",@"10",@"Jack",@"Queen",@"King"];
    }
    return [NSString stringWithFormat:@"%@ of %@s",[cardNames objectAtIndex:self.value],self.suite];
}
-(NSInteger)getSaveIndex
{
    if (self.index == 0)
    {
        return 100;
    }
    else
    {
        return self.index;
    }
}

-(void)setIndexFromSave:(NSInteger)saveIndex
{
    if (saveIndex == 100)
    {
        self.index = 0;
    }
    else
    {
        self.index = saveIndex;
    }
}

/*
-(NSInteger)index
{
    // It's it's an index of 0, translate that to 100!
    if (self.indexInternal == 0)
    {
        return 100;
    }
    else
    {
        return self.indexInternal;
    }
}

-(void)setIndex:(NSInteger)index
{
    if (index == 100)
    {
        self.indexInternal = 0;
    }
    else
    {
        self.indexInternal = index;
    }
}*/

-(id) initWithSuit:(NSString*) suit value:(NSInteger) value filename:(NSString*) filename color:(NSString*) color andIndex:(NSInteger)index is42:(BOOL) is42 isCopy:(BOOL) isCopy
{
    self = [super init];
    if (self)
    {
        // Do stuff here!
        self.suite = suit;
        self.value = value;
        self.isFacingUp = false;
        self.color = color;
        self.index = index;
        self.is42 = is42;
        if (isCopy)
        {
            self.filename = filename;
        }
        else
        {
            if (self.sharedDefaults == nil)
            {
                self.sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.solitaire"];
            }
            if ([self.sharedDefaults objectForKey:@"cardskin"] == nil)
            {
                [self.sharedDefaults setObject:@"classic" forKey:@"cardskin"];
            }
            if ([self.sharedDefaults objectForKey:@"cardskin"] != nil)
            {
                if ([[self.sharedDefaults objectForKey:@"cardskin"] isEqualToString: @"1"])
                {
                     [self.sharedDefaults setObject:@"classic" forKey:@"cardskin"];
                }
            }
            
            if (self.is42)
            {
                self.filename = [filename stringByReplacingOccurrencesOfString:@".png" withString:[NSString stringWithFormat:@"_44mm%@.png",[self.sharedDefaults objectForKey:@"cardskin"]]];
            }
            else
            {
                self.filename = [filename stringByReplacingOccurrencesOfString:@".png" withString:[NSString stringWithFormat:@"_38mm%@.png",[self.sharedDefaults objectForKey:@"cardskin"]]];//@"_38mm.png"];
            }
        }
        
        NSLog(@"filename is:%@ -%@",self.filename,self.is42?@"is42!":@"no!");
    }
    return self;
}

-(id) initWithSuit:(NSString*) suit value:(NSInteger) value filename:(NSString*) filename color:(NSString*) color andIndex:(NSInteger)index andFacing:(BOOL) facing is42:(BOOL) is42 isCopy:(BOOL) isCopy
{
    self = [super init];
    if (self)
    {
        // Do stuff here!
        self.suite = suit;
        self.value = value;
        
        self.isFacingUp = facing;
        self.color = color;
        self.index = index;
        self.is42 = is42;
        
        if (isCopy)
        {
            self.filename = filename;
        }
        else
        {
            if (self.sharedDefaults == nil)
            {
                self.sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.solitaire"];
            }
            if ([self.sharedDefaults objectForKey:@"cardskin"] == nil)
            {
                [self.sharedDefaults setObject:@"classic" forKey:@"cardskin"];
            }
            
            if ([self.sharedDefaults objectForKey:@"cardskin"] != nil)
            {
                if ([[self.sharedDefaults objectForKey:@"cardskin"] isEqualToString: @"1"])
                {
                    [self.sharedDefaults setObject:@"classic" forKey:@"cardskin"];
                }
            }
            if (self.is42)
            {
                self.filename = [filename stringByReplacingOccurrencesOfString:@".png" withString:[NSString stringWithFormat:@"_44mm%@.png",[self.sharedDefaults objectForKey:@"cardskin"]]];
            }
            else
            {
                self.filename = [filename stringByReplacingOccurrencesOfString:@".png" withString:[NSString stringWithFormat:@"_38mm%@.png",[self.sharedDefaults objectForKey:@"cardskin"]]];//@"_38mm.png"];
            }
        }
    }
    return self;
}

-(Card*) copyCard
{
    Card* cardCopy = [[Card alloc] initWithSuit:self.suite value:self.value filename:self.filename color:self.color andIndex:self.index andFacing:self.isFacingUp  is42:self.is42 isCopy:YES];
    
    return cardCopy;
}

@end
