/*
 *  TBUnitManager.m
 *  Thunderbolt
 *
 *  Created by bearkode on 10. 3. 7..
 *  Copyright 2010 tinybean. All rights reserved.
 *
 */

#import "TBUnitManager.h"

#import "TBAssociativeArray.h"

#import "TBUnit.h"
#import "TBWarhead.h"

#import "TBHelicopter.h"
#import "TBTank.h"
#import "TBArmoredVehicle.h"
#import "TBSoldier.h"
#import "TBMissile.h"

#import "TBGameConst.h"
#import "TBMacro.h"

#import "TBExplosionManager.h"
#import "TBMoneyManager.h"
#import "TBScoreManager.h"


@implementation TBUnitManager
{
    PBLayer            *mUnitLayer;

    NSInteger           mNextUnitID;
    
    TBUnit             *mAllyHelicopter;
    TBUnit             *mEnemyHelicopter;
    
    TBAssociativeArray *mAllyUnits;
    TBAssociativeArray *mEnemyUnits;
}


SYNTHESIZE_SINGLETON_CLASS(TBUnitManager, sharedManager);


- (id)init
{
    self = [super init];
    
    if (self)
    {
        mNextUnitID = 0;
    
        mAllyUnits  = [[TBAssociativeArray alloc] init];
        mEnemyUnits = [[TBAssociativeArray alloc] init];
    }
    
    return self;
}


#pragma mark -


- (void)reset
{
    [mAllyUnits removeAllObjects];
    [mEnemyUnits removeAllObjects];
}


- (void)setUnitLayer:(PBLayer *)aUnitLayer
{
    [mUnitLayer autorelease];
    mUnitLayer = [aUnitLayer retain];
}


- (NSNumber *)nextUnitID
{
    NSNumber *sResult = [NSNumber numberWithInteger:mNextUnitID];
    
    mNextUnitID++;
    
    return sResult;
}


- (void)addUnit:(TBUnit *)aUnit
{
    NSAssert([aUnit unitID], @"");
    
    [mUnitLayer addSublayer:aUnit];

    if ([aUnit isAlly])
    {
        if ([aUnit isKindOfUnit:kTBUnitHelicopter])
        {
            mAllyHelicopter = aUnit;
        }
        
        [mAllyUnits setObject:aUnit forKey:[aUnit unitID]];
        NSLog(@"mAllyUnits = %@", [mAllyUnits array]);
    }
    else
    {
        if ([aUnit isKindOfUnit:kTBUnitHelicopter])
        {
            mEnemyHelicopter = aUnit;
        }

        [mEnemyUnits setObject:aUnit forKey:[aUnit unitID]];
        NSLog(@"mEnemyUnits = %@", [mEnemyUnits array]);
    }
}


- (void)removeUnit:(TBUnit *)aUnit
{
    [mUnitLayer removeSublayer:aUnit];
    
    if ([aUnit isAlly])
    {
        if ([aUnit isKindOfUnit:kTBUnitHelicopter])
        {
            mAllyHelicopter = nil;
        }

        [mAllyUnits removeObjectForKey:[aUnit unitID]];
    }
    else
    {
        if ([aUnit isKindOfUnit:kTBUnitHelicopter])
        {
            mEnemyHelicopter = nil;
        }

        [mEnemyUnits removeObjectForKey:[aUnit unitID]];
    }
}


- (TBUnit *)unitForUnitID:(NSNumber *)aUnitID
{
    TBUnit *sResult = [mAllyUnits objectForKey:aUnitID];
    
    if (!sResult)
    {
        sResult = [mEnemyUnits objectForKey:aUnitID];
    }
    
    
    return sResult;
}


- (NSArray *)allyUnits
{
    return [mAllyUnits array];
}


- (NSArray *)enemyUnits
{
    return [mEnemyUnits array];
}


#pragma mark -


- (void)doActions
{
    [self removeDisabledUnits];
    
    for (TBUnit *sUnit in [mAllyUnits array])
    {
        [sUnit action];
    }

    for (TBUnit *sUnit in [mEnemyUnits array])
    {
        if ([mAllyHelicopter intersectWith:sUnit])
        {
            if ([sUnit isKindOfUnit:kTBUnitMissile])
            {
                [mAllyHelicopter addDamage:[(TBMissile *)sUnit destructivePower]];
                [sUnit addDamage:100];
            }
            else
            {
                [mAllyHelicopter addDamage:1000];
                [sUnit addDamage:1000];
            }
        }
        
        [sUnit action];
    }
}


- (TBUnit *)intersectedOpponentUnit:(TBWarhead *)aWarhead
{
    TBUnit  *sResult = nil;
    NSArray *sUnits  = ([aWarhead isAlly]) ? [mEnemyUnits array] : [mAllyUnits array];
    
    for (TBUnit *sUnit in sUnits)
    {
        if ([sUnit intersectWith:aWarhead])
        {
            sResult = sUnit;
            break;
        }
    }
    
    return sResult;
}


