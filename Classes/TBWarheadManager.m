/*
 *  TBWarheadManager.m
 *  Thunderbolt
 *
 *  Created by bearkode on 10. 5. 9..
 *  Copyright 2010 Tinybean. All rights reserved.
 *
 */

#import "TBWarheadManager.h"
#import <PBObjCUtil.h>
#import "TBObjectPool.h"
#import "TBUnit.h"
#import "TBUnitManager.h"
#import "TBExplosionManager.h"
#import "TBStructure.h"
#import "TBStructureManager.h"

#import "TBBullet.h"
#import "TBBomb.h"
#import "TBTankShell.h"


@implementation TBWarheadManager
{
    PBLayer        *mWarheadLayer;
    
    NSMutableArray *mWarheads;
    NSMutableArray *mDisabledWarheads;
    TBObjectPool   *mBulletPool;
}


SYNTHESIZE_SINGLETON_CLASS(TBWarheadManager, sharedManager)


- (id)init
{
    self = [super init];
    if (self)
    {
        mWarheads         = [[NSMutableArray alloc] init];
        mDisabledWarheads = [[NSMutableArray alloc] init];
        mBulletPool       = [[TBObjectPool alloc] initWithCapacity:10 storableClass:[TBBullet class]];
    }
    
    return self;
}


#pragma mark -


- (void)setWarheadLayer:(PBLayer *)aLayer
{
    [mWarheadLayer autorelease];
    mWarheadLayer = [aLayer retain];
}


- (void)addObject:(TBWarhead *)aWarhead
{
    [mWarheadLayer addSublayer:aWarhead];
    [mWarheads addObject:aWarhead];
}


- (NSArray *)allWarheads
{
    return mWarheads;
}


- (void)doActions
{
    TBWarhead   *sWarhead;
    TBUnit      *sUnit;
    TBStructure *sStructure;
    
    [self removeDisabledWarhead];
    
    for (sWarhead in mWarheads)
    {
        [sWarhead action];
     
        sUnit = [[TBUnitManager sharedManager] intersectedOpponentUnit:sWarhead];
        if (sUnit)
        {
            [sWarhead setAvailable:NO];
            [sUnit addDamage:[sWarhead power]];
            [TBExplosionManager bombExplosionAtPosition:[sWarhead point]];
        }
        
        if ([sWarhead isAvailable])
        {
            sStructure = [[TBStructureManager sharedManager] intersectedOpponentStructure:sWarhead];
            if (sStructure && ![sStructure isDestroyed])
            {
                [sWarhead setAvailable:NO];
                [sStructure addDamage:[sWarhead power]];
                [TBExplosionManager bombExplosionAtPosition:[sWarhead point]];
            }
        }
    }
}


- (void)removeDisabledWarhead
{
    [mDisabledWarheads removeAllObjects];
    
    for (TBWarhead *sWarhead in mWarheads)
    {
        if (![sWarhead isAvailable])
        {
            [mDisabledWarheads addObject:sWarhead];
            if ([sWarhead isMemberOfClass:[TBBullet class]])
            {
                [mBulletPool finishUsing:sWarhead];
            }
        }
        else if ([sWarhead isMemberOfClass:[TBBomb class]] && [sWarhead intersectWithGround])
        {
            [mDisabledWarheads addObject:sWarhead];
            
            CGPoint sPosition = [sWarhead point];
            [TBExplosionManager bombExplosionAtPosition:CGPointMake(sPosition.x, kMapGround + 18)];
        }
    }
    
    [mWarheadLayer removeSublayers:mDisabledWarheads];
    [mWarheads removeObjectsInArray:mDisabledWarheads];
    [mDisabledWarheads removeAllObjects];
}


#pragma mark -


- (TBBullet *)bulletWithTeam:(TBTeam)aTeam position:(CGPoint)aPos vector:(CGPoint)aVector power:(NSUInteger)aPower
{
    TBBullet *sBullet = (TBBullet *)[mBulletPool object];
    
    [sBullet reset];
    [sBullet setPower:aPower];
    [sBullet setTeam:aTeam];
    [sBullet setPoint:aPos];
    [sBullet setVector:aVector];
    
    [self addObject:sBullet];
    
    return sBullet;
}


+ (TBBomb *)bombWithTeam:(TBTeam)aTeam position:(CGPoint)aPos speed:(CGFloat)aSpeed
{
    TBBomb *sBomb = [[[TBBomb alloc] init] autorelease];
    
    [sBomb setTeam:aTeam];
    [sBomb setPoint:aPos];
    [sBomb setSpeed:aSpeed];
    
    [[TBWarheadManager sharedManager] addObject:sBomb];
    
    return sBomb;
}


+ (TBTankShell *)tankShellWithTeam:(TBTeam)aTeam position:(CGPoint)aPos vector:(CGPoint)aVector
{
    TBTankShell *sTankShell = [[[TBTankShell alloc] init] autorelease];
    
    [sTankShell setTeam:aTeam];
    [sTankShell setPoint:aPos];
    [sTankShell setVector:aVector];
    
    [[TBWarheadManager sharedManager] addObject:sTankShell];
    
    return sTankShell;
}


@end
