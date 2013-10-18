/*
 *  TBUnit.h
 *  Thunderbolt
 *
 *  Created by bearkode on 10. 1. 31..
 *  Copyright 2010 tinybean. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "TBGameConst.h"
#import "TBSprite.h"


typedef enum
{
    kTBUnitUnknown = 0,
    kTBUnitHelicopter,
    kTBUnitTank,
    kTBUnitArmoredVehicle,
    kTBUnitSoldier,
    kTBUnitMissile,
} TBUnitType;


typedef enum
{
    kTBUnitStateUnknown = 0,
    kTBUnitStateNormal,
    kTBUnitStateReady,
    kTBUnitStateCrashing,
    kTBUnitStateDestroyed
} TBUnitState;


#pragma mark -


@interface TBUnit : TBSprite


@property (nonatomic, assign)                       TBUnitType  type;
@property (nonatomic, retain)                       NSNumber   *unitID;
@property (nonatomic, readonly)                     TBTeam      team;
@property (nonatomic, assign)                       NSInteger   durability;
@property (nonatomic, assign)                       NSInteger   damage;
@property (nonatomic, assign)                       TBUnitState state;
//@property (nonatomic, assign, getter = isAvailable) BOOL        available;


- (id)initWithUnitID:(NSNumber *)aUnitID team:(TBTeam)aTeam;

- (BOOL)isKindOfUnit:(TBUnitType)aType;
- (BOOL)isAlly;
- (TBTeam)opponentTeam;

- (BOOL)addDamage:(NSInteger)aDamage;
- (void)repair:(NSInteger)aValue;

//- (BOOL)isAvailable;
- (CGFloat)damageRate;


@end
