/*
 *  TBController.h
 *  Thunderbolt
 *
 *  Created by cgkim on 13. 10. 15..
 *  Copyright (c) 2013 Tinybean. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


typedef enum
{
    kTBControllerModeNone = 0,
    kTBControllerModeMotion,
    kTBControllerModeScreen,
    kTBControllerModeGamepad,
} TBControllerMode;


@interface TBController : NSObject


@property (nonatomic, readonly) CGFloat xAxisValue;
@property (nonatomic, readonly) CGFloat yAxisValue;
@property (nonatomic, readonly) BOOL    AButtonValue;
@property (nonatomic, readonly) BOOL    BButtonValue;
@property (nonatomic, readonly) BOOL    XButtonValue;
@property (nonatomic, readonly) BOOL    YButtonValue;
@property (nonatomic, readonly) BOOL    rightShoulderValue;


- (void)setControllerMode:(TBControllerMode)aControllerMode;
- (TBControllerMode)controllerMode;


@end