- (TBUnit *)opponentUnitOf:(TBUnit *)aUnit inRange:(CGFloat)aRange
{
    TBUnit  *sResult = nil;
    TBUnit  *sUnit;
    NSArray *sUnits  = ([aUnit isAlly]) ? [mEnemyUnits array] : [mAllyUnits array];

    for (sUnit in sUnits)
    {
        if ([aUnit distanceWith:sUnit] < aRange)
        {
            sResult = sUnit;
            break;
        }
    }
    
    return sResult;
}


- (NSArray *)removeDisabledUnits
{
    NSMutableArray *sDisabledUnits = [NSMutableArray array];

    for (TBUnit *sUnit in [mAllyUnits array])
    {
        if ([sUnit isAvailable])
        {
            if ([sUnit point].x > (kMaxMapXPos + 50))
            {
                /*   Arrived Limit   */
                [sDisabledUnits addObject:sUnit];
            }
        }
        else
        {
            [sDisabledUnits addObject:sUnit];
            [TBExplosionManager explosionWithUnit:sUnit];
        }
    }

    for (TBUnit *sUnit in [mEnemyUnits array])
    {
        if ([sUnit isAvailable])
        {
            if ([sUnit point].x < -50)
            {
                /*   Arrived Limit   */
                [sDisabledUnits addObject:sUnit];
            }
        }
        else
        {
            [sDisabledUnits addObject:sUnit];
            [TBExplosionManager explosionWithUnit:sUnit];

            [[TBMoneyManager sharedManager] saveMoneyForUnit:sUnit];
            [[TBScoreManager sharedManager] addScoreForUnit:sUnit];
         }
    }

    for (TBUnit *sUnit in sDisabledUnits)
    {
        [self removeUnit:sUnit];
    }
    
    return sDisabledUnits;
}


- (TBHelicopter *)allyHelicopter
{
    return (TBHelicopter *)mAllyHelicopter;
}


- (TBHelicopter *)enemyHelicopter
{
    return (TBHelicopter *)mEnemyHelicopter;
}


- (TBHelicopter *)opponentHeicopter:(TBTeam)aTeam
{
    return (aTeam == kTBTeamAlly) ? (TBHelicopter *)mEnemyHelicopter : (TBHelicopter *)mAllyHelicopter;
}


#pragma mark -
#pragma mark Unit Constructors


+ (TBHelicopter *)helicopterWithTeam:(TBTeam)aTeam delegate:(id)aDelegate
{
    NSNumber     *sUnitID     = [[TBUnitManager sharedManager] nextUnitID];
    TBHelicopter *sHelicopter = [[[TBHelicopter alloc] initWithUnitID:sUnitID team:aTeam] autorelease];
    
    [sHelicopter setDelegate:aDelegate];    
    [sHelicopter setPoint:CGPointMake(kMinMapXPos + 200, kMapGround + ([[sHelicopter mesh] size].height /2))];
    [[TBUnitManager sharedManager] addUnit:sHelicopter];
    
    return sHelicopter;
}


+ (TBTank *)tankWithTeam:(TBTeam)aTeam
{
    NSNumber *sUnitID = [[TBUnitManager sharedManager] nextUnitID];
    TBTank   *sTank   = [[[TBTank alloc] initWithUnitID:sUnitID team:aTeam] autorelease];
    
    [[TBUnitManager sharedManager] addUnit:sTank];
    
    return sTank;
}


+ (TBArmoredVehicle *)armoredVehicleWithTeam:(TBTeam)aTeam
{
    NSNumber         *sUnitID         = [[TBUnitManager sharedManager] nextUnitID];
    TBArmoredVehicle *sArmoredVehicle = [[[TBArmoredVehicle alloc] initWithUnitID:sUnitID team:aTeam] autorelease];
    
    [[TBUnitManager sharedManager] addUnit:sArmoredVehicle];
    
    return sArmoredVehicle;
}


+ (TBSoldier *)soldierWithTeam:(TBTeam)aTeam
{
    NSNumber  *sUnitID  = [[TBUnitManager sharedManager] nextUnitID];
    TBSoldier *sSoldier = [[[TBSoldier alloc] initWithUnitID:sUnitID team:aTeam] autorelease];
    
    [[TBUnitManager sharedManager] addUnit:sSoldier];
    
    return sSoldier;
}


+ (TBMissile *)missileWithTeam:(TBTeam)aTeam position:(CGPoint)aPosition target:(TBUnit *)aTarget
{
    NSNumber  *sUnitID  = [[TBUnitManager sharedManager] nextUnitID];
    TBMissile *sMissile = [[[TBMissile alloc] initWithUnitID:sUnitID team:aTeam] autorelease];
    
    [sMissile setPoint:aPosition];
    [sMissile setTargetID:[aTarget unitID]];
    
    PBVertex3 sAngle = PBVertex3Make(0, 0, TBRadiansToDegrees(TBAngleBetweenToPoints(aPosition, [aTarget point])));
    [[sMissile transform] setAngle:sAngle];
    
    [[TBUnitManager sharedManager] addUnit:sMissile];
    
    return sMissile;
}


@end
