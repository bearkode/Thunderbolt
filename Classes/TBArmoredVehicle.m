/*
 *  TBArmoredVehicle.m
 *  Thunderbolt
 *
 *  Created by bearkode on 10. 5. 16..
 *  Copyright 2010 Tinybean. All rights reserved.
 *
 */

#import "TBArmoredVehicle.h"
#import "TBTextureNames.h"
#import "TBUnitManager.h"

#import "TBAAVulcan.h"
#import "TBMissileLauncher.h"


@implementation TBArmoredVehicle
{
    PBTexture         *mTextureNormal;
    PBTexture         *mTextureHit;
    
    NSInteger          mHitDiscount;
        
    TBAAVulcan        *mAAVulcan;
    TBMissileLauncher *mMissileLauncher;
}


- (id)initWithUnitID:(NSNumber *)aUnitID team:(TBTeam)aTeam
{
    self = [super initWithUnitID:aUnitID team:aTeam];
    
    if (self)
    {
        [self setType:kTBUnitArmoredVehicle];
        [self setDurability:kArmoredVehicleDurability];

        mHitDiscount = 0;
        
        [mTextureNormal autorelease];
        mTextureNormal = [[PBTextureManager textureWithImageName:kTexSAM] retain];
        [mTextureNormal loadIfNeeded];
        
        [mTextureHit autorelease];
        mTextureHit = [[PBTextureManager textureWithImageName:kTexSAMShoot] retain];
        [mTextureHit loadIfNeeded];

        [self setTexture:mTextureNormal];
        [self setPoint:CGPointMake(kMaxMapXPos + 50, kMapGround + ([[self mesh] size].height / 2))];
        
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
    BOOL sFire = NO;
    
    [super action];
    
    [mAAVulcan action];
    [mMissileLauncher action];
    
    if (![self isAlly])
    {
        TBUnit *sHelicopter = (TBUnit *)[[TBUnitManager sharedManager] allyHelicopter];
        
        NSLog(@"mMissileLauncher ammoCount = %d", [mMissileLauncher ammoCount]);
        if ([mMissileLauncher ammoCount] > 0)
        {
            sFire = [mMissileLauncher fireAt:sHelicopter];
        }
        else
        {
            sFire = [mAAVulcan fireAt:sHelicopter];
        }
    }
    
    if (!sFire)
    {
        CGPoint sPoint = [self point];
        sPoint.x += ([self isAlly]) ? 1.0 : -1.0;
        [self setPoint:sPoint];
    }
    
    if (mHitDiscount-- == 0)
    {
        [self setTexture:mTextureNormal];
    }
}


- (void)addDamage:(NSInteger)aDamage
{
    [super addDamage:aDamage];

    [self setTexture:mTextureHit];
    mHitDiscount = 10;
}


@end
