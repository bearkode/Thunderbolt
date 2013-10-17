/*
 *  TBBombChamber.m
 *  Thunderbolt
 *
 *  Created by cgkim on 13. 4. 22..
 *  Copyright (c) 2013 Tinybean. All rights reserved.
 *
 */

#import "TBBombChamber.h"
#import "TBHelicopter.h"
#import "TBWarheadManager.h"
#import "TBMoneyManager.h"


@implementation TBBombChamber
{
    BOOL mFire;
}


- (BOOL)canFire
{
    TBHelicopter *sBody  = (TBHelicopter *)[self body];
    
    return (![sBody isLanded] && [self ammoCount] > 0);
}


- (void)setFire:(BOOL)aFire
{
    mFire = aFire;
}


- (BOOL)fillUp
{
    BOOL sReloaded = NO;
    
    if ([TBMoneyManager useMoney:kTBPriceBullet])
    {
        TBHelicopter *sHelicopter = (TBHelicopter *)[self body];
        
        sReloaded = [self supplyAmmo:kLandingPadFillUpBombs];
        if (sReloaded)
        {
            [[sHelicopter delegate] helicopterWeaponDidReload:sHelicopter];
        }
    }
    
    return sReloaded;
}


#pragma mark -


- (void)action
{
    if (mFire)
    {
        if ([self canFire])
        {
            TBHelicopter *sBody  = (TBHelicopter *)[self body];
            CGFloat       sSpeed = [sBody speed];
            CGPoint       sPoint = [sBody point];
            
            [[TBWarheadManager sharedManager] addBombWithTeam:kTBTeamAlly position:CGPointMake(sPoint.x, sPoint.y - 10) speed:sSpeed];
            [self decreaseAmmoCount];
            
            [[sBody delegate] helicopter:sBody weaponDidFire:1];
        }
        
        mFire = NO;
    }
}


@end
