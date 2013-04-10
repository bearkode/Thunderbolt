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
    
    NSMutableArray *mWarheadArray;
    NSMutableArray *mReusableBulletArray;
}


SYNTHESIZE_SINGLETON_CLASS(TBWarheadManager, sharedManager)


- (TBBullet *)dequeueReusableBullet
{
    TBBullet *sResult = nil;
    
    if ([mReusableBulletArray count] > 0)
    {
        sResult = [[mReusableBulletArray lastObject] retain];
        [sResult reset];
        [mReusableBulletArray removeLastObject];
    }
    
    return [sResult autorelease];
}


- (void)storeReusableBullet:(TBBullet *)aBullet
{
    [mReusableBulletArray addObject:aBullet];
}


#pragma mark -


- (id)init
{
    self = [super init];
    if (self)
    {
        mWarheadArray        = [[NSMutableArray alloc] init];
        mReusableBulletArray = [[NSMutableArray alloc] init];
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
    [mWarheadArray addObject:aWarhead];
}


- (NSArray *)allWarheads
{
    return mWarheadArray;
}


- (void)doActions
{
    TBWarhead   *sWarhead;
    TBUnit      *sUnit;
    TBStructure *sStructure;
    
    for (sWarhead in mWarheadArray)
    {
        [sWarhead action];
     
        sUnit = [[TBUnitManager sharedManager] intersectedOpponentUnit:sWarhead];
        if (sUnit)
        {
            [sWarhead setAvailable:NO];
            [sUnit addDamage:[sWarhead destructivePower]];
            [TBExplosionManager bombExplosionAtPosition:[sWarhead point]];
        }
        
        if ([sWarhead isAvailable])
        {
            sStructure = [[TBStructureManager sharedManager] intersectedOpponentStructure:sWarhead];
            if (sStructure && ![sStructure isDestroyed])
            {
                [sWarhead setAvailable:NO];
                [sStructure addDamage:[sWarhead destructivePower]];
                [TBExplosionManager bombExplosionAtPosition:[sWarhead point]];
            }
        }
    }
}


- (void)removeDisabledSprite
{
    TBWarhead      *sWarhead;
    NSMutableArray *sRemovedSprites = [NSMutableArray array];
    
    for (sWarhead in mWarheadArray)
    {
        if (![sWarhead isAvailable])
        {
            [sRemovedSprites addObject:sWarhead];
            if ([sWarhead isMemberOfClass:[TBBullet class]])
            {
                [self storeReusableBullet:(TBBullet *)sWarhead];
            }
        }
        else if ([sWarhead isMemberOfClass:[TBBomb class]] && [sWarhead intersectWithGround])
        {
            CGPoint sPosition = [sWarhead point];
            
            [sWarhead setAvailable:NO];  
            [TBExplosionManager bombExplosionAtPosition:CGPointMake(sPosition.x, kMapGround + 18)];
            [sRemovedSprites addObject:sWarhead];
        }
    }
    
    [mWarheadLayer removeSublayers:sRemovedSprites];
    [mWarheadArray removeObjectsInArray:sRemovedSprites];
}


#pragma mark -


+ (TBBullet *)bulletWithTeam:(TBTeam)aTeam position:(CGPoint)aPos vector:(CGPoint)aVector destructivePower:(NSUInteger)aDestructivePower
{
    TBBullet *sBullet = [[TBWarheadManager sharedManager] dequeueReusableBullet];
    
    if (!sBullet)
    {
        sBullet = [[[TBBullet alloc] initWithDestructivePower:aDestructivePower] autorelease];
    }
    
    [sBullet setTeam:aTeam];
    [sBullet setPoint:aPos];
    [sBullet setVector:aVector];
    
    [[TBWarheadManager sharedManager] addObject:sBullet];
    
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
