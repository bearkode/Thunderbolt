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


@implementation TBBombChamber
{
    BOOL mFire;
}


- (void)setFire:(BOOL)aFire
{
    mFire = aFire;
}


- (void)action
{
    if (mFire)
    {
        if ([self ammoCount] > 0)
        {
            TBHelicopter *sBody  = (TBHelicopter *)[self body];
            CGFloat       sSpeed = [sBody speed];
            CGPoint       sPoint = [sBody point];
            
            [[TBWarheadManager sharedManager] addBombWithTeam:kTBTeamAlly position:CGPointMake(sPoint.x, sPoint.y - 10) speed:sSpeed];
            [self decreaseAmmoCount];
            
            [[sBody delegate] helicopter:sBody weaponFired:1];
        }
        
        mFire = NO;
    }
}


@end
