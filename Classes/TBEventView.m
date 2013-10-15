/*
 *  TBEventView.m
 *  Thunderbolt
 *
 *  Created by bearkode on 13. 4. 8..
 *  Copyright (c) 2013 Tinybean. All rights reserved.
 *
 */

#import "TBEventView.h"


@implementation TBEventView
{
    id       mDelegate;
    BOOL     mControlMode;
    
    /*  Control Mode */
    NSTimer *mTimer;
    CGFloat  mY;
    CGFloat  mZ;
    
    /*  Button Mode  */
    CGPoint  mBeginPoint;
}


@synthesize delegate = mDelegate;


#pragma mark -


- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    
    if (self)
    {
        mControlMode = NO;
//        [self setBackgroundColor:[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.5]];
    }
    
    return self;
}


- (void)dealloc
{
    [super dealloc];
}


#pragma mark -


- (void)updatePoint:(CGPoint)aPoint
{
    CGRect sBounds = [self bounds];
    
    mY = 1.0 - (aPoint.x / sBounds.size.width) * 2;
    mZ = (aPoint.y / sBounds.size.height) - 1.0;
}


- (void)touchesBegan:(NSSet *)aTouches withEvent:(UIEvent *)aEvent
{
    UITouch *sTouch = [aTouches anyObject];
    
    if (mControlMode)
    {
        [self updatePoint:[sTouch locationInView:self]];

        [mTimer invalidate];
        mTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0 / 30.0) target:self selector:@selector(timerExpired:) userInfo:nil repeats:YES];
    }
    else
    {
        mBeginPoint = [sTouch locationInView:self];
        
        if ([mDelegate respondsToSelector:@selector(eventView:touchBegan:)])
        {
            [mDelegate eventView:self touchBegan:mBeginPoint];
        }
    }
}


- (void)touchesMoved:(NSSet *)aTouches withEvent:(UIEvent *)aEvent
{
    UITouch *sTouch = [aTouches anyObject];
    CGPoint  sPoint = [sTouch locationInView:self];
    
    if (mControlMode)
    {
        [self updatePoint:sPoint];
    }
    else
    {
        if ([mDelegate respondsToSelector:@selector(eventView:touchMoved:)])
        {
            [mDelegate eventView:self touchMoved:sPoint];
        }
    }
}


- (void)touchesEnded:(NSSet *)aTouches withEvent:(UIEvent *)aEvent
{
    if (mControlMode)
    {
        [mTimer invalidate];
        mTimer = nil;
    }
    else
    {
        UITouch  *sTouch = [[aTouches allObjects] objectAtIndex:0];
        CGPoint   sPoint = [sTouch locationInView:self];
        NSInteger sCount = [sTouch tapCount];
        
        if ([mDelegate respondsToSelector:@selector(eventView:touchEnded:)])
        {
            [mDelegate eventView:self touchEnded:sPoint];
        }
        
        if ([mDelegate respondsToSelector:@selector(eventView:touchTapCount:)])
        {
            [mDelegate eventView:self touchTapCount:sCount];
        }
    }
}


- (void)touchesCancelled:(NSSet *)aTouches withEvent:(UIEvent *)aEvent
{
    if (mControlMode)
    {
        [mTimer invalidate];
        mTimer = nil;
    }
    else
    {
        UITouch *sTouch = [[aTouches allObjects] objectAtIndex:0];
        CGPoint  sPoint = [sTouch locationInView:self];
        
        mBeginPoint = CGPointMake(-1, -1);
        
        if ([mDelegate respondsToSelector:@selector(eventView:touchCancelled:)])
        {
            [mDelegate eventView:self touchCancelled:sPoint];
        }
    }
}


- (void)timerExpired:(NSTimer *)aTimer
{
    [mDelegate eventView:self controlAltitude:mZ speed:mY];
}


#pragma mark -


- (void)setControlMode:(BOOL)aFlag
{
    mControlMode = aFlag;
}


@end
