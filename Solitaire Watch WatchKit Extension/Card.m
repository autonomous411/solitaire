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

static NSString* SWNormalizedSkinName(NSString* skin)
{
    if (skin == nil || [skin length] == 0 || [skin isEqualToString:@"1"])
    {
        return @"classic";
    }
    return skin;
}

static NSArray<NSBundle*>* SWCandidateResourceBundles(void)
{
    NSMutableArray<NSBundle*>* bundles = [[NSMutableArray alloc] init];
    NSBundle* mainBundle = [NSBundle mainBundle];
    if (mainBundle != nil)
    {
        [bundles addObject:mainBundle];
        NSString* bundlePath = [mainBundle bundlePath];
        NSString* pluginsPath = [bundlePath stringByDeletingLastPathComponent];
        NSString* watchAppPath = [pluginsPath stringByDeletingLastPathComponent];
        if ([watchAppPath length] > 0)
        {
            NSBundle* watchAppBundle = [NSBundle bundleWithPath:watchAppPath];
            if (watchAppBundle != nil && watchAppBundle != mainBundle)
            {
                [bundles addObject:watchAppBundle];
            }
        }
    }
    return bundles;
}

static BOOL SWBundleHasImageNamed(NSString* filename)
{
    if (filename == nil || [filename length] == 0)
    {
        return NO;
    }
    NSString* extension = [filename pathExtension];
    NSString* nameWithoutExtension = [filename stringByDeletingPathExtension];
    if ([extension length] == 0)
    {
        extension = @"png";
        nameWithoutExtension = filename;
    }
    NSMutableArray<NSString*>* candidateNames = [[NSMutableArray alloc] init];
    [candidateNames addObject:nameWithoutExtension];
    [candidateNames addObject:[nameWithoutExtension stringByAppendingString:@"@2x"]];
    [candidateNames addObject:[nameWithoutExtension stringByAppendingString:@"@3x"]];
    if ([nameWithoutExtension hasSuffix:@"@2x"] || [nameWithoutExtension hasSuffix:@"@3x"])
    {
        NSRange atRange = [nameWithoutExtension rangeOfString:@"@" options:NSBackwardsSearch];
        if (atRange.location != NSNotFound)
        {
            NSString* strippedName = [nameWithoutExtension substringToIndex:atRange.location];
            if ([strippedName length] > 0)
            {
                [candidateNames addObject:strippedName];
            }
        }
    }

    for (NSBundle* bundle in SWCandidateResourceBundles())
    {
        for (NSString* candidateName in candidateNames)
        {
            if ([bundle pathForResource:candidateName ofType:extension] != nil)
            {
                return YES;
            }
        }
    }
    return NO;
}

static NSString* SWBuildFilename(NSString* baseFilename, NSString* suffix)
{
    NSString* root = [baseFilename stringByDeletingPathExtension];
    NSString* extension = [baseFilename pathExtension];
    if ([extension length] == 0)
    {
        extension = @"png";
    }
    return [NSString stringWithFormat:@"%@%@.%@", root, suffix, extension];
}

+(NSString*) resolveAssetFilenameForBaseFilename:(NSString*) baseFilename skin:(NSString*) skin preferLarge:(BOOL) preferLarge
{
    if (baseFilename == nil || [baseFilename length] == 0)
    {
        return baseFilename;
    }

    NSString* normalizedSkin = SWNormalizedSkinName(skin);
    NSArray* sizeTokens = preferLarge ? @[@"44mm", @"38mm"] : @[@"38mm", @"44mm"];
    NSMutableArray* candidates = [[NSMutableArray alloc] init];

    [candidates addObject:baseFilename];
    [candidates addObject:SWBuildFilename(baseFilename, [NSString stringWithFormat:@"_%@", normalizedSkin])];

    for (NSString* token in sizeTokens)
    {
        [candidates addObject:SWBuildFilename(baseFilename, [NSString stringWithFormat:@"_%@%@", token, normalizedSkin])];
        [candidates addObject:SWBuildFilename(baseFilename, [NSString stringWithFormat:@"_%@", token])];
        [candidates addObject:SWBuildFilename(baseFilename, [NSString stringWithFormat:@"_%@classic", token])];
    }

    NSMutableSet* seen = [[NSMutableSet alloc] init];
    for (NSString* candidate in candidates)
    {
        if ([seen containsObject:candidate])
        {
            continue;
        }
        [seen addObject:candidate];
        if (SWBundleHasImageNamed(candidate))
        {
            return candidate;
        }
    }

    return [candidates objectAtIndex:0];
}
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
            NSString* skin = SWNormalizedSkinName([self.sharedDefaults objectForKey:@"cardskin"]);
            [self.sharedDefaults setObject:skin forKey:@"cardskin"];
            self.filename = [Card resolveAssetFilenameForBaseFilename:filename skin:skin preferLarge:self.is42];
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
            NSString* skin = SWNormalizedSkinName([self.sharedDefaults objectForKey:@"cardskin"]);
            [self.sharedDefaults setObject:skin forKey:@"cardskin"];
            self.filename = [Card resolveAssetFilenameForBaseFilename:filename skin:skin preferLarge:self.is42];
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
