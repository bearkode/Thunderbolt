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
    NSTimer *mTimer;
    CGFloat  mY;
    CGFloat  mZ;
}


@synthesize delegate = mDelegate;


#pragma mark -


- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    
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


- (void)updatePoint:(CGPoint)aPoint
{
    CGRect sBounds = [self bounds];
    
    mY = 1.0 - (aPoint.x / sBounds.size.width) * 2;
    mZ = (aPoint.y / sBounds.size.height) - 1.0;
}


- (void)touchesBegan:(NSSet *)aTouches withEvent:(UIEvent *)aEvent
{
    UITouch *sTouch = [aTouches anyObject];
    [self updatePoint:[sTouch locationInView:self]];

    [mTimer invalidate];
    mTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0 / 30.0) target:self selector:@selector(timerExpired:) userInfo:nil repeats:YES];
}


- (void)touchesMoved:(NSSet *)aTouches withEvent:(UIEvent *)aEvent
{
    UITouch *sTouch = [aTouches anyObject];
    [self updatePoint:[sTouch locationInView:self]];
}


- (void)touchesEnded:(NSSet *)aTouches withEvent:(UIEvent *)aEvent
{
    [mTimer invalidate];
    mTimer = nil;
}


- (void)touchesCancelled:(NSSet *)aTouches withEvent:(UIEvent *)aEvent
{
    [mTimer invalidate];
    mTimer = nil;
}


- (void)timerExpired:(NSTimer *)aTimer
{
    [mDelegate eventView:self controlAltitude:mZ speed:mY];
}


@end
