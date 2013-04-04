//
//  TBExplosionManager.m
//  Thunderbolt
//
//  Created by jskim on 10. 5. 9..
//  Copyright 2010 Tinybean. All rights reserved.
//

#import "TBExplosionManager.h"
#import "TBExplosion.h"
#import "TBTextureManager.h"
#import "TBTextureNames.h"
#import "TBALPlayback.h"
#import "TBGameConst.h"
#import "TBUnit.h"
#import "TBHelicopter.h"


static TBExplosionManager *gExplosionManager = nil;


@implementation TBExplosionManager


#pragma mark -
#pragma mark for Singleton


+ (id)allocWithZone:(NSZone *)aZone
{
    @synchronized(self)
    {
        if (!gExplosionManager)
        {
            gExplosionManager = [super allocWithZone:aZone];
            return gExplosionManager;
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
        mExplosionArray = [[NSMutableArray alloc] init];
    }
    
    return self;
}


#pragma mark -


- (void)addObject:(TBExplosion *)aExplosion
{
    [mExplosionArray addObject:aExplosion];
}


- (void)doActions
{
    TBExplosion *sExplosion;
    
    for (sExplosion in mExplosionArray)
    {
        [sExplosion action];
        [sExplosion draw];
    }
}


- (void)removeFinishedExplosion
{
    TBExplosion    *sExplosion;
    NSMutableArray *sRemovedSprites = [NSMutableArray array];
    
    for (sExplosion in mExplosionArray)
    {
        if ([sExplosion isFinished])
        {
            [sRemovedSprites addObject:sExplosion];
        }
    }
    
    [mExplosionArray removeObjectsInArray:sRemovedSprites];
    [sRemovedSprites removeAllObjects];
}


#pragma mark -


+ (TBExplosionManager *)sharedManager
{
    @synchronized(self)
    {
        if (!gExplosionManager)
        {
            gExplosionManager = [[self alloc] init];
        }
    }
    
    return gExplosionManager;
}


+ (void)explosionWithUnit:(TBUnit *)aUnit
{
    if ([aUnit isKindOfUnit:kTBUnitTank])
    {
        [TBExplosionManager tankExplosionAtPoistion:[aUnit position]];
    }
    else if ([aUnit isKindOfUnit:kTBUnitMissile])
    {
        [TBExplosionManager missileExplosionAtPosition:[aUnit position] angle:[aUnit angle]];
    }
    else if ([aUnit isKindOfUnit:kTBUnitHelicopter])
    {
        [TBExplosionManager helicopterExplosionAtPosition:[aUnit position] isLeftAhead:[(TBHelicopter *)aUnit isLeftAhead]];
    }
    else if ([aUnit isKindOfUnit:kTBUnitSoldier])
    {
    
    }
    else
    {
        [TBExplosionManager tankExplosionAtPoistion:[aUnit position]];            
    }
}


//  TODO : explosion for each team
+ (TBExplosion *)tankExplosionAtPoistion:(CGPoint)aPosition
{
    TBExplosion   *sExplosion = [[[TBExplosion alloc] init] autorelease];
    TBTextureInfo *sInfo      = nil;
    
    sInfo = [TBTextureManager textureInfoForKey:kTexEnemyTankExp00];
    [sExplosion addTextureInfo:sInfo atPosition:aPosition];
    [sExplosion addTextureInfo:sInfo atPosition:aPosition];    
    sInfo = [TBTextureManager textureInfoForKey:kTexEnemyTankExp01];
    [sExplosion addTextureInfo:sInfo atPosition:aPosition];
    [sExplosion addTextureInfo:sInfo atPosition:aPosition];    
    sInfo = [TBTextureManager textureInfoForKey:kTexEnemyTankExp02];
    [sExplosion addTextureInfo:sInfo atPosition:aPosition];
    [sExplosion addTextureInfo:sInfo atPosition:aPosition];
    
    [[TBExplosionManager sharedManager] addObject:sExplosion];
    [[TBALPlayback sharedPlayback] startSound:kTBSoundTankExplosion];

    return sExplosion;
}


+ (TBExplosion *)bombExplosionAtPosition:(CGPoint)aPosition
{
    TBExplosion   *sExplosion = [[[TBExplosion alloc] init] autorelease];
    TBTextureInfo *sInfo      = nil;
    
    sInfo = [TBTextureManager textureInfoForKey:kTexBombExp00];
    [sExplosion addTextureInfo:sInfo atPosition:aPosition];
    [sExplosion addTextureInfo:sInfo atPosition:aPosition];    
    sInfo = [TBTextureManager textureInfoForKey:kTexBombExp01];
    [sExplosion addTextureInfo:sInfo atPosition:aPosition];
    [sExplosion addTextureInfo:sInfo atPosition:aPosition];    
    sInfo = [TBTextureManager textureInfoForKey:kTexBombExp02];
    [sExplosion addTextureInfo:sInfo atPosition:aPosition];
    [sExplosion addTextureInfo:sInfo atPosition:aPosition];    

    [[TBExplosionManager sharedManager] addObject:sExplosion];    
    
    [[TBALPlayback sharedPlayback] startSound:kTBSoundBombExplosion];

    return sExplosion;
}


+ (TBExplosion *)helicopterExplosionAtPosition:(CGPoint)aPosition isLeftAhead:(BOOL)aIsLeftAhead
{
    TBExplosion   *sExplosion = [[[TBExplosion alloc] init] autorelease];
    TBTextureInfo *sInfo      = nil;
    
    sInfo = [TBTextureManager textureInfoForKey:(aIsLeftAhead) ? kTexHeliLExp00 : kTexHeliRExp00];
    [sExplosion addTextureInfo:sInfo atPosition:aPosition];
    [sExplosion addTextureInfo:sInfo atPosition:aPosition];    
    sInfo = [TBTextureManager textureInfoForKey:(aIsLeftAhead) ? kTexHeliLExp01 : kTexHeliRExp01];
    [sExplosion addTextureInfo:sInfo atPosition:aPosition];
    [sExplosion addTextureInfo:sInfo atPosition:aPosition];    
    sInfo = [TBTextureManager textureInfoForKey:(aIsLeftAhead) ? kTexHeliLExp02 : kTexHeliRExp02];
    [sExplosion addTextureInfo:sInfo atPosition:aPosition];
    [sExplosion addTextureInfo:sInfo atPosition:aPosition];    
    
    [[TBExplosionManager sharedManager] addObject:sExplosion];    
    
    [[TBALPlayback sharedPlayback] startSound:kTBSoundTankExplosion];
    
    return sExplosion;
}


+ (TBExplosion *)missileExplosionAtPosition:(CGPoint)aPosition angle:(CGFloat)aAngle
{
    TBExplosion   *sExplosion = [[[TBExplosion alloc] init] autorelease];
    TBTextureInfo *sInfo      = nil;
    
    [sExplosion setAngle:aAngle];
    
    sInfo = [TBTextureManager textureInfoForKey:kTexMissileExp00];
    [sExplosion addTextureInfo:sInfo atPosition:aPosition];
    [sExplosion addTextureInfo:sInfo atPosition:aPosition];    
    sInfo = [TBTextureManager textureInfoForKey:kTexMissileExp01];
    [sExplosion addTextureInfo:sInfo atPosition:aPosition];
    [sExplosion addTextureInfo:sInfo atPosition:aPosition];    
    sInfo = [TBTextureManager textureInfoForKey:kTexMissileExp02];
    [sExplosion addTextureInfo:sInfo atPosition:aPosition];
    [sExplosion addTextureInfo:sInfo atPosition:aPosition];    
    
    [[TBExplosionManager sharedManager] addObject:sExplosion];    
    
    [[TBALPlayback sharedPlayback] startSound:kTBSoundBombExplosion];
    
    return sExplosion;
}


@end
