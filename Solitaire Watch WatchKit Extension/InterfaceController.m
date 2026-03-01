//
//  InterfaceController.m
//  Solitaire Watch WatchKit Extension
//
//  Created by Shayne Guiliano on 12/28/14.
//  Copyright (c) 2014 Shayne Guiliano. All rights reserved.
//

// Notes:
// New features:
// - More card art
// - Share hand with community.
// - Challenge a friend to do it in less turns.


#import "InterfaceController.h"
#import "Card.h"
#import "MMWormhole.h"
#import "PossibleMove.h"
#import "SolitaireSettings.h"
#import <math.h>

static BOOL isRemoteControlled = NO;
static BOOL isVoiceControlled = NO;
static BOOL isUsingMoves = NO;
static BOOL isOneTouch = YES;
static int lastFromTouched = 0;
@class SolitaireGameState;
@interface InterfaceController()
-(IBAction)resetBoardButton:(id)sender;
-(IBAction)cardsToggle;
-(IBAction)redealCards;
-(void) migrateLegacyDefaultsIfNeeded;
-(NSArray<NSArray<NSNumber*>*>*) validatedStacksFromSaveJSON:(id) jsonObject;
-(NSArray<NSMutableArray*>*) boardStackCollections;
-(BOOL) loadBoardFromValidatedStacks:(NSArray<NSArray<NSNumber*>*>*) stacks;
-(void) persistStacks:(NSArray<NSArray<NSNumber*>*>*) stacks notifyCompanion:(BOOL) notifyCompanion;
-(void) ensureBoardStacksAllocated;
@property (strong, nonatomic) IBOutlet WKInterfaceButton* deckFlipButton;
@property (strong, nonatomic) IBOutlet WKInterfaceButton* deckStackButton;
@property (strong, nonatomic) IBOutlet WKInterfaceButton* discard1Button;
@property (strong, nonatomic) IBOutlet WKInterfaceButton* discard2Button;
@property (strong, nonatomic) IBOutlet WKInterfaceButton* discard3Button;
@property (strong, nonatomic) IBOutlet WKInterfaceButton* discard4Button;
@property (strong, nonatomic) IBOutlet WKInterfaceButton* buttonCardsToggle;
@property (strong, nonatomic) IBOutlet WKInterfaceButton* buttonRedeal;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card0x0;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card0x1;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card0x2;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card0x3;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card0x4;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card0x5;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card0x6;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card0x7;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card0x8;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card0x9;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card0x10;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card0x11;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card0x12;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card0x13;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card0x14;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card0x15;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card0x16;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card0x17;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card0x18;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card0x19;

@property (strong, nonatomic) IBOutlet WKInterfaceImage* card1x0;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card1x1;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card1x2;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card1x3;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card1x4;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card1x5;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card1x6;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card1x7;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card1x8;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card1x9;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card1x10;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card1x11;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card1x12;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card1x13;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card1x14;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card1x15;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card1x16;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card1x17;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card1x18;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card1x19;

@property (strong, nonatomic) IBOutlet WKInterfaceImage* card2x0;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card2x1;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card2x2;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card2x3;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card2x4;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card2x5;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card2x6;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card2x7;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card2x8;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card2x9;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card2x10;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card2x11;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card2x12;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card2x13;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card2x14;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card2x15;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card2x16;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card2x17;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card2x18;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card2x19;

@property (strong, nonatomic) IBOutlet WKInterfaceImage* card3x0;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card3x1;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card3x2;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card3x3;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card3x4;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card3x5;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card3x6;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card3x7;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card3x8;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card3x9;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card3x10;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card3x11;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card3x12;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card3x13;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card3x14;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card3x15;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card3x16;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card3x17;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card3x18;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card3x19;

@property (strong, nonatomic) IBOutlet WKInterfaceImage* card4x0;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card4x1;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card4x2;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card4x3;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card4x4;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card4x5;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card4x6;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card4x7;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card4x8;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card4x9;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card4x10;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card4x11;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card4x12;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card4x13;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card4x14;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card4x15;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card4x16;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card4x17;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card4x18;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card4x19;

@property (strong, nonatomic) IBOutlet WKInterfaceImage* card5x0;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card5x1;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card5x2;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card5x3;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card5x4;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card5x5;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card5x6;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card5x7;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card5x8;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card5x9;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card5x10;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card5x11;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card5x12;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card5x13;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card5x14;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card5x15;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card5x16;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card5x17;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card5x18;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card5x19;

@property (strong, nonatomic) IBOutlet WKInterfaceImage* card6x0;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card6x1;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card6x2;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card6x3;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card6x4;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card6x5;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card6x6;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card6x7;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card6x8;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card6x9;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card6x10;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card6x11;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card6x12;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card6x13;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card6x14;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card6x15;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card6x16;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card6x17;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card6x18;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* card6x19;

@property (strong, nonatomic) IBOutlet WKInterfaceImage* deckStack1Image;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* deckStack2Image;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* deckStack3Image;

@property (strong, nonatomic) IBOutlet WKInterfaceImage* deckFlip1Image;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* deckFlip2Image;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* deckFlip3Image;

@property (strong, nonatomic) IBOutlet WKInterfaceImage* discard1Image;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* discard2Image;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* discard3Image;
@property (strong, nonatomic) IBOutlet WKInterfaceImage* discard4Image;

@property (strong, nonatomic) IBOutlet WKInterfaceButton* hand0Button;
@property (strong, nonatomic) IBOutlet WKInterfaceButton* hand1Button;
@property (strong, nonatomic) IBOutlet WKInterfaceButton* hand2Button;
@property (strong, nonatomic) IBOutlet WKInterfaceButton* hand3Button;
@property (strong, nonatomic) IBOutlet WKInterfaceButton* hand4Button;
@property (strong, nonatomic) IBOutlet WKInterfaceButton* hand5Button;
@property (strong, nonatomic) IBOutlet WKInterfaceButton* hand6Button;

@property (strong, nonatomic) NSArray* handCardImages;

@property (strong, nonatomic) NSMutableArray* masterDeck;
@property (strong, nonatomic) NSMutableArray* shuffleDeck;
@property (strong, nonatomic) NSMutableArray* hand0;
@property (strong, nonatomic) NSMutableArray* hand1;
@property (strong, nonatomic) NSMutableArray* hand2;
@property (strong, nonatomic) NSMutableArray* hand3;
@property (strong, nonatomic) NSMutableArray* hand4;
@property (strong, nonatomic) NSMutableArray* hand5;
@property (strong, nonatomic) NSMutableArray* hand6;
@property (strong, nonatomic) NSArray* handArray;
@property (strong, nonatomic) NSMutableArray* discard1;
@property (strong, nonatomic) NSMutableArray* discard2;
@property (strong, nonatomic) NSMutableArray* discard3;
@property (strong, nonatomic) NSMutableArray* discard4;
@property (strong, nonatomic) NSArray* discardArray;
@property (strong, nonatomic) NSMutableArray* deckStack;
@property (strong, nonatomic) NSMutableArray* deckFlip;
@property (strong, nonatomic) NSMutableArray* deckFlipDiscard;
@property (strong, nonatomic) NSNumber* flipCardsNumber;

@property (strong, nonatomic) IBOutlet WKInterfaceGroup* discardRow;
@property (strong, nonatomic) IBOutlet WKInterfaceGroup* flipDeckRow;

-(IBAction)deckStackAction:(id)sender;
-(IBAction)deckFlipAction:(id)sender;
-(IBAction)discard1Action:(id)sender;
-(IBAction)discard2Action:(id)sender;
-(IBAction)discard3Action:(id)sender;
-(IBAction)discard4Action:(id)sender;
-(IBAction)handStack1Action:(id)sender;
-(IBAction)handStack2Action:(id)sender;
-(IBAction)handStack3Action:(id)sender;
-(IBAction)handStack4Action:(id)sender;
-(IBAction)handStack5Action:(id)sender;
-(IBAction)handStack6Action:(id)sender;
-(IBAction)handStack7Action:(id)sender;


@property BOOL isStackEmpty;// = true;
@property int lastFlipCount;// = 3;//[self.deckFlip count];
@property BOOL hasSelected;// = false;
@property int selectedAction;
@property WKInterfaceObject* selectedImage;
@property NSUserDefaults* sharedDefaults;
@property MMWormhole* wormhole;
@property (nonatomic,strong) NSString* voiceResponse;
@property (strong, nonatomic) SolitaireGameState* gameState;
@end


static const int SELECTED_STACK_0 = 0;
static const int SELECTED_STACK_1 = 1;
static const int SELECTED_STACK_2 = 2;
static const int SELECTED_STACK_3 = 3;
static const int SELECTED_STACK_4 = 4;
static const int SELECTED_STACK_5 = 5;
static const int SELECTED_STACK_6 = 6;
static const int SELECTED_DISCARD_1 = 7;
static const int SELECTED_DISCARD_2 = 8;
static const int SELECTED_DISCARD_3 = 9;
static const int SELECTED_DISCARD_4 = 10;
static const int SELECTED_FLIP = 11;
static NSArray *skins;// = @[@"1",@""];
static const NSArray* cardNames;// = @[@"Unknown",@"Ace",@"One",@"Two",@"Three",@"Four",@"Five",@"Six",@"Seven",@"Eight",@"Nine",@"Ten",@"Jack",@"Queen",@"King"];
static NSString* const kSavedDataKey = @"savedata";
static NSString* const kSavedDataSchemaVersionKey = @"savedata_schema_version";
static NSString* const kFlipCardNumberKey = @"flipcardnumber";
static NSString* const kSolvedDealsKey = @"solved_deals";
static NSString* const kSolvedDealSelectionModeKey = @"solved_deal_selection_mode";
static NSString* const kSolvedDealFixedIndexKey = @"solved_deal_fixed_index";
static NSString* const kSolvedDealRoundRobinIndexKey = @"solved_deal_round_robin_index";
static NSString* const kSolvedDealLastIndexKey = @"solved_deal_last_index";
static NSInteger const kSaveStateStackCount = 14;
static NSInteger const kTotalCardsInDeck = 52;
static NSInteger const kCurrentSaveStateSchemaVersion = 2;

@interface SolitaireGameState : NSObject
@property (strong, nonatomic) NSMutableArray* masterDeck;
@property (strong, nonatomic) NSMutableArray* shuffleDeck;
@property (strong, nonatomic) NSMutableArray* deckStack;
@property (strong, nonatomic) NSMutableArray* deckFlip;
@property (strong, nonatomic) NSMutableArray* deckFlipDiscard;
@property (strong, nonatomic) NSArray* handArray;
@property (strong, nonatomic) NSArray* discardArray;
-(instancetype) initWithMasterDeck:(NSMutableArray*) masterDeck
                        shuffleDeck:(NSMutableArray*) shuffleDeck
                          deckStack:(NSMutableArray*) deckStack
                           deckFlip:(NSMutableArray*) deckFlip
                    deckFlipDiscard:(NSMutableArray*) deckFlipDiscard
                          handArray:(NSArray*) handArray
                       discardArray:(NSArray*) discardArray;
@end

@implementation SolitaireGameState
-(instancetype) initWithMasterDeck:(NSMutableArray*) masterDeck
                        shuffleDeck:(NSMutableArray*) shuffleDeck
                          deckStack:(NSMutableArray*) deckStack
                           deckFlip:(NSMutableArray*) deckFlip
                    deckFlipDiscard:(NSMutableArray*) deckFlipDiscard
                          handArray:(NSArray*) handArray
                       discardArray:(NSArray*) discardArray
{
    self = [super init];
    if (self)
    {
        self.masterDeck = masterDeck;
        self.shuffleDeck = shuffleDeck;
        self.deckStack = deckStack;
        self.deckFlip = deckFlip;
        self.deckFlipDiscard = deckFlipDiscard;
        self.handArray = handArray;
        self.discardArray = discardArray;
    }
    return self;
}
@end

@interface SolitaireGameEngine : NSObject
+(void) moveCards:(int) cards fromStack:(NSMutableArray*) fromStack toStack:(NSMutableArray*) toStack orderPreserved:(BOOL) preserved;
+(void) moveCards:(int) cards fromStack:(NSMutableArray*) fromStack toStack:(NSMutableArray*) toStack dealStacked:(BOOL) dealStacked;
+(void) flipFromDeckInState:(SolitaireGameState*) state flipCardsNumber:(NSNumber*) flipCardsNumber;
+(void) dealToStacksInState:(SolitaireGameState*) state;
+(void) shuffleMasterDeckInState:(SolitaireGameState*) state;
@end

@implementation SolitaireGameEngine
+(void) moveCards:(int) cards fromStack:(NSMutableArray*) fromStack toStack:(NSMutableArray*) toStack orderPreserved:(BOOL) preserved
{
    int frontIndex =(int)[fromStack count]-cards;
    for(int i = 0; i < cards; i++)
    {
        Card* card = [fromStack objectAtIndex:frontIndex];
        if (card != nil)
        {
            [fromStack removeObjectAtIndex:frontIndex];
            [toStack addObject:card];
        }
    }
}

+(void) moveCards:(int) cards fromStack:(NSMutableArray*) fromStack toStack:(NSMutableArray*) toStack dealStacked:(BOOL) dealStacked
{
    for(int i = 0; i < cards; i++)
    {
        Card* card = [fromStack lastObject];
        if (card != nil)
        {
            if (dealStacked && i == cards-1)
            {
                card.isFacingUp = YES;
            }
            [fromStack removeLastObject];
            [toStack addObject:card];
        }
    }
}

+(void) flipFromDeckInState:(SolitaireGameState*) state flipCardsNumber:(NSNumber*) flipCardsNumber
{
    if ([flipCardsNumber intValue] == 3)
    {
        if ([state.deckStack count] == 0)
        {
            [self moveCards:(int)[state.deckFlip count] fromStack:state.deckFlip toStack:state.deckFlipDiscard orderPreserved:YES];
            [self moveCards:(int)[state.deckFlipDiscard count] fromStack:state.deckFlipDiscard toStack:state.deckStack dealStacked:NO];
        }
        [self moveCards:(int)[state.deckFlip count] fromStack:state.deckFlip toStack:state.deckFlipDiscard orderPreserved:YES];
        [self moveCards:[flipCardsNumber intValue] fromStack:state.deckStack toStack:state.deckFlip dealStacked:NO];
    }
    else
    {
        if ([state.deckStack count] == 0)
        {
            [self moveCards:(int)[state.deckFlip count] fromStack:state.deckFlip toStack:state.deckFlipDiscard orderPreserved:YES];
            [self moveCards:(int)[state.deckFlipDiscard count] fromStack:state.deckFlipDiscard toStack:state.deckStack dealStacked:NO];
        }
        if ([state.deckFlip count] < 3)
        {
            [self moveCards:1 fromStack:state.deckStack toStack:state.deckFlip dealStacked:NO];
        }
        else
        {
            [self moveCards:(int)[state.deckFlip count] fromStack:state.deckFlip toStack:state.deckFlipDiscard orderPreserved:YES];
            [self moveCards:[flipCardsNumber intValue] fromStack:state.deckStack toStack:state.deckFlip dealStacked:NO];
        }
    }
}

+(void) dealToStacksInState:(SolitaireGameState*) state
{
    [self moveCards:1 fromStack:state.masterDeck toStack:[state.handArray objectAtIndex:0] dealStacked:YES];
    [self moveCards:2 fromStack:state.masterDeck toStack:[state.handArray objectAtIndex:1] dealStacked:YES];
    [self moveCards:3 fromStack:state.masterDeck toStack:[state.handArray objectAtIndex:2] dealStacked:YES];
    [self moveCards:4 fromStack:state.masterDeck toStack:[state.handArray objectAtIndex:3] dealStacked:YES];
    [self moveCards:5 fromStack:state.masterDeck toStack:[state.handArray objectAtIndex:4] dealStacked:YES];
    [self moveCards:6 fromStack:state.masterDeck toStack:[state.handArray objectAtIndex:5] dealStacked:YES];
    [self moveCards:7 fromStack:state.masterDeck toStack:[state.handArray objectAtIndex:6] dealStacked:YES];
    [self moveCards:(int)[state.masterDeck count] fromStack:state.masterDeck toStack:state.deckStack dealStacked:NO];
    for (int i = 0; i < [state.deckStack count]; i++)
    {
        Card* deckCard = [state.deckStack objectAtIndex:i];
        [deckCard setIsFacingUp:YES];
    }
}

+(void) shuffleMasterDeckInState:(SolitaireGameState*) state
{
    [state.shuffleDeck removeAllObjects];
    while([state.masterDeck count] > 0)
    {
        int randomIndex = arc4random_uniform((u_int32_t )[state.masterDeck count]);
        Card* card = [state.masterDeck objectAtIndex:randomIndex];
        [state.masterDeck removeObject:card];
        [state.shuffleDeck addObject:card];
    }
    while([state.shuffleDeck count] > 0)
    {
        int randomIndex = arc4random_uniform((u_int32_t )[state.shuffleDeck count]);
        Card* card = [state.shuffleDeck objectAtIndex:randomIndex];
        [state.shuffleDeck removeObject:card];
        [state.masterDeck addObject:card];
    }
}
@end

@interface SolitaireSolvedDealProvider : NSObject
+(NSArray<NSNumber*>*) nextDealOrderFromDefaults:(NSUserDefaults*) defaults;
+(BOOL) isValidDealOrder:(NSArray*) candidate;
@end

@implementation SolitaireSolvedDealProvider

