//
//  TBTankGun.m
//  Thunderbolt
//
//  Created by jskim on 10. 5. 16..
//  Copyright 2010 Tinybean. All rights reserved.
//

#import "TBTankGun.h"
#import "TBUnit.h"
#import "TBWarheadManager.h"


@implementation TBTankGun


- (id)initWithBody:(TBSprite *)aBody team:(TBTeam)aTeam
{
    self = [super initWithBody:aBody team:aTeam];
    
    if (self)
    {
        mReloadCount = 0;
        mAmmoCount   = 30;

        mReloadTime  = kTankGunReloadTime;
        mMaxRange    = kTankGunMaxRange;
    }
    
    return self;
}


- (BOOL)fireAt:(TBUnit *)aTarget
{
    BOOL    sResult = NO;
    CGPoint sTargetPosition;
    CGPoint sTankPosition;
    TBTeam  sTeam = ([aTarget isAlly]) ? kTBTeamEnemy : kTBTeamAlly;

    if ([self isReloaded])
    {
        sTargetPosition = [aTarget position];
        sTankPosition   = [mBody position];

        CGFloat sAngle  = TBAngleBetweenToPoints(sTankPosition, sTargetPosition);
        CGPoint sVector = TBVector(sAngle, 8.0);
            
        [TBWarheadManager tankShellWithTeam:sTeam position:sTankPosition vector:sVector];
        mAmmoCount--;
        [self reload];
        sResult = YES;
    }

    return sResult;
}


@end
