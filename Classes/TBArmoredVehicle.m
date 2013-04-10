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
        CGPoint sPoint = [self point];
        sPoint.x += ([self isAlly]) ? 1.0 : -1.0;
        [self setPoint:sPoint];
    }
    
    if (mHitDiscount == 0)
    {
        [self setTexture:mTextureNormal];
    }
    else
    {
        mHitDiscount--;
        [self setTexture:mTextureHit];
    }
}


- (void)addDamage:(NSInteger)aDamage
{
    [super addDamage:aDamage];
    
    mHitDiscount = 5;
}


@end
