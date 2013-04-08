/*
 *  TBControlStickValue.m
 *  Thunderbolt
 *
 *  Created by bearkode on 13. 4. 8..
 *  Copyright (c) 2013 Tinybean. All rights reserved.
 *
 */

#import "TBControlLever.h"
#import "TBHelicopter.h"


@implementation TBControlLever
{
    TBHelicopter *mHelicopter;
    
    CGFloat       mAltitude;
    CGFloat       mSpeed;
}


#pragma mark -


- (id)initWithHelicopter:(id)aHelicopter
{
    self = [super init];
    
    if (self)
    {
        mHelicopter= aHelicopter;
    }
    
    return self;
}


- (void)dealloc
{
    [super dealloc];
}


- (void)setAltitude:(CGFloat)aAltitude speed:(CGFloat)aSpeed
{
    mAltitude = aAltitude;
    mSpeed    = aSpeed;
    
    [mHelicopter setAltitudeLever:aAltitude];
    [mHelicopter setSpeedLever:aSpeed];
}


@end
