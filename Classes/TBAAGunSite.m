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
#import "TBVulcan.h"
#import "TBHelicopter.h"
#import "TBMacro.h"
#import "TBExplosionManager.h"


@implementation TBAAGunSite
{
    TBVulcan *mVulcan;
    NSArray  *mTextureArray;
}


- (void)updateTextureWithAngle:(CGFloat)aAngle
{
    PBTexture *sTexture = nil;
    
    if (aAngle < 36)
    {
        sTexture = [mTextureArray objectAtIndex:4];
    }
    else if (aAngle >= 36 && aAngle < 72)
    {
        sTexture = [mTextureArray objectAtIndex:3];
    }
    else if (aAngle >= 72 && aAngle < 108)
    {
        sTexture = [mTextureArray objectAtIndex:2];
    }
    else if (aAngle >= 108 && aAngle < 144)
    {
        sTexture = [mTextureArray objectAtIndex:1];
    }
    else if (aAngle >= 144)
    {
        sTexture = [mTextureArray objectAtIndex:0];
    }
    
    if (sTexture && sTexture != [self texture])
    {
        [sTexture loadIfNeeded];
        [self setTexture:sTexture];
    }
}


#pragma mark -


- (id)initWithTeam:(TBTeam)aTeam
{
    self = [super initWithTeam:aTeam];
    
    if (self)
    {
        [self setDurability:kAAGunSiteDurability];
        
        mVulcan = [[TBVulcan alloc] init];
        [mVulcan setBody:self];
        
        mTextureArray = [[NSArray alloc] initWithObjects:[PBTextureManager textureWithImageName:kTexAAGun01],
                                                         [PBTextureManager textureWithImageName:kTexAAGun01],
                                                         [PBTextureManager textureWithImageName:kTexAAGun02],
                                                         [PBTextureManager textureWithImageName:kTexAAGun03],
                                                         [PBTextureManager textureWithImageName:kTexAAGun04], nil];

        PBTexture *sTexture = [mTextureArray objectAtIndex:0];
        [self setTexture:sTexture];
        [self setTileSize:[sTexture size]];
    }
    
    return self;
}


- (void)dealloc
{
    [mVulcan release];
    [mTextureArray release];
    
    [super dealloc];
}


#pragma mark -


- (void)addDamage:(NSUInteger)aDamage
{
    [super addDamage:aDamage];
    
    if ([self isDestroyed])
    {
        PBTexture *sTexture = [PBTextureManager textureWithImageName:kTexAAGunDestroyed];

        [sTexture loadIfNeeded];
        [self setTexture:sTexture];

        [[TBExplosionManager sharedManager] addTankExplosionAtPoistion:[self point]];
    }
}


- (void)action
{
    if (![self isDestroyed])
    {
        [super action];
        [mVulcan action];
        
        TBHelicopter *sHelicopter = [[TBUnitManager sharedManager] opponentHeicopter:[self team]];
        if (sHelicopter)
        {
            CGPoint sSitePosition   = [self point];
            CGPoint sTargetPosition = [sHelicopter point];
            CGFloat sDistance       = TBDistanceBetweenToPoints(sSitePosition, sTargetPosition);
            
            if ([mVulcan inRange:sDistance])
            {
                [self updateTextureWithAngle:TBRadiansToDegrees(TBAngleBetweenToPoints(sSitePosition, sTargetPosition))];
                [mVulcan fireAt:sHelicopter];
            }
        }
    }
}


@end