+(BOOL) isValidDealOrder:(NSArray*) candidate
{
    if (![candidate isKindOfClass:[NSArray class]] || [candidate count] != 52)
    {
        return NO;
    }
    NSMutableSet* unique = [[NSMutableSet alloc] initWithCapacity:52];
    for (id value in candidate)
    {
        if (![value isKindOfClass:[NSNumber class]])
        {
            return NO;
        }
        NSInteger index = [value integerValue];
        if (index < 0 || index > 51)
        {
            return NO;
        }
        [unique addObject:@(index)];
    }
    return [unique count] == 52;
}

+(NSArray<NSNumber*>*) sequenceDealWithOffset:(NSInteger) offset
{
    NSMutableArray* sequence = [[NSMutableArray alloc] initWithCapacity:52];
    for (NSInteger i = 0; i < 52; i++)
    {
        [sequence addObject:@((i + offset) % 52)];
    }
    return sequence;
}

+(NSArray<NSArray<NSNumber*>*>*) bootstrapDeals
{
    NSMutableArray* reverse = [[NSMutableArray alloc] initWithCapacity:52];
    for (NSInteger i = 51; i >= 0; i--)
    {
        [reverse addObject:@(i)];
    }
    return @[
        [self sequenceDealWithOffset:0],
        [self sequenceDealWithOffset:13],
        reverse
    ];
}

+(NSArray<NSArray<NSNumber*>*>*) validatedDealsFromDefaults:(NSUserDefaults*) defaults
{
    NSMutableArray* validDeals = [[NSMutableArray alloc] init];
    NSArray* rawDeals = [defaults objectForKey:kSolvedDealsKey];
    if ([rawDeals isKindOfClass:[NSArray class]])
    {
        for (id record in rawDeals)
        {
            if ([self isValidDealOrder:record])
            {
                [validDeals addObject:record];
            }
        }
    }
    if ([validDeals count] == 0)
    {
        for (NSArray<NSNumber*>* fallbackDeal in [self bootstrapDeals])
        {
            [validDeals addObject:fallbackDeal];
        }
    }
    return validDeals;
}

+(NSInteger) normalizedIndex:(NSInteger) index count:(NSInteger) count
{
    if (count <= 0)
    {
        return NSNotFound;
    }
    NSInteger normalized = index % count;
    if (normalized < 0)
    {
        normalized += count;
    }
    return normalized;
}

+(NSArray<NSNumber*>*) nextDealOrderFromDefaults:(NSUserDefaults*) defaults
{
    NSArray<NSArray<NSNumber*>*>* deals = [self validatedDealsFromDefaults:defaults];
    if ([deals count] == 0)
    {
        return nil;
    }

    NSString* mode = [defaults objectForKey:kSolvedDealSelectionModeKey];
    if (![mode isKindOfClass:[NSString class]] || [mode length] == 0)
    {
        mode = @"random";
    }

    NSInteger selectedIndex = 0;
    if ([mode isEqualToString:@"fixed"])
    {
        NSInteger fixed = [[defaults objectForKey:kSolvedDealFixedIndexKey] integerValue];
        selectedIndex = [self normalizedIndex:fixed count:[deals count]];
    }
    else if ([mode isEqualToString:@"round_robin"])
    {
        NSInteger cursor = [[defaults objectForKey:kSolvedDealRoundRobinIndexKey] integerValue];
        selectedIndex = [self normalizedIndex:cursor count:[deals count]];
        NSInteger nextCursor = [self normalizedIndex:selectedIndex + 1 count:[deals count]];
        [defaults setObject:@(nextCursor) forKey:kSolvedDealRoundRobinIndexKey];
    }
    else
    {
        selectedIndex = arc4random_uniform((u_int32_t)[deals count]);
    }

    [defaults setObject:@(selectedIndex) forKey:kSolvedDealLastIndexKey];
    [defaults synchronize];
    return [deals objectAtIndex:selectedIndex];
}

@end

@implementation InterfaceController

-(CGFloat) currentWatchLogicalWidth
{
    CGRect screenBounds = [[WKInterfaceDevice currentDevice] screenBounds];
    CGFloat width = MIN(screenBounds.size.width, screenBounds.size.height);
    if (!isfinite(width) || width <= 0)
    {
        width = 136.0f;
    }
    return width;
}

-(CGFloat) currentWatchLogicalHeight
{
    CGRect screenBounds = [[WKInterfaceDevice currentDevice] screenBounds];
    CGFloat height = MAX(screenBounds.size.width, screenBounds.size.height);
    if (!isfinite(height) || height <= 0)
    {
        height = 170.0f;
    }
    return height;
}

-(CGFloat) topChromeReservedHeight
{
    CGFloat width = [self currentWatchLogicalWidth];
    CGFloat reserved = width * 0.32f;
    if (reserved < 44.0f)
    {
        reserved = 44.0f;
    }
    if (reserved > 62.0f)
    {
        reserved = 62.0f;
    }
    return reserved;
}

-(CGFloat) layoutScale
{
    CGFloat scale = [self currentWatchLogicalWidth] / 136.0f;
    if (!isfinite(scale) || scale <= 0)
    {
        scale = 1.0f;
    }
    if (scale < 0.85f)
    {
        scale = 0.85f;
    }
    if (scale > 1.60f)
    {
        scale = 1.60f;
    }
    return scale;
}

-(NSInteger) scaledIntegerFromBase:(CGFloat) base minimum:(NSInteger) minimum maximum:(NSInteger) maximum
{
    NSInteger value = (NSInteger)lroundf(base * [self layoutScale]);
    if (value < minimum)
    {
        value = minimum;
    }
    if (value > maximum)
    {
        value = maximum;
    }
    return value;
}

-(void) applyResponsiveLayout
{
    NSInteger discardRowHeight = [self getHeightOfDiscardRow];
    NSInteger flipRowHeight = [self getHeightOfFlipRow];
    NSInteger cardWidth = [self cardWidth];
    NSInteger cardHeight = [self cardHeight];
    NSInteger hiddenFlipSize = [self hiddenFlipWidth];
    NSInteger stackPeekSize = [self stackPeekWidth];
    NSInteger boardHeight = (NSInteger)lroundf([self currentWatchLogicalHeight] - [self topChromeReservedHeight] - discardRowHeight - flipRowHeight);
    if (boardHeight < 108)
    {
        boardHeight = 108;
    }
    if (boardHeight > 238)
    {
        boardHeight = 238;
    }

    [self.discardRow setHeight:discardRowHeight];
    [self.flipDeckRow setHeight:flipRowHeight];

    [self.deckStackButton setWidth:(cardWidth + (stackPeekSize * 2))];
    [self.deckStackButton setHeight:cardHeight];
    [self.deckFlipButton setWidth:(cardWidth + (hiddenFlipSize * 2))];
    [self.deckFlipButton setHeight:cardHeight];

    [self.discard1Button setWidth:cardWidth];
    [self.discard1Button setHeight:cardHeight];
    [self.discard2Button setWidth:cardWidth];
    [self.discard2Button setHeight:cardHeight];
    [self.discard3Button setWidth:cardWidth];
    [self.discard3Button setHeight:cardHeight];
    [self.discard4Button setWidth:cardWidth];
    [self.discard4Button setHeight:cardHeight];

    [self.deckStack1Image setWidth:cardWidth];
    [self.deckStack1Image setHeight:cardHeight];
    [self.deckStack2Image setWidth:stackPeekSize];
    [self.deckStack2Image setHeight:cardHeight];
    [self.deckStack3Image setWidth:stackPeekSize];
    [self.deckStack3Image setHeight:cardHeight];

    [self.deckFlip1Image setWidth:hiddenFlipSize];
    [self.deckFlip1Image setHeight:cardHeight];
    [self.deckFlip2Image setWidth:hiddenFlipSize];
    [self.deckFlip2Image setHeight:cardHeight];
    [self.deckFlip3Image setWidth:cardWidth];
    [self.deckFlip3Image setHeight:cardHeight];

    [self.discard1Image setWidth:cardWidth];
    [self.discard1Image setHeight:cardHeight];
    [self.discard2Image setWidth:cardWidth];
    [self.discard2Image setHeight:cardHeight];
    [self.discard3Image setWidth:cardWidth];
    [self.discard3Image setHeight:cardHeight];
    [self.discard4Image setWidth:cardWidth];
    [self.discard4Image setHeight:cardHeight];

    [self.hand0Button setHeight:boardHeight];
    [self.hand1Button setHeight:boardHeight];
    [self.hand2Button setHeight:boardHeight];
    [self.hand3Button setHeight:boardHeight];
    [self.hand4Button setHeight:boardHeight];
    [self.hand5Button setHeight:boardHeight];
    [self.hand6Button setHeight:boardHeight];
}

-(void) setupAccessibility
{
    //if ( == 1)
   // {
    // Need to check the number of cards in deck.
    // Tell them when they run out.
    [self.deckStackButton setAccessibilityLabel:[NSString stringWithFormat:@"Turns %d card%@ from deck to waste stack.",[self.flipCardsNumber intValue],([self.flipCardsNumber intValue]>1?@"s":@"")]];
    
    Card* waste = [self.deckFlip lastObject];
    if (waste == nil)
    {
        // actually the waste button
        [self.deckFlipButton setAccessibilityLabel:@"No card on the waste stack."];
    }
    else
    {
        [self.deckFlipButton setAccessibilityLabel:[NSString stringWithFormat:@"Plays %@ from waste stack.",[waste cardName]]];
    }
   // }
    //tableau piles
    // waste
    
}

-(IBAction)changeCardSkin
{
    if (skins == nil)
    {
        skins = @[@"classic",@"launch"];
    }
    
    int skinIndex = [[self.sharedDefaults objectForKey:@"skinindex"] intValue];
    skinIndex++;
    if (skinIndex >= [skins count])
    {
        skinIndex = 0;
    }
    
    [self.sharedDefaults setObject:[skins objectAtIndex:skinIndex] forKey:@"cardskin"];
    NSLog(@"skin index:%@",[skins objectAtIndex:skinIndex]);
    [self.sharedDefaults setObject:[NSString stringWithFormat:@"%d",skinIndex] forKey:@"skinindex"];
    
    [self loadMasterDeck];
    
    [self redealCards];
}

-(IBAction)cardsToggle
{
    [self select1card];
}

-(IBAction)redealCards
{
    [self resetBoard];
}

-(NSString*) getCommandText:(PossibleMove*) possibleMove
{
    return [NSString stringWithFormat:@"Add %d of %@s to %d of %@s",(int)possibleMove.fromCard.value, possibleMove.fromCard.suite,(int)possibleMove.toCard.value,possibleMove.toCard.suite];
}

-(NSString*) convertStringToSymbolic:(NSString*) input
{
    NSString* conversionResult = input;
    conversionResult = [conversionResult stringByReplacingOccurrencesOfString:@"Ace" withString:@"A"];
    conversionResult = [conversionResult stringByReplacingOccurrencesOfString:@"Two" withString:@"2"];
    conversionResult = [conversionResult stringByReplacingOccurrencesOfString:@"Three" withString:@"3"];
    conversionResult = [conversionResult stringByReplacingOccurrencesOfString:@"Four" withString:@"4"];
    conversionResult = [conversionResult stringByReplacingOccurrencesOfString:@"Five" withString:@"5"];
    conversionResult = [conversionResult stringByReplacingOccurrencesOfString:@"Six" withString:@"6"];
    conversionResult = [conversionResult stringByReplacingOccurrencesOfString:@"Seven" withString:@"7"];
    conversionResult = [conversionResult stringByReplacingOccurrencesOfString:@"Eight" withString:@"8"];
    conversionResult = [conversionResult stringByReplacingOccurrencesOfString:@"Nine" withString:@"9"];
    conversionResult = [conversionResult stringByReplacingOccurrencesOfString:@"Ten" withString:@"10"];
    conversionResult = [conversionResult stringByReplacingOccurrencesOfString:@"Jack" withString:@"J"];
    conversionResult = [conversionResult stringByReplacingOccurrencesOfString:@"Queen" withString:@"Q"];
    conversionResult = [conversionResult stringByReplacingOccurrencesOfString:@"King" withString:@"K"];
    conversionResult = [conversionResult stringByReplacingOccurrencesOfString:@"hearts" withString:@"♥️"];
    conversionResult = [conversionResult stringByReplacingOccurrencesOfString:@"diamonds" withString:@"♦️"];
    conversionResult = [conversionResult stringByReplacingOccurrencesOfString:@"clubs" withString:@"♣️"];
    conversionResult = [conversionResult stringByReplacingOccurrencesOfString:@"spades" withString:@"♠️"];
    return conversionResult;
}

-(void) clickedAnyButton
{
    NSArray* moves = [self determinePossibleMovesOnBoard];
    for(int i = 0; i < [moves count]; i++)
    {
        PossibleMove* move = [moves objectAtIndex:i];
        Card* toCard = [move.toArray lastObject];
        NSLog(@"moves: %d of %@ to %d of %@ %@",(int)move.fromCard.value, move.fromCard.suite,(int)toCard.value,toCard.suite, move.typeOfMove );
    }
    
    if (isVoiceControlled)
    {
        // Now, let's launch the controller!
        // Build an array of possible commands.
        // Flip is first always.
        NSMutableArray* commands = nil;
        if (isUsingMoves)
        {
            commands = [NSMutableArray array];
            [commands addObject:@"Flip"];
            for(int i = 0; i < [moves count]; i++)
            {
                PossibleMove* move = [moves objectAtIndex:i];
                if (move.typeOfMove != nil)
                {
                    [commands addObject:move.typeOfMove];
                }
                //NSString* nameOfCard = [[move fromCard] cardName];
                //NSLog(@"move:%@",move.typeOfMove);
                //[commands addObject:nameOfCard];
            }
        }
        
        if ([commands count] > 1)
        {
            int oneTouchResult = [self getOneTouchIndex:lastFromTouched];
            if (oneTouchResult > 1)
            {
                [commands exchangeObjectAtIndex:oneTouchResult withObjectAtIndex:1];
            }
        }
        // Now, let's find the command that would have been one touch and move it to index of 1.
        
        
        
        [self presentTextInputControllerWithSuggestions:commands allowedInputMode:WKTextInputModePlain completion:^(NSArray *results) {
            self.voiceResponse =[results objectAtIndex:0];
            [NSTimer scheduledTimerWithTimeInterval:.001f target:self selector:@selector(processVoiceResponse) userInfo:nil repeats:NO];
        }];
    }
}


-(int) getOneTouchIndex:(int)touchIndex
{
    NSArray* moves = [self determinePossibleMovesOnBoard];
    //PossibleMove* possible = nil;
    for(int i = 0; i < [moves count]; i++)
    {
        PossibleMove* maybepossible = [moves objectAtIndex:i];
        if (maybepossible.fromIndex == touchIndex)
        {
            return i;
        }
    }
    return -1;
}

-(BOOL) processOneTouch:(int)touchIndex
{
    NSArray* moves = [self determinePossibleMovesOnBoard];
    PossibleMove* possible = nil;
    for(int i = 0; i < [moves count]; i++)
    {
        PossibleMove* maybepossible = [moves objectAtIndex:i];
        if (maybepossible.fromIndex == touchIndex)
        {
            possible = maybepossible;
            break;
        }
    }
    
    if (possible != nil)
    {
        [self handleMoveFrom:possible.fromIndex to:possible.toIndex];
        return YES;
    }
    return NO;
}

