/*
 *  TBSprite.h
 *  Thunderbolt
 *
 *  Created by bearkode on 09. 11. 10.
 *  Copyright 2009 tinybean. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import <PBKit.h>


CGFloat TBAngleBetweenToPoints(CGPoint aPt1, CGPoint aPt2);
CGFloat TBDistanceBetweenToPoints(CGPoint aPt1, CGPoint aPt2);
CGPoint TBVector(CGFloat aAngle, CGFloat aSpeed);


@interface TBSprite : PBSprite
{
    id mDelegate;
}


@property (nonatomic, assign) id      delegate;


- (CGRect)contentRect;
- (BOOL)intersectWith:(TBSprite *)aSprite;
- (BOOL)intersectWithGround;
- (CGFloat)distanceWith:(TBSprite *)aSprite;
- (CGFloat)angleWith:(TBSprite *)aSprite;

- (void)action;


@end