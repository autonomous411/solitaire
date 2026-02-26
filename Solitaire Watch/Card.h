//
//  Card.h
//  Solitaire Watch
//
//  Created by Shayne Guiliano on 12/28/14.
//  Copyright (c) 2014 Shayne Guiliano. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Card : NSObject
@property (strong, nonatomic) NSString* suite;
@property (strong, nonatomic) NSString* color;
@property NSInteger value;
@property BOOL isFacingUp;
@property (strong, nonatomic) NSString* filename;
@property NSInteger index;
@property NSInteger indexInternal;
@property BOOL is42;
@property NSUserDefaults *sharedDefaults;
-(NSInteger) index;
-(id) initWithSuit:(NSString*) suit value:(NSInteger) value filename:(NSString*) filename color:(NSString*) color andIndex:(NSInteger) index is42:(BOOL) is42 isCopy:(BOOL) isCopy;
-(Card*) copyCard;
-(id) initWithSuit:(NSString*) suit value:(NSInteger) value filename:(NSString*) filename color:(NSString*) color andIndex:(NSInteger)index andFacing:(BOOL) facing is42:(BOOL) is42 isCopy:(BOOL) isCopy;
-(NSInteger)getSaveIndex;
-(void)setIndexFromSave:(NSInteger)saveIndex;
@end
