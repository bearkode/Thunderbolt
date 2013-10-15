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
    PBNode         *mWarheadLayer;
    
    NSMutableArray *mWarheads;
    NSMutableArray *mDisabledWarheads;

    TBObjectPool   *mBulletPool;
    TBObjectPool   *mBombPool;
    TBObjectPool   *mTankShellPool;
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
        mBombPool         = [[TBObjectPool alloc] initWithCapacity:10 storableClass:[TBBomb class]];
        mTankShellPool    = [[TBObjectPool alloc] initWithCapacity:10 storableClass:[TBTankShell class]];
    }
    
    return self;
}


#pragma mark -


- (void)reset
{
    [mWarheadLayer release];
    mWarheadLayer = nil;
    
    [mWarheads removeAllObjects];
    [mDisabledWarheads removeAllObjects];

    [mBulletPool reset];
    [mBombPool reset];
    [mTankShellPool reset];
}


- (void)setWarheadLayer:(PBNode *)aLayer
{
    [mWarheadLayer autorelease];
    mWarheadLayer = [aLayer retain];
}


- (void)addObject:(TBWarhead *)aWarhead
{
    [mWarheadLayer addSubNode:aWarhead];
    [mWarheads addObject:aWarhead];
}


- (NSArray *)allWarheads
{
    return mWarheads;
}


- (void)doActions
{
    [self removeDisabledWarhead];
    
    for (TBWarhead *sWarhead in mWarheads)
    {
        [sWarhead action];
     
        TBUnit *sUnit = [[TBUnitManager sharedManager] intersectedOpponentUnit:sWarhead];
        if (sUnit)
        {
            [sWarhead setAvailable:NO];
            
            [sUnit addDamage:[sWarhead power]];
            [[TBExplosionManager sharedManager] addBombExplosionAtPosition:[sWarhead point]];
        }
        
        TBStructure *sStructure = [[TBStructureManager sharedManager] intersectedOpponentStructure:sWarhead];
        if (sStructure)
        {
            [sWarhead setAvailable:NO];
            
            [sStructure addDamage:[sWarhead power]];
            [[TBExplosionManager sharedManager] addBombExplosionAtPosition:[sWarhead point]];
        }
    }
}


- (void)removeDisabledWarhead
{
    [mDisabledWarheads removeAllObjects];
    
    for (TBWarhead *sWarhead in mWarheads)
    {
        if (![sWarhead available])
        {
            TBObjectPool *sObjectPool = [sWarhead objectPool];
            [sObjectPool finishUsing:sWarhead];
            [mDisabledWarheads addObject:sWarhead];
        }
    }
    
    [mWarheadLayer removeSubNodes:mDisabledWarheads];
    [mWarheads removeObjectsInArray:mDisabledWarheads];
    [mDisabledWarheads removeAllObjects];
}


#pragma mark -


- (TBBullet *)addBulletWithTeam:(TBTeam)aTeam position:(CGPoint)aPos vector:(CGPoint)aVector power:(NSUInteger)aPower
{
    TBBullet *sBullet = (TBBullet *)[mBulletPool object];
    
    [sBullet reset];
    [sBullet setPower:aPower];
    [sBullet setTeam:aTeam];
    [sBullet setPoint:aPos];
    [sBullet setVector:aVector];
    [sBullet setObjectPool:mBulletPool];
    
    [self addObject:sBullet];
    
    return sBullet;
}


- (TBBomb *)addBombWithTeam:(TBTeam)aTeam position:(CGPoint)aPos speed:(CGFloat)aSpeed
{
    TBBomb *sBomb = (TBBomb *)[mBombPool object];
    
    [sBomb reset];
    [sBomb setTeam:aTeam];
    [sBomb setPoint:aPos];
    [sBomb setSpeed:aSpeed];
    [sBomb setObjectPool:mBombPool];
    
    [self addObject:sBomb];
    
    return sBomb;
}


- (TBTankShell *)addTankShellWithTeam:(TBTeam)aTeam position:(CGPoint)aPos vector:(CGPoint)aVector
{
    TBTankShell *sTankShell = (TBTankShell *)[mTankShellPool object];
    
    [sTankShell reset];
    [sTankShell setTeam:aTeam];
    [sTankShell setPoint:aPos];
    [sTankShell setVector:aVector];
    [sTankShell setObjectPool:mTankShellPool];
    
    [self addObject:sTankShell];
    
    return sTankShell;
}


@end
