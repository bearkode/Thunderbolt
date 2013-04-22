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

- (TBBullet *)addBulletWithTeam:(TBTeam)aTeam position:(CGPoint)aPos vector:(CGPoint)aVector power:(NSUInteger)apower;
- (TBBomb *)addBombWithTeam:(TBTeam)aTeam position:(CGPoint)aPos speed:(CGFloat)aSpeed;
- (TBTankShell *)addTankShellWithTeam:(TBTeam)aTeam position:(CGPoint)aPos vector:(CGPoint)aVector;

- (void)reset;
- (void)setWarheadLayer:(PBLayer *)aLayer;
- (void)addObject:(TBWarhead *)aWarhead;
- (NSArray *)allWarheads;

- (void)doActions;


@end