-(void) processVoiceResponse
{
    NSArray* moves = [self determinePossibleMovesOnBoard];
    if ([[self.voiceResponse lowercaseString] isEqualToString:@"1 card"]
        || [[self.voiceResponse lowercaseString] isEqualToString:@"one card"])
    {
        // Flip it!
        self.flipCardsNumber = [NSNumber numberWithInt:1];
        
        [self.sharedDefaults setObject:self.flipCardsNumber forKey:kFlipCardNumberKey];
        [self.sharedDefaults synchronize];
        
        [self resetBoard];
        return;
    }
    else
        if ([[self.voiceResponse lowercaseString] isEqualToString:@"3 card"]
            || [[self.voiceResponse lowercaseString] isEqualToString:@"three card"])
        {
            self.flipCardsNumber = [NSNumber numberWithInt:3];
            
            [self.sharedDefaults setObject:self.flipCardsNumber forKey:kFlipCardNumberKey];
            [self.sharedDefaults synchronize];
            
            [self resetBoard];
            return;
        }
        else
    if ([[self.voiceResponse lowercaseString] isEqualToString:@"flip"])
    {
        // Flip it!
        [self moveFlipFromStack];
        return;
    }
    if ([[self.voiceResponse lowercaseString] isEqualToString:@"redeal"]
        || [[self.voiceResponse lowercaseString] isEqualToString:@"read deal"]
        || [[self.voiceResponse lowercaseString] isEqualToString:@"deal again"]
        || [[self.voiceResponse lowercaseString] isEqualToString:@"read"]
        || [[self.voiceResponse lowercaseString] isEqualToString:@"review"])
    {
        // Flip it!
        [self resetBoard];
        return;
    }
    else
    {
        // Look for a match in the moves list.
        for(int i = 0; i < [moves count]; i++)
        {
            PossibleMove* move = [moves objectAtIndex:i];
            if ([[self.voiceResponse lowercaseString] isEqualToString:[move.typeOfMove lowercaseString]])
            {
                // We found a move!
                
                NSLog(@"Player moved! %d of %@ to %d of %@ %@",(int)move.fromCard.value, move.fromCard.suite,(int)move.toCard.value,move.toCard.suite, move.typeOfMove );
                // Now, let's try processing the move?
                //[self move:1 CardsFromStack:move.fromArray toStack:move.toArray dealStacked:YES];
                [self handleMoveFrom:move.fromIndex to:move.toIndex];
                //[self renderFullBoard];
                return;
            }
                
        }
        
        // Now, let's use the from card to trigger on only a number and suit.
        NSArray* words = [self.voiceResponse componentsSeparatedByString:@" "];
        // Look to see if the words matches anything in the cardNames array.
        // Format assumed: 'Ace of Spades"
        if ([words count] == 3)
        {
            int valueFound = -1;
            NSString* suitFound = nil;
            for(int i = 1; i < [cardNames count]; i++)
            {
                if ([[[cardNames objectAtIndex:i] lowercaseString] isEqualToString:[[words objectAtIndex:0]lowercaseString]])
                {
                    // Found a card value!
                    valueFound = i;
                    // Now, let's look for a suit.
                    if ([[[words objectAtIndex:2] lowercaseString] isEqualToString:@"spade"]
                        || [[[words objectAtIndex:2] lowercaseString] isEqualToString:@"spades"])
                    {
                        suitFound = @"spades";
                    }
                    
                    if ([[[words objectAtIndex:2] lowercaseString] isEqualToString:@"heart"]
                        || [[[words objectAtIndex:2] lowercaseString] isEqualToString:@"hearts"])
                    {
                        suitFound = @"hearts";
                    }
                    
                    if ([[[words objectAtIndex:2] lowercaseString] isEqualToString:@"club"]
                        || [[[words objectAtIndex:2] lowercaseString] isEqualToString:@"clubs"])
                    {
                        suitFound = @"clubs";
                    }
                    
                    if ([[[words objectAtIndex:2] lowercaseString] isEqualToString:@"diamond"]
                        || [[[words objectAtIndex:2] lowercaseString] isEqualToString:@"diamonds"])
                    {
                        suitFound = @"diamonds";
                    }
                    
                    if (suitFound != nil && valueFound > 0)
                    {
                        // Now, let's look through the moves and see if we can match this to the card names.
                        for( int j = 0; j < [moves count]; j++)
                        {
                            PossibleMove* move = [moves objectAtIndex:j];
                            Card* fromCard = move.fromCard;
                            NSLog(@"Compare: %@ to %@",[[fromCard cardName] lowercaseString],[NSString stringWithFormat:@"%@ of %@",[cardNames objectAtIndex:valueFound],suitFound]);
                            if ([[[fromCard cardName] lowercaseString] isEqualToString:[[NSString stringWithFormat:@"%@ of %@",[cardNames objectAtIndex:valueFound],suitFound]lowercaseString]])
                            {
                                // We found a move!!!
                                [self handleMoveFrom:move.fromIndex to:move.toIndex];
                                return;
                            }
                        }
                    }
                    
                    return;
                }
            }
        }
    }
    

}
// nil if not possible.
-(PossibleMove*) isMovePossibleFrom:(NSMutableArray*) _from to:(NSMutableArray*) _to isAscending:(BOOL) isAscending andSameColor:(BOOL) sameColor andSameSuit:(BOOL)sameSuit moveLabel:(NSString*) typeOfMove
{
    Card* from = [_from lastObject];
    Card* to = [_to lastObject];
    
    if (isAscending)
    {
        // Now check it?
        if ([from value] == [to value] + 1)
        {
            if (sameSuit)
            {
                if ([[from suite] isEqualToString: [to suite]])
                {
                    PossibleMove* possibleMove = [[PossibleMove alloc] init];
                    [possibleMove setFromCard:from];
                    [possibleMove setToCard:to];
                    [possibleMove setFromArray:_from];
                    [possibleMove setToArray:_to];
                    [possibleMove setTypeOfMove:typeOfMove];
                    return possibleMove;
                }
            }
            else
            if (sameColor)
            {
                if ([[from color] isEqualToString: [to color]])
                {
                    PossibleMove* possibleMove = [[PossibleMove alloc] init];
                    [possibleMove setFromCard:from];
                    [possibleMove setToCard:to];
                    [possibleMove setFromArray:_from];
                    [possibleMove setToArray:_to];
                    [possibleMove setTypeOfMove:typeOfMove];
                    return possibleMove;
                }
            }
            else
            {
                if (![[from color] isEqualToString: [to color]])
                {
                    PossibleMove* possibleMove = [[PossibleMove alloc] init];
                    [possibleMove setFromCard:from];
                    [possibleMove setToCard:to];
                    [possibleMove setFromArray:_from];
                    [possibleMove setToArray:_to];
                    [possibleMove setTypeOfMove:typeOfMove];
                    return possibleMove;
                }
            }
        }
        else
        {
            return nil;
        }
    }
    else
    {
        // Now check it?
        if ([from value] + 1 == [to value])
        {
            if (sameSuit)
            {
                if ([[from suite] isEqualToString: [to suite]])
                {
                    PossibleMove* possibleMove = [[PossibleMove alloc] init];
                    [possibleMove setFromCard:from];
                    [possibleMove setToCard:to];
                    [possibleMove setFromArray:_from];
                    [possibleMove setToArray:_to];
                    [possibleMove setTypeOfMove:typeOfMove];
                    return possibleMove;
                }
            }
            else
            if (sameColor)
            {
                if ([[from color] isEqualToString: [to color]])
                {
                    PossibleMove* possibleMove = [[PossibleMove alloc] init];
                    [possibleMove setFromCard:from];
                    [possibleMove setToCard:to];
                    [possibleMove setFromArray:_from];
                    [possibleMove setToArray:_to];
                    [possibleMove setTypeOfMove:typeOfMove];
                    return possibleMove;
                }
            }
            else
            {
                if (![[from color] isEqualToString: [to color]])
                {
                    PossibleMove* possibleMove = [[PossibleMove alloc] init];
                    [possibleMove setFromCard:from];
                    [possibleMove setToCard:to];
                    [possibleMove setFromArray:_from];
                    [possibleMove setToArray:_to];
                    [possibleMove setTypeOfMove:typeOfMove];
                    return possibleMove;
                }
            }
        }
        else
        {
            return nil;
        }
    }
    return nil;
}

