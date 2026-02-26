//
//  ViewController.m
//  Solitaire Watch
//
//  Created by Shayne Guiliano on 12/28/14.
//  Copyright (c) 2014 Shayne Guiliano. All rights reserved.
//

#import "ViewController.h"
#import "MMWormhole.h"
#import "PossibleMove.h"

@interface ViewController ()
@property (nonatomic,strong) MMWormhole* wormhole;
-(IBAction)clickedReset:(id)sender;
@property (nonatomic, strong) NSUserDefaults* sharedDefaults;
@property (strong, nonatomic) IBOutlet UIButton* deckFlipButton;
@property (strong, nonatomic) IBOutlet UIButton* cardGameToggle;
@property (strong, nonatomic) IBOutlet UIButton* touchToggle;
-(IBAction)toggleTouchCount:(id)sender;
-(IBAction)toggleCardNumber:(id)sender;
@property (nonatomic,strong) NSArray* discardArray;
@property (strong, nonatomic) IBOutlet UIImageView* card0x0;
@property (strong, nonatomic) IBOutlet UIImageView* card0x1;
@property (strong, nonatomic) IBOutlet UIImageView* card0x2;
@property (strong, nonatomic) IBOutlet UIImageView* card0x3;
@property (strong, nonatomic) IBOutlet UIImageView* card0x4;
@property (strong, nonatomic) IBOutlet UIImageView* card0x5;
@property (strong, nonatomic) IBOutlet UIImageView* card0x6;
@property (strong, nonatomic) IBOutlet UIImageView* card0x7;
@property (strong, nonatomic) IBOutlet UIImageView* card0x8;
@property (strong, nonatomic) IBOutlet UIImageView* card0x9;
@property (strong, nonatomic) IBOutlet UIImageView* card0x10;
@property (strong, nonatomic) IBOutlet UIImageView* card0x11;
@property (strong, nonatomic) IBOutlet UIImageView* card0x12;
@property (strong, nonatomic) IBOutlet UIImageView* card0x13;
@property (strong, nonatomic) IBOutlet UIImageView* card0x14;
@property (strong, nonatomic) IBOutlet UIImageView* card0x15;
@property (strong, nonatomic) IBOutlet UIImageView* card0x16;
@property (strong, nonatomic) IBOutlet UIImageView* card0x17;
@property (strong, nonatomic) IBOutlet UIImageView* card0x18;
@property (strong, nonatomic) IBOutlet UIImageView* card0x19;

@property (strong, nonatomic) IBOutlet UIImageView* card1x0;
@property (strong, nonatomic) IBOutlet UIImageView* card1x1;
@property (strong, nonatomic) IBOutlet UIImageView* card1x2;
@property (strong, nonatomic) IBOutlet UIImageView* card1x3;
@property (strong, nonatomic) IBOutlet UIImageView* card1x4;
@property (strong, nonatomic) IBOutlet UIImageView* card1x5;
@property (strong, nonatomic) IBOutlet UIImageView* card1x6;
@property (strong, nonatomic) IBOutlet UIImageView* card1x7;
@property (strong, nonatomic) IBOutlet UIImageView* card1x8;
@property (strong, nonatomic) IBOutlet UIImageView* card1x9;
@property (strong, nonatomic) IBOutlet UIImageView* card1x10;
@property (strong, nonatomic) IBOutlet UIImageView* card1x11;
@property (strong, nonatomic) IBOutlet UIImageView* card1x12;
@property (strong, nonatomic) IBOutlet UIImageView* card1x13;
@property (strong, nonatomic) IBOutlet UIImageView* card1x14;
@property (strong, nonatomic) IBOutlet UIImageView* card1x15;
@property (strong, nonatomic) IBOutlet UIImageView* card1x16;
@property (strong, nonatomic) IBOutlet UIImageView* card1x17;
@property (strong, nonatomic) IBOutlet UIImageView* card1x18;
@property (strong, nonatomic) IBOutlet UIImageView* card1x19;

@property (strong, nonatomic) IBOutlet UIImageView* card2x0;
@property (strong, nonatomic) IBOutlet UIImageView* card2x1;
@property (strong, nonatomic) IBOutlet UIImageView* card2x2;
@property (strong, nonatomic) IBOutlet UIImageView* card2x3;
@property (strong, nonatomic) IBOutlet UIImageView* card2x4;
@property (strong, nonatomic) IBOutlet UIImageView* card2x5;
@property (strong, nonatomic) IBOutlet UIImageView* card2x6;
@property (strong, nonatomic) IBOutlet UIImageView* card2x7;
@property (strong, nonatomic) IBOutlet UIImageView* card2x8;
@property (strong, nonatomic) IBOutlet UIImageView* card2x9;
@property (strong, nonatomic) IBOutlet UIImageView* card2x10;
@property (strong, nonatomic) IBOutlet UIImageView* card2x11;
@property (strong, nonatomic) IBOutlet UIImageView* card2x12;
@property (strong, nonatomic) IBOutlet UIImageView* card2x13;
@property (strong, nonatomic) IBOutlet UIImageView* card2x14;
@property (strong, nonatomic) IBOutlet UIImageView* card2x15;
@property (strong, nonatomic) IBOutlet UIImageView* card2x16;
@property (strong, nonatomic) IBOutlet UIImageView* card2x17;
@property (strong, nonatomic) IBOutlet UIImageView* card2x18;
@property (strong, nonatomic) IBOutlet UIImageView* card2x19;

@property (strong, nonatomic) IBOutlet UIImageView* card3x0;
@property (strong, nonatomic) IBOutlet UIImageView* card3x1;
@property (strong, nonatomic) IBOutlet UIImageView* card3x2;
@property (strong, nonatomic) IBOutlet UIImageView* card3x3;
@property (strong, nonatomic) IBOutlet UIImageView* card3x4;
@property (strong, nonatomic) IBOutlet UIImageView* card3x5;
@property (strong, nonatomic) IBOutlet UIImageView* card3x6;
@property (strong, nonatomic) IBOutlet UIImageView* card3x7;
@property (strong, nonatomic) IBOutlet UIImageView* card3x8;
@property (strong, nonatomic) IBOutlet UIImageView* card3x9;
@property (strong, nonatomic) IBOutlet UIImageView* card3x10;
@property (strong, nonatomic) IBOutlet UIImageView* card3x11;
@property (strong, nonatomic) IBOutlet UIImageView* card3x12;
@property (strong, nonatomic) IBOutlet UIImageView* card3x13;
@property (strong, nonatomic) IBOutlet UIImageView* card3x14;
@property (strong, nonatomic) IBOutlet UIImageView* card3x15;
@property (strong, nonatomic) IBOutlet UIImageView* card3x16;
@property (strong, nonatomic) IBOutlet UIImageView* card3x17;
@property (strong, nonatomic) IBOutlet UIImageView* card3x18;
@property (strong, nonatomic) IBOutlet UIImageView* card3x19;

@property (strong, nonatomic) IBOutlet UIImageView* card4x0;
@property (strong, nonatomic) IBOutlet UIImageView* card4x1;
@property (strong, nonatomic) IBOutlet UIImageView* card4x2;
@property (strong, nonatomic) IBOutlet UIImageView* card4x3;
@property (strong, nonatomic) IBOutlet UIImageView* card4x4;
@property (strong, nonatomic) IBOutlet UIImageView* card4x5;
@property (strong, nonatomic) IBOutlet UIImageView* card4x6;
@property (strong, nonatomic) IBOutlet UIImageView* card4x7;
@property (strong, nonatomic) IBOutlet UIImageView* card4x8;
@property (strong, nonatomic) IBOutlet UIImageView* card4x9;
@property (strong, nonatomic) IBOutlet UIImageView* card4x10;
@property (strong, nonatomic) IBOutlet UIImageView* card4x11;
@property (strong, nonatomic) IBOutlet UIImageView* card4x12;
@property (strong, nonatomic) IBOutlet UIImageView* card4x13;
@property (strong, nonatomic) IBOutlet UIImageView* card4x14;
@property (strong, nonatomic) IBOutlet UIImageView* card4x15;
@property (strong, nonatomic) IBOutlet UIImageView* card4x16;
@property (strong, nonatomic) IBOutlet UIImageView* card4x17;
@property (strong, nonatomic) IBOutlet UIImageView* card4x18;
@property (strong, nonatomic) IBOutlet UIImageView* card4x19;

@property (strong, nonatomic) IBOutlet UIImageView* card5x0;
@property (strong, nonatomic) IBOutlet UIImageView* card5x1;
@property (strong, nonatomic) IBOutlet UIImageView* card5x2;
@property (strong, nonatomic) IBOutlet UIImageView* card5x3;
@property (strong, nonatomic) IBOutlet UIImageView* card5x4;
@property (strong, nonatomic) IBOutlet UIImageView* card5x5;
@property (strong, nonatomic) IBOutlet UIImageView* card5x6;
@property (strong, nonatomic) IBOutlet UIImageView* card5x7;
@property (strong, nonatomic) IBOutlet UIImageView* card5x8;
@property (strong, nonatomic) IBOutlet UIImageView* card5x9;
@property (strong, nonatomic) IBOutlet UIImageView* card5x10;
@property (strong, nonatomic) IBOutlet UIImageView* card5x11;
@property (strong, nonatomic) IBOutlet UIImageView* card5x12;
@property (strong, nonatomic) IBOutlet UIImageView* card5x13;
@property (strong, nonatomic) IBOutlet UIImageView* card5x14;
@property (strong, nonatomic) IBOutlet UIImageView* card5x15;
@property (strong, nonatomic) IBOutlet UIImageView* card5x16;
@property (strong, nonatomic) IBOutlet UIImageView* card5x17;
@property (strong, nonatomic) IBOutlet UIImageView* card5x18;
@property (strong, nonatomic) IBOutlet UIImageView* card5x19;

