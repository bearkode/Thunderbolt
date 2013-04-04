//
//  TBWarheadManager.m
//  Thunderbolt
//
//  Created by jskim on 10. 5. 9..
//  Copyright 2010 Tinybean. All rights reserved.
//

#import "TBWarheadManager.h"
#import "TBUnit.h"
#import "TBUnitManager.h"
#import "TBExplosionManager.h"
#import "TBStructure.h"
#import "TBStructureManager.h"

#import "TBBullet.h"
#import "TBBomb.h"
#import "TBTankShell.h"

static TBWarheadManager *gWarheadManager = nil;


@interface TBWarheadManager (Privates)
@end


@implementation TBWarheadManager (Privates)


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


@end


@implementation TBWarheadManager


#pragma mark -
#pragma mark for Singleton


+ (id)allocWithZone:(NSZone *)aZone
{
    @synchronized(self)
    {
        if (!gWarheadManager)
        {
            gWarheadManager = [super allocWithZone:aZone];
            return gWarheadManager;
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
        mWarheadArray        = [[NSMutableArray alloc] init];
        mReusableBulletArray = [[NSMutableArray alloc] init];
    }
    
    return self;
}


#pragma mark -


- (void)addObject:(TBWarhead *)aWarhead
{
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
            [TBExplosionManager bombExplosionAtPosition:[sWarhead position]];
        }
        else
        {
            [sWarhead draw];
        }
        
        if ([sWarhead isAvailable])
        {
            sStructure = [[TBStructureManager sharedManager] intersectedOpponentStructure:sWarhead];
            if (sStructure && ![sStructure isDestroyed])
            {
                [sWarhead setAvailable:NO];
                [sStructure addDamage:[sWarhead destructivePower]];
                [TBExplosionManager bombExplosionAtPosition:[sWarhead position]];
            }
            else
            {
                [sWarhead draw];        
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
            CGPoint sPosition = [sWarhead position];
            
            [sWarhead setAvailable:NO];  
            [TBExplosionManager bombExplosionAtPosition:CGPointMake(sPosition.x, MAP_GROUND + 18)];
            [sRemovedSprites addObject:sWarhead];
        }
    }
     
    [mWarheadArray removeObjectsInArray:sRemovedSprites];
}


#pragma mark -


+ (TBWarheadManager *)sharedManager
{
    @synchronized(self)
    {
        if (!gWarheadManager)
        {
            gWarheadManager = [[self alloc] init];
        }
    }
    
    return gWarheadManager;
}


+ (TBBullet *)bulletWithTeam:(TBTeam)aTeam position:(CGPoint)aPos vector:(CGPoint)aVector destructivePower:(NSUInteger)aDestructivePower
{
    TBBullet *sBullet = [[TBWarheadManager sharedManager] dequeueReusableBullet];
    
    if (!sBullet)
    {
        sBullet = [[[TBBullet alloc] initWithDestructivePower:aDestructivePower] autorelease];
    }
    
    [sBullet setTeam:aTeam];
    [sBullet setPosition:aPos];
    [sBullet setVector:aVector];
    
    [[TBWarheadManager sharedManager] addObject:sBullet];
    
    return sBullet;
}


+ (TBBomb *)bombWithTeam:(TBTeam)aTeam position:(CGPoint)aPos speed:(CGFloat)aSpeed
{
    TBBomb *sBomb = [[[TBBomb alloc] init] autorelease];
    
    [sBomb setTeam:aTeam];
    [sBomb setPosition:aPos];
    [sBomb setSpeed:aSpeed];
    
    [[TBWarheadManager sharedManager] addObject:sBomb];
    
    return sBomb;
}


+ (TBTankShell *)tankShellWithTeam:(TBTeam)aTeam position:(CGPoint)aPos vector:(CGPoint)aVector
{
    TBTankShell *sTankShell = [[[TBTankShell alloc] init] autorelease];
    
    [sTankShell setTeam:aTeam];
    [sTankShell setPosition:aPos];
    [sTankShell setVector:aVector];
    
    [[TBWarheadManager sharedManager] addObject:sTankShell];
    
    return sTankShell;
}


@end
