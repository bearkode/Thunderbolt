/*
 *  TBController.m
 *  Thunderbolt
 *
 *  Created by cgkim on 13. 10. 15..
 *  Copyright (c) 2013 Tinybean. All rights reserved.
 *
 */

#import "TBController.h"
#import <CoreMotion/CoreMotion.h>


@implementation TBController
{
    TBControllerMode mControllerMode;

    CGFloat          mXAxisValue;
    CGFloat          mYAxisValue;
    BOOL             mAButtonValue;
    BOOL             mBButtonValue;
    BOOL             mXButtonValue;
    BOOL             mYButtonValue;

    /* HW Controller */
    CMMotionManager *mMotionManager;
}


@synthesize xAxisValue   = mXAxisValue;
@synthesize yAxisValue   = mYAxisValue;
@synthesize AButtonValue = mAButtonValue;
@synthesize BButtonValue = mBButtonValue;
@synthesize XButtonValue = mXButtonValue;
@synthesize YButtonValue = mYButtonValue;


#pragma mark -


- (id)init
{
    self = [super init];
    
    if (self)
    {
    
    }
    
    return self;
}


- (void)dealloc
{
    [mMotionManager stopAccelerometerUpdates];
    [mMotionManager release];
    
    [super dealloc];
}


#pragma mark -


- (void)controllerModeWillChange
{
    if (mControllerMode == kTBControllerModeMotion)
    {
        [mMotionManager stopAccelerometerUpdates];
        [mMotionManager release];
        mMotionManager = nil;
    }
}


- (void)controllerModeDidChange
{
    if (mControllerMode == kTBControllerModeMotion)
    {
        mMotionManager = [[CMMotionManager alloc] init];
        [mMotionManager setAccelerometerUpdateInterval:(1.0 / 60.0)];
        [mMotionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData *aAccelerometerData, NSError *aError) {
            mXAxisValue = [aAccelerometerData acceleration].y;
            mYAxisValue = [aAccelerometerData acceleration].x;
            mYAxisValue = (((mYAxisValue + 1.0) * 2.0) - 1.0);
            mYAxisValue = (mYAxisValue >  1.0) ?  1.0 : mYAxisValue;
            mYAxisValue = (mYAxisValue < -1.0) ? -1.0 : mYAxisValue;
        }];
    }
}


#pragma mark -


- (void)setControllerMode:(TBControllerMode)aControllerMode
{
    if (mControllerMode != aControllerMode)
    {
        [self controllerModeWillChange];
        
        mControllerMode = aControllerMode;
        
        [self controllerModeDidChange];
    }
}


@end


//#if (0)
//if ([[GCController controllers] count])
//{
//    CGFloat                sYValue = -0.68;
//    GCController          *sController = [[GCController controllers] objectAtIndex:0];
//    GCGamepad             *sGamepad    = [sController gamepad];
//    GCControllerAxisInput *sXAxisInput = [[sGamepad dpad] xAxis];
//    GCControllerAxisInput *sYAxisInput = [[sGamepad dpad] yAxis];
//    TBHelicopter  *sHelicopter   = [[TBUnitManager sharedManager] allyHelicopter];
//    
//    //        NSLog(@"x value = %f", [sXAxisInput value]);
//    NSLog(@"y value = %f", [sYAxisInput value]);
//    
//    CGFloat y = -[sYAxisInput value];
//    CGFloat x = -[sXAxisInput value];
//    
//    //        if (y > 0 && sYValue < -0.2)
//    //        {
//    //            sYValue += 0.01;
//    //        }
//    //        else if (y < 0 && sYValue > -0.8)
//    //        {
//    //            sYValue -= 0.01;
//    //        }
//    
//    sYValue += (y / 2.0);
//    
//    NSLog(@"sYValue = %f", sYValue);
//    
//    if ([[sGamepad buttonA] value] > 0.1)
//    {
//        [[[TBUnitManager sharedManager] allyHelicopter] setFire:YES];
//    }
//    else
//    {
//        [[[TBUnitManager sharedManager] allyHelicopter] setFire:NO];
//    }
//    
//    
//    if (sHelicopter)
//    {
//        [[sHelicopter controlLever] setAltitude:sYValue speed:x / 1.5];
//        [self updateCameraPositoin];
//    }
//}
//else
//{
//    CMAcceleration sAcceleration = [[mMotionManager accelerometerData] acceleration];
//    TBHelicopter  *sHelicopter   = [[TBUnitManager sharedManager] allyHelicopter];
//    
//    NSLog(@"z - %f y - %f", sAcceleration.z, sAcceleration.y);
//    
//    if (sHelicopter)
//    {
//        [[sHelicopter controlLever] setAltitude:sAcceleration.z speed:sAcceleration.y];
//        [self updateCameraPositoin];
//    }
//}
//#endif
