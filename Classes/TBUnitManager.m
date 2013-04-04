//
//  TBUnitManager.m
//  Thunderbolt
//
//  Created by jskim on 10. 3. 7..
//  Copyright 2010 tinybean. All rights reserved.
//

#import "TBUnitManager.h"
#import "TBUnit.h"
#import "TBWarhead.h"

#import "TBHelicopter.h"
#import "TBTank.h"
#import "TBArmoredVehicle.h"
#import "TBSoldier.h"
#import "TBMissile.h"

#import "TBALPlayback.h"
#import "TBGameConst.h"
#import "TBMacro.h"

#import "TBExplosionManager.h"
#import "TBMoneyManager.h"
#import "TBScoreManager.h"


static TBUnitManager *gUnitManager = nil;


@implementation TBUnitManager


+ (TBUnitManager *)sharedManager
{
    @synchronized(self)
    {
        if (!gUnitManager)
        {
            gUnitManager = [[self alloc] init];
        }
    }
    
    return gUnitManager;
}


+ (id)allocWithZone:(NSZone *)aZone
{
    @synchronized(self)
    {
        if (!gUnitManager)
        {
            gUnitManager = [super allocWithZone:aZone];
            return gUnitManager;
        }
    }
    
    return nil;
}


- (id)copyWithZone:(NSZone *)aZone
{
    return self;
}


- (id)retain
{
    return self;
}


- (unsigned)retainCount
{
    return UINT_MAX;
}

- (oneway void)release
{
}


- (id)autorelease
{
    return self;
}


#pragma mark -


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


- (NSNumber *)nextUnitID
{
    NSNumber *sResult = [NSNumber numberWithInteger:mNextUnitID];
    
    mNextUnitID++;
    
    return sResult;
}


- (void)addUnit:(TBUnit *)aUnit
{
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
            sPosition = [sUnit position];
            [sUnit addDamage:100];
            [TBExplosionManager bombExplosionAtPosition:CGPointMake(sPosition.x, MAP_GROUND + 18)];
        }
        
        [sUnit action];
        [sUnit draw];
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
            sPosition = [sUnit position];
            [sUnit addDamage:100];
            [TBExplosionManager bombExplosionAtPosition:CGPointMake(sPosition.x, MAP_GROUND + 18)];
        }
        
        [sUnit action];
        [sUnit draw];
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
            if ([sUnit position].x > (MAX_MAP_XPOS + 50))
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
            if ([sUnit position].x < -50)
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
    [sHelicopter setPosition:CGPointMake(MIN_MAP_XPOS + 200, MAP_GROUND + ([sHelicopter contentSize].height /2))];    
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
    NSNumber  *sUnitID  = [gUnitManager nextUnitID];
    TBMissile *sMissile = [[[TBMissile alloc] initWithUnitID:sUnitID team:aTeam] autorelease];
    
    [sMissile setPosition:aPosition];
    [sMissile setTargetID:[aTarget unitID]];
    [sMissile setAngle:TBRadiansToDegrees(TBAngleBetweenToPoints(aPosition, [aTarget position]))];
    
    [gUnitManager addUnit:sMissile];
    
    return sMissile;
}


@end