-(NSArray*) determinePossibleMovesOnBoard
{
    NSMutableArray* possibleMoves = [NSMutableArray array];
    NSLog(@"hand array:%d", (int)[self.handArray count]);
    
    // Now check the flip to empty suit move.
    // Need to handle the discard pile better, so aces can fill empties.
    Card* topOfFlip = [self.deckFlip lastObject];
    NSLog(@"Top of Flip: %d", (int)topOfFlip.value);
    if ([topOfFlip value] == 1)
    {
        // Let's look for an empty discard array.
        for(int i = 0; i < [self.discardArray count]; i++)
        {
            if ([[self.discardArray objectAtIndex:i] count] == 0)
            {
                // We got a move!!!
                PossibleMove* move = [[PossibleMove alloc] init];
                move.fromArray = self.deckFlip;
                move.toArray = [self.discardArray objectAtIndex:i];
                //move.typeOfMove = [NSString stringWithFormat:@"Move %@ to suit pile.",[topOfFlip cardName]];
                move.fromIndex = SELECTED_FLIP;
                move.toIndex = SELECTED_DISCARD_1+i;
                move.fromCard = topOfFlip;
                if (topOfFlip != nil)
                    [possibleMoves addObject:move];
                break;
            }
        }
    }
    
    // Now lets check Flipped King's against the stacks.
    if ([topOfFlip value] == 13)
    {
        // Let's look for an empty discard array.
        for(int i = 0; i < [self.handArray count]; i++)
        {
            if ([[self.handArray objectAtIndex:i] count] == 0)
            {
                // We got a move!!!
                PossibleMove* move = [[PossibleMove alloc] init];
                move.fromArray = self.deckFlip;
                move.toArray = [self.handArray objectAtIndex:i];
                //move.typeOfMove = [NSString stringWithFormat:@"Move %@ to suit pile.",[topOfFlip cardName]];
                move.fromIndex = SELECTED_FLIP;
                move.toIndex = SELECTED_STACK_0+i;
                move.fromCard = topOfFlip;
                //if (topOfFlip != nil)
                [possibleMoves addObject:move];
                break;
            }
        }
    }
    
    // Now, let's run a check against all the discard piles.
    for(int i = 0; i < [self.discardArray count]; i++)
    {
        // Check all hand to discard moves!
        for(int j = 0; j < [self.handArray count]; j++)
        {
            if ([self isMovePossibleFrom:[self.handArray objectAtIndex:j] to:[self.discardArray objectAtIndex:i] isAscending:YES andSameColor:YES andSameSuit:YES moveLabel:@""])
            {
                PossibleMove* move =[self isMovePossibleFrom:[self.handArray objectAtIndex:j] to:[self.discardArray objectAtIndex:i] isAscending:YES andSameColor:YES andSameSuit:YES moveLabel:[NSString stringWithFormat:@"Suit Stack %d to Hand %d",i+1,j+1]];
                Card* fromCard = [[self.handArray objectAtIndex:j] lastObject];
                Card* toCard = [[self.discardArray objectAtIndex:i] lastObject];
                //move.typeOfMove =[NSString stringWithFormat:@"Move %@ to %@",[fromCard cardName],[toCard cardName]];
                move.fromIndex = SELECTED_STACK_0+j;
                move.toIndex = SELECTED_DISCARD_1+i;
                move.fromCard = fromCard;
                if (fromCard != nil && toCard != nil)
                    [possibleMoves addObject:move];
            }
            else
            {
                // Need to handle the discard pile better, so aces can fill empties.
                Card* fromCard = [[self.handArray objectAtIndex:j] lastObject];
                if (fromCard != nil)
                {
                    if ([[self.discardArray objectAtIndex:i] count] == 0
                        && fromCard.value == 1)
                    {
                        PossibleMove* move = [[PossibleMove alloc] init];
                        move.fromArray = [self.handArray objectAtIndex:j];
                        move.toArray = [self.discardArray objectAtIndex:i];
                        //move.typeOfMove = [NSString stringWithFormat:@"Move %@ to suit pile.",[fromCard cardName]];
                        move.fromIndex = SELECTED_STACK_0+j;
                        move.toIndex = SELECTED_DISCARD_1+i;
                        move.fromCard = fromCard;
                        if (fromCard != nil)
                            [possibleMoves addObject:move];
                    }
                }
            }
        }
        
        // Check the flip to discard move.
        if ([self isMovePossibleFrom:self.deckFlip to:[self.discardArray objectAtIndex:i] isAscending:YES andSameColor:YES andSameSuit:YES moveLabel:@""])
        {
            PossibleMove* move = [self isMovePossibleFrom:self.deckFlip to:[self.discardArray objectAtIndex:i] isAscending:YES andSameColor:YES andSameSuit:YES moveLabel:[NSString stringWithFormat:@"Flip hand to Suit Stack %d",i+1]];
            Card* fromCard = [self.deckFlip lastObject];
            Card* toCard = [[self.discardArray objectAtIndex:i]lastObject];
            //move.typeOfMove =[NSString stringWithFormat:@"Move %@ to %@",[fromCard cardName],[toCard cardName]];
            move.fromIndex = SELECTED_FLIP;
            move.toIndex = SELECTED_DISCARD_1+i;
            move.fromCard = fromCard;
            if (fromCard != nil && toCard != nil)
                [possibleMoves addObject:move];
        }
    }
    
    for (int i = 0; i < [self.handArray count]; i++)
    {
        // Check all hand to hand moves!
        for(int j = 0; j < [self.handArray count]; j++)
        {
            // if (i == j)
            //   continue;
            
            if ([self isMovePossibleFrom:[self.handArray objectAtIndex:i] to:[self.handArray objectAtIndex:j] isAscending:NO andSameColor:NO andSameSuit:NO moveLabel:@""])
            {
                PossibleMove* move = [self isMovePossibleFrom:[self.handArray objectAtIndex:i] to:[self.handArray objectAtIndex:j] isAscending:NO andSameColor:NO andSameSuit:NO moveLabel:[NSString stringWithFormat:@"Hand %d to Hand %d",i+1,j+1]];
                // Set the indexes
                Card* fromCard = [[self.handArray objectAtIndex:i]lastObject];
                Card* toCard = [[self.handArray objectAtIndex:j]lastObject];
                move.fromCard = fromCard;
                //move.typeOfMove =[NSString stringWithFormat:@"Move %@ to %@",[fromCard cardName],[toCard cardName]];
                move.fromIndex = SELECTED_STACK_0+i;
                move.toIndex = SELECTED_STACK_0+j;
                
                if (fromCard != nil && toCard != nil)
                {
                    NSLog(@"move:%@",move.typeOfMove);
                    if (fromCard != nil && toCard != nil)
                        [possibleMoves addObject:move];
                }
            }
            else
            {
                // Let's check kings against empties.
                if ([[self.handArray objectAtIndex:j] count] == 0)
                {
                    Card* fromCard = [[self.handArray objectAtIndex:i] lastObject];
                    if (fromCard)
                    {
                        // Is it a Kind?
                        if (fromCard.value == 13)
                        {
                            PossibleMove* move = [[PossibleMove alloc] init];
                            move.fromArray =[self.handArray objectAtIndex:i];
                            move.toArray = [self.handArray objectAtIndex:j];
                            // Set the indexes
                            //move.typeOfMove = [NSString stringWithFormat:@"King of %@ to Empty Hand %d",fromCard.suite,j+1];
                            
                            //Card* fromCard = [[self.handArray objectAtIndex:i]lastObject];
                            move.fromCard = fromCard;
                            //move.typeOfMove =[NSString stringWithFormat:@"Move %@ to empty hand",[fromCard cardName]];
                            
                            move.fromIndex = SELECTED_STACK_0+i;
                            move.toIndex = SELECTED_STACK_0+j;
                            //if (fromCard != nil && toCard != nil)
                            [possibleMoves addObject:move];
                        }
                    }
                }
            }
        }
        
        
        // Now, let's check all moves from deck to hand?
        if ([self isMovePossibleFrom:self.deckFlip to:[self.handArray objectAtIndex:i] isAscending:NO andSameColor:NO andSameSuit:NO moveLabel:@""])
        {
            PossibleMove* move = [self isMovePossibleFrom:self.deckFlip to:[self.handArray objectAtIndex:i] isAscending:NO andSameColor:NO andSameSuit:NO moveLabel:[NSString stringWithFormat:@"Flipped Stack to Hand %d",i+1]];
            Card* fromCard = [self.deckFlip lastObject];
            Card* toCard = [[self.handArray objectAtIndex:i]lastObject];
            //move.typeOfMove =[NSString stringWithFormat:@"Move %@ to %@",[fromCard cardName],[toCard cardName]];
            move.fromIndex = SELECTED_FLIP;
            move.fromCard = fromCard;
            move.toIndex = SELECTED_STACK_0+i;
            if (fromCard != nil && toCard != nil)
                [possibleMoves addObject:move];
        }
        
        // Now, let's run all the discard checks to hands.
        if ([self isMovePossibleFrom:self.discard1 to:[self.handArray objectAtIndex:i] isAscending:NO andSameColor:NO andSameSuit:NO moveLabel:@""])
        {
            PossibleMove* move = [self isMovePossibleFrom:self.discard1 to:[self.handArray objectAtIndex:i] isAscending:NO andSameColor:NO andSameSuit:NO moveLabel:[NSString stringWithFormat:@"Suit Stack 1 to Hand %d",i+1]];
            Card* fromCard = [self.discard1 lastObject];
            Card* toCard = [[self.handArray objectAtIndex:i]lastObject];
            //move.typeOfMove =[NSString stringWithFormat:@"Move %@ to %@",[fromCard cardName],[toCard cardName]];
            move.fromIndex = SELECTED_DISCARD_1;
            move.toIndex = SELECTED_STACK_0+i;
            move.fromCard = fromCard;
            if (fromCard != nil && toCard != nil)
                [possibleMoves addObject: move];
        }
        
        if ([self isMovePossibleFrom:self.discard2 to:[self.handArray objectAtIndex:i] isAscending:NO andSameColor:NO andSameSuit:NO moveLabel:@""])
        {
            PossibleMove* move = [self isMovePossibleFrom:self.discard2 to:[self.handArray objectAtIndex:i] isAscending:NO andSameColor:NO andSameSuit:NO moveLabel:[NSString stringWithFormat:@"Suit Stack 2 to Hand %d",i+1]];
            Card* fromCard = [self.discard2 lastObject];
            Card* toCard = [[self.handArray objectAtIndex:i]lastObject];
            //move.typeOfMove =[NSString stringWithFormat:@"Move %@ to %@",[fromCard cardName],[toCard cardName]];
            move.fromIndex = SELECTED_DISCARD_2;
            move.toIndex = SELECTED_STACK_0+i;
            move.fromCard = fromCard;
            if (fromCard != nil && toCard != nil)
                [possibleMoves addObject:move];
        }
        
        if ([self isMovePossibleFrom:self.discard3 to:[self.handArray objectAtIndex:i] isAscending:NO andSameColor:NO andSameSuit:NO moveLabel:@""])
        {
            PossibleMove* move =[self isMovePossibleFrom:self.discard3 to:[self.handArray objectAtIndex:i] isAscending:NO andSameColor:NO andSameSuit:NO moveLabel:[NSString stringWithFormat:@"Suit Stack 3 to Hand %d",i+1]];
            Card* fromCard = [self.discard3 lastObject];
            Card* toCard = [[self.handArray objectAtIndex:i]lastObject];
            //move.typeOfMove =[NSString stringWithFormat:@"Move %@ to %@",[fromCard cardName],[toCard cardName]];
            move.fromIndex = SELECTED_DISCARD_3;
            move.toIndex = SELECTED_STACK_0+i;
            move.fromCard = fromCard;
            if (fromCard != nil && toCard != nil)
                [possibleMoves addObject:move];
        }
        
        if ([self isMovePossibleFrom:self.discard4 to:[self.handArray objectAtIndex:i] isAscending:NO andSameColor:NO andSameSuit:NO moveLabel:@""])
        {
            PossibleMove* move =[self isMovePossibleFrom:self.discard4 to:[self.handArray objectAtIndex:i] isAscending:NO andSameColor:NO andSameSuit:NO moveLabel:[NSString stringWithFormat:@"Suit Stack 4 to Hand %d",i+1]];
            Card* fromCard = [self.discard4 lastObject];
            Card* toCard = [[self.handArray objectAtIndex:i]lastObject];
            //move.typeOfMove =[NSString stringWithFormat:@"Move %@ to %@",[fromCard cardName],[toCard cardName]];
            move.fromIndex = SELECTED_DISCARD_4;
            move.toIndex = SELECTED_STACK_0+i;
            move.fromCard = fromCard;
            if (fromCard != nil && toCard != nil)
                [possibleMoves addObject:move];
        }
    }
    
    
    // Need to look up the pile for more possibilities?  Hm, can we skip this? no.
    // Now, let's check every card that is face up against all last cards.
    for(int i = 0; i < [self.handArray count]; i++)
    {
        NSArray* fromStack = [self.handArray objectAtIndex:i];
        // Skip the last card...already checked for...meaning start with -2 instead of -1.
        for(int j = ((int)[fromStack count]-2); j >= 0; j--)
        {
            //Card* lastCard = [fromStack lastObject];
            Card* fromCard = [fromStack objectAtIndex:j];
            //NSLog(@"1---last card:%@ target card:%@",lastCard,fromCard);
            if (!fromCard.isFacingUp)
            {
                // Only search cards facing up.
                break;
            }
            // Now, let's check this card against all the stacks!
            
            
            // Now, let's check the cards.
            for(int k = 0; k < [self.handArray count]; k++)
            {
                // NSLog(@"2---last card:%@ target card:%@",lastCard,fromCard);
                Card* toCard = [[self.handArray objectAtIndex:k] lastObject];
                
                if (fromCard.value == 13
                    && toCard == nil)
                {
                    PossibleMove* move = [[PossibleMove alloc] init];
                    move.fromIndex = SELECTED_STACK_0+i;
                    move.toIndex = SELECTED_STACK_0+k;
                    move.fromCard = fromCard;
                    move.toArray =[self.handArray objectAtIndex:k];
                    //move.fromArray = fromStack;//[fromStack objectAtIndex:j];
                    //NSArray* fromArray = [fromStack objectAtIndex:j];
                    // Card* lastCard = [fromStack lastObject];//[fromArray lastObject];
                    
                    // move.typeOfMove = [NSString stringWithFormat:@"Pile from %d of %@ through %d of %@ to %d of %@",(int)fromCard.value,fromCard.suite,(int)lastCard.value,lastCard.suite,(int)toCard.value,toCard.suite];
                    //NSLog(@"1---last card:%@ target card:%@",lastCard,fromCard);
                    //Card* fromCard = [self.deckFlip lastObject];
                    //Card* toCard = [self.handArray objectAtIndex:i];
                    //NSLog(@"--Move %@ through %@ to %@",fromCard,lastCard,toCard);
                    //move.typeOfMove =[NSString stringWithFormat:@"Move %@ through %@ to %@",[fromCard cardName],[lastCard cardName],[toCard cardName]];
                    if (fromCard != nil)
                        [possibleMoves addObject:move];
                }
                
                if (![fromCard.color isEqualToString:toCard.color]
                    && [fromCard value] == [toCard value]-1)
                {
                    //
                    // We found a stack move?
                    PossibleMove* move = [[PossibleMove alloc] init];
                    move.fromIndex = SELECTED_STACK_0+i;
                    move.toIndex = SELECTED_STACK_0+k;
                    move.fromCard = fromCard;
                    move.toArray =[self.handArray objectAtIndex:k];
                    //move.fromArray = fromStack;//[fromStack objectAtIndex:j];
                    //NSArray* fromArray = [fromStack objectAtIndex:j];
                    // Card* lastCard = [fromStack lastObject];//[fromArray lastObject];
                    
                    // move.typeOfMove = [NSString stringWithFormat:@"Pile from %d of %@ through %d of %@ to %d of %@",(int)fromCard.value,fromCard.suite,(int)lastCard.value,lastCard.suite,(int)toCard.value,toCard.suite];
                    //NSLog(@"1---last card:%@ target card:%@",lastCard,fromCard);
                    //Card* fromCard = [self.deckFlip lastObject];
                    //Card* toCard = [self.handArray objectAtIndex:i];
                    //NSLog(@"--Move %@ through %@ to %@",fromCard,lastCard,toCard);
                    //move.typeOfMove =[NSString stringWithFormat:@"Move %@ through %@ to %@",[fromCard cardName],[lastCard cardName],[toCard cardName]];
                    if (fromCard != nil && toCard != nil)
                        [possibleMoves addObject:move];
                }
            }
        }
    }
    
    return possibleMoves;
    /*
     
    NSMutableArray* possibleMoves = [NSMutableArray array];
    NSLog(@"hand array:%d",(int)[self.handArray count]);
    
    
    // Now check the flip to empty suit move.
    // Need to handle the discard pile better, so aces can fill empties.
    Card* topOfFlip = [self.deckFlip lastObject];
    NSLog(@"Top of Flip: %d",(int)topOfFlip.value);
    if ([topOfFlip value] == 1)
    {
        // Let's look for an empty discard array.
        for(int i = 0; i < [self.discardArray count]; i++)
        {
            if ([[self.discardArray objectAtIndex:i] count] == 0)
            {
                // We got a move!!!
                PossibleMove* move = [[PossibleMove alloc] init];
                move.fromArray = self.deckFlip;
                move.toArray = [self.discardArray objectAtIndex:i];
                move.typeOfMove = [NSString stringWithFormat:@"Move %@ to suit pile.",[topOfFlip cardName]];
                move.fromIndex = SELECTED_FLIP;
                move.toIndex = SELECTED_DISCARD_1+i;
                move.fromCard = topOfFlip;
                if (topOfFlip != nil)
                    [possibleMoves addObject:move];
                break;
            }
        }
    }
    
    // Now, let's run a check against all the discard piles.
    for(int i = 0; i < [self.discardArray count]; i++)
    {
        // Check all hand to discard moves!
        for(int j = 0; j < [self.handArray count]; j++)
        {
            if ([self isMovePossibleFrom:[self.handArray objectAtIndex:j] to:[self.discardArray objectAtIndex:i] isAscending:YES andSameColor:YES andSameSuit:YES moveLabel:@""])
            {
                PossibleMove* move =[self isMovePossibleFrom:[self.handArray objectAtIndex:j] to:[self.discardArray objectAtIndex:i] isAscending:YES andSameColor:YES andSameSuit:YES moveLabel:[NSString stringWithFormat:@"Suit Stack %d to Hand %d",i+1,j+1]];
                Card* fromCard = [[self.handArray objectAtIndex:j] lastObject];
                Card* toCard = [[self.discardArray objectAtIndex:i] lastObject];
                move.typeOfMove =[NSString stringWithFormat:@"Move %@ to %@",[fromCard cardName],[toCard cardName]];
                move.fromIndex = SELECTED_STACK_0+j;
                move.toIndex = SELECTED_DISCARD_1+i;
                move.fromCard = fromCard;
                if (fromCard != nil && toCard != nil)
                    [possibleMoves addObject:move];
            }
            else
            {
                // Need to handle the discard pile better, so aces can fill empties.
                Card* fromCard = [[self.handArray objectAtIndex:j] lastObject];
                if (fromCard != nil)
                {
                    if ([[self.discardArray objectAtIndex:i] count] == 0
                        && fromCard.value == 1)
                    {
                        PossibleMove* move = [[PossibleMove alloc] init];
                        move.fromArray = [self.handArray objectAtIndex:j];
                        move.toArray = [self.discardArray objectAtIndex:i];
                        move.typeOfMove = [NSString stringWithFormat:@"Move %@ to suit pile.",[fromCard cardName]];
                        move.fromIndex = SELECTED_STACK_0+j;
                        move.toIndex = SELECTED_DISCARD_1+i;
                        move.fromCard = fromCard;
                        if (fromCard != nil)
                            [possibleMoves addObject:move];
                    }
                }
            }
        }
        
        // Check the flip to discard move.
        if ([self isMovePossibleFrom:self.deckFlip to:[self.discardArray objectAtIndex:i] isAscending:YES andSameColor:YES andSameSuit:YES moveLabel:@""])
        {
            PossibleMove* move = [self isMovePossibleFrom:self.deckFlip to:[self.discardArray objectAtIndex:i] isAscending:YES andSameColor:YES andSameSuit:YES moveLabel:[NSString stringWithFormat:@"Flip hand to Suit Stack %d",i+1]];
            Card* fromCard = [self.deckFlip lastObject];
            Card* toCard = [[self.discardArray objectAtIndex:i]lastObject];
            move.typeOfMove =[NSString stringWithFormat:@"Move %@ to %@",[fromCard cardName],[toCard cardName]];
            move.fromIndex = SELECTED_FLIP;
            move.toIndex = SELECTED_DISCARD_1+i;
            move.fromCard = fromCard;
            if (fromCard != nil && toCard != nil)
                [possibleMoves addObject:move];
        }
    }
    
    for (int i = 0; i < [self.handArray count]; i++)
    {
        // Check all hand to hand moves!
        for(int j = 0; j < [self.handArray count]; j++)
        {
           // if (i == j)
             //   continue;
            
            if ([self isMovePossibleFrom:[self.handArray objectAtIndex:i] to:[self.handArray objectAtIndex:j] isAscending:NO andSameColor:NO andSameSuit:NO moveLabel:@""])
            {
                PossibleMove* move = [self isMovePossibleFrom:[self.handArray objectAtIndex:i] to:[self.handArray objectAtIndex:j] isAscending:NO andSameColor:NO andSameSuit:NO moveLabel:[NSString stringWithFormat:@"Hand %d to Hand %d",i+1,j+1]];
                // Set the indexes
                Card* fromCard = [[self.handArray objectAtIndex:i]lastObject];
                Card* toCard = [[self.handArray objectAtIndex:j]lastObject];
                move.fromCard = fromCard;
                move.typeOfMove =[NSString stringWithFormat:@"Move %@ to %@",[fromCard cardName],[toCard cardName]];
                move.fromIndex = SELECTED_STACK_0+i;
                move.toIndex = SELECTED_STACK_0+j;
                
                if (fromCard != nil && toCard != nil)
                {
                    NSLog(@"move:%@",move.typeOfMove);
                    if (fromCard != nil && toCard != nil)
                    [possibleMoves addObject:move];
                }
            }
            else
            {
                // Let's check kings against empties.
                if ([[self.handArray objectAtIndex:j] count] == 0)
                {
                    Card* fromCard = [[self.handArray objectAtIndex:j] lastObject];
                    if (fromCard)
                    {
                        // Is it a Kind?
                        if (fromCard.value == 13)
                        {
                            PossibleMove* move = [[PossibleMove alloc] init];
                            move.fromArray =[self.handArray objectAtIndex:i];
                            move.toArray = [self.handArray objectAtIndex:j];
                            // Set the indexes
                            move.typeOfMove = [NSString stringWithFormat:@"King of %@ to Empty Hand %d",fromCard.suite,j+1];
                            
                            Card* fromCard = [[self.handArray objectAtIndex:i]lastObject];
                            move.fromCard = fromCard;
                            move.typeOfMove =[NSString stringWithFormat:@"Move %@ to empty hand",[fromCard cardName]];
                            
                            move.fromIndex = SELECTED_STACK_0+i;
                            move.toIndex = SELECTED_STACK_0+j;
                            //if (fromCard != nil && toCard != nil)
                            [possibleMoves addObject:move];
                        }
                    }
                }
            }
        }
        
        
        // Now, let's check all moves from flip to hand?
        if ([self isMovePossibleFrom:self.deckFlip to:[self.handArray objectAtIndex:i] isAscending:NO andSameColor:NO andSameSuit:NO moveLabel:@""])
        { PossibleMove* move = [self isMovePossibleFrom:self.deckFlip to:[self.handArray objectAtIndex:i] isAscending:NO andSameColor:NO andSameSuit:NO moveLabel:[NSString stringWithFormat:@"Flipped Stack to Hand %d",i+1]];
            Card* fromCard = [self.deckFlip lastObject];
            Card* toCard = [[self.handArray objectAtIndex:i]lastObject];
            move.typeOfMove =[NSString stringWithFormat:@"Move %@ to %@",[fromCard cardName],[toCard cardName]];
            move.fromIndex = SELECTED_FLIP;
            move.fromCard = fromCard;
            move.toIndex = SELECTED_STACK_0+i;
            if (fromCard != nil && toCard != nil)
            [possibleMoves addObject:move];
        }
        
        // Now, let's run all the discard checks to hands.
        if ([self isMovePossibleFrom:self.discard1 to:[self.handArray objectAtIndex:i] isAscending:NO andSameColor:NO andSameSuit:NO moveLabel:@""])
        {
            PossibleMove* move = [self isMovePossibleFrom:self.discard1 to:[self.handArray objectAtIndex:i] isAscending:NO andSameColor:NO andSameSuit:NO moveLabel:[NSString stringWithFormat:@"Suit Stack 1 to Hand %d",i+1]];
            Card* fromCard = [self.discard1 lastObject];
            Card* toCard = [[self.handArray objectAtIndex:i]lastObject];
            move.typeOfMove =[NSString stringWithFormat:@"Move %@ to %@",[fromCard cardName],[toCard cardName]];
            move.fromIndex = SELECTED_DISCARD_1;
            move.toIndex = SELECTED_STACK_0+i;
            move.fromCard = fromCard;
            if (fromCard != nil && toCard != nil)
            [possibleMoves addObject: move];
        }
        
        if ([self isMovePossibleFrom:self.discard2 to:[self.handArray objectAtIndex:i] isAscending:NO andSameColor:NO andSameSuit:NO moveLabel:@""])
        {
            PossibleMove* move = [self isMovePossibleFrom:self.discard2 to:[self.handArray objectAtIndex:i] isAscending:NO andSameColor:NO andSameSuit:NO moveLabel:[NSString stringWithFormat:@"Suit Stack 2 to Hand %d",i+1]];
            Card* fromCard = [self.discard2 lastObject];
            Card* toCard = [[self.handArray objectAtIndex:i]lastObject];
            move.typeOfMove =[NSString stringWithFormat:@"Move %@ to %@",[fromCard cardName],[toCard cardName]];
            move.fromIndex = SELECTED_DISCARD_2;
            move.toIndex = SELECTED_STACK_0+i;
            move.fromCard = fromCard;
            if (fromCard != nil && toCard != nil)
            [possibleMoves addObject:move];
        }
        
        if ([self isMovePossibleFrom:self.discard3 to:[self.handArray objectAtIndex:i] isAscending:NO andSameColor:NO andSameSuit:NO moveLabel:@""])
        {
            PossibleMove* move =[self isMovePossibleFrom:self.discard3 to:[self.handArray objectAtIndex:i] isAscending:NO andSameColor:NO andSameSuit:NO moveLabel:[NSString stringWithFormat:@"Suit Stack 3 to Hand %d",i+1]];
            Card* fromCard = [self.discard3 lastObject];
            Card* toCard = [[self.handArray objectAtIndex:i]lastObject];
            move.typeOfMove =[NSString stringWithFormat:@"Move %@ to %@",[fromCard cardName],[toCard cardName]];
            move.fromIndex = SELECTED_DISCARD_3;
            move.toIndex = SELECTED_STACK_0+i;
            move.fromCard = fromCard;
            if (fromCard != nil && toCard != nil)
            [possibleMoves addObject:move];
        }
        
        if ([self isMovePossibleFrom:self.discard4 to:[self.handArray objectAtIndex:i] isAscending:NO andSameColor:NO andSameSuit:NO moveLabel:@""])
        {
            PossibleMove* move =[self isMovePossibleFrom:self.discard4 to:[self.handArray objectAtIndex:i] isAscending:NO andSameColor:NO andSameSuit:NO moveLabel:[NSString stringWithFormat:@"Suit Stack 4 to Hand %d",i+1]];
            Card* fromCard = [self.discard4 lastObject];
            Card* toCard = [[self.handArray objectAtIndex:i]lastObject];
            move.typeOfMove =[NSString stringWithFormat:@"Move %@ to %@",[fromCard cardName],[toCard cardName]];
            move.fromIndex = SELECTED_DISCARD_4;
            move.toIndex = SELECTED_STACK_0+i;
            move.fromCard = fromCard;
            if (fromCard != nil && toCard != nil)
            [possibleMoves addObject:move];
        }
    }
    
    
    
    // Need to look up the pile for more possibilities?  Hm, can we skip this? no.
    // Now, let's check every card that is face up against all last cards.
    for(int i = 0; i < [self.handArray count]; i++)
    {
        NSArray* fromStack = [self.handArray objectAtIndex:i];
        // Skip the last card...already checked for...meaning start with -2 instead of -1.
        for(int j = ((int)[fromStack count]-2); j >= 0; j--)
        {
            Card* lastCard = [fromStack lastObject];
            Card* fromCard = [fromStack objectAtIndex:j];
            //NSLog(@"1---last card:%@ target card:%@",lastCard,fromCard);
            if (!fromCard.isFacingUp)
            {
                // Only search cards facing up.
                break;
            }
            // Now, let's check this card against all the stacks!
            // Now, let's check the cards.
            for(int k = 0; k < [self.handArray count]; k++)
            {
               // NSLog(@"2---last card:%@ target card:%@",lastCard,fromCard);
                Card* toCard = [[self.handArray objectAtIndex:k] lastObject];
                
                if (![fromCard.color isEqualToString:toCard.color]
                    && [fromCard value] == [toCard value]-1)
                {
                    //
                    // We found a stack move?
                    PossibleMove* move = [[PossibleMove alloc] init];
                    move.fromIndex = SELECTED_STACK_0+i;
                    move.toIndex = SELECTED_STACK_0+k;
                    move.fromCard = fromCard;
                    move.toArray =[self.handArray objectAtIndex:k];
                    //move.fromArray = fromStack;//[fromStack objectAtIndex:j];
                    //NSArray* fromArray = [fromStack objectAtIndex:j];
                   // Card* lastCard = [fromStack lastObject];//[fromArray lastObject];
                    
                    move.typeOfMove = [NSString stringWithFormat:@"Pile from %d of %@ through %d of %@ to %d of %@",(int)fromCard.value,fromCard.suite,(int)lastCard.value,lastCard.suite,(int)toCard.value,toCard.suite];
                    //NSLog(@"1---last card:%@ target card:%@",lastCard,fromCard);
                    //Card* fromCard = [self.deckFlip lastObject];
                    //Card* toCard = [self.handArray objectAtIndex:i];
                    //NSLog(@"--Move %@ through %@ to %@",fromCard,lastCard,toCard);
                    move.typeOfMove =[NSString stringWithFormat:@"Move %@ through %@ to %@",[fromCard cardName],[lastCard cardName],[toCard cardName]];
                    if (fromCard != nil && toCard != nil)
                    [possibleMoves addObject:move];
                }
            }
        }
    }
    
    return possibleMoves;*/
}

