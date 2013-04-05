/*
 *  GLSprite.h
 *  
 *
 *  Created by bearkode on 09. 11. 10.
 *  Copyright 2009 tinybean. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


CGFloat TBAngleBetweenToPoints(CGPoint aPt1, CGPoint aPt2);
CGFloat TBDistanceBetweenToPoints(CGPoint aPt1, CGPoint aPt2);
CGPoint TBVector(CGFloat aAngle, CGFloat aSpeed);


@interface TBSprite : NSObject
{
    id      mDelegate;
    GLuint  mTextureID;
    CGSize  mTextureSize;
    CGSize  mContentSize;
    GLfloat mVertices[12];
    
    CGFloat mAngle;
    CGPoint mPosition;
}

@property (nonatomic, assign) id      delegate;
@property (nonatomic, assign) GLuint  textureID;
@property (nonatomic, assign) CGSize  textureSize;
@property (nonatomic, assign) CGSize  contentSize;
@property (nonatomic, assign) CGFloat angle;
@property (nonatomic, assign) CGPoint position;

- (CGRect)contentRect;
- (BOOL)intersectWith:(TBSprite *)aSprite;
- (BOOL)intersectWithGround;
- (CGFloat)distanceWith:(TBSprite *)aSprite;
- (CGFloat)angleWith:(TBSprite *)aSprite;

- (void)action;
- (void)draw;

@end