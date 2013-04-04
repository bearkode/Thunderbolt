//
//  TBRifle.m
//  Thunderbolt
//
//  Created by jskim on 10. 7. 22..
//  Copyright 2010 Tinybean. All rights reserved.
//

#import "TBRifle.h"
#import "TBUnit.h"
#import "TBWarheadManager.h"


@implementation TBRifle


- (id)initWithBody:(TBSprite *)aBody team:(TBTeam)aTeam
{
    self = [super initWithBody:aBody team:aTeam];
    if (self)
    {
        mReloadCount = 0;
        mReloadTime  = kRifleReloadTime;
        mMaxRange    = kRifleMaxRange;
        mAmmoCount   = 20;
    }
    
    return self;
}


- (BOOL)fireAt:(TBUnit *)aUnit
{
    BOOL      sResult = NO;
    CGPoint   sTargetPosition;
    CGPoint   sBodyPosition;
    CGFloat   sDistance;
    TBTeam    sTeam = ([aUnit isAlly]) ? kTBTeamEnemy : kTBTeamAlly;
    TBBullet *sBullet;

    if ([self isReloaded])
    {
        sTargetPosition = [aUnit position];
        sBodyPosition   = [mBody position];
        sBodyPosition.y = sBodyPosition.y + 15;
        sDistance       = TBDistanceBetweenToPoints(sBodyPosition, sTargetPosition);
        
        if (sDistance <= mMaxRange)
        {
            CGFloat sAngle  = TBAngleBetweenToPoints(sBodyPosition, sTargetPosition);
            CGPoint sVector = TBVector(sAngle, 6.0);
            
            sBullet = [TBWarheadManager bulletWithTeam:sTeam position:sBodyPosition vector:sVector destructivePower:kRifleBulletPower];
            mAmmoCount--;
            [self reload];
            sResult = YES;
        }
    }
    
    return sResult;
}


@end
