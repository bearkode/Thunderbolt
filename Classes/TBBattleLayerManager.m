/*
 *  TBBattleLayerManager.m
 *  Thunderbolt
 *
 *  Created by cgkim on 13. 10. 15..
 *  Copyright (c) 2013 Tinybean. All rights reserved.
 *
 */

#import "TBBattleLayerManager.h"
#import <PBKit.h>
#import "TBGameConst.h"
#import "TBCloudLayer.h"


@implementation TBBattleLayerManager
{
    PBNode       *mRadarLayer;
    PBNode       *mInterfaceLayer;
    PBNode       *mEffectLayer;
    PBNode       *mSmokeLayer;
    PBNode       *mWarheadLayer;
    PBNode       *mExplosionLayer;
    PBNode       *mUnitLayer;
    PBNode       *mStructureLayer;
    PBNode       *mBackgroundLayer;
    TBCloudLayer *mCloudLayer;
}


@synthesize radarLayer      = mRadarLayer;
@synthesize interfaceLayer  = mInterfaceLayer;
@synthesize effectLayer     = mEffectLayer;
@synthesize smokeLayer      = mSmokeLayer;
@synthesize warheadLayer    = mWarheadLayer;
@synthesize explosionLayer  = mExplosionLayer;
@synthesize unitLayer       = mUnitLayer;
@synthesize structureLayer  = mStructureLayer;
@synthesize backgroundLayer = mBackgroundLayer;
@synthesize cloudLayer      = mCloudLayer;


#pragma mark -


- (void)setupBackgroundLayer
{
    NSMutableArray *sNodes         = [NSMutableArray array];
    PBTexture      *sGroundTexture = [PBTextureManager textureWithImageName:@"ground"];
    CGSize          sTextureSize   = [sGroundTexture size];
    PBMergeNode    *sMergeNode     = nil;
    
    for (NSInteger x = -400; x <= kMaxMapXPos + 400; x += sTextureSize.width)
    {
        PBSpriteNode *sLayer = [PBSpriteNode spriteNodeWithImageNamed:@"ground"];
        [sLayer setPoint:CGPointMake(x, sTextureSize.height / 2)];
        [sNodes addObject:sLayer];
    }
    
    sMergeNode = [[[PBMergeNode alloc] initWithNodeArray:sNodes] autorelease];
    [mBackgroundLayer addSubNode:sMergeNode];
}


#pragma mark -


- (id)init
{
    self = [super init];
    
    if (self)
    {
        mRadarLayer      = [[PBNode alloc] init];
        mInterfaceLayer  = [[PBNode alloc] init];
        mEffectLayer     = [[PBNode alloc] init];
        mSmokeLayer      = [[PBNode alloc] init];
        mWarheadLayer    = [[PBNode alloc] init];
        mExplosionLayer  = [[PBNode alloc] init];
        mUnitLayer       = [[PBNode alloc] init];
        mStructureLayer  = [[PBNode alloc] init];
        mBackgroundLayer = [[PBNode alloc] init];
        mCloudLayer      = [[TBCloudLayer alloc] init];
        
        [self setupBackgroundLayer];
    }
    
    return self;
}


- (void)dealloc
{
    [mRadarLayer release];
    [mInterfaceLayer release];
    [mEffectLayer release];
    [mSmokeLayer release];
    [mWarheadLayer release];
    [mExplosionLayer release];
    [mUnitLayer release];
    [mStructureLayer release];
    [mBackgroundLayer release];
    [mCloudLayer release];
    
    [super dealloc];
}


#pragma mark -


- (NSArray *)layers
{
    return @[mCloudLayer, mBackgroundLayer, mStructureLayer, mUnitLayer, mExplosionLayer, mWarheadLayer, mSmokeLayer, mEffectLayer, mInterfaceLayer, mRadarLayer];
}


@end
