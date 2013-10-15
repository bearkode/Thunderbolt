/*
 *  TBSprite.m
 *  Thunderbolt
 *
 *  Created by bearkode on 09. 11. 10.
 *  Copyright 2009 tinybean. All rights reserved.
 *
 */

#import <QuartzCore/QuartzCore.h>
#import "TBSprite.h"
#import "TBMacro.h"
#import "TBGameConst.h"


inline CGFloat TBAngleBetweenToPoints(CGPoint aPt1, CGPoint aPt2)
{
    float sResult = 0.0;
    float sDX, sDY;
    
    sDX     = aPt2.x - aPt1.x;
    sDY     = aPt2.y - aPt1.y;
    sResult = atan(sDY / sDX);
    
    if (sDX < 0)
    {
        sResult += M_PI;
    }
    
    return sResult;
}


inline CGFloat TBDistanceBetweenToPoints(CGPoint aPt1, CGPoint aPt2)
{
    CGFloat sDeltaX;
    CGFloat sDeltaY;
    CGFloat sDistance;

    sDeltaX   = aPt1.x - aPt2.x;
    sDeltaY   = aPt1.y - aPt2.y;
    sDistance = sqrt(sDeltaX * sDeltaX + sDeltaY * sDeltaY);
    
    return sDistance;
}


inline CGPoint TBMakeVector(CGFloat aAngle, CGFloat aSpeed)
{
    CGFloat sX = cos(aAngle) * aSpeed;
    CGFloat sY = sin(aAngle) * aSpeed;
    
    return CGPointMake(sX, sY);
}


#pragma mark -


@implementation TBSprite
{
    CGRect mFrame;
}


#pragma mark -


- (id)init
{
    self = [super init];

    if (self)
    {

    }
    
    return self;
}


#pragma mark -


- (CGRect)contentRect
{
    return mFrame;
}


- (void)setPoint:(CGPoint)aPoint
{
    [super setPoint:aPoint];
    
    CGSize sSize = [self tileSize];//[[self mesh] size];
    
    mFrame.origin.x    = aPoint.x - sSize.width  / 2;
    mFrame.origin.y    = aPoint.y - sSize.height / 2;
    mFrame.size.width  = sSize.width;
    mFrame.size.height = sSize.height;
}


- (BOOL)intersectWith:(TBSprite *)aSprite
{
    return CGRectIntersectsRect([self contentRect], [aSprite contentRect]);
}


- (BOOL)intersectWithGround
{
    CGPoint sPoint = [self point];
    CGSize  sSize  = [self tileSize];//[[self mesh] size];
    
    if ((sPoint.y - sSize.height) < kMapGround)
    {
        return YES;
    }
    
    return NO;
}


- (CGFloat)distanceWith:(TBSprite *)aSprite
{
    CGPoint sSpritePoint = [aSprite point];
    
    CGFloat sDeltaX = sSpritePoint.x - [self point].x;
    CGFloat sDeltaY = sSpritePoint.y - [self point].y;

    return sqrt(sDeltaX * sDeltaX + sDeltaY * sDeltaY);
}


- (CGFloat)angleWith:(TBSprite *)aSprite
{
    CGFloat sDegree;
    CGFloat sRadian;
    CGFloat sDX = [aSprite point].x - [self point].x;
    CGFloat sDY = [aSprite point].y - [self point].y;
    
    sRadian = atan2(sDX, sDY);
    sDegree = TBRadiansToDegrees(sRadian);
    
    return sDegree;
}


#pragma mark -


- (void)moveWithVector:(CGPoint)aVector
{
    CGPoint sPoint = [self point];
    
    sPoint.x += aVector.x;
    sPoint.y += aVector.y;
    
    [self setPoint:sPoint];
}


#pragma mark -


- (void)action
{

}


@end
