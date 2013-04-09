/*
 *  TBAAGun.m
 *  Thunderbolt
 *
 *  Created by bearkode on 10. 7. 4..
 *  Copyright 2010 Tinybean. All rights reserved.
 *
 */

#import "TBAAGunSite.h"
#import <PBKit.h>
#import "TBGameConst.h"
#import "TBTextureNames.h"
#import "TBUnitManager.h"
#import "TBAAVulcan.h"
#import "TBHelicopter.h"
#import "TBMacro.h"
#import "TBExplosionManager.h"


@implementation TBAAGunSite
{
    TBAAVulcan *mAAVulcan;
    
    NSArray    *mTextureArray;
}


- (id)initWithTeam:(TBTeam)aTeam
{
    self = [super initWithTeam:aTeam];
    
    if (self)
    {
        [self setDurability:kAAGunSiteDurability];
        
        mAAVulcan     = [[TBAAVulcan alloc] initWithBody:self team:aTeam];        
        mTextureArray = [[NSArray alloc] initWithObjects:[PBTextureManager textureWithImageName:kTexAAGun01],
                                                         [PBTextureManager textureWithImageName:kTexAAGun01],
                                                         [PBTextureManager textureWithImageName:kTexAAGun02],
                                                         [PBTextureManager textureWithImageName:kTexAAGun03],
                                                         [PBTextureManager textureWithImageName:kTexAAGun04], nil];

        PBTexture *sTexture = [mTextureArray objectAtIndex:0];
        [sTexture loadIfNeeded];
        [self setTexture:sTexture];
    }
    
    return self;
}


- (void)dealloc
{
    [mAAVulcan release];
    [mTextureArray release];
    
    [super dealloc];
}


- (void)addDamage:(NSUInteger)aDamage
{
    if (!mIsDestroyed)
    {
        mDamage += aDamage;    
        if (mDurability <= mDamage)
        {
            mIsDestroyed = YES;

            PBTexture *sTexture = [PBTextureManager textureWithImageName:kTexAAGunDestroyed];

            [sTexture loadIfNeeded];
            [self setTexture:sTexture];
            
            [TBExplosionManager tankExplosionAtPoistion:[self point]];
        }
    }
}


- (void)action
{
    [super action];
    
    if (![self isDestroyed])
    {
        [mAAVulcan action];
        
        TBHelicopter *sHelicopter     = [[TBUnitManager sharedManager] opponentHeicopter:mTeam];
        CGPoint       sSitePosition   = [self point];
        CGPoint       sTargetPosition = [sHelicopter point];
        CGFloat       sAngle;
        CGFloat       sDistance;
        PBTexture    *sTexture = nil;
        
        sDistance = TBDistanceBetweenToPoints(sSitePosition, sTargetPosition);
        
        if (sHelicopter && sDistance < [mAAVulcan maxRange])
        {
            sAngle = TBRadiansToDegrees(TBAngleBetweenToPoints(sSitePosition, sTargetPosition));
            if (sAngle < 36)
            {
                sTexture = [mTextureArray objectAtIndex:4];
            }
            else if (sAngle >= 36 && sAngle < 72)
            {
                sTexture = [mTextureArray objectAtIndex:3];
            }
            else if (sAngle >= 72 && sAngle < 108)
            {
                sTexture = [mTextureArray objectAtIndex:2];
            }
            else if (sAngle >= 108 && sAngle < 144)
            {
                sTexture = [mTextureArray objectAtIndex:1];
            }
            else if (sAngle >= 144)
            {
                sTexture = [mTextureArray objectAtIndex:0];
            }
            
            if (sTexture)
            {
                [sTexture loadIfNeeded];
                [self setTexture:sTexture];
            }
            
            [mAAVulcan fireAt:sHelicopter];
        }
    }
}


@end