-(void) triggerVoiceControl
{
    // So, what's need to happen?
    // We need to figure out all moves available to start with.
    //
}

-(NSInteger) getHeightOfDiscardRow
{
    NSInteger base = [self cardHeight] + 6;
    if (isVoiceControlled)
    {
        base -= 2;
    }
    if (base < 24)
    {
        base = 24;
    }
    if (base > 38)
    {
        base = 38;
    }
    return base;
}

-(NSInteger) getHeightOfFlipRow
{
    NSInteger base = [self cardHeight] + 6;
    if (isVoiceControlled)
    {
        base -= 2;
    }
    if (base < 24)
    {
        base = 24;
    }
    if (base > 38)
    {
        base = 38;
    }
    return base;
}

-(NSInteger) hiddenFlipWidth
{
    return [self is42] ? 16 : 14;
}

-(NSInteger) stackPeekWidth
{
    return [self is42] ? 6 : 3;
}

-(NSInteger) cardWidth
{
    return [self is42] ? 22 : 19;
}

-(NSInteger) cardHeight
{
    return [self is42] ? 30 : 25;
}

-(NSInteger) handDownFacing
{
    return [self is42] ? 6 : 4;
}

-(NSInteger) handUpBehind
{
    return [self is42] ? 16 : 13;
}

-(NSInteger) handUpFront
{
    return [self cardHeight];
}

-(void) moveFlipFromStack
{
    [self flipFromDeck];
    [self renderStack];
    [self renderFlip];
    [self saveBoard];
}
// Now what?

-(IBAction)deckStackAction:(id)sender
{
    if (!isVoiceControlled)
    {
        if (self.hasSelected)
        {
            [self.selectedImage setAlpha:1.0f];
            self.hasSelected = false;
        }
        
        [self moveFlipFromStack];
    }
    [self clickedAnyButton];
}

-(void) clearSelection
{
    NSLog(@"clear selection");
    [self.selectedImage setAlpha:1];
    self.hasSelected = false;
}


-(IBAction)deckFlipAction:(id)sender
{
    lastFromTouched = SELECTED_FLIP;
    if (!isVoiceControlled)
    {
        if (isOneTouch)
        {
            if ([self processOneTouch:SELECTED_FLIP])
            {
                return;
            }
        }
        
        if (self.hasSelected)
        {
            //if (self.selectedAction == SELECTED_FLIP)
            //{
            [self clearSelection];
            //}
        }
        else
        {
            if ([self.deckFlip count] == 0)
            {
                // Do nothing.
            }
            else
            {
                self.selectedAction = SELECTED_FLIP;
                self.hasSelected = true;
                // Let's set the alpha of the top card to .5f.
                if ([self.deckFlip count] == 1)
                {
                    [self.deckFlip3Image setAlpha:.5f];
                    self.selectedImage = self.deckFlip3Image;
                }
                
                if ([self.deckFlip count] == 2)
                {
                    [self.deckFlip3Image setAlpha:.5f];
                    self.selectedImage = self.deckFlip3Image;
                }
                
                if ([self.deckFlip count] == 3)
                {
                    [self.deckFlip3Image setAlpha:.5f];
                    self.selectedImage = self.deckFlip3Image;
                }
                // Keep a reference to the selected image.
            }
        }
    }
    [self clickedAnyButton];
}

-(IBAction)discard1Action:(id)sender
{
    lastFromTouched = SELECTED_DISCARD_1;
    if (!isVoiceControlled)
    {
        if (isOneTouch)
        {
            if ([self processOneTouch:SELECTED_DISCARD_1])
            {
                return;
            }
        }
        
        if (self.hasSelected)
        {
            [self handleMoveFrom:self.selectedAction to:SELECTED_DISCARD_1];
        }
        else
        {
            if ([self.discard1 count] > 0)
            {
                self.selectedImage = self.discard1Image;
                [self.discard1Image setAlpha:.5f];
                self.hasSelected = true;
                self.selectedAction = SELECTED_DISCARD_1;
            }
        }
    }
    [self clickedAnyButton];
}
-(IBAction)discard2Action:(id)sender
{
    lastFromTouched = SELECTED_DISCARD_2;
    if (!isVoiceControlled)
    {
        if (isOneTouch)
        {
            if ([self processOneTouch:SELECTED_DISCARD_2])
            {
                return;
            }
        }
        
        if (self.hasSelected)
        {
            [self handleMoveFrom:self.selectedAction to:SELECTED_DISCARD_2];
        }
        
        else
        {
            if ([self.discard2 count] > 0)
            {
                self.selectedImage = self.discard2Image;
                [self.discard2Image setAlpha:.5f];
                self.hasSelected = true;
                self.selectedAction = SELECTED_DISCARD_2;
            }
        }
    }
    [self clickedAnyButton];
}

-(IBAction)discard3Action:(id)sender
{
    lastFromTouched = SELECTED_DISCARD_3;
    if (!isVoiceControlled)
    {
        if (isOneTouch)
        {
            if ([self processOneTouch:SELECTED_DISCARD_3])
            {
                return;
            }
        }
        
        if (self.hasSelected)
        {
            [self handleMoveFrom:self.selectedAction to:SELECTED_DISCARD_3];
        }
        else
        {
            if ([self.discard3 count] > 0)
            {
                self.selectedImage = self.discard3Image;
                [self.discard3Image setAlpha:.5f];
                self.hasSelected = true;
                self.selectedAction = SELECTED_DISCARD_3;
            }
        }
    }
    [self clickedAnyButton];
}
-(IBAction)discard4Action:(id)sender
{
    lastFromTouched = SELECTED_DISCARD_4;
    if (!isVoiceControlled)
    {
        if (isOneTouch)
        {
            if ([self processOneTouch:SELECTED_DISCARD_4])
            {
                return;
            }
        }
        
        if (self.hasSelected)
        {
            [self handleMoveFrom:self.selectedAction to:SELECTED_DISCARD_4];
        }
        else
        {
            if ([self.discard4 count] > 0)
            {
                self.selectedImage = self.discard4Image;
                [self.discard4Image setAlpha:.5f];
                self.hasSelected = true;
                self.selectedAction = SELECTED_DISCARD_4;
            }
        }
    }
    [self clickedAnyButton];
}

-(void) makeLastCardVisibleInHand:(int) hand
{
    NSArray* handAffected = [self.handArray objectAtIndex:hand];
    Card* lastCard = [handAffected lastObject];
    [lastCard setIsFacingUp:YES];
}

-(void) handleMoveFrom:(int) from to:(int) to
{
    [self.selectedImage setAlpha:1];
    self.hasSelected = false;
    
    NSLog(@"Move from %d to %d",from,to);
    if (from >= SELECTED_DISCARD_1 && from <= SELECTED_DISCARD_4)
    {
        if (to >= SELECTED_STACK_0 && to <= SELECTED_STACK_6)
        {
            NSMutableArray* discardStack = nil;
            if (from == SELECTED_DISCARD_1)
                discardStack = self.discard1;
            if (from == SELECTED_DISCARD_2)
                discardStack = self.discard2;
            if (from == SELECTED_DISCARD_3)
                discardStack = self.discard3;
            if (from == SELECTED_DISCARD_4)
                discardStack = self.discard4;
            Card* discardCard = [discardStack lastObject];
            
            NSMutableArray* hand_stack = [self.handArray objectAtIndex:to];
            Card* handCard = [hand_stack lastObject];
            if (handCard == nil
                || discardCard == nil)
            {
                // Do nothing?
                
            }
            else
            {
                // One less, plus alternating colors.
                if ([discardCard value]+1 == [handCard value]
                    && ![[discardCard color] isEqualToString:[handCard color]])
                {
                    //[topFlick setIsFacingUp:YES];
                    [self move:1 CardsFromStack:discardStack toStack:hand_stack dealStacked:NO];
                    [self renderHand:to];
                    [self renderDiscard];
                    //[self renderFlip];
                    [self saveBoard];
                }
                else
                {
                    NSLog(@"illegal move2!");
                    NSLog(@"what to do?");
                }
            }
        }
    }
    // From flip to discards
    if (from == SELECTED_FLIP)
    {
        if (to >= SELECTED_DISCARD_1 && to <= SELECTED_DISCARD_4)
        {
            // Discard
            NSMutableArray* discard_stack = nil;
            if (to == SELECTED_DISCARD_1) discard_stack = self.discard1;
            if (to == SELECTED_DISCARD_2) discard_stack = self.discard2;
            if (to == SELECTED_DISCARD_3) discard_stack = self.discard3;
            if (to == SELECTED_DISCARD_4) discard_stack = self.discard4;
            
            // We know the flip and the stack!
            if ([self.deckFlip count] > 0)
            {
                Card* topFlick = [self.deckFlip lastObject];
                
                if ([discard_stack count] == 0)
                {
                    // Check for ace on flip!
                    if ([topFlick value] == 1)
                    {
                        NSLog(@"Ace!");
                        [topFlick setIsFacingUp:YES];
                        [self move:1 CardsFromStack:self.deckFlip toStack:discard_stack dealStacked:NO];
                        [self renderFlip];
                        [self renderDiscard];
                        [self checkWinner];
                        [self saveBoard];
                    }
                    else
                    {
                        NSLog(@"illegal move!");
                        NSLog(@"what to do?");
                        // A label, "Can't"?
                    }
                }
                else
                {
                    Card* topOfDiscard = [discard_stack lastObject];
                    
                    if ([topOfDiscard value] == [topFlick value]-1
                        && [[topOfDiscard suite] isEqualToString:[topFlick suite]])
                    {
                        [topFlick setIsFacingUp:YES];
                        [self move:1 CardsFromStack:self.deckFlip toStack:discard_stack dealStacked:NO];
                        [self renderDiscard];
                        [self renderFlip];
                        [self checkWinner];
                        [self saveBoard];
                    }
                    else
                    {
                        NSLog(@"illegal move!");
                        NSLog(@"what to do?");
                    }
                }
            }
            else
            {
                // Clear selection?  shouldn't be possible
                NSLog(@"shouldn't be possible");
            }
        }
        else
        // From flip to hands
        if (to >= SELECTED_STACK_0 && to <= SELECTED_STACK_6)
        {
            // Stack handling
            // Discard
            NSMutableArray* hand_stack = [self.handArray objectAtIndex:to];
            
            // We know the flip and the stack!
            if ([self.deckFlip count] > 0)
            {
                Card* topFlick = [self.deckFlip lastObject];
                
                // True for empty row!
                if ([hand_stack count] == 0)
                {
                    // Check for ace on flip!
                    if ([topFlick value] == 13)
                    {
                        [topFlick setIsFacingUp:YES];
                        NSLog(@"King!");
                        [self move:1 CardsFromStack:self.deckFlip toStack:hand_stack dealStacked:NO];
                        [self renderFlip];
                        [self renderHand:to];
                        [self saveBoard];
                    }
                    else
                    {
                        NSLog(@"illegal move!");
                        NSLog(@"what to do?");
                        // A label, "Can't"?
                    }
                }
                else
                {
                    // how could we get here with a negative index and empty array?
                    if (([hand_stack count]-1) > 40)
                    {
                        NSLog(@"what happened!");
                    }
                    else
                    {
                        
                        
                        Card* topOfHand = [hand_stack lastObject];
                        
                        
                        // One less, plus alternating colors.
                        if ([topOfHand value] == [topFlick value]+1
                            && ![[topOfHand color] isEqualToString:[topFlick color]])
                        {
                            [topFlick setIsFacingUp:YES];
                            [self move:1 CardsFromStack:self.deckFlip toStack:hand_stack dealStacked:NO];
                            [self renderHand:to];
                            [self renderFlip];
                            [self saveBoard];
                        }
                        else
                        {
                            NSLog(@"illegal move!");
                            NSLog(@"what to do?");
                        }
                    }
                }
            }
            else
            {
                // Clear selection?  shouldn't be possible
                NSLog(@"shouldn't be possible");
            }
        }
    }
    
    
    // From hands to discards
    if (from >= SELECTED_STACK_0 && from <= SELECTED_STACK_6)
    {
        if (to >= SELECTED_STACK_0 && to <= SELECTED_STACK_6)
        {
            
            // Check, stack to stack.
            if ([[self.handArray objectAtIndex:to] count] == 0)
            {
                // Is there a visible king in the from hand stack?
                // Look for a visible king.
                int cardsAway = [self findNumberOfCardsFromKingInHandStack:from];
                if (cardsAway == -1)
                {
                    NSLog(@"illegal move!");
                    NSLog(@"what to do?");
                }
                else
                {
                    if (cardsAway == 1)
                    {
                        [self move:cardsAway CardsFromStack:[self.handArray objectAtIndex:from] toStack:[self.handArray objectAtIndex:to] dealStacked:NO];
                    }
                    else
                    {
                        [self move:cardsAway CardsFromStack:[self.handArray objectAtIndex:from] toStack:[self.handArray objectAtIndex:to] orderPreserved:YES];
                    }
                    
                    [self makeLastCardVisibleInHand:from];
                    [self renderHand:from];
                    [self renderHand:to];
                    [self saveBoard];
                }
            }
            else
            {
                // Else, does it fit?
                NSMutableArray* toArray = [self.handArray objectAtIndex:to];
                 NSMutableArray* fromArray = [self.handArray objectAtIndex:from];
                Card* topOfStackTo = [toArray lastObject];
                
                // Let's get the target type.
                int target_value = (int)[topOfStackTo value] - 1;
                NSString* target_color = [self getOppositeColor:[topOfStackTo color]];
                int cardsAway = [self findNumberOfCardsFromCardWithValue:target_value inHandStackId:from andMatchingColor:target_color];
                NSLog(@"top of stack value:%@ %ld %d %@ %@ %@ %d",topOfStackTo.filename,(long)[topOfStackTo value], target_value,topOfStackTo, [topOfStackTo color], target_color,cardsAway);
                if (cardsAway == -1)
                {
                    NSLog(@"illegal move!");
                    NSLog(@"what to do?");
                }
                else
                {
                    if (cardsAway == 1)
                    {
                        [self move:cardsAway CardsFromStack:fromArray toStack:toArray dealStacked:NO];
                    }
                    else
                    {
                        [self move:cardsAway CardsFromStack:fromArray toStack:toArray orderPreserved:YES];
                    }
                    
                    [self makeLastCardVisibleInHand:from];
                    
                    [self renderHand:from];
                    [self renderHand:to];
                    [self saveBoard];
                }
                
            }
        }
        else
        if (to >= SELECTED_DISCARD_1 && to <= SELECTED_DISCARD_4)
        {
            // Discard
            NSMutableArray* discard_stack = nil;
            if (to == SELECTED_DISCARD_1) discard_stack = self.discard1;
            if (to == SELECTED_DISCARD_2) discard_stack = self.discard2;
            if (to == SELECTED_DISCARD_3) discard_stack = self.discard3;
            if (to == SELECTED_DISCARD_4) discard_stack = self.discard4;
            
            NSMutableArray* handFrom =[self.handArray objectAtIndex:from];
            // We know the flip and the stack!
            if ([handFrom count] > 0)
            {
                Card* topHandCard = [handFrom lastObject];//objectAtIndex:([handFrom count]-1)];
                
                if ([discard_stack count] == 0)
                {
                    // Check for ace on flip!
                    if ([topHandCard value] == 1)
                    {
                        NSLog(@"Ace!");
                        [self move:1 CardsFromStack:handFrom toStack:discard_stack dealStacked:NO];
                        
                        if ([handFrom count] > 0)
                        {
                            // Make sure the topHandfrom is flipped now!
                            Card* newTop = [handFrom lastObject];
                            [newTop setIsFacingUp:YES];
                            // Can we set the height of the image?
                            WKInterfaceImage* card = [self.handCardImages objectAtIndex:from*20 + ([handFrom count]-1)];
                            [card setHeight:[self handUpFront]];
                        }
                        [self renderHand:from];
                        [self renderDiscard];
                        [self checkWinner];
                        [self saveBoard];
                    }
                    else
                    {
                        NSLog(@"illegal move!");
                        NSLog(@"what to do?");
                        // A label, "Can't"?
                    }
                }
                else
                {
                    Card* topOfDiscard = [discard_stack lastObject];
                    
                    if ([topOfDiscard value] == [topHandCard value]-1
                        && [[topOfDiscard suite] isEqualToString:[topHandCard suite]])
                    {
                        [self move:1 CardsFromStack:handFrom toStack:discard_stack dealStacked:NO];
                        if ([handFrom count] > 0)
                        {
                            // Make sure the topHandfrom is flipped now!
                            Card* newTop = [handFrom lastObject];
                            [newTop setIsFacingUp:YES];
                            // Can we set the height of the image?
                            WKInterfaceImage* card = [self.handCardImages objectAtIndex:from*20 + ([handFrom count]-1)];
                            [card setHeight:[self handUpFront]];
                        }
                        [self renderDiscard];
                        [self renderFlip];
                        [self checkWinner];
                        [self renderHand:from];
                        [self saveBoard];
                    }
                    else
                    {
                        NSLog(@"illegal move!");
                        NSLog(@"what to do?");
                    }
                }
            }
            else
            {
                // Clear selection?  shouldn't be possible
                NSLog(@"illegal move!");
                NSLog(@"what to do?");
            }
        }
    }
    // From hands to hands
}

