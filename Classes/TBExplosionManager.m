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
    PBLayer        *mExplosionLayer;
    NSMutableArray *mExplosionArray;
}


SYNTHESIZE_SINGLETON_CLASS(TBExplosionManager, sharedManager)


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
    [mExplosionLayer addSublayer:aExplosion];
    [mExplosionArray addObject:aExplosion];
}


- (void)setExplosionLayer:(PBLayer *)aExplosionLayer
{
    [mExplosionLayer autorelease];
    mExplosionLayer = [aExplosionLayer retain];
}


- (void)doActions
{
    TBExplosion *sExplosion;
    
    [self removeFinishedExplosion];
    
    for (sExplosion in mExplosionArray)
    {
        [sExplosion action];
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

    [mExplosionLayer removeSublayers:sRemovedSprites];
    [mExplosionArray removeObjectsInArray:sRemovedSprites];
    [sRemovedSprites removeAllObjects];
}


#pragma mark -


+ (void)explosionWithUnit:(TBUnit *)aUnit
{
    if ([aUnit isKindOfUnit:kTBUnitTank])
    {
        [TBExplosionManager tankExplosionAtPoistion:[aUnit point]];
    }
    else if ([aUnit isKindOfUnit:kTBUnitMissile])
    {
        PBVertex3 sAngle = [[aUnit transform] angle];
        [TBExplosionManager missileExplosionAtPosition:[aUnit point] angle:sAngle.z];
    }
    else if ([aUnit isKindOfUnit:kTBUnitHelicopter])
    {
        [TBExplosionManager helicopterExplosionAtPosition:[aUnit point] isLeftAhead:[(TBHelicopter *)aUnit isLeftAhead]];
    }
    else if ([aUnit isKindOfUnit:kTBUnitSoldier])
    {
    
    }
    else
    {
        [TBExplosionManager tankExplosionAtPoistion:[aUnit point]];
    }
}


//  TODO : explosion for each team
+ (TBExplosion *)tankExplosionAtPoistion:(CGPoint)aPosition
{
    TBExplosion *sExplosion   = [[[TBExplosion alloc] init] autorelease];
    PBTexture   *sTexture     = nil;
    
    sTexture = [PBTextureManager textureWithImageName:kTexEnemyTankExp00];
    [sTexture loadIfNeeded];
    [sExplosion addTexture:sTexture atPosition:aPosition];
    [sExplosion addTexture:sTexture atPosition:aPosition];
    
    sTexture = [PBTextureManager textureWithImageName:kTexEnemyTankExp01];
    [sTexture loadIfNeeded];
    [sExplosion addTexture:sTexture atPosition:aPosition];
    [sExplosion addTexture:sTexture atPosition:aPosition];
    
    sTexture = [PBTextureManager textureWithImageName:kTexEnemyTankExp02];
    [sTexture loadIfNeeded];
    [sExplosion addTexture:sTexture atPosition:aPosition];
    [sExplosion addTexture:sTexture atPosition:aPosition];
    
    [[TBExplosionManager sharedManager] addObject:sExplosion];
#warning fix it
//    [[TBALPlayback sharedPlayback] startSound:kTBSoundTankExplosion];

    return sExplosion;
}


+ (TBExplosion *)bombExplosionAtPosition:(CGPoint)aPosition
{
    TBExplosion *sExplosion = [[[TBExplosion alloc] init] autorelease];
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

    [[TBExplosionManager sharedManager] addObject:sExplosion];
#warning fix it
//    [[TBALPlayback sharedPlayback] startSound:kTBSoundBombExplosion];

    return sExplosion;
}


+ (TBExplosion *)helicopterExplosionAtPosition:(CGPoint)aPosition isLeftAhead:(BOOL)aIsLeftAhead
{
    TBExplosion *sExplosion = [[[TBExplosion alloc] init] autorelease];
    PBTexture   *sTexture = nil;
    
    sTexture = [PBTextureManager textureWithImageName:(aIsLeftAhead) ? kTexHeliLExp00 : kTexHeliRExp00];
    [sTexture loadIfNeeded];
    [sExplosion addTexture:sTexture atPosition:aPosition];
    [sExplosion addTexture:sTexture atPosition:aPosition];
    
    sTexture = [PBTextureManager textureWithImageName:(aIsLeftAhead) ? kTexHeliLExp01 : kTexHeliRExp01];
    [sTexture loadIfNeeded];
    [sExplosion addTexture:sTexture atPosition:aPosition];
    [sExplosion addTexture:sTexture atPosition:aPosition];
    
    sTexture = [PBTextureManager textureWithImageName:(aIsLeftAhead) ? kTexHeliLExp02 : kTexHeliRExp02];
    [sTexture loadIfNeeded];
    [sExplosion addTexture:sTexture atPosition:aPosition];
    [sExplosion addTexture:sTexture atPosition:aPosition];
    
    [[TBExplosionManager sharedManager] addObject:sExplosion];
#warning fix it
//    [[TBALPlayback sharedPlayback] startSound:kTBSoundTankExplosion];
    
    return sExplosion;
}


+ (TBExplosion *)missileExplosionAtPosition:(CGPoint)aPosition angle:(CGFloat)aAngle
{
    TBExplosion *sExplosion = [[[TBExplosion alloc] init] autorelease];
    PBTexture   *sTexture   = nil;
    PBVertex3    sAngle = PBVertex3Make(0, 0, aAngle);
    
    [[sExplosion transform] setAngle:sAngle];
    
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
    
    [[TBExplosionManager sharedManager] addObject:sExplosion];
#warning fix it
//    [[TBALPlayback sharedPlayback] startSound:kTBSoundBombExplosion];
    
    return sExplosion;
}


@end
