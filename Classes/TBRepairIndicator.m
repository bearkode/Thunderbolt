/*
 *  TBRepairIndicator.m
 *  Thunderbolt
 *
 *  Created by cgkim on 13. 10. 17..
 *  Copyright (c) 2013 Tinybean. All rights reserved.
 *
 */

#import "TBRepairIndicator.h"


#define kAngleMin (-30.0)
#define kAngleMax (30.0)


@implementation TBRepairIndicator
{
    NSInteger mCounter;
    BOOL      mEnabled;
    CGFloat   mAngleDelta;
}


- (id)init
{
    self = [super initWithImageNamed:@"repair"];
    
    if (self)
    {

    }
    
    return self;
}


- (void)dealloc
{
    [super dealloc];
}


#pragma mark -


- (void)setEnabled:(BOOL)aFlag
{
    mEnabled    = aFlag;
    mAngleDelta = 3.0;
    [self setAlpha:1.0];
    [self setAngle:PBVertex3Make(0.0, 0.0, -30.0)];
    [self setHidden:(mEnabled) ? NO : YES];
}


- (BOOL)isEnabled
{
    return mEnabled;
}


- (void)action
{
    if (mEnabled)
    {
        CGPoint   sPoint = [self point];
        CGFloat   sAlpha = [self alpha];
        PBVertex3 sAngle = [self angle];
        
        sPoint.y += 0.5;
        sAlpha   -= 0.02;
        
        if (sAngle.z < kAngleMin || sAngle.z > kAngleMax)
        {
            mAngleDelta = -mAngleDelta;
        }
        
        sAngle.z += mAngleDelta;
        
        if (sPoint.y >= 80)
        {
            [self setEnabled:NO];
        }
        else
        {
            [self setAngle:sAngle];
            [self setPoint:sPoint];
            [self setAlpha:sAlpha];
        }
    }
}


@end