@property (strong, nonatomic) IBOutlet UIImageView* card6x0;
@property (strong, nonatomic) IBOutlet UIImageView* card6x1;
@property (strong, nonatomic) IBOutlet UIImageView* card6x2;
@property (strong, nonatomic) IBOutlet UIImageView* card6x3;
@property (strong, nonatomic) IBOutlet UIImageView* card6x4;
@property (strong, nonatomic) IBOutlet UIImageView* card6x5;
@property (strong, nonatomic) IBOutlet UIImageView* card6x6;
@property (strong, nonatomic) IBOutlet UIImageView* card6x7;
@property (strong, nonatomic) IBOutlet UIImageView* card6x8;
@property (strong, nonatomic) IBOutlet UIImageView* card6x9;
@property (strong, nonatomic) IBOutlet UIImageView* card6x10;
@property (strong, nonatomic) IBOutlet UIImageView* card6x11;
@property (strong, nonatomic) IBOutlet UIImageView* card6x12;
@property (strong, nonatomic) IBOutlet UIImageView* card6x13;
@property (strong, nonatomic) IBOutlet UIImageView* card6x14;
@property (strong, nonatomic) IBOutlet UIImageView* card6x15;
@property (strong, nonatomic) IBOutlet UIImageView* card6x16;
@property (strong, nonatomic) IBOutlet UIImageView* card6x17;
@property (strong, nonatomic) IBOutlet UIImageView* card6x18;
@property (strong, nonatomic) IBOutlet UIImageView* card6x19;

@property (strong, nonatomic) IBOutlet UIImageView* deckStack1Image;
@property (strong, nonatomic) IBOutlet UIImageView* deckStack2Image;
@property (strong, nonatomic) IBOutlet UIImageView* deckStack3Image;

@property (strong, nonatomic) IBOutlet UIImageView* deckFlip1Image;
@property (strong, nonatomic) IBOutlet UIImageView* deckFlip2Image;
@property (strong, nonatomic) IBOutlet UIImageView* deckFlip3Image;

@property (strong, nonatomic) IBOutlet UIImageView* discard1Image;
@property (strong, nonatomic) IBOutlet UIImageView* discard2Image;
@property (strong, nonatomic) IBOutlet UIImageView* discard3Image;
@property (strong, nonatomic) IBOutlet UIImageView* discard4Image;

@property (strong, nonatomic) IBOutlet UIButton* hand0Button;
@property (strong, nonatomic) IBOutlet UIButton* hand1Button;
@property (strong, nonatomic) IBOutlet UIButton* hand2Button;
@property (strong, nonatomic) IBOutlet UIButton* hand3Button;
@property (strong, nonatomic) IBOutlet UIButton* hand4Button;
@property (strong, nonatomic) IBOutlet UIButton* hand5Button;
@property (strong, nonatomic) IBOutlet UIButton* hand6Button;

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
@property (strong, nonatomic) NSMutableArray* deckStack;
@property (strong, nonatomic) NSMutableArray* deckFlip;
@property (strong, nonatomic) NSMutableArray* deckFlipDiscard;
@property (strong, nonatomic) NSNumber* flipCardsNumber;

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
@property UIView* selectedImage;
@property CGRect movedFromFrame;
@property NSString* cardToMoveName;

@property (strong, nonatomic) UIImageView* imageForAnimation;
//@property NSUserDefaults* sharedDefaults;
//// HELPER PROP
@property CGRect contentFrame;
// END HELPER
@end

// HELPER CATEGORIES!
@interface WKMenuItemIcon : NSString

@end

@interface UIView (Solitaire)
-(void) setInverseAlpha:(CGFloat) alpha;
@end

@implementation UIView (Solitaire)

-(void) setInverseAlpha:(CGFloat) alpha
{
    float newAlpha = 1-alpha;
    if (newAlpha < .1f)
    {
        newAlpha = .015f;
    }
    
    if (newAlpha > .4f)
    {
        newAlpha = .7f;
    }
    self.alpha = newAlpha;//1-alpha;
}

@end

@interface ViewController (Solitaire)
// HELPER methods!
- (void)pushControllerWithName:(NSString *)name context:(id)context;
- (void)clearAllMenuItems;
@end

// Protocol for UIImageView setHeight?
@interface UIImageView (Solitaire)
- (void)setHeight:(CGFloat)height;
- (void)setImageNamed:(NSString *)imageName;
@end

@implementation UIImageView (Solitaire)
- (void)setHeight:(CGFloat)height
{
    CGRect currentFrame = self.frame;
    currentFrame.size.height = height;
 //   NSMutableArray* shuffledArray = [NSMutableArray arrayWithArray: self];
    //[shuffledArray shuffle];
    //return shuffledArray;
}


- (void)setWidth:(CGFloat)width
{
    CGRect currentFrame = self.frame;
    currentFrame.size.width = width;
    
    //   NSMutableArray* shuffledArray = [NSMutableArray arrayWithArray: self];
    //[shuffledArray shuffle];
    //return shuffledArray;
}

- (void)setImageNamed:(NSString *)imageName
{
    self.image = [UIImage imageNamed:imageName];
}
@end

@implementation UIViewController (Solitaire)







- (void)clearAllMenuItems
{
    
}
@end
/// END HELPER

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
// HELPER STRINGS
static NSString* WKMenuItemIconShuffle = @"WKMenuItemIconShuffle";
static NSString* WKMenuItemIconDecline = @"WKMenuItemIconDecline";
static NSString* WKMenuItemIconTrash = @"WKMenuItemIconTrash";
static NSString* WKMenuItemIconInfo = @"WKMenuItemIconInfo";
// END HELPER
static BOOL isOneTouchiPhone = NO;
@implementation ViewController

