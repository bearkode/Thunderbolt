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


- (void)setupTexture
{
    [self setTexture:[PBTextureManager textureWithImageName:kTexBase]];
    [self setTileSize:CGSizeMake(60, 65)];

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
            [self selectTileAtIndex:mTextureIndex++];
            mTextureIndex = (mTextureIndex > 7) ? 0 : mTextureIndex;
        }
        
        [mVulcan action];
        [mMissileLauncher action];

        TBUnit *sTarget = [[TBUnitManager sharedManager] opponentHeicopter:[self team]];
#if (0)
#warning Base Use AAGun
        if (sTarget)
        {
            if ([mVulcan fireAt:sTarget])
            {
                [mVulcan supplyAmmo:1];
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
#endif
    }
}


@end
