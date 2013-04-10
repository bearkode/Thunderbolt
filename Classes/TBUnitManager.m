/*
 *  TBUnitManager.m
 *  Thunderbolt
 *
 *  Created by bearkode on 10. 3. 7..
 *  Copyright 2010 tinybean. All rights reserved.
 *
 */

#import "TBUnitManager.h"
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
    PBLayer             *mUnitLayer;
    
    NSInteger            mNextUnitID;
    
    TBUnit              *mAllyHelicopter;
    TBUnit              *mEnemyHelicopter;
    
    NSMutableDictionary *mAllyUnitDict;
    NSMutableDictionary *mEnemyUnitDict;
}


SYNTHESIZE_SINGLETON_CLASS(TBUnitManager, sharedManager);


- (id)init
{
    self = [super init];
    if (self)
    {
        mNextUnitID    = 0;
        mAllyUnitDict  = [[NSMutableDictionary alloc] init];
        mEnemyUnitDict = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}


#pragma mark -


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
    [mUnitLayer addSublayer:aUnit];
    
    if (![aUnit unitID])
    {
        NSLog(@"aUnit = %@", aUnit);
    }
    
    if ([aUnit isAlly])
    {
        if ([aUnit isKindOfUnit:kTBUnitHelicopter])
        {
            mAllyHelicopter = aUnit;
        }
        [mAllyUnitDict setObject:aUnit forKey:[aUnit unitID]];
        NSLog(@"mAllyUnitDict = %@", mAllyUnitDict);
    }
    else
    {
        if ([aUnit isKindOfUnit:kTBUnitHelicopter])
        {
            mEnemyHelicopter = aUnit;
        }
        [mEnemyUnitDict setObject:aUnit forKey:[aUnit unitID]];
        NSLog(@"mEnemyUnitDict = %@", mEnemyUnitDict);
    }
}


- (TBUnit *)unitForUnitID:(NSNumber *)aUnitID
{
    TBUnit *sResult = nil;
    
    sResult = [mAllyUnitDict objectForKey:aUnitID];
    if (!sResult)
    {
        sResult = [mEnemyUnitDict objectForKey:aUnitID];
    }
    
    return sResult;
}


- (NSArray *)allyUnits
{
    return [mAllyUnitDict allValues];
}


- (NSArray *)enemyUnits
{
    return [mEnemyUnitDict allValues];
}


#pragma mark -


- (void)doActions
{
    TBUnit  *sUnit;
    CGPoint  sPosition;
    NSArray *sUnits;
    
    sUnits = [mAllyUnitDict allValues];
    for (sUnit in sUnits)
    {
        if ([sUnit isKindOfUnit:kTBUnitMissile] && [sUnit intersectWithGround])
        {
            sPosition = [sUnit point];
            [sUnit addDamage:100];
            [TBExplosionManager bombExplosionAtPosition:CGPointMake(sPosition.x, kMapGround + 18)];
        }
        
        [sUnit action];
    }
    
    sUnits = [mEnemyUnitDict allValues];
    for (sUnit in sUnits)
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
        
        if ([sUnit isKindOfUnit:kTBUnitMissile] && [sUnit intersectWithGround])
        {
            sPosition = [sUnit point];
            [sUnit addDamage:100];
            [TBExplosionManager bombExplosionAtPosition:CGPointMake(sPosition.x, kMapGround + 18)];
        }
        
        [sUnit action];
    }
}


- (TBUnit *)intersectedOpponentUnit:(TBWarhead *)aWarhead
{
    TBUnit       *sResult   = nil;
    TBUnit       *sUnit     = nil;
    NSArray      *sUnits    = nil;
    
    sUnits = ([aWarhead isAlly]) ? [mEnemyUnitDict allValues] : [mAllyUnitDict allValues];
    
    for (sUnit in sUnits)
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
    NSArray *sUnits  = ([aUnit isAlly]) ? [mEnemyUnitDict allValues] : [mAllyUnitDict allValues];

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
    TBUnit         *sUnit;
    NSArray        *sUnits;
    NSMutableArray *sDisabledUnits = [NSMutableArray array];

    sUnits = [mAllyUnitDict allValues];
    for (sUnit in sUnits)
    {
        if ([sUnit isAvailable])
        {
            if ([sUnit point].x > (kMaxMapXPos + 50))
            {
                /*   Arrived Limit   */
                [sDisabledUnits addObject:sUnit];
                [mAllyUnitDict removeObjectForKey:[sUnit unitID]];
            }
        }
        else
        {
            [sDisabledUnits addObject:sUnit];
            [mAllyUnitDict removeObjectForKey:[sUnit unitID]];
            [TBExplosionManager explosionWithUnit:sUnit];            
        }
    }

    sUnits = [mEnemyUnitDict allValues];
    for (sUnit in sUnits)
    {
        if ([sUnit isAvailable])
        {
            if ([sUnit point].x < -50)
            {
                /*   Arrived Limit   */
                [sDisabledUnits addObject:sUnit];
                [mEnemyUnitDict removeObjectForKey:[sUnit unitID]];
            }
        }
        else
        {
            [sDisabledUnits addObject:sUnit];
            [mEnemyUnitDict removeObjectForKey:[sUnit unitID]];
            [TBExplosionManager explosionWithUnit:sUnit];

            [[TBMoneyManager sharedManager] saveMoneyForUnit:sUnit];
            [[TBScoreManager sharedManager] addScoreForUnit:sUnit];
         }
    }

    for (sUnit in sDisabledUnits)
    {
        if ([sUnit isAlly])
        {
            if ([sUnit isKindOfUnit:kTBUnitHelicopter])
            {
                mAllyHelicopter = nil;
            }
            [mAllyUnitDict removeObjectForKey:[sUnit unitID]];            
        }
        else
        {
            if ([sUnit isKindOfUnit:kTBUnitHelicopter])
            {
                mEnemyHelicopter = nil;
            }
            [mEnemyUnitDict removeObjectForKey:[sUnit unitID]];
        }
        
        [mUnitLayer removeSublayers:sDisabledUnits];
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
