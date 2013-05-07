/*
 *  TBBase.m
 *  Thunderbolt
 *
 *  Created by bearkode on 10. 3. 5..
 *  Copyright 2010 tinybean. All rights reserved.
 *
 */

#import "TBBase.h"
#import "TBTextureNames.h"
#import "TBUnitManager.h"
#import "TBWarheadManager.h"
#import "TBHelicopter.h"

#import "TBVulcan.h"
#import "TBMissileLauncher.h"


@implementation TBBase
{
    NSInteger          mTick;
    NSUInteger         mTextureIndex;
    NSArray           *mTextureKeys;
    
    TBVulcan          *mVulcan;
    TBMissileLauncher *mMissileLauncher;
}


#pragma mark -


+ (Class)meshClass
{
    return [PBTileMesh class];
}


- (void)setupTexture
{
    [(PBTileMesh *)[self mesh] setTileSize:CGSizeMake(60, 65)];
    
    PBTexture *sTexture = [PBTextureManager textureWithImageName:kTexBase];
    [sTexture loadIfNeeded];
    [self setTexture:sTexture];

    mTick         = 0;
    mTextureIndex = 0;
}


#pragma mark -


- (id)initWithTeam:(TBTeam)aTeam
{
    self = [super initWithTeam:aTeam];

    if (self)
    {
        [self setDurability:kBaseDurability];
        [self setupTexture];
        
        mVulcan          = [[TBVulcan alloc] init];
        mMissileLauncher = [[TBMissileLauncher alloc] init];
        
        [mVulcan setBody:self];
        [mMissileLauncher setBody:self];
    }
    
    return self;
}


- (void)dealloc
{
    [mTextureKeys     release];
    [mVulcan        release];
    [mMissileLauncher release];
    
    [super dealloc];
}


- (void)action
{
    [super action];
    
    if (![self isDestroyed])
    {
        if (mTick++ > 5)
        {
            mTick = 0;
            [(PBTileMesh *)[self mesh] selectTileAtIndex:mTextureIndex++];
            mTextureIndex = (mTextureIndex > 7) ? 0 : mTextureIndex;
        }
        
        TBUnit *sTarget = ([self team] == kTBTeamAlly) ? [[TBUnitManager sharedManager] enemyHelicopter] : [[TBUnitManager sharedManager] allyHelicopter];
        [mVulcan action];
        [mMissileLauncher action];
        
#if (0)
        if (sTarget)
        {
            if ([mAAVulcan fireAt:sTarget])
            {
                [mAAVulcan supplyAmmo:1];
            }
        }
#else
        if (sTarget)
        {
            if ([mMissileLauncher fireAt:sTarget])
            {
                [mMissileLauncher supplyAmmo:1];
            }
        }
    }
#endif
}


@end
