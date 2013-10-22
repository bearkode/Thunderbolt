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
#import <GameController/GameController.h>


@implementation TBController
{
    TBControllerMode mControllerMode;

    CGFloat          mXAxisValue;
    CGFloat          mYAxisValue;
    BOOL             mAButtonValue;
    BOOL             mBButtonValue;
    BOOL             mXButtonValue;
    BOOL             mYButtonValue;
    BOOL             mRightShoulderValue;

    /* HW Controller */
    CMMotionManager *mMotionManager;
    GCGamepad       *mGamepad;
}


@synthesize xAxisValue         = mXAxisValue;
@synthesize yAxisValue         = mYAxisValue;
@synthesize AButtonValue       = mAButtonValue;
@synthesize BButtonValue       = mBButtonValue;
@synthesize XButtonValue       = mXButtonValue;
@synthesize YButtonValue       = mYButtonValue;
@synthesize rightShoulderValue = mRightShoulderValue;


#pragma mark -


- (BOOL)detectGameController
{
    if ([[GCController controllers] count] > 0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


#pragma mark -


- (id)init
{
    self = [super init];
    
    if (self)
    {
        NSNotificationCenter *sNotiCenter = [NSNotificationCenter defaultCenter];

        [sNotiCenter addObserver:self selector:@selector(gameControllerDidConnectNotification:) name:GCControllerDidConnectNotification object:nil];
        [sNotiCenter addObserver:self selector:@selector(gameControllerDidDisconnectNotification:) name:GCControllerDidDisconnectNotification object:nil];

        if ([self detectGameController])
        {
            [self setControllerMode:kTBControllerModeGamepad];
        }
        else
        {
            [self setControllerMode:kTBControllerModeMotion];
        }
    }
    
    return self;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

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
    else if (mControllerMode == kTBControllerModeGamepad)
    {
        [[mGamepad dpad] setValueChangedHandler:NULL];
        [[mGamepad buttonA] setValueChangedHandler:NULL];
        [[mGamepad rightShoulder] setValueChangedHandler:NULL];
        mGamepad = nil;
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
    else if (mControllerMode == kTBControllerModeGamepad)
    {
        mGamepad = [[[GCController controllers] objectAtIndex:0] gamepad];
        
        [[mGamepad dpad] setValueChangedHandler:^(GCControllerDirectionPad *aDpad, float aXValue, float aYValue) {
            mXAxisValue = -aXValue / 1.5;
            mYAxisValue = aYValue / 1.5;
        }];

        [[mGamepad buttonA] setValueChangedHandler:^(GCControllerButtonInput *aButton, float aValue, BOOL aPressed) {
            mAButtonValue = aPressed;
        }];
        
        [[mGamepad rightShoulder] setValueChangedHandler:^(GCControllerButtonInput *aButton, float aValue, BOOL aPressed) {
            mRightShoulderValue = aPressed;
        }];
    }
}


#pragma mark -


- (void)setControllerMode:(TBControllerMode)aControllerMode
{
    NSLog(@"setControllerMode: %d", aControllerMode);
    
    if (mControllerMode != aControllerMode)
    {
        [self controllerModeWillChange];
        
        mControllerMode = aControllerMode;
        
        [self controllerModeDidChange];
    }
}


- (TBControllerMode)controllerMode
{
    return mControllerMode;
}


#pragma mark -


- (void)gameControllerDidConnectNotification:(NSNotification *)aNotification
{
//    NSDictionary *sUserInfo = [aNotification userInfo];
//    
//    NSLog(@"%@", [NSString stringWithFormat:@"connect = %@", sUserInfo]);

    [self setControllerMode:kTBControllerModeGamepad];
}


- (void)gameControllerDidDisconnectNotification:(NSNotification *)aNotification
{
//    NSDictionary *sUserInfo = [aNotification userInfo];
//    
//    NSLog(@"%@", [NSString stringWithFormat:@"disconnect = %@", sUserInfo]);
    
    [self setControllerMode:kTBControllerModeMotion];
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
