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

#import "TBVulcan.h"
#import "TBMissileLauncher.h"


const CGFloat kAPCSpeed = 0.5;


#pragma mark -


@implementation TBArmoredVehicle
{
    PBTexture         *mTextureNormal;
    PBTexture         *mTextureHit;
    
    NSInteger          mHitDiscount;
        
    TBVulcan          *mVulcan;
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
        
        mTextureNormal = [[PBTextureManager textureWithImageName:kTexSAM] retain];
        mTextureHit    = [[PBTextureManager textureWithImageName:kTexSAMShoot] retain];

        [self setTexture:mTextureNormal];
        [self setTileSize:[mTextureNormal size]];
        [self setPoint:CGPointMake(kMaxMapXPos + 50, kMapGround + ([self tileSize].height / 2))];
        
        mVulcan        = [[TBVulcan alloc] init];
        mMissileLauncher = [[TBMissileLauncher alloc] init];
        
        [mVulcan setBody:self];
        [mMissileLauncher setBody:self];
    }
    
    return self;
}


- (void)dealloc
{
    [mVulcan        release];
    [mMissileLauncher release];
    
    [super dealloc];
}


- (void)action
{
    BOOL sFire = NO;
    
    [super action];
    
    [mVulcan action];
    [mMissileLauncher action];
    
    if (![self isAlly])
    {
        TBUnit *sHelicopter = (TBUnit *)[[TBUnitManager sharedManager] allyHelicopter];
        
        if ([mMissileLauncher ammoCount] > 0)
        {
            sFire = [mMissileLauncher fireAt:sHelicopter];
        }
        else
        {
            sFire = [mVulcan fireAt:sHelicopter];
        }
    }
    
    if (!sFire)
    {
        [self moveWithVector:CGPointMake(([self isAlly]) ? kAPCSpeed : -kAPCSpeed, 0)];
    }
    
    if (mHitDiscount-- == 0)
    {
        [self setTexture:mTextureNormal];
        [self setTileSize:[mTextureNormal size]];
    }
}


- (void)addDamage:(NSInteger)aDamage
{
    [super addDamage:aDamage];

    [self setTexture:mTextureHit];
    [self setTileSize:[mTextureHit size]];
    mHitDiscount = 10;
}


@end