-(IBAction)clickedReset:(id)sender
{
    [self resetBoard];
}
- (void)pushControllerWithName: (NSString*) name context: (id) context {
    if ([name isEqualToString:@"winner"])
    {
        // Do what?
        NSString* gamesWon = [self.sharedDefaults objectForKey:[NSString stringWithFormat:@"gamesWon-%dcard",[self.flipCardsNumber intValue]]];
        int gamesWonInt = [gamesWon intValue];
        if (gamesWon == nil)
        {
            // first win!!
            UIAlertView* winnerAlert = [[UIAlertView alloc] initWithTitle:@"Winner!" message:[NSString stringWithFormat:@"Congratulations on your first %d-card win!  You're winning record will be saved locally, and count towards the leaderboard that will launch soon!",[self.flipCardsNumber intValue]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [winnerAlert show];
            [self.sharedDefaults setObject:@"1" forKey:[NSString stringWithFormat:@"gamesWon-%dcard",[self.flipCardsNumber intValue]]];
        }
        else
        {
            UIAlertView* winnerAlert = [[UIAlertView alloc] initWithTitle:@"You won!" message:[NSString stringWithFormat:@"Congratulations on winning %@ games of %d-card!  You're winning record will be saved locally, and count towards the leaderboard that will launch soon!", gamesWon,[self.flipCardsNumber intValue]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [winnerAlert show];
            gamesWonInt++;
            [self.sharedDefaults setObject:[NSString stringWithFormat:@"%d", gamesWonInt] forKey:[NSString stringWithFormat:@"gamesWon-%dcard",[self.flipCardsNumber intValue]]];
        }
    }
}
- (void)addMenuItemWithItemIcon:(id)itemIcon title:(NSString *)title action:(SEL)action
{
    // This means we want to change the label and trigger it properly.
    if ([title isEqualToString:@"1 Card Flip"])
    {
        [self.cardGameToggle setTitle:title forState:UIControlStateNormal];
    }
    if ([title isEqualToString:@"3 Card Flip"])
    {
        [self.cardGameToggle setTitle:title forState:UIControlStateNormal];
    }
}

// HELPER methods!
-(IBAction)toggleCardNumber:(id)sender
{
    [self select1card];
}

// context passed to child controller via initWithContext:
// END HELPER
- (void)viewDidLoad {
    [super viewDidLoad];
    // HELPER INIT
    self.contentFrame = [UIScreen mainScreen].bounds;//...nativeBounds;//CGRect
    
    // END HELPER
    
    // Do any additional setup after loading the view, typically from a nib.
    self.sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.solitaire"];
   // NSError* errortest;
    NSLog(@"shared defaults!!!-%@",[self.sharedDefaults objectForKey:@"savedata"]);//[NSJSONSerialization JSONObjectWithData:[self.sharedDefaults objectForKey:@"savedata"] options:nil error:&errortest]);
    
    self.wormhole = [[MMWormhole alloc] initWithApplicationGroupIdentifier:@"group.solitaire"
                                                         optionalDirectory:@"wormhole"];
    
    [self.wormhole listenForMessageWithIdentifier:@"loadSavedStateNative"
                                         listener:^(id messageObject) {
                                             
                                              //[NSString alloc] initmessageObject forKey:@"savedata"];
                                             // Do Something
                                             //UIAlertView* alertTest = [[UIAlertView alloc] initWithTitle:@"hello" message:@"hello" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
                                             //[alertTest show];
                                             [NSTimer scheduledTimerWithTimeInterval:.1f target:self selector:@selector(loadBoard) userInfo:nil repeats:NO];
                                             //[self loadBoard];
                                         }];
    [self awakeWithContext:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger) hiddenFlipWidth
{
    if (self.contentFrame.size.width > 200)
    {
        return 44;
    }
    else
    if([self is42])
    {
        return 14;
    }
    else
    {
        // need to support 42mm!
        return 14;
    }
}

-(NSInteger) cardWidth
{
    if (self.contentFrame.size.width > 200)
    {
        return 44;
    }
    else
    if([self is42])
    {
        return 22;
    }
    else
    {
        // Need to support 42mm!
        return 19;
    }
}

-(NSInteger) handDownFacing
{
    if (self.contentFrame.size.width > 200)
    {
        return 60;
    }
    else
    if([self is42])
    {
        return 6;
    }
    else
    {
        // Need to support 42mm!
        return 6;
    }
}
//44 x 60 on iphone
-(NSInteger) handUpBehind
{
    if (self.contentFrame.size.width > 200)
    {
        return 60;
    }
    else
    if([self is42])
    {
        return 8;
    }
    else
    {
        // Need to support 42mm!
        return 8;
    }
}

-(NSInteger) handUpFront
{
    // iPhone!
    if (self.contentFrame.size.width > 200)
    {
        return 60;
    }
    else
    if([self is42])
    {
        return 30;
    }
    else
    {
        // Need to support 42mm!
        return 25;
    }
}

-(void) setupFlippedFrame
{
    // Give it an origin.
    if ([self.deckFlip count]==0)
    {
        self.movedFromFrame = self.deckFlip1Image.frame;
    }
    
    if ([self.deckFlip count]==1)
    {
        self.movedFromFrame = self.deckFlip2Image.frame;
    }
    
    if ([self.deckFlip count]==2
        || [self.deckFlip count]==3)
    {
        self.movedFromFrame = self.deckFlip3Image.frame;
    }
}

-(void) processOrderedGraphics
{
    for(int i = 1; i < [self.handCardImages count]-1;i++)
    {
        UIImageView* view = [self.handCardImages objectAtIndex:i];
        UIImageView* underview = [self.handCardImages objectAtIndex:i-1];
        [view.superview insertSubview:view aboveSubview:underview];
    }
    
    [self.deckFlip1Image.superview insertSubview:self.deckFlip2Image aboveSubview:self.deckFlip1Image];
    [self.deckFlip1Image.superview insertSubview:self.deckFlip3Image aboveSubview:self.deckFlip2Image];
    //[self.deckFlip1Image setAlpha:1];
    //[self.deckFlip2Image setAlpha:1];
    //[self.deckFlip3Image setAlpha:1];
}


-(void) animateCardWithName:(NSString*) cardImageName fromPosition:(CGRect) originFrame toPosition:(CGRect) finalFrame thenRenderThing:(int) thingIndex
{
   // __block UIImageView* imageToMove = cardImage;//[self getImageViewOfCardWithFileName:cardName];
    if (self.imageForAnimation == nil)
    {
        self.imageForAnimation = [[UIImageView alloc] initWithImage:[UIImage imageNamed:cardImageName]];
        [self.view addSubview:self.imageForAnimation];
    }
    else
    {
        [self.imageForAnimation setImage:[UIImage imageNamed:cardImageName]];
    }
    __weak typeof(self) weakself = self;
    self.imageForAnimation.frame = originFrame;
    [UIView animateWithDuration:.4 animations:^{
        //code
        weakself.imageForAnimation.frame = finalFrame;
    } completion:^(BOOL finished) {
        //code
        weakself.imageForAnimation.frame = finalFrame;
        [NSTimer scheduledTimerWithTimeInterval:.1f target:weakself selector:@selector(processOrderedGraphics) userInfo:nil repeats:NO];
        if (thingIndex >= SELECTED_DISCARD_1 && thingIndex <= SELECTED_DISCARD_4)
        {
            [weakself renderDiscard];
        }
        
        if (thingIndex >= SELECTED_STACK_0
            && thingIndex <= SELECTED_STACK_6)
        {
            [weakself renderHand:thingIndex];
        }
        weakself.imageForAnimation.frame = CGRectZero;
        //[weakself processOrderedGraphics];
    }];
}

-(void) animateCardImage:(UIImageView*) cardImage fromPosition:(CGRect) originFrame
{
    __block UIImageView* imageToMove = cardImage;//[self getImageViewOfCardWithFileName:cardName];
    __weak typeof(self) weakself = self;
    [[imageToMove superview] bringSubviewToFront:imageToMove];
    const CGRect finalFrame = imageToMove.frame;
    NSLog(@"moving: %@ from %f,%f to %f,%f",imageToMove,originFrame.origin.x,originFrame.origin.y,finalFrame.origin.x,finalFrame.origin.y);
    imageToMove.frame = originFrame;
    [UIView animateWithDuration:.4 animations:^{
        //code
        imageToMove.frame = finalFrame;
    } completion:^(BOOL finished) {
        //code
        imageToMove.frame = finalFrame;
        [NSTimer scheduledTimerWithTimeInterval:.1f target:weakself selector:@selector(processOrderedGraphics) userInfo:nil repeats:NO];
        //[weakself processOrderedGraphics];
    }];
}


-(void) animateCardNamed:(NSString*) cardName fromPosition:(CGRect) originFrame
{
    __block UIImageView* imageToMove = [self getImageViewOfCardWithFileName:cardName];
    __weak typeof(self) weakself=self;
    [[imageToMove superview] bringSubviewToFront:imageToMove];
    const CGRect finalFrame = imageToMove.frame;
    NSLog(@"moving: %@ found as: %@ from %f,%f to %f,%f",cardName,imageToMove,originFrame.origin.x,originFrame.origin.y,finalFrame.origin.x,finalFrame.origin.y);
    if (imageToMove == nil)
    {
        NSLog(@"nil");
    }
    else
    {
        imageToMove.frame = originFrame;
        [UIView animateWithDuration:.4 animations:^{
            //code
            imageToMove.frame = finalFrame;
        } completion:^(BOOL finished) {
            //code
            imageToMove.frame = finalFrame;
            [NSTimer scheduledTimerWithTimeInterval:.1f target:weakself selector:@selector(processOrderedGraphics) userInfo:nil repeats:NO];
            //[weakself processOrderedGraphics];
        }];
    }
}

-(IBAction)deckStackAction:(id)sender
{
    if (self.hasSelected)
    {
        [self.selectedImage setInverseAlpha:1.0f];
        self.hasSelected = false;
    }
    
    [self flipFromDeck];
    [self renderStack];
    [self renderFlip];
    //[self animateCardNamed:self.cardToMoveName fromPosition:self.movedFromFrame];
    [self renderFlipAnims];
    [self saveBoard];
    [self.deckFlip1Image setAlpha:1];
    [self.deckFlip2Image setAlpha:1];
    [self.deckFlip3Image setAlpha:1];
    [self.deckFlipButton setAlpha:0.015f];
    
    //[self animateFromFlip:((Card*)[self.deckFlip lastObject]).filename];
}

-(void) clearSelection
{
    NSLog(@"clear selection");
    [self.selectedImage setInverseAlpha:1];
    self.hasSelected = false;
    [self.deckFlip1Image setAlpha:1];
    [self.deckFlip2Image setAlpha:1];
    [self.deckFlip3Image setAlpha:1];
    [self.deckFlipButton setAlpha:0.015f];
}


-(void) processOneTouch:(int)touchIndex
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
        
        // Now we need to handle animation?
    }
    
}


-(NSArray*) determinePossibleMovesOnBoard
{
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
    
    
    
    /*Card* fromCard = [[self.handArray objectAtIndex:j] lastObject];
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
     [possibleMoves addObject:move];
     }
     }*/
    
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


-(IBAction)deckFlipAction:(id)sender
{
    if (isOneTouchiPhone)
    {
        [self processOneTouch:SELECTED_FLIP];
        return;
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
                [self.deckFlip3Image setInverseAlpha:.5f];
                self.selectedImage = self.deckFlip3Image;
            }
            
            if ([self.deckFlip count] == 2)
            {
                [self.deckFlip3Image setInverseAlpha:.5f];
                self.selectedImage = self.deckFlip3Image;
            }
            
            if ([self.deckFlip count] == 3)
            {
                [self.deckFlip3Image setInverseAlpha:.5f];
                self.selectedImage = self.deckFlip3Image;
            }
            
            // Keep a reference to the selected image.
        }
        [self.deckFlipButton setAlpha:.7f];
    }
    [self.deckFlip1Image setAlpha:1];
    [self.deckFlip2Image setAlpha:1];
    [self.deckFlip3Image setAlpha:1];
}

-(IBAction)discard1Action:(id)sender
{
    if (isOneTouchiPhone)
    {
        [self processOneTouch:SELECTED_DISCARD_1];
        return;
    }
    
    if (self.hasSelected)
    {
        [self handleMoveFrom:self.selectedAction to:SELECTED_DISCARD_1];
    }
    else
    {
        self.selectedImage = self.discard1Image;
        [self.discard1Image setAlpha:.5f];
        self.hasSelected = true;
        self.selectedAction = SELECTED_DISCARD_1;
    }
    [self.deckFlip1Image setAlpha:1];
    [self.deckFlip2Image setAlpha:1];
    [self.deckFlip3Image setAlpha:1];
    [self.deckFlipButton setAlpha:0.015f];
}
-(IBAction)discard2Action:(id)sender
{
    if (isOneTouchiPhone)
    {
        [self processOneTouch:SELECTED_DISCARD_2];
        return;
    }
    
    if (self.hasSelected)
    {
        [self handleMoveFrom:self.selectedAction to:SELECTED_DISCARD_2];
    }
    else
    {
        self.selectedImage = self.discard2Image;
        [self.discard2Image setAlpha:.5f];
        self.hasSelected = true;
        self.selectedAction = SELECTED_DISCARD_2;
    }
    [self.deckFlip1Image setAlpha:1];
    [self.deckFlip2Image setAlpha:1];
    [self.deckFlip3Image setAlpha:1];
    [self.deckFlipButton setAlpha:0.015f];
}
-(IBAction)discard3Action:(id)sender
{
    if (isOneTouchiPhone)
    {
        [self processOneTouch:SELECTED_DISCARD_3];
        return;
    }
    
    if (self.hasSelected)
    {
        [self handleMoveFrom:self.selectedAction to:SELECTED_DISCARD_3];
    }
    else
    {
        self.selectedImage = self.discard3Image;
        [self.discard3Image setAlpha:.5f];
        self.hasSelected = true;
        self.selectedAction = SELECTED_DISCARD_3;
    }
    [self.deckFlip1Image setAlpha:1];
    [self.deckFlip2Image setAlpha:1];
    [self.deckFlip3Image setAlpha:1];
    [self.deckFlipButton setAlpha:0.015f];
}
-(IBAction)discard4Action:(id)sender
{
    if (isOneTouchiPhone)
    {
        [self processOneTouch:SELECTED_DISCARD_4];
        return;
    }
    
    if (self.hasSelected)
    {
        [self handleMoveFrom:self.selectedAction to:SELECTED_DISCARD_4];
    }
    else
    {
        self.selectedImage = self.discard4Image;
        [self.discard4Image setAlpha:.5f];
        self.hasSelected = true;
        self.selectedAction = SELECTED_DISCARD_4;
    }
    [self.deckFlip1Image setAlpha:1];
    [self.deckFlip2Image setAlpha:1];
    [self.deckFlip3Image setAlpha:1];
    [self.deckFlipButton setAlpha:0.015f];
}

-(void) makeLastCardVisibleInHand:(int) hand
{
    NSArray* handAffected = [self.handArray objectAtIndex:hand];
    Card* lastCard = [handAffected lastObject];
    [lastCard setIsFacingUp:YES];
}

-(void) handleMoveFrom:(int) from to:(int) to
{
    CGRect moveFromRect;
    CGRect moveToRect;
    [self.selectedImage setInverseAlpha:1];
    self.hasSelected = false;
    [self.discard1Image setAlpha:1];
    [self.discard2Image setAlpha:1];
    [self.discard3Image setAlpha:1];
    [self.discard4Image setAlpha:1];
    NSLog(@"Move from %d to %d",from,to);
    if (from >= SELECTED_DISCARD_1 && from <= SELECTED_DISCARD_4)
    {
        if (to >= SELECTED_STACK_0 && to <= SELECTED_STACK_6)
        {
            NSMutableArray* discardStack = nil;
            if (from == SELECTED_DISCARD_1){
                discardStack = self.discard1;
                moveFromRect = self.discard1Image.frame;
            }
            if (from == SELECTED_DISCARD_2){
                discardStack = self.discard2;
                moveFromRect = self.discard2Image.frame;
            }
            if (from == SELECTED_DISCARD_3){
                discardStack = self.discard3;
                moveFromRect = self.discard3Image.frame;
            }
            if (from == SELECTED_DISCARD_4){
                discardStack = self.discard4;
                moveFromRect = self.discard4Image.frame;
            }
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
                    
                    int indexOfCard = to*20+(int)[hand_stack count]-1;
                    UIImageView* imageTo = [self.handCardImages objectAtIndex:indexOfCard];
                    moveToRect = imageTo.frame;
                    //[self renderHand:to];
                    [self renderDiscard];
                    Card* topCard = [hand_stack lastObject];
                    //[self animateCardNamed:self.cardToMoveName fromPosition:self.movedFromFrame];
                    [self animateCardWithName:topCard.filename fromPosition:moveFromRect toPosition:moveToRect thenRenderThing:to];
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
        [self.deckFlipButton setAlpha:0.015f];
        if (to >= SELECTED_DISCARD_1 && to <= SELECTED_DISCARD_4)
        {
            // Discard
            NSMutableArray* discard_stack = nil;
            if (to == SELECTED_DISCARD_1){
                discard_stack = self.discard1;
                moveToRect = self.discard1Image.frame;
            }
            if (to == SELECTED_DISCARD_2){
                discard_stack = self.discard2;
                moveToRect = self.discard2Image.frame;
            }
            if (to == SELECTED_DISCARD_3){
                discard_stack = self.discard3;
                moveToRect = self.discard3Image.frame;
            }
            if (to == SELECTED_DISCARD_4){
                discard_stack = self.discard4;
                moveToRect = self.discard4Image.frame;
            }
            
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
                        //[self renderDiscard];
                        [self setupFlippedFrame];
                        //[self animateCardNamed:self.cardToMoveName fromPosition:self.movedFromFrame];
                         [self animateCardWithName:topFlick.filename fromPosition:self.deckFlip3Image.frame toPosition:moveToRect thenRenderThing:SELECTED_DISCARD_1];
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
                        //[self renderDiscard];
                        [self renderFlip];
                        [self setupFlippedFrame];
                        //[self animateCardNamed:self.cardToMoveName fromPosition:self.movedFromFrame];
                        [self animateCardWithName:topFlick.filename fromPosition:self.deckFlip3Image.frame toPosition:moveToRect thenRenderThing:SELECTED_DISCARD_1];
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
                            
                            int indexOfCard = to*20;
                            UIImageView* imageTo = [self.handCardImages objectAtIndex:indexOfCard];
                            moveToRect = imageTo.frame;
                            
                            [self animateCardWithName:topFlick.filename fromPosition:self.deckFlip3Image.frame toPosition:moveToRect thenRenderThing:to];
                            //[self renderHand:to];
                            //[self setupFlippedFrame];
                            //[self animateCardNamed:self.cardToMoveName fromPosition:self.movedFromFrame];
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
                                self.cardToMoveName = topFlick.filename;
                                [topFlick setIsFacingUp:YES];
                                [self move:1 CardsFromStack:self.deckFlip toStack:hand_stack dealStacked:NO];
                                [self renderHand:to];
                                [self renderFlip];
                                [self setupFlippedFrame];
                                [self animateCardNamed:self.cardToMoveName fromPosition:self.movedFromFrame];
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
                NSMutableArray* toArray = [self.handArray objectAtIndex:to];
                NSMutableArray* fromArray = [self.handArray objectAtIndex:from];
                int indexOfCard = from*20+(int)[fromArray count]-1;
                UIImageView* imageFrom = [self.handCardImages objectAtIndex:indexOfCard];
                moveFromRect = imageFrom.frame;
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
                    
                    int indexOfCardTo = to*20+(int)[toArray count]-1;
                    UIImageView* imageTo = [self.handCardImages objectAtIndex:indexOfCardTo];
                    moveToRect = imageTo.frame;
                    
                    [self makeLastCardVisibleInHand:from];
                    Card* topOfStackToAfterMove = [toArray lastObject];
                    [self renderHand:from];
                    //[self renderHand:to];
                    //[self animateCardNamed:self.cardToMoveName fromPosition:self.movedFromFrame];
                    [self animateCardWithName:topOfStackToAfterMove.filename fromPosition:moveFromRect toPosition:moveToRect thenRenderThing:to];
                    [self saveBoard];
                }
            }
            else
            {
                // Else, does it fit?
                NSMutableArray* toArray = [self.handArray objectAtIndex:to];
                NSMutableArray* fromArray = [self.handArray objectAtIndex:from];
                Card* topOfStackTo = [toArray lastObject];
               // Card* topOfStackFrom = [fromArray lastObject];
                
                int indexOfCard = from*20+(int)[fromArray count]-1;
                UIImageView* imageFrom = [self.handCardImages objectAtIndex:indexOfCard];
                moveFromRect = imageFrom.frame;
                
               
                
                
                
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
                    
                    int indexOfCardTo = to*20+(int)[toArray count]-1;
                    UIImageView* imageTo = [self.handCardImages objectAtIndex:indexOfCardTo];
                    moveToRect = imageTo.frame;
                    
                    [self makeLastCardVisibleInHand:from];
                    Card* topOfStackToAfterMove = [toArray lastObject];
                    
                    [self renderHand:from];
                    //[self renderHand:to];
                    //[self animateCardNamed:self.cardToMoveName fromPosition:self.movedFromFrame];
                    [self animateCardWithName:topOfStackToAfterMove.filename fromPosition:moveFromRect toPosition:moveToRect thenRenderThing:to];
                    [self saveBoard];
                }
                
            }
        }
        else
            if (to >= SELECTED_DISCARD_1 && to <= SELECTED_DISCARD_4)
            {
                // Discard
                NSMutableArray* discard_stack = nil;
                if (to == SELECTED_DISCARD_1){
                    discard_stack = self.discard1;
                    moveToRect = self.discard1Image.frame;
                }
                if (to == SELECTED_DISCARD_2){
                    discard_stack = self.discard2;
                    moveToRect = self.discard2Image.frame;
                }
                if (to == SELECTED_DISCARD_3){
                    discard_stack = self.discard3;
                    moveToRect = self.discard3Image.frame;
                }
                if (to == SELECTED_DISCARD_4){
                    discard_stack = self.discard4;
                    moveToRect = self.discard4Image.frame;
                }
                
                
                
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
                            int indexOfCard = from*20+(int)[handFrom count]-1;
                            UIImageView* imageFrom = [self.handCardImages objectAtIndex:indexOfCard];
                            moveFromRect = imageFrom.frame;
                            [self move:1 CardsFromStack:handFrom toStack:discard_stack dealStacked:NO];
                            
                            if ([handFrom count] > 0)
                            {// NTDSGG
                                // Make sure the topHandfrom is flipped now!
                                Card* newTop = [handFrom lastObject];
                                [newTop setIsFacingUp:YES];
                                // Can we set the height of the image?
                                UIImageView* card = [self.handCardImages objectAtIndex:from*20 + ([handFrom count]-1)];
                                [card setHeight:[self handUpFront]];
                            }
                            [self renderHand:from];
                            [self animateCardWithName:topHandCard.filename fromPosition:moveFromRect toPosition:moveToRect thenRenderThing:SELECTED_DISCARD_1];
                            //[self renderDiscard];
                            //[self animateCardNamed:self.cardToMoveName fromPosition:moveFromRect];
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
                            int indexOfCard = from*20+(int)[handFrom count]-1;
                            UIImageView* imageFrom = [self.handCardImages objectAtIndex:indexOfCard];
                            moveFromRect = imageFrom.frame;
                            [self move:1 CardsFromStack:handFrom toStack:discard_stack dealStacked:NO];
                            if ([handFrom count] > 0)
                            {
                                // Make sure the topHandfrom is flipped now!
                                Card* newTop = [handFrom lastObject];
                                [newTop setIsFacingUp:YES];
                                // Can we set the height of the image?
                                UIImageView* card = [self.handCardImages objectAtIndex:from*20 + ([handFrom count]-1)];
                                [card setHeight:[self handUpFront]];
                            }
                            //[self renderDiscard];
                            [self renderFlip];
                            
                            [self checkWinner];
                            [self renderHand:from];
                            [self animateCardWithName:topHandCard.filename fromPosition:moveFromRect toPosition:moveToRect thenRenderThing:SELECTED_DISCARD_1];
                            //[self animateCardNamed:self.cardToMoveName fromPosition:self.movedFromFrame];
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
    [self.deckFlip1Image setAlpha:1];
    [self.deckFlip2Image setAlpha:1];
    [self.deckFlip3Image setAlpha:1];
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
    if (isOneTouchiPhone)
    {
        [self processOneTouch:SELECTED_STACK_0];
        return;
    }
    if (self.hasSelected)
    {
        // Handle a move!
        if (self.selectedAction == SELECTED_STACK_0)
        {
            // undo selection
            [self.hand0Button setInverseAlpha:1];
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
        [self.hand0Button setInverseAlpha:.5f];
        self.hasSelected = true;
        self.selectedAction = SELECTED_STACK_0;
    }
}
-(IBAction)handStack2Action:(id)sender
{
    if (isOneTouchiPhone)
    {
        [self processOneTouch:SELECTED_STACK_1];
        return;
    }
    if (self.hasSelected)
    {
        // Handle a move!
        if (self.selectedAction == SELECTED_STACK_1)
        {
            // undo selection
            [self.hand1Button setInverseAlpha:1];
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
        [self.hand1Button setInverseAlpha:.5f];
        self.hasSelected = true;
        self.selectedAction = SELECTED_STACK_1;
    }
}
-(IBAction)handStack3Action:(id)sender
{
    if (isOneTouchiPhone)
    {
        [self processOneTouch:SELECTED_STACK_2];
        return;
    }
    if (self.hasSelected)
    {
        // Handle a move!
        if (self.selectedAction == SELECTED_STACK_2)
        {
            // undo selection
            [self.hand2Button setInverseAlpha:1];
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
        [self.hand2Button setInverseAlpha:.5f];
        self.hasSelected = true;
        self.selectedAction = SELECTED_STACK_2;
    }
}
-(IBAction)handStack4Action:(id)sender
{
    if (isOneTouchiPhone)
    {
        [self processOneTouch:SELECTED_STACK_3];
        return;
    }
    if (self.hasSelected)
    {
        // Handle a move!
        if (self.selectedAction == SELECTED_STACK_3)
        {
            // undo selection
            [self.hand3Button setInverseAlpha:1];
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
        [self.hand3Button setInverseAlpha:.5f];
        self.hasSelected = true;
        self.selectedAction = SELECTED_STACK_3;
    }
}
-(IBAction)handStack5Action:(id)sender
{
    if (isOneTouchiPhone)
    {
        [self processOneTouch:SELECTED_STACK_4];
        return;
    }
    if (self.hasSelected)
    {
        // Handle a move!
        if (self.selectedAction == SELECTED_STACK_4)
        {
            // undo selection
            [self.hand4Button setInverseAlpha:1];
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
        [self.hand4Button setInverseAlpha:.5f];
        self.hasSelected = true;
        self.selectedAction = SELECTED_STACK_4;
    }
}
-(IBAction)handStack6Action:(id)sender
{
    if (isOneTouchiPhone)
    {
        [self processOneTouch:SELECTED_STACK_5];
        return;
    }
    if (self.hasSelected)
    {
        // Handle a move!
        if (self.selectedAction == SELECTED_STACK_5)
        {
            // undo selection
            [self.hand5Button setInverseAlpha:1];
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
        [self.hand5Button setInverseAlpha:.5f];
        self.hasSelected = true;
        self.selectedAction = SELECTED_STACK_5;
    }
}
-(IBAction)handStack7Action:(id)sender
{
    if (isOneTouchiPhone)
    {
        [self processOneTouch:SELECTED_STACK_6];
        return;
    }
    if (self.hasSelected)
    {
        // Handle a move!
        if (self.selectedAction == SELECTED_STACK_6)
        {
            // undo selection
            [self.hand6Button setInverseAlpha:1];
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
        [self.hand6Button setInverseAlpha:.5f];
        self.hasSelected = true;
        self.selectedAction = SELECTED_STACK_6;
    }
}


- (void)awakeWithContext:(id)context {
  //  [super awakeWithContext:context];
    @try {
        
    
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
    if (self.deckStack == nil)
    {
        self.deckStack = [[NSMutableArray alloc] init];
    }
    if (self.deckFlip == nil)
    {
        self.deckFlip = [[NSMutableArray alloc] init];
    }
         self.discardArray = @[self.discard1, self.discard2, self.discard3, self.discard4];
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
    
    if (self.flipCardsNumber==nil)
    {
        self.flipCardsNumber = [NSNumber numberWithInt:3];
        [self addMenuItemWithItemIcon:WKMenuItemIconShuffle title:@"1 Card Flip" action:@selector(select1card)];
    }
    else
        if ([self.flipCardsNumber intValue] == 1)
        {
            [self addMenuItemWithItemIcon:WKMenuItemIconShuffle title:@"3 Card Flip" action:@selector(select1card)];
        }
        else
            if ([self.flipCardsNumber intValue] == 3)
            {
                [self addMenuItemWithItemIcon:WKMenuItemIconShuffle title:@"1 Card Flip" action:@selector(select1card)];
            }
    
    if ([self.sharedDefaults objectForKey:@"savedata"]==nil)
    {
        // Setup all 52 cards test for now.
        [self setupNewBoard];
    }
    else
    {
        [self loadBoard];
    }
    
    [self addMenuItemWithItemIcon:WKMenuItemIconDecline title:@"" action:@selector(back)];
    
    [self addMenuItemWithItemIcon:WKMenuItemIconTrash title:@"Restart" action:@selector(resetBoard)];
    
    self.flipCardsNumber = [self.sharedDefaults objectForKey:@"flipcardnumber"];
        
        isOneTouchiPhone = [self.sharedDefaults boolForKey:@"iphonetouchcount"];
        
        if (isOneTouchiPhone)
        {
            [self.touchToggle setTitle:@"2-Touch" forState:UIControlStateNormal];
        }
        else
        {
            [self.touchToggle setTitle:@"1-Touch" forState:UIControlStateNormal];
        }
    
    if (self.flipCardsNumber == nil)
    {
        self.flipCardsNumber = [NSNumber numberWithInt:3];
        [self.sharedDefaults setObject:self.flipCardsNumber forKey:@"flipcardnumber"];
        [self.sharedDefaults synchronize];
    }
    
    if ([self.flipCardsNumber intValue] == 0)
    {
        self.flipCardsNumber = [NSNumber numberWithInt:3];
        [self.sharedDefaults setObject:self.flipCardsNumber forKey:@"flipcardnumber"];
        [self.sharedDefaults synchronize];
    }
    
    if ([self.flipCardsNumber intValue] == 1)
    {
        //if ([title isEqualToString:])
        //{
            [self.cardGameToggle setTitle:@"3 Card Flip" forState:UIControlStateNormal];
        //}
    }
        
        if ([self.flipCardsNumber intValue] == 3)
        {
            //if ([title isEqualToString:])
            //{
            [self.cardGameToggle setTitle:@"1 Card Flip" forState:UIControlStateNormal];
            //}
        }
    //[self addMenuItemWithItemIcon:WKMenuItemIconInfo title:@"Bests" action:@selector(rankings)];
        
    }
    @catch (NSException *exception) {
        NSLog(@"Exception %@",exception);
    }
    @finally {
        NSLog(@"code thrown!");
    }
}

// A helper button in the context menu.
-(void) back
{
    
}

-(void) rankings
{
    
}


-(void) toggleTouchCount:(id)sender
{
    
    //[self clearAllMenuItems];
    //[self addMenuItemWithItemIcon:WKMenuItemIconDecline title:@"" action:@selector(back)];
    
    //[self addMenuItemWithItemIcon:WKMenuItemIconTrash title:@"Restart" action:@selector(resetBoard)];
    isOneTouchiPhone = !isOneTouchiPhone;
    [self.sharedDefaults setBool:isOneTouchiPhone forKey:@"iphonetouchcount"];
    
    if (isOneTouchiPhone)
    {
        [self.touchToggle setTitle:@"2-Touch" forState:UIControlStateNormal];
    }
    else
    {
        [self.touchToggle setTitle:@"1-Touch" forState:UIControlStateNormal];
    }
}


-(void) select1card
{
    
    [self clearAllMenuItems];
    //[self addMenuItemWithItemIcon:WKMenuItemIconDecline title:@"" action:@selector(back)];
    
    //[self addMenuItemWithItemIcon:WKMenuItemIconTrash title:@"Restart" action:@selector(resetBoard)];
    
    if ([self.flipCardsNumber intValue] == 1)
    {
        self.flipCardsNumber = [NSNumber numberWithInt:3];
        
        [self.sharedDefaults setObject:self.flipCardsNumber forKey:@"flipcardnumber"];
        
        [self addMenuItemWithItemIcon:WKMenuItemIconShuffle title:@"1 Card Flip" action:@selector(select1card)];
    }
    else
        if ([self.flipCardsNumber intValue] == 3)
        {
            self.flipCardsNumber = [NSNumber numberWithInt:1];
            
            [self.sharedDefaults setObject:self.flipCardsNumber forKey:@"flipcardnumber"];
            [self addMenuItemWithItemIcon:WKMenuItemIconShuffle title:@"3 Card Flip" action:@selector(select1card)];
        }
    
    [self addMenuItemWithItemIcon:WKMenuItemIconTrash title:@"Bests" action:@selector(rankings)];
    
    [self resetBoard];
}

-(void) resetBoard
{
    [self setupNewBoard];
}

-(BOOL) is42
{
    if (self.contentFrame.size.width > 136)
    {
        //NSLog(@"is 42!");
        return true;
    }
    else
    {
        // NSLog(@"is 38!");
        return false;
    }
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
}

-(void) shuffleMasterDeck
{
    
    [self.shuffleDeck removeAllObjects];
    
    while([self.masterDeck count] > 0)
    {
        int randomIndex = arc4random_uniform((u_int32_t )[self.masterDeck count]);
        NSLog(@"randomIndex %d count:%lu",randomIndex,(unsigned long)[self.masterDeck count]);
        Card* card = [self.masterDeck objectAtIndex:randomIndex];
        [self.masterDeck removeObject:card];
        [self.shuffleDeck addObject:card];
        
    }
    NSLog(@"done!");
    while([self.shuffleDeck count] > 0)
    {
        int randomIndex = arc4random_uniform((u_int32_t )[self.shuffleDeck count]);
        NSLog(@"randomIndex suffle %d %lu",randomIndex,(unsigned long)[self.shuffleDeck count]);
        Card* card = [self.shuffleDeck objectAtIndex:randomIndex];
        [self.shuffleDeck removeObject:card];
        [self.masterDeck addObject:card];
        
    }
    
    for(int i =0; i < [self.masterDeck count]; i++)
    {
        Card* card = [self.masterDeck objectAtIndex:i];
        NSLog(@"Shuffled deck card: %d %@ %ld",i,[card suite],(long)[card value]);
    }
}

- (void) setupNewBoard
{
    [self cleanBoardData];
    if (self.hasSelected)
    {
        [self.selectedImage setInverseAlpha:1];
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
    
    [self shuffleMasterDeck];
    
    // Deal to all hands.
    [self dealToStacks];
    
    [self flipFromDeck];
    
    [self renderFullBoard];
    
    [self saveBoard];
    
    // Fixes bug.
    [self.deckStack1Image setImageNamed:[self platform:@"facedown.png"]];
    [self.deckStack1Image setRestorationIdentifier:[self platform:@"facedown.png"]];
}

-(NSString*) platform:(NSString*) filename
{
    if ([self is42])
    {
        return [filename stringByReplacingOccurrencesOfString:@".png" withString:@"_44mm1.png"];
    }
    else
    {
        return [filename stringByReplacingOccurrencesOfString:@".png" withString:@"_44mm1.png"];//@"_38mm.png"];
    }
}

-(void) renderStack
{
    if ([self.deckStack count] == 0)
    {
        [self.deckStack1Image setImageNamed:[self platform:@"cardback.png"]];
        [self.deckStack1Image setRestorationIdentifier:@"cardback.png"];
        self.isStackEmpty = YES;
        
        [self.deckStack2Image setHidden:YES];
        [self.deckStack3Image setHidden:YES];
    }
    else
    {
        if (self.isStackEmpty)
        {
            [self.deckStack1Image setImageNamed:[self platform:@"facedown.png"]];
            [self.deckStack1Image setRestorationIdentifier:@"facedown.png"];
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
        [self.discard1Image setRestorationIdentifier:card.filename];
    }
    else
    {
        [self.discard1Image setImageNamed:[self platform:@"cardback.png"]];
        [self.discard1Image setRestorationIdentifier:@"cardback.png"];
    }
    
    if ([self.discard2 count] > 0)
    {
        Card* card = [self.discard2 lastObject];
        [self.discard2Image setImageNamed:card.filename];
        [self.discard2Image setRestorationIdentifier:card.filename];
    }
    else
    {
        [self.discard2Image setImageNamed:[self platform:@"cardback.png"]];
        [self.discard2Image setRestorationIdentifier:@"cardback.png"];
    }
    
    if ([self.discard3 count] > 0)
    {
        Card* card = [self.discard3 lastObject];
        [self.discard3Image setImageNamed:card.filename];
        [self.discard3Image setRestorationIdentifier:card.filename];
    }
    else
    {
        [self.discard3Image setImageNamed:[self platform:@"cardback.png"]];
        [self.discard3Image setRestorationIdentifier:@"cardback.png"];
    }
    
    if ([self.discard4 count] > 0)
    {
        Card* card = [self.discard4 lastObject];
        [self.discard4Image setImageNamed:card.filename];
        [self.discard4Image setRestorationIdentifier:card.filename];
    }
    else
    {
        [self.discard4Image setImageNamed:[self platform:@"cardback.png"]];
        [self.discard4Image setRestorationIdentifier:@"cardback.png"];
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
                [self renderFlipAnims];
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
                [self.deckFlip3Image setRestorationIdentifier:card3.filename];
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
                    [self.deckFlip2Image setRestorationIdentifier:card1.filename];
                    Card* card2 = [self.deckFlip objectAtIndex:1];
                    [self.deckFlip3Image setImageNamed:card2.filename];
                    [self.deckFlip3Image setRestorationIdentifier:card2.filename];
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
                        // [self.deckFlip1Image setInverseAlpha:.5f];
                        Card* card1 = [self.deckFlip objectAtIndex:0];
                        [self.deckFlip1Image setImageNamed:card1.filename];
                        [self.deckFlip1Image setRestorationIdentifier:card1.filename];
                        Card* card2 = [self.deckFlip objectAtIndex:1];
                        [self.deckFlip2Image setImageNamed:card2.filename];
                        [self.deckFlip2Image setRestorationIdentifier:card2.filename];
                        Card* card3 = [self.deckFlip objectAtIndex:2];
                        [self.deckFlip3Image setImageNamed:card3.filename];
                        [self.deckFlip3Image setRestorationIdentifier:card3.filename];
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
        UIImageView* handImage = [self.handCardImages objectAtIndex:startIndex + i];
        // Now, let's set the values
        if (i < [handFromArray count])
        {
            Card* cardFromHand = [handFromArray objectAtIndex:i];
            [handImage setHidden:NO];
            
            if (cardFromHand.isFacingUp)
            {
                // Set image.
                [handImage setImageNamed:cardFromHand.filename];
                [handImage setRestorationIdentifier:cardFromHand.filename];
                
                // If last card, make full height.
                if (i == [handFromArray count]-1)
                {
                    [handImage setHeight:[self handUpFront]];
                    [handImage setWidth:[self handUpFront]];
                }
                else
                {
                    [handImage setHeight:[self handUpBehind]];
                }
            }
            else
            {
                // Set image.
                [handImage setImageNamed:[self platform:@"facedown.png"]];
                [handImage setRestorationIdentifier:[self platform:@"facedown.png"]];
                [handImage setHeight:[self handDownFacing]];
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

-(UIImageView*) getImageViewOfCardWithFileName:(NSString*) nameOfCard
{
    for(int i = 0; i < [self.handCardImages count]; i++)
    {
        UIImageView* possibleCard = [self.handCardImages objectAtIndex:i];
        if ([nameOfCard isEqualToString:[possibleCard restorationIdentifier]])
        {
            return possibleCard;
        }
    }
    
    return nil;
}

-(CGRect) getImageFrameOfCardWithFileName:(NSString*) nameOfCard
{
    UIImageView* cardImageView = nil;
    for(int i = 0; i < [self.handCardImages count]; i++)
    {
        UIImageView* possibleCard = [self.handCardImages objectAtIndex:i];
        if ([nameOfCard isEqualToString:[possibleCard restorationIdentifier]]
            && ![possibleCard isHidden])
        {
            return possibleCard.frame;
        }
    }
    
    return cardImageView.frame;
}


-(void) move:(int) cards CardsFromStack:(NSMutableArray*) fromStack toStack:(NSMutableArray*) toStack orderPreserved:(BOOL) preserved
{
    // Let's try to figure out where the frames of the objects are!
    int frontIndex =(int)[fromStack count]-cards;
    for(int i = 0; i < cards; i++)
    {
        Card* card = [fromStack objectAtIndex:frontIndex];
        
        //self.movedFromFrame = [self getImageFrameOfCardWithFileName:card.filename];
        //self.cardToMoveName = card.filename;
        
        // Let's figure out the animation based off the card name?  Can we find the ImageView from the card image name?
        // Now what?
        if (card != nil)
        {
            [fromStack removeObjectAtIndex:frontIndex];
            [toStack addObject:card];
        }
        else
        {
            NSLog(@"shouldn't happen!");
        }
        
    }
}


-(void) move:(int) cards CardsFromStack:(NSMutableArray*) fromStack toStack:(NSMutableArray*) toStack dealStacked:(BOOL) dealStacked
{
    for(int i = 0; i < cards; i++)
    {
        Card* card = [fromStack lastObject];
        
        //self.movedFromFrame = [self getImageFrameOfCardWithFileName:card.filename];
        //self.cardToMoveName = card.filename;
        
        if (card != nil)
        {
            if (dealStacked && i == cards-1)
            {
                card.isFacingUp = YES;
            }
            
            [fromStack removeLastObject];
            [toStack addObject:card];
        }
        else
        {
            NSLog(@"shouldn't happen!");
        }
        
    }
}

-(void) flipFromDeck
{
    if ([self.flipCardsNumber intValue]== 3)
    {
        if ([self.deckStack count] == 0)
        {
            
            [self move:(int)[self.deckFlip count]  CardsFromStack:self.deckFlip toStack:self.deckFlipDiscard orderPreserved:YES];
            
            [self move:(int)[self.deckFlipDiscard count] CardsFromStack:self.deckFlipDiscard toStack:self.deckStack dealStacked:NO];
        }
        
        [self move:(int)[self.deckFlip count]  CardsFromStack:self.deckFlip toStack:self.deckFlipDiscard orderPreserved:YES];
        NSLog(@"flip cards number:%d",[self.flipCardsNumber intValue]);
        [self move:[self.flipCardsNumber intValue] CardsFromStack:self.deckStack toStack:self.deckFlip dealStacked:NO];
        
    }
    else
    {
        if ([self.deckStack count] == 0)
        {
            
            [self move:(int)[self.deckFlip count]  CardsFromStack:self.deckFlip toStack:self.deckFlipDiscard orderPreserved:YES];
            
            [self move:(int)[self.deckFlipDiscard count] CardsFromStack:self.deckFlipDiscard toStack:self.deckStack dealStacked:NO];
        }
        
        if ([self.deckFlip count] < 3)
        {
            [self move:1 CardsFromStack:self.deckStack toStack:self.deckFlip dealStacked:NO];
            
        }
        else
        {
            [self move:(int)[self.deckFlip count]  CardsFromStack:self.deckFlip toStack:self.deckFlipDiscard orderPreserved:YES];
            // So, first, let's move anything from the flip to the flip discard.
            //[self move:(int)[self.deckFlip count] CardsFromStack:self.deckFlip toStack:self.deckFlipDiscard dealStacked:NO];
            NSLog(@"flip cards number:%d",[self.flipCardsNumber intValue]);
            
        }
        //[self move:3 CardsFromStack:self.deckStack toStack:self.deckFlip orderPreserved:YES];
    }
}

-(void) renderFlipAnims
{
    if ([self.flipCardsNumber intValue]== 3)
    {
        
        
        if ([self.deckFlip count]>=1)
        {
            [self animateCardImage:self.deckFlip1Image fromPosition:self.deckStack1Image.frame];
        }
        
        if ([self.deckFlip count]>=2)
        {
            [self animateCardImage:self.deckFlip2Image fromPosition:self.deckStack2Image.frame];
        }
        if ([self.deckFlip count]>=3)
        {
            [self animateCardImage:self.deckFlip3Image fromPosition:self.deckStack3Image.frame];
        }
        // Now, let's animate the 3 cards in the self.deckFlipDiscard!
    }
    else
    {
        
        if ([self.deckFlip count] < 3)
        {
            if ([self.deckFlip count]==2)
            {
                //[self animateCardImage:self.deckFlip2Image fromPosition:self.deckStack3Image.frame];
                [self animateCardImage:self.deckFlip3Image fromPosition:self.deckStack3Image.frame];
            }
            if ([self.deckFlip count]==1)
            {
                [self animateCardImage:self.deckFlip3Image fromPosition:self.deckStack3Image.frame];
            }
        }
        else
        {
            if ([self.deckFlip count]>=3)
            {
                [self animateCardImage:self.deckFlip3Image fromPosition:self.deckStack3Image.frame];
            }
        }
        //[self move:3 CardsFromStack:self.deckStack toStack:self.deckFlip orderPreserved:YES];
    }
}

-(void) dealToStacks
{
    [self move:1 CardsFromStack:self.masterDeck toStack:self.hand0 dealStacked:YES];
    [self move:2 CardsFromStack:self.masterDeck toStack:self.hand1 dealStacked:YES];
    [self move:3 CardsFromStack:self.masterDeck toStack:self.hand2 dealStacked:YES];
    [self move:4 CardsFromStack:self.masterDeck toStack:self.hand3 dealStacked:YES];
    [self move:5 CardsFromStack:self.masterDeck toStack:self.hand4 dealStacked:YES];
    [self move:6 CardsFromStack:self.masterDeck toStack:self.hand5 dealStacked:YES];
    [self move:7 CardsFromStack:self.masterDeck toStack:self.hand6 dealStacked:YES];
    
    [self move:(int)[self.masterDeck count] CardsFromStack:self.masterDeck toStack:self.deckStack dealStacked:NO];
    
    for(int i = 0; i < [self.deckStack count]; i++)
    {
        Card* deckCard = [self.deckStack objectAtIndex:i];
        [deckCard setIsFacingUp:YES];
    }
    /*@property (strong, nonatomic) NSMutableArray* hand0;
     @property (strong, nonatomic) NSMutableArray* hand1;
     @property (strong, nonatomic) NSMutableArray* hand2;
     @property (strong, nonatomic) NSMutableArray* hand3;
     @property (strong, nonatomic) NSMutableArray* hand4;
     @property (strong, nonatomic) NSMutableArray* hand5;
     @property (strong, nonatomic) NSMutableArray* hand6;
     @property (strong, nonatomic) NSMutableArray* discard1;
     @property (strong, nonatomic) NSMutableArray* discard2;
     @property (strong, nonatomic) NSMutableArray* discard3;
     @property (strong, nonatomic) NSMutableArray* discard4;
     @property (strong, nonatomic) NSMutableArray* deckStack;
     @property (strong, nonatomic) NSMutableArray* deckFlip;*/
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

-(void) loadBoard
{
    NSLog(@"loading board!");
    [self loadMasterDeck];
    [self cleanBoardData];
    
    NSData* savedData = [self.sharedDefaults objectForKey:@"savedata"];
    NSError* error = nil;
    NSArray* saveArray = [NSJSONSerialization JSONObjectWithData:savedData options:NSJSONReadingAllowFragments error:&error];
    
    NSArray* deckStackSaved = [saveArray objectAtIndex:0];
    
    [self loadCardsIntoArray:self.deckStack fromIndexArray:deckStackSaved];
    NSArray* flipStackSaved = [saveArray objectAtIndex:1];
    [self loadCardsIntoArray:self.deckFlip fromIndexArray:flipStackSaved];
    NSArray* flipStackDiscardSaved = [saveArray objectAtIndex:2];
    [self loadCardsIntoArray:self.deckFlipDiscard fromIndexArray:flipStackDiscardSaved];
    NSArray* hand0Saved = [saveArray objectAtIndex:3];
    [self loadCardsIntoArray:self.hand0 fromIndexArray:hand0Saved];
    NSArray* hand1Saved = [saveArray objectAtIndex:4];
    [self loadCardsIntoArray:self.hand1 fromIndexArray:hand1Saved];
    NSArray* hand2Saved = [saveArray objectAtIndex:5];
    [self loadCardsIntoArray:self.hand2 fromIndexArray:hand2Saved];
    NSArray* hand3Saved = [saveArray objectAtIndex:6];
    [self loadCardsIntoArray:self.hand3 fromIndexArray:hand3Saved];
    NSArray* hand4Saved = [saveArray objectAtIndex:7];
    [self loadCardsIntoArray:self.hand4 fromIndexArray:hand4Saved];
    NSArray* hand5Saved = [saveArray objectAtIndex:8];
    [self loadCardsIntoArray:self.hand5 fromIndexArray:hand5Saved];
    NSArray* hand6Saved = [saveArray objectAtIndex:9];
    [self loadCardsIntoArray:self.hand6 fromIndexArray:hand6Saved];
    NSArray* discard1Saved = [saveArray objectAtIndex:10];
    [self loadCardsIntoArray:self.discard1 fromIndexArray:discard1Saved];
    NSArray* discard2Saved = [saveArray objectAtIndex:11];
    [self loadCardsIntoArray:self.discard2 fromIndexArray:discard2Saved];
    NSArray* discard3Saved = [saveArray objectAtIndex:12];
    [self loadCardsIntoArray:self.discard3 fromIndexArray:discard3Saved];
    NSArray* discard4Saved = [saveArray objectAtIndex:13];
    [self loadCardsIntoArray:self.discard4 fromIndexArray:discard4Saved];
    NSLog(@"about to savedata!");
    NSError* e = nil;
    NSData* saveData = [NSJSONSerialization dataWithJSONObject:saveArray options:NSJSONWritingPrettyPrinted error:&e];
    NSString* saveString = [[NSString alloc] initWithData:saveData encoding:NSUTF8StringEncoding];
    NSLog(@"loadedBoard!%@",saveString);
    NSLog(@"saved data!");
    [self renderFullBoard];
}

-(void) saveBoard
{
    // Should be able to create actual arrays?
    // then use json serializer?  For shortcut.
    // Steps -
    NSMutableArray* saveObject = [[NSMutableArray alloc] init];
    // Get Deck Array indexes
    NSMutableArray* deckSave = [[NSMutableArray alloc] init];
    for(int i = 0; i < [self.deckStack count]; i++)
    {
        //NSInteger value = (NSInteger)[((Card*)[self.deckStack objectAtIndex:i]) value]
        [deckSave addObject:[NSNumber numberWithInteger:(NSInteger)[((Card*)[self.deckStack objectAtIndex:i]) getSaveIndex]*(((Card*)[self.deckStack objectAtIndex:i]).isFacingUp?1:-1)]];
    }
    [saveObject addObject:deckSave];
    // Get Flip Array indexes
    NSMutableArray* flipSave = [[NSMutableArray alloc] init];
    for(int i = 0; i < [self.deckFlip count]; i++)
    {
        [flipSave addObject:[NSNumber numberWithInteger:(NSInteger)[((Card*)[self.deckFlip objectAtIndex:i]) getSaveIndex]*(((Card*)[self.deckFlip objectAtIndex:i]).isFacingUp?1:-1)]];
        //[flipSave addObject:[self.deckFlip objectAtIndex:i]];
    }
    [saveObject addObject:flipSave];
    // Get Flip Discard Array indexes
    NSMutableArray* flipDiscardSave = [[NSMutableArray alloc] init];
    for(int i = 0; i < [self.deckFlipDiscard count]; i++)
    {
        [flipDiscardSave addObject:[NSNumber numberWithInteger:(NSInteger)[((Card*)[self.deckFlipDiscard objectAtIndex:i]) getSaveIndex]*(((Card*)[self.deckFlipDiscard objectAtIndex:i]).isFacingUp?1:-1)]];
        //[flipDiscardSave addObject:[self.deckFlipDiscard objectAtIndex:i]];
    }
    [saveObject addObject:flipDiscardSave];
    // Get All Hands indexes
    NSMutableArray* hand1Save = [[NSMutableArray alloc] init];
    for(int i = 0; i < [self.hand0 count]; i++)
    {
        [hand1Save addObject:[NSNumber numberWithInteger:(NSInteger)[((Card*)[self.hand0 objectAtIndex:i]) getSaveIndex]*(((Card*)[self.hand0 objectAtIndex:i]).isFacingUp?1:-1)]];
        // [hand1Save addObject:[self.hand0 objectAtIndex:i]];
    }
    [saveObject addObject:hand1Save];
    NSMutableArray* hand2Save = [[NSMutableArray alloc] init];
    for(int i = 0; i < [self.hand1 count]; i++)
    {
        [hand2Save addObject:[NSNumber numberWithInteger:(NSInteger)[((Card*)[self.hand1 objectAtIndex:i]) getSaveIndex]*(((Card*)[self.hand1 objectAtIndex:i]).isFacingUp?1:-1)]];
        //[hand2Save addObject:[self.hand1 objectAtIndex:i]];
    }
    [saveObject addObject:hand2Save];
    NSMutableArray* hand3Save = [[NSMutableArray alloc] init];
    for(int i = 0; i < [self.hand2 count]; i++)
    {
        [hand3Save addObject:[NSNumber numberWithInteger:(NSInteger)[((Card*)[self.hand2 objectAtIndex:i]) getSaveIndex]*(((Card*)[self.hand2 objectAtIndex:i]).isFacingUp?1:-1)]];
        //[hand3Save addObject:[self.hand2 objectAtIndex:i]];
    }
    [saveObject addObject:hand3Save];
    NSMutableArray* hand4Save = [[NSMutableArray alloc] init];
    for(int i = 0; i < [self.hand3 count]; i++)
    {
        [hand4Save addObject:[NSNumber numberWithInteger:(NSInteger)[((Card*)[self.hand3 objectAtIndex:i]) getSaveIndex]*(((Card*)[self.hand3 objectAtIndex:i]).isFacingUp?1:-1)]];
        //[hand4Save addObject:[self.hand3 objectAtIndex:i]];
    }
    [saveObject addObject:hand4Save];
    NSMutableArray* hand5Save = [[NSMutableArray alloc] init];
    for(int i = 0; i < [self.hand4 count]; i++)
    {
        [hand5Save addObject:[NSNumber numberWithInteger:(NSInteger)[((Card*)[self.hand4 objectAtIndex:i]) getSaveIndex]*(((Card*)[self.hand4 objectAtIndex:i]).isFacingUp?1:-1)]];
        //[hand5Save addObject:[self.hand4 objectAtIndex:i]];
    }
    [saveObject addObject:hand5Save];
    NSMutableArray* hand6Save = [[NSMutableArray alloc] init];
    for(int i = 0; i < [self.hand5 count]; i++)
    {
        [hand6Save addObject:[NSNumber numberWithInteger:(NSInteger)[((Card*)[self.hand5 objectAtIndex:i]) getSaveIndex]*(((Card*)[self.hand5 objectAtIndex:i]).isFacingUp?1:-1)]];
        //[hand6Save addObject:[self.hand5 objectAtIndex:i]];
    }
    [saveObject addObject:hand6Save];
    NSMutableArray* hand7Save = [[NSMutableArray alloc] init];
    for(int i = 0; i < [self.hand6 count]; i++)
    {
        [hand7Save addObject:[NSNumber numberWithInteger:(NSInteger)[((Card*)[self.hand6 objectAtIndex:i]) getSaveIndex]*(((Card*)[self.hand6 objectAtIndex:i]).isFacingUp?1:-1)]];
        //[hand7Save addObject:[self.hand6 objectAtIndex:i]];
    }
    [saveObject addObject:hand7Save];
    // Get All discards indexes
    NSMutableArray* discard1Save = [[NSMutableArray alloc] init];
    for(int i = 0; i < [self.discard1 count]; i++)
    {
        [discard1Save addObject:[NSNumber numberWithInteger:(NSInteger)[((Card*)[self.discard1 objectAtIndex:i]) getSaveIndex]*(((Card*)[self.discard1 objectAtIndex:i]).isFacingUp?1:-1)]];
        // [discard1Save addObject:[self.discard1 objectAtIndex:i]];
    }
    [saveObject addObject:discard1Save];
    NSMutableArray* discard2Save = [[NSMutableArray alloc] init];
    for(int i = 0; i < [self.discard2 count]; i++)
    {
        [discard2Save addObject:[NSNumber numberWithInteger:(NSInteger)[((Card*)[self.discard2 objectAtIndex:i]) getSaveIndex]*(((Card*)[self.discard2 objectAtIndex:i]).isFacingUp?1:-1)]];
        // [discard2Save addObject:[self.discard2 objectAtIndex:i]];
    }
    [saveObject addObject:discard2Save];
    NSMutableArray* discard3Save = [[NSMutableArray alloc] init];
    for(int i = 0; i < [self.discard3 count]; i++)
    {
        [discard3Save addObject:[NSNumber numberWithInteger:(NSInteger)[((Card*)[self.discard3 objectAtIndex:i]) getSaveIndex]*(((Card*)[self.discard3 objectAtIndex:i]).isFacingUp?1:-1)]];
        //[discard3Save addObject:[self.discard3 objectAtIndex:i]];
    }
    [saveObject addObject:discard3Save];
    NSMutableArray* discard4Save = [[NSMutableArray alloc] init];
    for(int i = 0; i < [self.discard4 count]; i++)
    {
        [discard4Save addObject:[NSNumber numberWithInteger:(NSInteger)[((Card*)[self.discard4 objectAtIndex:i]) getSaveIndex]*(((Card*)[self.discard4 objectAtIndex:i]).isFacingUp?1:-1)]];
        //[discard4Save addObject:[self.discard4 objectAtIndex:i]];
    }
    [saveObject addObject:discard4Save];
    NSError* e = nil;
    NSData* saveData = [NSJSONSerialization dataWithJSONObject:saveObject options:NSJSONWritingPrettyPrinted error:&e];
    //NSString* saveString = [[NSString alloc] initWithData:saveData encoding:NSUTF8StringEncoding];
    
    //NSLog(@"save string!:%@",saveString);
    
    [self.sharedDefaults setObject:saveData forKey:@"savedata"];
    [self.sharedDefaults synchronize];
    [self.wormhole passMessageObject:@{}
                          identifier:@"loadSavedStateExtension"];
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


@end
