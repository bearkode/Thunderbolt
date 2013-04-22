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

    [self setReloadTime:kRifleReloadTime];
    [self setMaxRange:kRifleMaxRange];
    [self setAmmoCount:20];
}


- (CGPoint)mountPoint
{
    CGPoint sMountPoint = [[self body] point];
    
    sMountPoint.y += 15;
    
    return sMountPoint;
}


- (BOOL)fireAt:(TBUnit *)aUnit
{
    BOOL sResult = NO;

    if ([self isReloaded])
    {
        CGFloat sDistance = TBDistanceBetweenToPoints([aUnit point], [self mountPoint]);
        
        if ([self inRange:sDistance])
        {
            CGFloat sAngle  = TBAngleBetweenToPoints([self mountPoint], [aUnit point]);
            CGPoint sVector = TBMakeVector(sAngle, 3.0);
            
            [[TBWarheadManager sharedManager] addBulletWithTeam:[aUnit opponentTeam] position:[self mountPoint] vector:sVector power:kRifleBulletPower];
            
            [self decreaseAmmoCount];
            [self reload];
            sResult = YES;
        }
    }
    
    return sResult;
}


@end
