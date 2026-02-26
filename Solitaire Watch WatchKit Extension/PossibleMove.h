//
//  PossibleMove.h
//  Solitaire Watch
//
//  Created by Shayne Guiliano on 4/7/15.
//  Copyright (c) 2015 Shayne Guiliano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface PossibleMove : NSObject
@property (nonatomic,weak) Card* fromCard;
@property (nonatomic,weak) Card* toCard;
@property (nonatomic,weak) NSMutableArray* fromArray;
@property (nonatomic,weak) NSMutableArray* toArray;
@property int fromIndex;
@property int toIndex;
@property (nonatomic,strong) NSString* typeOfMove;
@end
