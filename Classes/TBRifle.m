/*
 *  TBRifle.m
 *  Thunderbolt
 *
 *  Created by bearkode on 10. 7. 22..
 *  Copyright 2010 Tinybean. All rights reserved.
 *
 */

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


- (void)dealloc
{
    [super dealloc];
}


#pragma mark -


- (BOOL)fireAt:(TBUnit *)aUnit
{
    BOOL    sResult = NO;
    CGPoint sTargetPosition;
    CGPoint sBodyPosition;
    CGFloat sDistance;
    TBTeam  sTeam = ([aUnit isAlly]) ? kTBTeamEnemy : kTBTeamAlly;

    if ([self isReloaded])
    {
        sTargetPosition = [aUnit point];
        sBodyPosition   = [mBody point];
        sBodyPosition.y = sBodyPosition.y + 15;
        sDistance       = TBDistanceBetweenToPoints(sBodyPosition, sTargetPosition);
        
        if (sDistance <= mMaxRange)
        {
            CGFloat sAngle  = TBAngleBetweenToPoints(sBodyPosition, sTargetPosition);
            CGPoint sVector = TBVector(sAngle, 3.0);
            
            [[TBWarheadManager sharedManager] bulletWithTeam:sTeam
                                                    position:sBodyPosition
                                                      vector:sVector
                                            destructivePower:kRifleBulletPower];
            
            mAmmoCount--;
            [self reload];
            sResult = YES;
        }
    }
    
    return sResult;
}


@end