-(NSString*) getOppositeColor:(NSString*) color
{
    if ([color isEqualToString:@"black"])
    {
        return @"red";
    }
    else
    {
        return @"black";
    }
}

-(int) findNumberOfCardsFromCardWithValue:(int) value inHandStackId:(int) handId andMatchingColor:(NSString*) color
{
    NSArray* hand = [self.handArray objectAtIndex: handId];
    int kingPosition = -1;
    int numberOfCardsAway = 1;
    for(int i = (int)[hand count]-1; i >=0; i--)
    {
        Card* card = [hand objectAtIndex:i];
        if (!card.isFacingUp)
        {
            break;
        }
        if ([card value] == value
            && [[card color] isEqualToString:color])
        {
            kingPosition = numberOfCardsAway;
            break;
        }
        numberOfCardsAway++;
    }
    
    return kingPosition;
}

-(int) findNumberOfCardsFromKingInHandStack:(int) handId
{
    NSArray* hand = [self.handArray objectAtIndex: handId];
    int kingPosition = -1;
    int numberOfCardsAway = 1;
    for(int i = (int)[hand count]-1; i >=0; i--)
    {
        Card* card = [hand objectAtIndex:i];
        if (!card.isFacingUp)
        {
            break;
        }
        
        if ([card value] == 13)
        {
            kingPosition = numberOfCardsAway;
            break;
        }
        numberOfCardsAway++;
    }
    
    return kingPosition;
}

-(IBAction)handStack1Action:(id)sender
{
    lastFromTouched = SELECTED_STACK_0;
    if (!isVoiceControlled)
    {
        if (isOneTouch)
        {
            if ([self processOneTouch:SELECTED_STACK_0])
            {
                return;
            }
        }
        
        if (self.hasSelected)
        {
            // Handle a move!
            if (self.selectedAction == SELECTED_STACK_0)
            {
                // undo selection
                [self.hand0Button setAlpha:1];
                self.hasSelected = false;
            }
            else
            {
                // Handle a move!!
                [self handleMoveFrom:self.selectedAction to:SELECTED_STACK_0];
            }
        }
        else
        {
            self.selectedImage = self.hand0Button;
            [self.hand0Button setAlpha:.5f];
            self.hasSelected = true;
            self.selectedAction = SELECTED_STACK_0;
        }
    }
    [self clickedAnyButton];
}
-(IBAction)handStack2Action:(id)sender
{
    lastFromTouched = SELECTED_STACK_1;
    if (!isVoiceControlled)
    {
        if (isOneTouch)
        {
            if ([self processOneTouch:SELECTED_STACK_1])
            {
                return;
            }
        }
        if (self.hasSelected)
        {
            // Handle a move!
            if (self.selectedAction == SELECTED_STACK_1)
            {
                // undo selection
                [self.hand1Button setAlpha:1];
                self.hasSelected = false;
            }
            else
            {
                // Handle a move!!
                [self handleMoveFrom:self.selectedAction to:SELECTED_STACK_1];
            }
        }
        else
        {
            self.selectedImage = self.hand1Button;
            [self.hand1Button setAlpha:.5f];
            self.hasSelected = true;
            self.selectedAction = SELECTED_STACK_1;
        }
    }
    [self clickedAnyButton];
}
-(IBAction)handStack3Action:(id)sender
{
    lastFromTouched = SELECTED_STACK_2;
    if (!isVoiceControlled)
    {
        if (isOneTouch)
        {
            if ([self processOneTouch:SELECTED_STACK_2])
            {
                return;
            }
        }
        if (self.hasSelected)
        {
            // Handle a move!
            if (self.selectedAction == SELECTED_STACK_2)
            {
                // undo selection
                [self.hand2Button setAlpha:1];
                self.hasSelected = false;
            }
            else
            {
                // Handle a move!!
                [self handleMoveFrom:self.selectedAction to:SELECTED_STACK_2];
            }
        }
        else
        {
            self.selectedImage = self.hand2Button;
            [self.hand2Button setAlpha:.5f];
            self.hasSelected = true;
            self.selectedAction = SELECTED_STACK_2;
        }
    }
    [self clickedAnyButton];
}
-(IBAction)handStack4Action:(id)sender
{
    lastFromTouched = SELECTED_STACK_3;
    if (!isVoiceControlled)
    {
        if (isOneTouch)
        {
            if ([self processOneTouch:SELECTED_STACK_3])
            {
                return;
            }
        }
        if (self.hasSelected)
        {
            // Handle a move!
            if (self.selectedAction == SELECTED_STACK_3)
            {
                // undo selection
                [self.hand3Button setAlpha:1];
                self.hasSelected = false;
            }
            else
            {
                // Handle a move!!
                [self handleMoveFrom:self.selectedAction to:SELECTED_STACK_3];
            }
        }
        else
        {
            self.selectedImage = self.hand3Button;
            [self.hand3Button setAlpha:.5f];
            self.hasSelected = true;
            self.selectedAction = SELECTED_STACK_3;
        }
    }
    [self clickedAnyButton];
}
-(IBAction)handStack5Action:(id)sender
{
    lastFromTouched = SELECTED_STACK_4;
    if (!isVoiceControlled)
    {
        if (isOneTouch)
        {
            if ([self processOneTouch:SELECTED_STACK_4])
            {
                return;
            }
        }
        if (self.hasSelected)
        {
            // Handle a move!
            if (self.selectedAction == SELECTED_STACK_4)
            {
                // undo selection
                [self.hand4Button setAlpha:1];
                self.hasSelected = false;
            }
            else
            {
                // Handle a move!!
                [self handleMoveFrom:self.selectedAction to:SELECTED_STACK_4];
            }
        }
        else
        {
            self.selectedImage = self.hand4Button;
            [self.hand4Button setAlpha:.5f];
            self.hasSelected = true;
            self.selectedAction = SELECTED_STACK_4;
        }
    }
    [self clickedAnyButton];
}
-(IBAction)handStack6Action:(id)sender
{
    lastFromTouched = SELECTED_STACK_5;
    if (!isVoiceControlled)
    {
        if (isOneTouch)
        {
            if ([self processOneTouch:SELECTED_STACK_5])
            {
                return;
            }
        }
        if (self.hasSelected)
        {
            // Handle a move!
            if (self.selectedAction == SELECTED_STACK_5)
            {
                // undo selection
                [self.hand5Button setAlpha:1];
                self.hasSelected = false;
            }
            else
            {
                // Handle a move!!
                [self handleMoveFrom:self.selectedAction to:SELECTED_STACK_5];
            }
        }
        else
        {
            self.selectedImage = self.hand5Button;
            [self.hand5Button setAlpha:.5f];
            self.hasSelected = true;
            self.selectedAction = SELECTED_STACK_5;
        }
    }
    [self clickedAnyButton];
}
-(IBAction)handStack7Action:(id)sender
{
    lastFromTouched = SELECTED_STACK_6;
    if (!isVoiceControlled)
    {
        if (isOneTouch)
        {
            if ([self processOneTouch:SELECTED_STACK_6])
            {
                return;
            }
        }
        if (self.hasSelected)
        {
            // Handle a move!
            if (self.selectedAction == SELECTED_STACK_6)
            {
                // undo selection
                [self.hand6Button setAlpha:1];
                self.hasSelected = false;
            }
            else
            {
                // Handle a move!!
                [self handleMoveFrom:self.selectedAction to:SELECTED_STACK_6];
            }
        }
        else
        {
            self.selectedImage = self.hand6Button;
            [self.hand6Button setAlpha:.5f];
            self.hasSelected = true;
            self.selectedAction = SELECTED_STACK_6;
        }
    }
    [self clickedAnyButton];
}

-(void) controlSettings
{
    [self pushControllerWithName:@"settings" context:nil];
}

-(void) refreshInteractionModeFromSettings
{
    // Force touch interaction for watch-first gameplay reliability.
    isRemoteControlled = NO;
    isVoiceControlled = NO;
    isUsingMoves = NO;
    isOneTouch = NO;

    NSString* uiSetting = [SolitaireSettings getUISetting];
    if ([uiSetting isEqualToString:TOUCHONE])
    {
        isVoiceControlled = NO;
        isOneTouch = YES;
    }
    else
    {
        isVoiceControlled = NO;
        isOneTouch = NO;
    }
}

-(void) initSolitaire
{
    self.sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.solitaire"];
    if (self.sharedDefaults == nil)
    {
        self.sharedDefaults = [NSUserDefaults standardUserDefaults];
    }
    self.wormhole = [[MMWormhole alloc] initWithApplicationGroupIdentifier:@"group.solitaire"
                                                         optionalDirectory:@"wormhole"];
    
    [self.wormhole listenForMessageWithIdentifier:@"loadSavedStateExtension"
                                         listener:^(id messageObject) {
                                             isRemoteControlled = YES;
                                             // Do Something
                                             //UIAlertView* alertTest = [[UIAlertView alloc] initWithTitle:@"hello" message:@"hello" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
                                            // [alertTest show];
                                             //[self presentControllerWithName:@"winner" context:nil];
                                             //[self setupNewBoard];
                                             [self loadBoard];
                                         }];
    [self migrateLegacyDefaultsIfNeeded];
    
    // Configure interface objects here.
    self.handCardImages = @[self.card0x0,self.card0x1,self.card0x2,self.card0x3,self.card0x4, self.card0x5, self.card0x6, self.card0x7, self.card0x8, self.card0x9, self.card0x10, self.card0x11, self.card0x12, self.card0x13, self.card0x14, self.card0x15, self.card0x16, self.card0x17, self.card0x18, self.card0x19,
                            self.card1x0,self.card1x1,self.card1x2,self.card1x3,self.card1x4, self.card1x5, self.card1x6, self.card1x7, self.card1x8, self.card1x9, self.card1x10, self.card1x11, self.card1x12, self.card1x13, self.card1x14, self.card1x15, self.card1x16, self.card1x17, self.card1x18, self.card1x19,
                            self.card2x0,self.card2x1,self.card2x2,self.card2x3,self.card2x4, self.card2x5, self.card2x6, self.card2x7, self.card2x8, self.card2x9, self.card2x10, self.card2x11, self.card2x12, self.card2x13, self.card2x14, self.card2x15, self.card2x16, self.card2x17, self.card2x18, self.card2x19,
                            self.card3x0,self.card3x1,self.card3x2,self.card3x3,self.card3x4, self.card3x5, self.card3x6, self.card3x7, self.card3x8, self.card3x9, self.card3x10, self.card3x11, self.card3x12, self.card3x13, self.card3x14, self.card3x15, self.card3x16, self.card3x17, self.card3x18, self.card3x19,
                            self.card4x0,self.card4x1,self.card4x2,self.card4x3,self.card4x4, self.card4x5, self.card4x6, self.card4x7, self.card4x8, self.card4x9, self.card4x10, self.card4x11, self.card4x12, self.card4x13, self.card4x14, self.card4x15, self.card4x16, self.card4x17, self.card4x18, self.card4x19,
                            self.card5x0,self.card5x1,self.card5x2,self.card5x3,self.card5x4, self.card5x5, self.card5x6, self.card5x7, self.card5x8, self.card5x9, self.card5x10, self.card5x11, self.card5x12, self.card5x13, self.card5x14, self.card5x15, self.card5x16, self.card5x17, self.card5x18, self.card5x19,
                            self.card6x0,self.card6x1,self.card6x2,self.card6x3,self.card6x4, self.card6x5, self.card6x6, self.card6x7, self.card6x8, self.card6x9, self.card6x10, self.card6x11, self.card6x12, self.card6x13, self.card6x14, self.card6x15, self.card6x16, self.card6x17, self.card6x18, self.card6x19
                            ];
    
    if (self.hand0 == nil)
    {
        self.hand0 = [[NSMutableArray alloc] init];
    }
    if (self.hand1 == nil)
    {
        self.hand1 = [[NSMutableArray alloc] init];
    }
    if (self.hand2 == nil)
    {
        self.hand2 = [[NSMutableArray alloc] init];
    }
    if (self.hand3 == nil)
    {
        self.hand3 = [[NSMutableArray alloc] init];
    }
    if (self.hand4 == nil)
    {
        self.hand4 = [[NSMutableArray alloc] init];
    }
    if (self.hand5 == nil)
    {
        self.hand5 = [[NSMutableArray alloc] init];
    }
    if (self.hand6 == nil)
    {
        self.hand6 = [[NSMutableArray alloc] init];
    }
    
    self.handArray = @[self.hand0,self.hand1,self.hand2,self.hand3,self.hand4,self.hand5,self.hand6];
    
    if (self.discard1 == nil)
    {
        self.discard1 = [[NSMutableArray alloc] init];
    }
    if (self.discard2 == nil)
    {
        self.discard2 = [[NSMutableArray alloc] init];
    }
    if (self.discard3 == nil)
    {
        self.discard3 = [[NSMutableArray alloc] init];
    }
    if (self.discard4 == nil)
    {
        self.discard4 = [[NSMutableArray alloc] init];
    }
    self.discardArray = @[self.discard1, self.discard2, self.discard3, self.discard4];
    
    if (self.deckStack == nil)
    {
        self.deckStack = [[NSMutableArray alloc] init];
    }
    if (self.deckFlip == nil)
    {
        self.deckFlip = [[NSMutableArray alloc] init];
    }
    if (self.shuffleDeck == nil)
    {
        self.shuffleDeck = [[NSMutableArray alloc] init];
    }
    if (self.masterDeck == nil)
    {
        self.masterDeck = [[NSMutableArray alloc] init];
    }
    if (self.deckFlipDiscard == nil)
    {
        self.deckFlipDiscard = [[NSMutableArray alloc] init];
    }

    self.gameState = [[SolitaireGameState alloc] initWithMasterDeck:self.masterDeck
                                                        shuffleDeck:self.shuffleDeck
                                                          deckStack:self.deckStack
                                                           deckFlip:self.deckFlip
                                                    deckFlipDiscard:self.deckFlipDiscard
                                                          handArray:self.handArray
                                                       discardArray:self.discardArray];
    
    [self clearAllMenuItems];
    [self addMenuItemWithItemIcon:WKMenuItemIconMore title:@"Controls" action:@selector(controlSettings)];
    
    if (self.flipCardsNumber==nil)
    {
        self.flipCardsNumber = [NSNumber numberWithInt:3];
        [self.buttonCardsToggle setTitle:@"1-Card"];

        [self addMenuItemWithItemIcon:WKMenuItemIconShuffle title:@"1 Card Flip" action:@selector(select1card)];
    }
    else
        if ([self.flipCardsNumber intValue] == 1)
        {
            [self.buttonCardsToggle setTitle:@"3-Card"];

            [self addMenuItemWithItemIcon:WKMenuItemIconShuffle title:@"3 Card Flip" action:@selector(select1card)];
        }
        else
            if ([self.flipCardsNumber intValue] == 3)
            {
                [self.buttonCardsToggle setTitle:@"1-Card"];

                [self addMenuItemWithItemIcon:WKMenuItemIconShuffle title:@"1 Card Flip" action:@selector(select1card)];
            }
    
    [self applyResponsiveLayout];

    if ([self.sharedDefaults objectForKey:kSavedDataKey]==nil)
    {
        // Setup all 52 cards test for now.
        [self setupNewBoard];
    }
    else
    {
        [self loadBoard];
    }
    
    //[self addMenuItemWithItemIcon:WKMenuItemIconDecline title:@"" action:@selector(back)];
    
    [self addMenuItemWithItemIcon:WKMenuItemIconTrash title:@"Redeal" action:@selector(resetBoard)];
    
    self.flipCardsNumber = [self.sharedDefaults objectForKey:kFlipCardNumberKey];
    
    if (self.flipCardsNumber == nil)
    {
        self.flipCardsNumber = [NSNumber numberWithInt:3];
        [self.sharedDefaults setObject:self.flipCardsNumber forKey:kFlipCardNumberKey];
        [self.sharedDefaults synchronize];
        //[self.wormhole passMessageObject:@{@"saved" : @"a"}
          //                    identifier:@"loadSavedState"];
    }
    
    if ([self.flipCardsNumber intValue] == 0)
    {
        self.flipCardsNumber = [NSNumber numberWithInt:3];
        [self.sharedDefaults setObject:self.flipCardsNumber forKey:kFlipCardNumberKey];
        [self.sharedDefaults synchronize];
        
        //[self.wormhole passMessageObject:@{@"saved" : @"a"}
          //                    identifier:@"loadSavedState"];
    }
    
    
    //[self addMenuItemWithItemIcon:WKMenuItemIconInfo title:@"Bests" action:@selector(rankings)];
    

}

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
}

