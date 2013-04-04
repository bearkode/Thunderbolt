//
//  TBAAGun.m
//  Thunderbolt
//
//  Created by jskim on 10. 7. 4..
//  Copyright 2010 Tinybean. All rights reserved.
//

#import "TBAAGunSite.h"
#import "TBGameConst.h"
#import "TBTextureNames.h"
#import "TBTextureInfo.h"
#import "TBTextureManager.h"
#import "TBUnitManager.h"
#import "TBAAVulcan.h"
#import "TBHelicopter.h"
#import "TBMacro.h"
#import "TBExplosionManager.h"


@implementation TBAAGunSite


- (id)initWithTeam:(TBTeam)aTeam
{
    TBTextureInfo *sInfo;
    
    self = [super initWithTeam:aTeam];
    if (self)
    {
        [self setDurability:kAAGunSiteDurability];
        
        mAAVulcan     = [[TBAAVulcan alloc] initWithBody:self team:aTeam];        
        mTextureArray = [[NSArray alloc] initWithObjects:[TBTextureManager textureInfoForKey:kTexAAGun00],
                                                         [TBTextureManager textureInfoForKey:kTexAAGun01],
                                                         [TBTextureManager textureInfoForKey:kTexAAGun02],
                                                         [TBTextureManager textureInfoForKey:kTexAAGun03],
                                                         [TBTextureManager textureInfoForKey:kTexAAGun04], nil];
                         
        sInfo = [mTextureArray objectAtIndex:0];
        [self setTextureID:[sInfo textureID]];
        [self setTextureSize:[sInfo textureSize]];
        [self setContentSize:[sInfo contentSize]];
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

            TBTextureInfo *sInfo = [TBTextureManager textureInfoForKey:kTexAAGunDestroyed];
            [self setTextureID:[sInfo textureID]];
            [self setTextureSize:[sInfo textureSize]];
            [self setContentSize:[sInfo contentSize]];
            
            [TBExplosionManager tankExplosionAtPoistion:[self position]];
        }
    }
}


- (void)action
{
    [super action];
    
    if (![self isDestroyed])
    {
        [mAAVulcan action];
        
        TBHelicopter  *sHelicopter     = [[TBUnitManager sharedManager] opponentHeicopter:mTeam];
        CGPoint        sSitePosition   = [self position];
        CGPoint        sTargetPosition = [sHelicopter position];
        CGFloat        sAngle;
        CGFloat        sDistance;
        TBTextureInfo *sInfo;
        
        
        sDistance = TBDistanceBetweenToPoints(sSitePosition, sTargetPosition);
        
        if (sHelicopter && sDistance < [mAAVulcan maxRange])
        {
            sAngle = TBRadiansToDegrees(TBAngleBetweenToPoints(sSitePosition, sTargetPosition));
            if (sAngle < 36)
            {
                sInfo = [mTextureArray objectAtIndex:4];
            }
            else if (sAngle >= 36 && sAngle < 72)
            {
                sInfo = [mTextureArray objectAtIndex:3];
            }
            else if (sAngle >= 72 && sAngle < 108)
            {
                sInfo = [mTextureArray objectAtIndex:2];
            }
            else if (sAngle >= 108 && sAngle < 144)
            {
                sInfo = [mTextureArray objectAtIndex:1];
            }
            else if (sAngle >= 144)
            {
                sInfo = [mTextureArray objectAtIndex:0];
            }
            
            [self setTextureID:[sInfo textureID]];
            [self setTextureSize:[sInfo textureSize]];
            [self setContentSize:[sInfo contentSize]];
            
            [mAAVulcan fireAt:sHelicopter];
        }
    }
}


@end
