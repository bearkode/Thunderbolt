/*
 *  TBArmoredVehicle.m
 *  Thunderbolt
 *
 *  Created by bearkode on 10. 5. 16..
 *  Copyright 2010 Tinybean. All rights reserved.
 *
 */

#import "TBArmoredVehicle.h"
#import "TBTextureManager.h"
#import "TBTextureNames.h"
#import "TBUnitManager.h"

#import "TBAAVulcan.h"
#import "TBMissileLauncher.h"


@implementation TBArmoredVehicle


- (id)initWithUnitID:(NSNumber *)aUnitID team:(TBTeam)aTeam
{
    TBTextureManager *sTextureMan = [TBTextureManager sharedManager];
    TBTextureInfo    *sInfo;
    
    self = [super initWithUnitID:aUnitID team:aTeam];
    if (self)
    {
        [self setType:kTBUnitArmoredVehicle];
        [self setDurability:kArmoredVehicleDurability];
        mHitDiscount = 0;
        
        sInfo          = [sTextureMan textureInfoForKey:kTexSAM];
        mTextureNormal = [sInfo textureID];
        sInfo          = [sTextureMan textureInfoForKey:kTexSAMShoot];
        mTextureHit    = [sInfo textureID];
        
        [self setTextureSize:[sInfo textureSize]];
        [self setContentSize:[sInfo contentSize]];
        [self setPosition:CGPointMake(kMaxMapXPos + 50, MAP_GROUND + (mContentSize.height / 2))];
        
        mAAVulcan        = [[TBAAVulcan alloc] initWithBody:self team:aTeam];
        mMissileLauncher = [[TBMissileLauncher alloc] initWithBody:self team:aTeam];
    }
    
    return self;
}


- (void)dealloc
{
    [mAAVulcan        release];
    [mMissileLauncher release];
    
    [super dealloc];
}


- (void)action
{
    BOOL    sFire       = NO;
    TBUnit *sHelicopter = nil;
    
    [super action];
    [mAAVulcan action];
    [mMissileLauncher action];
    
    if (![self isAlly])
    {
        sHelicopter = (TBUnit *)[[TBUnitManager sharedManager] allyHelicopter];
        
        if ([mMissileLauncher ammoCount] > 0)
        {
            [mMissileLauncher fireAt:sHelicopter];
            sFire = YES;
        }
        else
        {
            [mAAVulcan fireAt:sHelicopter];
            sFire = YES;
        }
    }
    
    if (!sFire)
    {
        mPosition.x += ([self isAlly]) ? 1.0 : -1.0;
    }
}


- (void)addDamage:(NSInteger)aDamage
{
    [super addDamage:aDamage];
    
    mHitDiscount = 5;
}


- (void)draw
{
    if (mHitDiscount == 0)
    {
        [self setTextureID:mTextureNormal];
    }
    else
    {
        mHitDiscount--;
        [self setTextureID:mTextureHit];
    }
    
    [super draw];
}


@end
