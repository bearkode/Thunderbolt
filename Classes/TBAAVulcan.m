/*
 *  TBAAVulcan.m
 *  Thunderbolt
 *
 *  Created by bearkode on 10. 5. 14..
 *  Copyright 2010 Tinybean. All rights reserved.
 *
 */

#import "TBAAVulcan.h"
#import "TBUnit.h"
#import "TBWarheadManager.h"


@implementation TBAAVulcan


- (id)initWithBody:(TBSprite *)aBody team:(TBTeam)aTeam
{
    self = [super initWithBody:aBody team:aTeam];
    
    if (self)
    {
        mReloadCount = 0;
        mReloadTime  = kAAVulcanReloadTime;
        mMaxRange    = kAAVulcanMaxRange;
        mAmmoCount   = 100;
    }
    
    return self;
}


- (BOOL)fireAt:(TBUnit *)aTarget
{
    BOOL    sResult = NO;
    CGPoint sTargetPosition;
    CGPoint sVulcanPosition;
    CGFloat sDistance;
    TBTeam  sTeam = ([aTarget isAlly]) ? kTBTeamEnemy : kTBTeamAlly;
    
    if ([self isReloaded])
    {
        sTargetPosition = [aTarget point];
        sVulcanPosition = [mBody point];
        sDistance       = TBDistanceBetweenToPoints(sVulcanPosition, sTargetPosition);
        
        if (sDistance <= mMaxRange)
        {
            CGFloat sAngle  = TBAngleBetweenToPoints(sVulcanPosition, sTargetPosition);
            CGPoint sVector = TBVector(sAngle, 3.0);
            
            [[TBWarheadManager sharedManager] bulletWithTeam:sTeam position:sVulcanPosition vector:sVector power:kVulcanBulletPower];
            mAmmoCount--;
            [self reload];            
            sResult = YES;
        }
    }
    
    return sResult;
}


@end
