/*
 *  TBExplosionManager.m
 *  Thunderbolt
 *
 *  Created by bearkode on 10. 5. 9..
 *  Copyright 2010 Tinybean. All rights reserved.
 *
 */

#import "TBExplosionManager.h"
#import <PBKit.h>
#import <PBObjCUtil.h>
#import "TBExplosion.h"
#import "TBTextureNames.h"
#import "TBGameConst.h"
#import "TBUnit.h"
#import "TBHelicopter.h"


@implementation TBExplosionManager
{
    PBNode         *mExplosionLayer;
    
    NSMutableArray *mLiveExplosions;
    NSMutableArray *mIdleExplosions;
    NSMutableArray *mTempExplosions;
}


SYNTHESIZE_SINGLETON_CLASS(TBExplosionManager, sharedManager)


- (id)init
{
    self = [super init];
    if (self)
    {
        mLiveExplosions = [[NSMutableArray alloc] init];
        mIdleExplosions = [[NSMutableArray alloc] init];
        mTempExplosions = [[NSMutableArray alloc] init];
    }
    
    return self;
}


#pragma mark -


- (TBExplosion *)idleExplosion
{
    TBExplosion *sExplosion = nil;
    
    if ([mIdleExplosions count] > 0)
    {
        sExplosion = [[mIdleExplosions lastObject] retain];
        [mIdleExplosions removeLastObject];
    }
    else
    {
        sExplosion = [[TBExplosion alloc] init];
    }
    
    [sExplosion reset];
    
    return [sExplosion autorelease];
}


- (void)setLiveExplosion:(TBExplosion *)aExplosion
{
    [mExplosionLayer addSubNode:aExplosion];
    [mLiveExplosions addObject:aExplosion];
}


- (void)reset
{
    [mExplosionLayer release];
    mExplosionLayer = nil;
    
    [mIdleExplosions addObjectsFromArray:mLiveExplosions];
    [mLiveExplosions removeAllObjects];
    [mTempExplosions removeAllObjects];

}


- (void)setExplosionLayer:(PBNode *)aExplosionLayer
{
    [mExplosionLayer autorelease];
    mExplosionLayer = [aExplosionLayer retain];
}


- (void)doActions
{
    [self removeFinishedExplosion];
    
    for (TBExplosion *sExplosion in mLiveExplosions)
    {
        [sExplosion action];
    }
}


- (void)removeFinishedExplosion
{
    [mTempExplosions removeAllObjects];
    
    for (TBExplosion *sExplosion in mLiveExplosions)
    {
        if ([sExplosion isFinished])
        {
            [sExplosion reset];
            [mTempExplosions addObject:sExplosion];
        }
    }

    [mExplosionLayer removeSubNodes:mTempExplosions];
    [mLiveExplosions removeObjectsInArray:mTempExplosions];
    [mIdleExplosions addObjectsFromArray:mTempExplosions];

    [mTempExplosions removeAllObjects];
}


#pragma mark -


- (void)addExplosionWithUnit:(TBUnit *)aUnit
{
    if ([aUnit isKindOfUnit:kTBUnitTank])
    {
        [self addTankExplosionAtPoistion:[aUnit point]];
    }
    else if ([aUnit isKindOfUnit:kTBUnitMissile])
    {
        PBVertex3 sAngle = [aUnit angle];
        [self addMissileExplosionAtPosition:[aUnit point] angle:sAngle.z];
    }
    else if ([aUnit isKindOfUnit:kTBUnitHelicopter])
    {
        [self addHelicopterExplosionAtPosition:[aUnit point] leftAhead:[(TBHelicopter *)aUnit isLeftAhead]];
    }
    else if ([aUnit isKindOfUnit:kTBUnitSoldier])
    {
    
    }
    else
    {
        [self addTankExplosionAtPoistion:[aUnit point]];
    }
}


//  TODO : explosion for each team
- (TBExplosion *)addTankExplosionAtPoistion:(CGPoint)aPosition
{
    TBExplosion *sExplosion   = [self idleExplosion];
    PBTexture   *sTexture     = nil;
    
    sTexture = [PBTextureManager textureWithImageName:kTexEnemyTankExp00];
    [sTexture loadIfNeeded];
    [sExplosion addTexture:sTexture atPosition:aPosition];
    [sExplosion addTexture:sTexture atPosition:aPosition];
    [sExplosion addTexture:sTexture atPosition:aPosition];
    
    sTexture = [PBTextureManager textureWithImageName:kTexEnemyTankExp01];
    [sTexture loadIfNeeded];
    [sExplosion addTexture:sTexture atPosition:aPosition];
    [sExplosion addTexture:sTexture atPosition:aPosition];
    [sExplosion addTexture:sTexture atPosition:aPosition];
    
    sTexture = [PBTextureManager textureWithImageName:kTexEnemyTankExp02];
    [sTexture loadIfNeeded];
    [sExplosion addTexture:sTexture atPosition:aPosition];
    [sExplosion addTexture:sTexture atPosition:aPosition];
    [sExplosion addTexture:sTexture atPosition:aPosition];

    [sExplosion setSound:[[PBSoundManager sharedManager] soundForKey:kTBSoundTankExplosion]];
    
    [[TBExplosionManager sharedManager] setLiveExplosion:sExplosion];

    return sExplosion;
}


