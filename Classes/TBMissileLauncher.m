/*
 *  TBSAMLauncher.m
 *  Thunderbolt
 *
 *  Created by bearkode on 10. 5. 16..
 *  Copyright 2010 Tinybean. All rights reserved.
 *
 */

#import "TBMissileLauncher.h"
#import "TBUnit.h"
#import "TBUnitManager.h"
#import "TBMacro.h"


@implementation TBMissileLauncher


- (id)initWithBody:(TBSprite *)aBody team:(TBTeam)aTeam
{
    self = [super initWithBody:aBody team:aTeam];
    
    if (self)
    {
        mReloadCount = 0;
        mReloadTime  = kMissileReloadTime;
        mMaxRange    = kMissileMaxRange;
        mAmmoCount   = 1;
    }
    
    return self;
}


- (void)dealloc
{
    [super dealloc];
}


#pragma mark -


//  TODO : 개선 방법을 찾아볼 것.
//         fast enumeration 중에 미사일 유닛이 추가되면서 크래시 발생.
- (void)launchMissle:(id)aUnit
{
    [TBUnitManager missileWithTeam:kTBTeamEnemy position:[mBody point] target:aUnit];
    mAmmoCount--;
    [self reload];
}


- (BOOL)fireAt:(TBUnit *)aUnit
{
    BOOL    sResult = NO;
    CGPoint sTargetPosition;
    CGPoint sBodyPosition;
    CGFloat sDistance;

    if ([self isReloaded])
    {
        sTargetPosition = [aUnit point];
        sBodyPosition   = [mBody point];
        sBodyPosition.y = sBodyPosition.y + 20;
        sDistance       = TBDistanceBetweenToPoints(sBodyPosition, sTargetPosition);

        if (sDistance <= mMaxRange)
        {
            [self performSelector:@selector(launchMissle:) withObject:aUnit afterDelay:0.0];
            sResult = YES;
        }
    }

    return sResult;
}


@end
