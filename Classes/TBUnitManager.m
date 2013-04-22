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
#import "TBGameConst.h"
#import "TBMacro.h"

#import "TBExplosionManager.h"
#import "TBMoneyManager.h"
#import "TBScoreManager.h"

#import "TBUnit.h"
#import "TBWarhead.h"
#import "TBHelicopter.h"
#import "TBTank.h"
#import "TBArmoredVehicle.h"
#import "TBRifleman.h"
#import "TBMissile.h"


@implementation TBUnitManager
{
    PBLayer            *mUnitLayer;

    NSInteger           mNextUnitID;
    
    TBUnit             *mAllyHelicopter;
    TBUnit             *mEnemyHelicopter;
    
    TBAssociativeArray *mAllyUnits;
    TBAssociativeArray *mEnemyUnits;
    NSMutableArray     *mDisabledUnits;
}


SYNTHESIZE_SINGLETON_CLASS(TBUnitManager, sharedManager);


- (id)init
{
    self = [super init];
    
    if (self)
    {
        mAllyUnits     = [[TBAssociativeArray alloc] init];
        mEnemyUnits    = [[TBAssociativeArray alloc] init];
        mDisabledUnits = [[NSMutableArray alloc] init];
        
        [self reset];
    }
    
    return self;
}


#pragma mark -
#pragma mark Privates


- (NSNumber *)nextUnitID
{
    return [NSNumber numberWithInteger:mNextUnitID++];
}


- (void)addUnit:(TBUnit *)aUnit
{
    NSAssert([aUnit unitID], @"");

    TBAssociativeArray *sUnits = ([aUnit isAlly]) ? mAllyUnits : mEnemyUnits;
    
    [mUnitLayer addSublayer:aUnit];
    [sUnits setObject:aUnit forKey:[aUnit unitID]];
    
    if ([aUnit isKindOfUnit:kTBUnitHelicopter])
    {
        if ([aUnit isAlly])
        {
            mAllyHelicopter = aUnit;
        }
        else
        {
            mEnemyHelicopter = aUnit;
        }
    }
    
    NSLog(@"sUnits = %@", [sUnits array]);
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


- (void)removeDisabledUnits
{
    [mDisabledUnits removeAllObjects];
    
    for (TBUnit *sUnit in [mAllyUnits array])
    {
        if (![sUnit isAvailable])
        {
            [mDisabledUnits addObject:sUnit];
        }
    }
    
    for (TBUnit *sUnit in [mEnemyUnits array])
    {
        if (![sUnit isAvailable])
        {
            [mDisabledUnits addObject:sUnit];
            
            [[TBMoneyManager sharedManager] saveMoneyForUnit:sUnit];
            [[TBScoreManager sharedManager] addScoreForUnit:sUnit];
        }
    }
    
    for (TBUnit *sUnit in mDisabledUnits)
    {
        [self removeUnit:sUnit];
    }
    
    [mDisabledUnits removeAllObjects];
}


#pragma mark -
#pragma mark Config


- (void)reset
{
    [mUnitLayer release];
    mUnitLayer = nil;
    
    mNextUnitID      = 0;
    
    mAllyHelicopter  = nil;
    mEnemyHelicopter = nil;
    
    [mAllyUnits removeAllObjects];
    [mEnemyUnits removeAllObjects];
}


- (void)setUnitLayer:(PBLayer *)aUnitLayer
{
    [mUnitLayer autorelease];
    mUnitLayer = [aUnitLayer retain];
}


#pragma mark -
#pragma mark Actions


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
                [mAllyHelicopter addDamage:[(TBMissile *)sUnit power]];
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


#pragma mark -
#pragma mark Access Units


- (NSArray *)allyUnits
{
    return [mAllyUnits array];
}


- (NSArray *)enemyUnits
{
    return [mEnemyUnits array];
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


#pragma mark -
#pragma mark Helicopter


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
#pragma mark Add New Unit


- (TBHelicopter *)addHelicopterWithTeam:(TBTeam)aTeam delegate:(id)aDelegate
{
    NSNumber     *sUnitID     = [[TBUnitManager sharedManager] nextUnitID];
    TBHelicopter *sHelicopter = [[[TBHelicopter alloc] initWithUnitID:sUnitID team:aTeam] autorelease];
    
    [sHelicopter setDelegate:aDelegate];    
    [sHelicopter setPoint:CGPointMake(kMinMapXPos + 200, kMapGround + ([[sHelicopter mesh] size].height /2))];
    [self addUnit:sHelicopter];
    
    return sHelicopter;
}


- (TBTank *)addTankWithTeam:(TBTeam)aTeam
{
    NSNumber *sUnitID = [[TBUnitManager sharedManager] nextUnitID];
    TBTank   *sTank   = [[[TBTank alloc] initWithUnitID:sUnitID team:aTeam] autorelease];
    
    [self addUnit:sTank];
    
    return sTank;
}


- (TBArmoredVehicle *)addArmoredVehicleWithTeam:(TBTeam)aTeam
{
    NSNumber         *sUnitID         = [[TBUnitManager sharedManager] nextUnitID];
    TBArmoredVehicle *sArmoredVehicle = [[[TBArmoredVehicle alloc] initWithUnitID:sUnitID team:aTeam] autorelease];
    
    [self addUnit:sArmoredVehicle];
    
    return sArmoredVehicle;
}


- (TBRifleman *)addRiflemanWithTeam:(TBTeam)aTeam
{
    NSNumber   *sUnitID   = [[TBUnitManager sharedManager] nextUnitID];
    TBRifleman *sRifleman = [[[TBRifleman alloc] initWithUnitID:sUnitID team:aTeam] autorelease];
    
    [self addUnit:sRifleman];
    
    return sRifleman;
}


- (TBMissile *)addMissileWithTeam:(TBTeam)aTeam position:(CGPoint)aPosition target:(TBUnit *)aTarget
{
    NSNumber  *sUnitID  = [[TBUnitManager sharedManager] nextUnitID];
    TBMissile *sMissile = [[[TBMissile alloc] initWithUnitID:sUnitID team:aTeam] autorelease];
    
    [sMissile setPoint:aPosition];
    [sMissile setTargetID:[aTarget unitID]];
    
    PBVertex3 sAngle = PBVertex3Make(0, 0, TBRadiansToDegrees(TBAngleBetweenToPoints(aPosition, [aTarget point])));
    [[sMissile transform] setAngle:sAngle];
    
    [self addUnit:sMissile];
    
    return sMissile;
}


@end
