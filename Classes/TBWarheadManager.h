/*
 *  TBWarheadManager.h
 *  Thunderbolt
 *
 *  Created by bearkode on 10. 5. 9..
 *  Copyright 2010 Tinybean. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import <PBKit.h>
#import "TBGameConst.h"


@class TBWarhead;
@class TBBullet;
@class TBBomb;
@class TBTankShell;


@interface TBWarheadManager : NSObject


+ (TBWarheadManager *)sharedManager;

- (TBBullet *)bulletWithTeam:(TBTeam)aTeam position:(CGPoint)aPos vector:(CGPoint)aVector power:(NSUInteger)apower;
+ (TBBomb *)bombWithTeam:(TBTeam)aTeam position:(CGPoint)aPos speed:(CGFloat)aSpeed;
+ (TBTankShell *)tankShellWithTeam:(TBTeam)aTeam position:(CGPoint)aPos vector:(CGPoint)aVector;

- (void)setWarheadLayer:(PBLayer *)aLayer;
- (void)addObject:(TBWarhead *)aWarhead;
- (NSArray *)allWarheads;

- (void)doActions;


@end
