/*
 *  TBAAVulcan.m
 *  Thunderbolt
 *
 *  Created by bearkode on 10. 5. 14..
 *  Copyright 2010 Tinybean. All rights reserved.
 *
 */

#import "TBVulcan.h"
#import "TBUnit.h"
#import "TBWarheadManager.h"


@implementation TBVulcan


- (id)init
{
    self = [super init];
    
    if (self)
    {
        [self reset];
    }
    
    return self;
}


- (void)dealloc
{
    [super dealloc];
}


#pragma mark -


- (void)reset
{
    [super reset];
    
    [self setReloadTime:kAAVulcanReloadTime];
    [self setMaxRange:kAAVulcanMaxRange];
    [self setAmmoCount:100];
}


- (BOOL)fireAt:(TBUnit *)aTarget
{
    BOOL sResult = NO;
    
    if ([self isReloaded])
    {
        CGFloat sDistance = TBDistanceBetweenToPoints([aTarget point], [self mountPoint]);

        if ([self inRange:sDistance])
        {
            CGFloat sAngle  = TBAngleBetweenToPoints([self mountPoint], [aTarget point]);
            CGPoint sVector = TBMakeVector(sAngle, 3.0);
            
            [[TBWarheadManager sharedManager] addBulletWithTeam:[aTarget opponentTeam] position:[self mountPoint] vector:sVector power:kVulcanBulletPower];
            [self decreaseAmmoCount];
            [self reload];

            sResult = YES;
        }
    }
    
    return sResult;
}


@end
