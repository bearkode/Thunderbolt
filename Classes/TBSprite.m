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


CGFloat TBAngleBetweenToPoints(CGPoint aPt1, CGPoint aPt2)
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


CGFloat TBDistanceBetweenToPoints(CGPoint aPt1, CGPoint aPt2)
{
    CGFloat sDeltaX;
    CGFloat sDeltaY;
    CGFloat sDistance;

    sDeltaX   = aPt1.x - aPt2.x;
    sDeltaY   = aPt1.y - aPt2.y;
    sDistance = sqrt(sDeltaX * sDeltaX + sDeltaY * sDeltaY);
    
    return sDistance;
}


CGPoint TBVector(CGFloat aAngle, CGFloat aSpeed)
{
    CGFloat sX = cos(aAngle) * aSpeed;
    CGFloat sY = sin(aAngle) * aSpeed;
    
    return CGPointMake(sX, sY);
}


@implementation TBSprite


@synthesize delegate        = mDelegate;
//@synthesize textureID       = mTextureID;
//@dynamic    textureSize;
//@synthesize contentSize     = mContentSize;
//@synthesize angle           = mAngle;
//@synthesize position        = mPosition;


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
    CGRect  sResult = CGRectZero;
    CGPoint sPoint  = [self point];
    CGSize  sSize   = [[self mesh] size];
    
    sResult.origin.x    = sPoint.x - sSize.width  / 2;
    sResult.origin.y    = sPoint.y - sSize.height / 2;
    sResult.size.width  = sSize.width;
    sResult.size.height = sSize.height;
    
    return sResult;
}


- (BOOL)intersectWith:(TBSprite *)aSprite
{
    return CGRectIntersectsRect([self contentRect], [aSprite contentRect]);
}


- (BOOL)intersectWithGround
{
    CGPoint sPoint = [self point];
    CGSize  sSize  = [[self mesh] size];
    
    if ((sPoint.y - sSize.height) < MAP_GROUND)
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


- (void)action
{

}


//- (void)draw
//{
//    glPushMatrix();
//    glEnable(GL_BLEND);
//    glBindTexture(GL_TEXTURE_2D, mTextureID);
//    glTranslatef(mPosition.x, mPosition.y, 0.0f);
//    glRotatef(mAngle, 0.0, 0.0, 1.0);
//    glVertexPointer(3, GL_FLOAT, 0, mVertices);
//    glEnableClientState(GL_VERTEX_ARRAY);
//    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
//    glPopMatrix();
//}


#pragma mark -


//- (void)setTextureSize:(CGSize)aSize
//{
//    mTextureSize = aSize;
//
//    mVertices[0]  = -mTextureSize.width / 2;
//    mVertices[1]  = -mTextureSize.height / 2;
//    mVertices[2]  = 0;
//    mVertices[3]  = mTextureSize.width / 2;
//    mVertices[4]  = -mTextureSize.height / 2;
//    mVertices[5]  = 0;
//    mVertices[6]  = -mTextureSize.width / 2;
//    mVertices[7]  = mTextureSize.height / 2;
//    mVertices[8]  = 0;
//    mVertices[9]  = mTextureSize.width / 2;
//    mVertices[10] = mTextureSize.height / 2;
//    mVertices[11] = 0;
//}
//
//
//- (CGSize)textureSize
//{
//    return mTextureSize;
//}


@end