- (TBExplosion *)addBombExplosionAtPosition:(CGPoint)aPosition
{
    TBExplosion *sExplosion = [self idleExplosion];
    PBTexture   *sTexture   = nil;
    
    sTexture = [PBTextureManager textureWithImageName:kTexBombExp00];
    [sTexture loadIfNeeded];
    [sExplosion addTexture:sTexture atPosition:aPosition];
    [sExplosion addTexture:sTexture atPosition:aPosition];
    
    sTexture = [PBTextureManager textureWithImageName:kTexBombExp01];
    [sTexture loadIfNeeded];
    [sExplosion addTexture:sTexture atPosition:aPosition];
    [sExplosion addTexture:sTexture atPosition:aPosition];
    
    sTexture = [PBTextureManager textureWithImageName:kTexBombExp02];
    [sTexture loadIfNeeded];
    [sExplosion addTexture:sTexture atPosition:aPosition];
    [sExplosion addTexture:sTexture atPosition:aPosition];
    
    [sExplosion setSound:[[PBSoundManager sharedManager] soundForKey:kTBSoundBombExplosion]];

    [[TBExplosionManager sharedManager] setLiveExplosion:sExplosion];

    return sExplosion;
}


- (TBExplosion *)addHelicopterExplosionAtPosition:(CGPoint)aPosition leftAhead:(BOOL)aLeftAhead
{
    TBExplosion *sExplosion = [self idleExplosion];
    PBTexture   *sTexture   = nil;
    
    sTexture = [PBTextureManager textureWithImageName:(aLeftAhead) ? kTexHeliLExp00 : kTexHeliRExp00];
    [sTexture loadIfNeeded];
    [sExplosion addTexture:sTexture atPosition:aPosition];
    [sExplosion addTexture:sTexture atPosition:aPosition];
    
    sTexture = [PBTextureManager textureWithImageName:(aLeftAhead) ? kTexHeliLExp01 : kTexHeliRExp01];
    [sTexture loadIfNeeded];
    [sExplosion addTexture:sTexture atPosition:aPosition];
    [sExplosion addTexture:sTexture atPosition:aPosition];
    
    sTexture = [PBTextureManager textureWithImageName:(aLeftAhead) ? kTexHeliLExp02 : kTexHeliRExp02];
    [sTexture loadIfNeeded];
    [sExplosion addTexture:sTexture atPosition:aPosition];
    [sExplosion addTexture:sTexture atPosition:aPosition];
    
    [sExplosion setSound:[[PBSoundManager sharedManager] soundForKey:kTBSoundTankExplosion]];
    
    [[TBExplosionManager sharedManager] setLiveExplosion:sExplosion];
    
    return sExplosion;
}


- (TBExplosion *)addMissileExplosionAtPosition:(CGPoint)aPosition angle:(CGFloat)aAngle
{
    TBExplosion *sExplosion = [self idleExplosion];
    PBTexture   *sTexture   = nil;
    PBVertex3    sAngle     = PBVertex3Make(0, 0, aAngle);
    
    [sExplosion setAngle:sAngle];
    
    sTexture = [PBTextureManager textureWithImageName:kTexMissileExp00];
    [sTexture loadIfNeeded];
    [sExplosion addTexture:sTexture atPosition:aPosition];
    [sExplosion addTexture:sTexture atPosition:aPosition];
    
    sTexture = [PBTextureManager textureWithImageName:kTexMissileExp01];
    [sTexture loadIfNeeded];
    [sExplosion addTexture:sTexture atPosition:aPosition];
    [sExplosion addTexture:sTexture atPosition:aPosition];
    
    sTexture = [PBTextureManager textureWithImageName:kTexMissileExp02];
    [sTexture loadIfNeeded];
    [sExplosion addTexture:sTexture atPosition:aPosition];
    [sExplosion addTexture:sTexture atPosition:aPosition];
    
    [sExplosion setSound:[[PBSoundManager sharedManager] soundForKey:kTBSoundBombExplosion]];
    
    [[TBExplosionManager sharedManager] setLiveExplosion:sExplosion];
    
    return sExplosion;
}


@end