// A helper button in the context menu.
-(void) back
{
    
}

-(void) rankings
{
    
}

-(void) select1card
{
    
    [self clearAllMenuItems];
    //[self addMenuItemWithItemIcon:WKMenuItemIconDecline title:@"" action:@selector(back)];
    [self addMenuItemWithItemIcon:WKMenuItemIconMore title:@"Controls" action:@selector(controlSettings)];
    
    [self addMenuItemWithItemIcon:WKMenuItemIconTrash title:@"Redeal" action:@selector(resetBoard)];
    
    if ([self.flipCardsNumber intValue] == 1)
    {
        self.flipCardsNumber = [NSNumber numberWithInt:3];
        [self.buttonCardsToggle setTitle:@"1-Card"];
        [self.sharedDefaults setObject:self.flipCardsNumber forKey:kFlipCardNumberKey];
        [self.sharedDefaults synchronize];
        
        //[self.wormhole passMessageObject:@{}
                     //         identifier:@"loadSavedResetState"];
        
        [self addMenuItemWithItemIcon:WKMenuItemIconShuffle title:@"1 Card Flip" action:@selector(select1card)];
    }
    else
    if ([self.flipCardsNumber intValue] == 3)
    {
        self.flipCardsNumber = [NSNumber numberWithInt:1];
        
        [self.sharedDefaults setObject:self.flipCardsNumber forKey:kFlipCardNumberKey];
        [self.sharedDefaults synchronize];
        
        //[self.wormhole passMessageObject:@{}
                    //          identifier:@"loadSavedResetState"];
        [self.buttonCardsToggle setTitle:@"3-Card"];

        [self addMenuItemWithItemIcon:WKMenuItemIconShuffle title:@"3 Card Flip" action:@selector(select1card)];
    }
    
    //[self addMenuItemWithItemIcon:WKMenuItemIconTrash title:@"Bests" action:@selector(rankings)];
    
    [self resetBoard];
}

-(IBAction)resetBoardButton:(id)sender
{
    [self resetBoard];
}

-(void) resetBoard
{
    [self setupNewBoard];
}

-(BOOL) is42
{
    return ([self currentWatchLogicalWidth] >= 176.0f);
}

-(void) loadMasterDeck
{
    
    [self.masterDeck removeAllObjects];
    
    NSLog(@"is 42 now?:%@",[self is42]?@"42!":@"38!");
    
    // Instantiate and add all 52 cards.
    [self.masterDeck addObject:[[Card alloc] initWithSuit:@"spade" value:1 filename:@"spadeA.png" color:@"black" andIndex:0 is42:[self is42] isCopy:NO]];
    [self.masterDeck addObject:[[Card alloc] initWithSuit:@"spade" value:2 filename:@"spade2.png" color:@"black" andIndex:1 is42:[self is42] isCopy:NO]];
    
    [self.masterDeck addObject:[[Card alloc] initWithSuit:@"spade" value:3 filename:@"spade3.png" color:@"black" andIndex:2 is42:[self is42] isCopy:NO]];
    
    [self.masterDeck addObject:[[Card alloc] initWithSuit:@"spade" value:4 filename:@"spade4.png" color:@"black" andIndex:3 is42:[self is42] isCopy:NO]];
    [self.masterDeck addObject:[[Card alloc] initWithSuit:@"spade" value:5 filename:@"spade5.png" color:@"black" andIndex:4 is42:[self is42] isCopy:NO]];
    [self.masterDeck addObject:[[Card alloc] initWithSuit:@"spade" value:6 filename:@"spade6.png" color:@"black" andIndex:5 is42:[self is42] isCopy:NO]];
    [self.masterDeck addObject:[[Card alloc] initWithSuit:@"spade" value:7 filename:@"spade7.png" color:@"black" andIndex:6 is42:[self is42] isCopy:NO]];
    [self.masterDeck addObject:[[Card alloc] initWithSuit:@"spade" value:8 filename:@"spade8.png" color:@"black" andIndex:7 is42:[self is42] isCopy:NO]];
    [self.masterDeck addObject:[[Card alloc] initWithSuit:@"spade" value:9 filename:@"spade9.png" color:@"black" andIndex:8 is42:[self is42] isCopy:NO]];
    
    [self.masterDeck addObject:[[Card alloc] initWithSuit:@"spade" value:10 filename:@"spade10.png" color:@"black" andIndex:9 is42:[self is42] isCopy:NO]];
    [self.masterDeck addObject:[[Card alloc] initWithSuit:@"spade" value:11 filename:@"spadeJ.png" color:@"black" andIndex:10 is42:[self is42] isCopy:NO]];
    [self.masterDeck addObject:[[Card alloc] initWithSuit:@"spade" value:12 filename:@"spadeQ.png" color:@"black" andIndex:11 is42:[self is42] isCopy:NO]];
    [self.masterDeck addObject:[[Card alloc] initWithSuit:@"spade" value:13 filename:@"spadeK.png" color:@"black" andIndex:12 is42:[self is42] isCopy:NO]];
    
    [self.masterDeck addObject:[[Card alloc] initWithSuit:@"club" value:1 filename:@"clubA.png" color:@"black" andIndex:13 is42:[self is42] isCopy:NO]];
    [self.masterDeck addObject:[[Card alloc] initWithSuit:@"club" value:2 filename:@"club2.png" color:@"black" andIndex:14 is42:[self is42] isCopy:NO]];
    [self.masterDeck addObject:[[Card alloc] initWithSuit:@"club" value:3 filename:@"club3.png" color:@"black" andIndex:15 is42:[self is42] isCopy:NO]];
    [self.masterDeck addObject:[[Card alloc] initWithSuit:@"club" value:4 filename:@"club4.png" color:@"black" andIndex:16 is42:[self is42] isCopy:NO]];
    [self.masterDeck addObject:[[Card alloc] initWithSuit:@"club" value:5 filename:@"club5.png" color:@"black" andIndex:17 is42:[self is42] isCopy:NO]];
    [self.masterDeck addObject:[[Card alloc] initWithSuit:@"club" value:6 filename:@"club6.png" color:@"black" andIndex:18 is42:[self is42] isCopy:NO]];
    [self.masterDeck addObject:[[Card alloc] initWithSuit:@"club" value:7 filename:@"club7.png" color:@"black" andIndex:19 is42:[self is42] isCopy:NO]];
    [self.masterDeck addObject:[[Card alloc] initWithSuit:@"club" value:8 filename:@"club8.png" color:@"black" andIndex:20 is42:[self is42] isCopy:NO]];
    [self.masterDeck addObject:[[Card alloc] initWithSuit:@"club" value:9 filename:@"club9.png" color:@"black" andIndex:21 is42:[self is42] isCopy:NO]];
    
    [self.masterDeck addObject:[[Card alloc] initWithSuit:@"club" value:10 filename:@"club10.png" color:@"black" andIndex:22 is42:[self is42] isCopy:NO]];
    [self.masterDeck addObject:[[Card alloc] initWithSuit:@"club" value:11 filename:@"clubJ.png" color:@"black" andIndex:23 is42:[self is42] isCopy:NO]];
    [self.masterDeck addObject:[[Card alloc] initWithSuit:@"club" value:12 filename:@"clubQ.png" color:@"black" andIndex:24 is42:[self is42] isCopy:NO]];
    [self.masterDeck addObject:[[Card alloc] initWithSuit:@"club" value:13 filename:@"clubK.png" color:@"black" andIndex:25 is42:[self is42] isCopy:NO]];
    
    [self.masterDeck addObject:[[Card alloc] initWithSuit:@"diamond" value:1 filename:@"diamondA.png" color:@"red" andIndex:26 is42:[self is42] isCopy:NO]];
    [self.masterDeck addObject:[[Card alloc] initWithSuit:@"diamond" value:2 filename:@"diamond2.png" color:@"red" andIndex:27 is42:[self is42] isCopy:NO]];
    [self.masterDeck addObject:[[Card alloc] initWithSuit:@"diamond" value:3 filename:@"diamond3.png" color:@"red" andIndex:28 is42:[self is42] isCopy:NO]];
    [self.masterDeck addObject:[[Card alloc] initWithSuit:@"diamond" value:4 filename:@"diamond4.png" color:@"red" andIndex:29 is42:[self is42] isCopy:NO]];
    [self.masterDeck addObject:[[Card alloc] initWithSuit:@"diamond" value:5 filename:@"diamond5.png" color:@"red" andIndex:30 is42:[self is42] isCopy:NO]];
    [self.masterDeck addObject:[[Card alloc] initWithSuit:@"diamond" value:6 filename:@"diamond6.png" color:@"red" andIndex:31 is42:[self is42] isCopy:NO]];
    [self.masterDeck addObject:[[Card alloc] initWithSuit:@"diamond" value:7 filename:@"diamond7.png" color:@"red" andIndex:32 is42:[self is42] isCopy:NO]];
    [self.masterDeck addObject:[[Card alloc] initWithSuit:@"diamond" value:8 filename:@"diamond8.png" color:@"red" andIndex:33 is42:[self is42] isCopy:NO]];
    [self.masterDeck addObject:[[Card alloc] initWithSuit:@"diamond" value:9 filename:@"diamond9.png" color:@"red" andIndex:34 is42:[self is42] isCopy:NO]];
    [self.masterDeck addObject:[[Card alloc] initWithSuit:@"diamond" value:10 filename:@"diamond10.png" color:@"red" andIndex:35 is42:[self is42] isCopy:NO]];
    
    [self.masterDeck addObject:[[Card alloc] initWithSuit:@"diamond" value:11 filename:@"diamondJ.png" color:@"red" andIndex:36 is42:[self is42] isCopy:NO]];
    [self.masterDeck addObject:[[Card alloc] initWithSuit:@"diamond" value:12 filename:@"diamondQ.png" color:@"red" andIndex:37 is42:[self is42] isCopy:NO]];
    [self.masterDeck addObject:[[Card alloc] initWithSuit:@"diamond" value:13 filename:@"diamondK.png" color:@"red" andIndex:38 is42:[self is42] isCopy:NO]];
    
    [self.masterDeck addObject:[[Card alloc] initWithSuit:@"heart" value:1 filename:@"heartA.png" color:@"red" andIndex:39 is42:[self is42] isCopy:NO]];
    [self.masterDeck addObject:[[Card alloc] initWithSuit:@"heart" value:2 filename:@"heart2.png" color:@"red" andIndex:40 is42:[self is42] isCopy:NO]];
    [self.masterDeck addObject:[[Card alloc] initWithSuit:@"heart" value:3 filename:@"heart3.png" color:@"red" andIndex:41 is42:[self is42] isCopy:NO]];
    [self.masterDeck addObject:[[Card alloc] initWithSuit:@"heart" value:4 filename:@"heart4.png" color:@"red" andIndex:42 is42:[self is42] isCopy:NO]];
    [self.masterDeck addObject:[[Card alloc] initWithSuit:@"heart" value:5 filename:@"heart5.png" color:@"red" andIndex:43 is42:[self is42] isCopy:NO]];
    [self.masterDeck addObject:[[Card alloc] initWithSuit:@"heart" value:6 filename:@"heart6.png" color:@"red" andIndex:44 is42:[self is42] isCopy:NO]];
    [self.masterDeck addObject:[[Card alloc] initWithSuit:@"heart" value:7 filename:@"heart7.png" color:@"red" andIndex:45 is42:[self is42] isCopy:NO]];
    [self.masterDeck addObject:[[Card alloc] initWithSuit:@"heart" value:8 filename:@"heart8.png" color:@"red" andIndex:46 is42:[self is42] isCopy:NO]];
    [self.masterDeck addObject:[[Card alloc] initWithSuit:@"heart" value:9 filename:@"heart9.png" color:@"red" andIndex:47 is42:[self is42] isCopy:NO]];
    [self.masterDeck addObject:[[Card alloc] initWithSuit:@"heart" value:10 filename:@"heart10.png" color:@"red" andIndex:48 is42:[self is42] isCopy:NO]];
    [self.masterDeck addObject:[[Card alloc] initWithSuit:@"heart" value:11 filename:@"heartJ.png" color:@"red" andIndex:49 is42:[self is42] isCopy:NO]];
    [self.masterDeck addObject:[[Card alloc] initWithSuit:@"heart" value:12 filename:@"heartQ.png" color:@"red" andIndex:50 is42:[self is42] isCopy:NO]];
    [self.masterDeck addObject:[[Card alloc] initWithSuit:@"heart" value:13 filename:@"heartK.png" color:@"red" andIndex:51 is42:[self is42] isCopy:NO]];
    cardNames = @[@"Unknown",@"Ace",@"One",@"Two",@"Three",@"Four",@"Five",@"Six",@"Seven",@"Eight",@"Nine",@"10",@"Jack",@"Queen",@"King"];
}

-(void) shuffleMasterDeck
{
    [SolitaireGameEngine shuffleMasterDeckInState:self.gameState];
}

-(BOOL) applyDealOrderToMasterDeck:(NSArray<NSNumber*>*) dealOrder
{
    if (![SolitaireSolvedDealProvider isValidDealOrder:dealOrder])
    {
        return NO;
    }
    if ([self.masterDeck count] != 52)
    {
        return NO;
    }
    NSArray* originalDeck = [NSArray arrayWithArray:self.masterDeck];
    [self.masterDeck removeAllObjects];
    for (NSNumber* indexNumber in dealOrder)
    {
        NSInteger index = [indexNumber integerValue];
        [self.masterDeck addObject:[originalDeck objectAtIndex:index]];
    }
    return YES;
}

- (void) setupNewBoard
{
    if (self.hasSelected)
    {
        [self.selectedImage setAlpha:1];
    }
    self.isStackEmpty = false;
    self.lastFlipCount = 3;
    self.hasSelected = false;
    for(int i = 0; i < [self.handArray count]; i++)
    {
        [[self.handArray objectAtIndex:i] removeAllObjects];
    }
    
    [self.discard1 removeAllObjects];
    [self.discard2 removeAllObjects];
    [self.discard3 removeAllObjects];
    [self.discard4 removeAllObjects];
    
    [self.deckFlip removeAllObjects];
    [self.deckFlipDiscard removeAllObjects];
    [self.deckStack removeAllObjects];
    
    // First, we need to shuffle a deck.
    // Start with a deck.
    [self loadMasterDeck];

    NSArray<NSNumber*>* solvedDealOrder = [SolitaireSolvedDealProvider nextDealOrderFromDefaults:self.sharedDefaults];
    BOOL appliedSolvedDeal = [self applyDealOrderToMasterDeck:solvedDealOrder];
    if (!appliedSolvedDeal)
    {
        NSLog(@"Solved deal unavailable/invalid. Falling back to shuffle path.");
        [self shuffleMasterDeck];
    }
    else
    {
        NSLog(@"Applied solved deal ordering for new board.");
    }
    
    // Deal to all hands.
    [self dealToStacks];
    
    [self flipFromDeck];
    
    [self renderFullBoard];
    
    [self saveBoard];
    
    // Fixes bug.
    [self.deckStack1Image setImageNamed:[self platform:@"facedown.png"]];
}

-(NSString*) platform:(NSString*) filename
{
    return [Card resolveAssetFilenameForBaseFilename:filename skin:nil preferLarge:[self is42]];
}

-(void) renderStack
{
    if ([self.deckStack count] == 0)
    {
        [self.deckStack1Image setImageNamed:[self platform:@"cardback.png"]];
        self.isStackEmpty = YES;
        
        [self.deckStack2Image setHidden:YES];
        [self.deckStack3Image setHidden:YES];
    }
    else
    {
        if (self.isStackEmpty)
        {
            [self.deckStack1Image setImageNamed:[self platform:@"facedown.png"]];
            self.isStackEmpty = NO;
        }
        if ([self.deckStack count] == 1)
        {
            [self.deckStack1Image setHidden:NO];
            [self.deckStack2Image setHidden:YES];
            [self.deckStack3Image setHidden:YES];
        }
        else
            if ([self.deckStack count] == 2)
            {
                
                [self.deckStack1Image setHidden:NO];
                [self.deckStack2Image setHidden:NO];
                [self.deckStack3Image setHidden:YES];
            }
            else
            {
                [self.deckStack1Image setHidden:NO];
                [self.deckStack2Image setHidden:NO];
                [self.deckStack3Image setHidden:NO];
            }
    }
    
}

