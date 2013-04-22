/*
 *  TBWarhead.h
 *  Thunderbolt
 *
 *  Created by bearkode on 10. 2. 3..
 *  Copyright 2010 tinybean. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "TBSprite.h"
#import "TBGameConst.h"


@class TBObjectPool;


@interface TBWarhead : TBSprite


@property (nonatomic, assign) TBTeam        team;
@property (nonatomic, assign) NSInteger     power;
@property (nonatomic, assign) NSInteger     life;
@property (nonatomic, assign) BOOL          available;
@property (nonatomic, assign) CGPoint       vector;
@property (nonatomic, assign) TBObjectPool *objectPool;


- (void)reset;

- (void)decreaseLife;
- (BOOL)isAlly;


@end
