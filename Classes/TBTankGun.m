/*
 *  TBTankGun.m
 *  Thunderbolt
 *
 *  Created by bearkode on 10. 5. 16..
 *  Copyright 2010 Tinybean. All rights reserved.
 *
 */

#import "TBTankGun.h"
#import "TBUnit.h"
#import "TBWarheadManager.h"


@implementation TBTankGun


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
    
    [self setAmmoCount:30];
    [self setReloadTime:kTankGunReloadTime];
    [self setMaxRange:kTankGunMaxRange];
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
            CGPoint sVector = TBVector(sAngle, 4.0);
            
            [[TBWarheadManager sharedManager] addTankShellWithTeam:[aTarget opponentTeam] position:[self mountPoint] vector:sVector];
            [self decreaseAmmoCount];
            [self reload];
            
            sResult = YES;
        }
    }

    return sResult;
}


@end
