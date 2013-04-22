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
    
    [self setReloadTime:kMissileReloadTime];
    [self setMaxRange:kMissileMaxRange];
    [self setAmmoCount:1];
}


- (CGPoint)mountPoint
{
    CGPoint sMountPoint = [[self body] point];
    
    sMountPoint.y += 20;
    
    return sMountPoint;
}

//  TODO : 개선 방법을 찾아볼 것.
//         fast enumeration 중에 미사일 유닛이 추가되면서 크래시 발생.
- (void)launchMissile:(id)aUnit
{
    [[TBUnitManager sharedManager] addMissileWithTeam:kTBTeamEnemy position:[self mountPoint] target:aUnit];
    [self decreaseAmmoCount];
    [self reload];
}


- (BOOL)fireAt:(TBUnit *)aUnit
{
    BOOL sResult = NO;

    if ([self isReloaded])
    {
        CGFloat sDistance = TBDistanceBetweenToPoints([self mountPoint], [aUnit point]);

        if ([self inRange:sDistance])
        {
            [self performSelector:@selector(launchMissile:) withObject:aUnit afterDelay:0.0];
            
            sResult = YES;
        }
    }

    return sResult;
}


@end