-(void) renderDiscard
{
    //
    if ([self.discard1 count] > 0)
    {
        Card* card = [self.discard1 lastObject];
        [self.discard1Image setImageNamed:card.filename];
    }
    else
    {
        [self.discard1Image setImageNamed:[self platform:@"cardback.png"]];
    }
    
    if ([self.discard2 count] > 0)
    {
        Card* card = [self.discard2 lastObject];
        [self.discard2Image setImageNamed:card.filename];
    }
    else
    {
        [self.discard2Image setImageNamed:[self platform:@"cardback.png"]];
    }
    
    if ([self.discard3 count] > 0)
    {
        Card* card = [self.discard3 lastObject];
        [self.discard3Image setImageNamed:card.filename];
    }
    else
    {
        [self.discard3Image setImageNamed:[self platform:@"cardback.png"]];
    }
    
    if ([self.discard4 count] > 0)
    {
        Card* card = [self.discard4 lastObject];
        [self.discard4Image setImageNamed:card.filename];
    }
    else
    {
        [self.discard4Image setImageNamed:[self platform:@"cardback.png"]];
    }
}
//static bool checkRecursiveFlipRender = false;
-(void) renderFlip
{
    @try {
        
    if ([self.deckFlip count] == 0)
    {
        //Card* flipBottom = [self.deckFlip objectAtIndex:0];
        //if ([self.deckFlip count] != self.lastFlipCount)
        
        {
            [self.deckFlip1Image setHidden:YES];
            [self.deckFlip2Image setHidden:YES];
            [self.deckFlip3Image setHidden:YES];
        }
        //Turn off flip button!?
        // Actually, let's deal if we need to!
        if ([self.deckStack count] > 0 || [self.deckFlipDiscard count] > 0)
        {
            [self flipFromDeck];
            [self renderFlip];
            [self renderStack];
        }
    }
    else
        if ([self.deckFlip count] == 1)
        {
           // if ([self.deckFlip count] != self.lastFlipCount)
            {
                //[self.deckFlip1Image setWidth:[self cardWidth]];
                [self.deckFlip1Image setHidden:YES];
                [self.deckFlip2Image setHidden:YES];
                [self.deckFlip3Image setHidden:NO];
            }
            Card* card3 = [self.deckFlip objectAtIndex:0];
            [self.deckFlip3Image setImageNamed:card3.filename];
        }
        else
            if ([self.deckFlip count] == 2)
            {
                //if ([self.deckFlip count] != self.lastFlipCount)
                {
                    [self.deckFlip1Image setHidden:YES];
                    [self.deckFlip2Image setHidden:NO];
                    
                    
                    [self.deckFlip3Image setHidden:NO];
                    NSLog(@"what?");
                }
                Card* card1 = [self.deckFlip objectAtIndex:0];
                [self.deckFlip2Image setImageNamed:card1.filename];
                Card* card2 = [self.deckFlip objectAtIndex:1];
                [self.deckFlip3Image setImageNamed:card2.filename];
            }
            else
                if ([self.deckFlip count] == 3)
                {
                   // if ([self.deckFlip count] != self.lastFlipCount)
                    {
                        //[self.deckFlip1Image setWidth:(int)[self hiddenFlipWidth]];
                        //[self.deckFlip2Image setWidth:(int)[self hiddenFlipWidth]];
                      //  NSLog(@"self.deckFlip3Image - %@ %ld - %ld",self.deckFlip3Image, (long)[self cardWidth],(long)[self hiddenFlipWidth]);
                      //  [self.deckFlip3Image setWidth:(int)[self cardWidth]];
                        [self.deckFlip1Image setHidden:NO];
                        [self.deckFlip2Image setHidden:NO];
                        [self.deckFlip3Image setHidden:NO];
                    }
                   // [self.deckFlip1Image setAlpha:.5f];
                    Card* card1 = [self.deckFlip objectAtIndex:0];
                    [self.deckFlip1Image setImageNamed:card1.filename];
                    Card* card2 = [self.deckFlip objectAtIndex:1];
                    [self.deckFlip2Image setImageNamed:card2.filename];
                    Card* card3 = [self.deckFlip objectAtIndex:2];
                    [self.deckFlip3Image setImageNamed:card3.filename];
                }
    else
    {
        NSLog(@"shouldn't be possible!");
    }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception!%@", exception);
    }
    @finally {
         NSLog(@"finally!!");
    }
}

-(void) renderHand:(int) hand
{
    int startIndex = hand*20;
    
    NSMutableArray* handFromArray = [self.handArray objectAtIndex:hand];
    for(int i = 0; i < 20; i++)
    {
        WKInterfaceImage* handImage = [self.handCardImages objectAtIndex:startIndex + i];
        // Now, let's set the values
        if (i < [handFromArray count])
        {
            Card* cardFromHand = [handFromArray objectAtIndex:i];
            [handImage setHidden:NO];
            
            if (cardFromHand.isFacingUp)
            {
                // Set image.
                [handImage setImageNamed:cardFromHand.filename];
                
                // If last card, make full height.
                if (i == [handFromArray count]-1)
                {
                    [handImage setHeight:[self handUpFront]];
                    [handImage setWidth:[self cardWidth]];
                }
                else
                {
                    [handImage setHeight:[self handUpBehind]];
                    [handImage setWidth:[self cardWidth]];
                }
            }
            else
            {
                // Set image.
                [handImage setImageNamed:[self platform:@"facedown.png"]];
                [handImage setHeight:[self handDownFacing]];
                [handImage setWidth:[self cardWidth]];
            }
        }
        else
        {
            [handImage setHidden:YES];
        }
    }
}

-(void) renderFullBoard
{
  
    [self renderStack];
    
    [self renderFlip];
    
    for(int i = 0; i < 7; i++)
    {
        [self renderHand:i];
    }
    
    [self renderDiscard];
}

-(void) checkWinner
{
    if ([self.discard1 count]==13
        && [self.discard2 count]==13
        && [self.discard3 count]==13
        && [self.discard4 count]==13)
    {
        [self pushControllerWithName:@"winner" context:nil];
        [self setupNewBoard];
    }
}

-(void) move:(int) cards CardsFromStack:(NSMutableArray*) fromStack toStack:(NSMutableArray*) toStack orderPreserved:(BOOL) preserved
{
    [SolitaireGameEngine moveCards:cards fromStack:fromStack toStack:toStack orderPreserved:preserved];
}


-(void) move:(int) cards CardsFromStack:(NSMutableArray*) fromStack toStack:(NSMutableArray*) toStack dealStacked:(BOOL) dealStacked
{
    [SolitaireGameEngine moveCards:cards fromStack:fromStack toStack:toStack dealStacked:dealStacked];
}

-(void) flipFromDeck
{
    [SolitaireGameEngine flipFromDeckInState:self.gameState flipCardsNumber:self.flipCardsNumber];
}

-(void) dealToStacks
{
    [SolitaireGameEngine dealToStacksInState:self.gameState];
}

-(BOOL) is38
{
    return true;
}


-(Card*) cardCopyFromMasterIndex:(NSInteger) index
{
    // Handle the ace of spades issue of index 0 can't carry negative!
    if (index == 100 || index == -100)
    {
        
        BOOL isFacedown = false;
        //NSInteger unsignedIndex = index < 0 ? (index * -1): index;
        if (index < 0)
        {
            isFacedown = true;
        }
        else
        {
            isFacedown = false;
        }
        
        // If negative, face down!
        Card* masterCard = [self.masterDeck objectAtIndex:0];
        if (isFacedown)
        {
            [masterCard setIsFacingUp:NO];
        }
        else
        {
            [masterCard setIsFacingUp:YES];
        }
        
        return [masterCard copyCard];
    }
    else
    {
    
        BOOL isFacedown = false;
        NSInteger unsignedIndex = index < 0 ? (index * -1): index;
        if (index < 0)
        {
            isFacedown = true;
        }
        else
        {
            isFacedown = false;
        }
        
        // If negative, face down!
        Card* masterCard = [self.masterDeck objectAtIndex:unsignedIndex];
        if (isFacedown)
        {
            [masterCard setIsFacingUp:NO];
        }
        else
        {
            [masterCard setIsFacingUp:YES];
        }
        
        return [masterCard copyCard];
    }
}

-(void) loadCardsIntoArray:(NSMutableArray*) intoArray fromIndexArray:(NSArray*) indexArray
{
    for(int i = 0; i < [indexArray count]; i++)
    {
        NSNumber* indexNumber = [indexArray objectAtIndex:i];
        
        Card* copyFromIndex = [self cardCopyFromMasterIndex:[indexNumber integerValue]];
        [intoArray addObject:copyFromIndex];
    }
}

-(NSArray<NSMutableArray*>*) boardStackCollections
{
    [self ensureBoardStacksAllocated];
    return @[
        self.deckStack ?: [[NSMutableArray alloc] init],
        self.deckFlip ?: [[NSMutableArray alloc] init],
        self.deckFlipDiscard ?: [[NSMutableArray alloc] init],
        self.hand0 ?: [[NSMutableArray alloc] init],
        self.hand1 ?: [[NSMutableArray alloc] init],
        self.hand2 ?: [[NSMutableArray alloc] init],
        self.hand3 ?: [[NSMutableArray alloc] init],
        self.hand4 ?: [[NSMutableArray alloc] init],
        self.hand5 ?: [[NSMutableArray alloc] init],
        self.hand6 ?: [[NSMutableArray alloc] init],
        self.discard1 ?: [[NSMutableArray alloc] init],
        self.discard2 ?: [[NSMutableArray alloc] init],
        self.discard3 ?: [[NSMutableArray alloc] init],
        self.discard4 ?: [[NSMutableArray alloc] init]
    ];
}

-(void) ensureBoardStacksAllocated
{
    if (self.deckStack == nil) self.deckStack = [[NSMutableArray alloc] init];
    if (self.deckFlip == nil) self.deckFlip = [[NSMutableArray alloc] init];
    if (self.deckFlipDiscard == nil) self.deckFlipDiscard = [[NSMutableArray alloc] init];
    if (self.hand0 == nil) self.hand0 = [[NSMutableArray alloc] init];
    if (self.hand1 == nil) self.hand1 = [[NSMutableArray alloc] init];
    if (self.hand2 == nil) self.hand2 = [[NSMutableArray alloc] init];
    if (self.hand3 == nil) self.hand3 = [[NSMutableArray alloc] init];
    if (self.hand4 == nil) self.hand4 = [[NSMutableArray alloc] init];
    if (self.hand5 == nil) self.hand5 = [[NSMutableArray alloc] init];
    if (self.hand6 == nil) self.hand6 = [[NSMutableArray alloc] init];
    if (self.discard1 == nil) self.discard1 = [[NSMutableArray alloc] init];
    if (self.discard2 == nil) self.discard2 = [[NSMutableArray alloc] init];
    if (self.discard3 == nil) self.discard3 = [[NSMutableArray alloc] init];
    if (self.discard4 == nil) self.discard4 = [[NSMutableArray alloc] init];
}

-(void) migrateLegacyDefaultsIfNeeded
{
    NSUserDefaults* standardDefaults = [NSUserDefaults standardUserDefaults];
    if (self.sharedDefaults == nil || self.sharedDefaults == standardDefaults)
    {
        return;
    }

    NSArray* migrationKeys = @[
        kSavedDataKey,
        kSavedDataSchemaVersionKey,
        kFlipCardNumberKey,
        kSolvedDealsKey,
        kSolvedDealSelectionModeKey,
        kSolvedDealFixedIndexKey,
        kSolvedDealRoundRobinIndexKey,
        kSolvedDealLastIndexKey
    ];

    BOOL copiedAnyValue = NO;
    for (NSString* key in migrationKeys)
    {
        if ([self.sharedDefaults objectForKey:key] != nil)
        {
            continue;
        }
        id legacyValue = [standardDefaults objectForKey:key];
        if (legacyValue != nil)
        {
            [self.sharedDefaults setObject:legacyValue forKey:key];
            copiedAnyValue = YES;
        }
    }
    if (copiedAnyValue)
    {
        [self.sharedDefaults synchronize];
    }
}

-(NSArray<NSArray<NSNumber*>*>*) validatedStacksFromSaveJSON:(id) jsonObject
{
    NSArray* stackCandidates = nil;
    if ([jsonObject isKindOfClass:[NSArray class]])
    {
        stackCandidates = (NSArray*)jsonObject;
    }
    else if ([jsonObject isKindOfClass:[NSDictionary class]])
    {
        stackCandidates = [(NSDictionary*)jsonObject objectForKey:@"stacks"];
    }

    if (![stackCandidates isKindOfClass:[NSArray class]] || [stackCandidates count] != kSaveStateStackCount)
    {
        return nil;
    }

    NSMutableArray<NSArray<NSNumber*>*>* validatedStacks = [[NSMutableArray alloc] initWithCapacity:kSaveStateStackCount];
    NSMutableSet* uniqueCardIndexes = [[NSMutableSet alloc] initWithCapacity:kTotalCardsInDeck];
    NSInteger cardCount = 0;

    for (id stack in stackCandidates)
    {
        if (![stack isKindOfClass:[NSArray class]])
        {
            return nil;
        }
        NSMutableArray<NSNumber*>* normalizedStack = [[NSMutableArray alloc] initWithCapacity:[(NSArray*)stack count]];
        for (id value in (NSArray*)stack)
        {
            if (![value isKindOfClass:[NSNumber class]])
            {
                return nil;
            }
            NSInteger cardIndex = [(NSNumber*)value integerValue];
            NSInteger absoluteIndex = labs(cardIndex);
            if (absoluteIndex < 1 || absoluteIndex > kTotalCardsInDeck)
            {
                return nil;
            }
            NSNumber* absoluteKey = @(absoluteIndex);
            if ([uniqueCardIndexes containsObject:absoluteKey])
            {
                return nil;
            }
            [uniqueCardIndexes addObject:absoluteKey];
            [normalizedStack addObject:@(cardIndex)];
            cardCount += 1;
        }
        [validatedStacks addObject:normalizedStack];
    }

    if (cardCount != kTotalCardsInDeck || [uniqueCardIndexes count] != kTotalCardsInDeck)
    {
        return nil;
    }
    return validatedStacks;
}

-(void) cleanBoardData
{
    [self.deckStack removeAllObjects];
    [self.deckFlip removeAllObjects];
    [self.deckFlipDiscard removeAllObjects];
    [self.hand0 removeAllObjects];
    [self.hand1 removeAllObjects];
    [self.hand2 removeAllObjects];
    [self.hand3 removeAllObjects];
    [self.hand4 removeAllObjects];
    [self.hand5 removeAllObjects];
    [self.hand6 removeAllObjects];
    [self.discard1 removeAllObjects];
    [self.discard2 removeAllObjects];
    [self.discard3 removeAllObjects];
    [self.discard4 removeAllObjects];
}

-(BOOL) loadBoardFromValidatedStacks:(NSArray<NSArray<NSNumber*>*>*) stacks
{
    if (stacks == nil || [stacks count] != kSaveStateStackCount)
    {
        return NO;
    }
    [self cleanBoardData];
    [self loadMasterDeck];
    NSArray<NSMutableArray*>* destinations = [self boardStackCollections];
    for (NSInteger i = 0; i < kSaveStateStackCount; i++)
    {
        [self loadCardsIntoArray:[destinations objectAtIndex:i] fromIndexArray:[stacks objectAtIndex:i]];
    }
    [self renderFullBoard];
    [self setupAccessibility];
    return YES;
}

-(void) loadBoard
{
    NSData* savedData = [self.sharedDefaults objectForKey:kSavedDataKey];
    if (![savedData isKindOfClass:[NSData class]])
    {
        [self setupNewBoard];
        return;
    }

    NSError* error = nil;
    id saveJSON = [NSJSONSerialization JSONObjectWithData:savedData options:NSJSONReadingAllowFragments error:&error];
    NSArray<NSArray<NSNumber*>*>* stacks = [self validatedStacksFromSaveJSON:saveJSON];
    if (error != nil || stacks == nil || ![self loadBoardFromValidatedStacks:stacks])
    {
        NSLog(@"Saved board data invalid; rebuilding a fresh board to prevent load loop.");
        [self setupNewBoard];
        return;
    }

    NSInteger schemaVersion = [[self.sharedDefaults objectForKey:kSavedDataSchemaVersionKey] integerValue];
    if (schemaVersion < kCurrentSaveStateSchemaVersion)
    {
        [self persistStacks:stacks notifyCompanion:NO];
    }
}

-(void) saveBoard
{
    NSArray<NSMutableArray*>* boardStacks = [self boardStackCollections];
    NSMutableArray<NSArray<NSNumber*>*>* stacksToPersist = [[NSMutableArray alloc] initWithCapacity:kSaveStateStackCount];
    for (NSMutableArray* stack in boardStacks)
    {
        NSMutableArray<NSNumber*>* serializedStack = [[NSMutableArray alloc] initWithCapacity:[stack count]];
        for (Card* card in stack)
        {
            NSInteger signedIndex = [card getSaveIndex] * (card.isFacingUp ? 1 : -1);
            [serializedStack addObject:@(signedIndex)];
        }
        [stacksToPersist addObject:serializedStack];
    }
    [self persistStacks:stacksToPersist notifyCompanion:YES];
    [self setupAccessibility];
}

-(void) persistStacks:(NSArray<NSArray<NSNumber*>*>*) stacks notifyCompanion:(BOOL) notifyCompanion
{
    NSError* serializationError = nil;
    NSData* saveData = [NSJSONSerialization dataWithJSONObject:stacks options:NSJSONWritingPrettyPrinted error:&serializationError];
    if (serializationError != nil || saveData == nil)
    {
        NSLog(@"Unable to persist save data: %@", serializationError);
        return;
    }
    [self.sharedDefaults setObject:saveData forKey:kSavedDataKey];
    [self.sharedDefaults setObject:@(kCurrentSaveStateSchemaVersion) forKey:kSavedDataSchemaVersionKey];
    [self.sharedDefaults synchronize];

    if (notifyCompanion)
    {
        [self.wormhole passMessageObject:@{}
                              identifier:@"loadSavedStateNative"];
    }
}

-(void) restoreBoard
{
    // Steps -
    // Get Deck Array indexes
    // Get Flip Array indexes
    // Get Flip Discard Array indexes
    // Get All Hands indexes
    // Get All discards indexes
    
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    [self setTitle:@""];
    [self presentControllerWithName:@"swiftuiRoot" context:nil];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end
