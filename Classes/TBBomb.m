/*
 *  TBBomb.m
 *  Thunderbolt
 *
 *  Created by bearkode on 10. 2. 3..
 *  Copyright 2010 tinybean. All rights reserved.
 *
 */

#import "TBBomb.h"
#import "TBTextureNames.h"


@implementation TBBomb
{
    CGPoint mVector;
}


@synthesize vector = mVector;


#pragma mark -


- (id)init
{
    self = [super init];
    
    if (self)
    {
        PBTexture *sTexture = [PBTextureManager textureWithImageName:kTexBomb];
        [sTexture loadIfNeeded];

        [self setTexture:sTexture];
        [self setDestructivePower:kBombPower];
    
        mVector = CGPointZero;
    }
    
    return self;
}


- (void)dealloc
{
    [super dealloc];
}


- (void)action
{
    if (mVector.x == 0)
    {
    
    }
    else if (mVector.x < 0)
    {
        mVector.x += 1.0;
    }
    else if (mVector.x > 0)
    {
        mVector.x -= 1.0;
    }
    
    mVector.y += 0.4;
    
    CGPoint sPoint = [self point];
    
    sPoint.x += mVector.x;
    sPoint.y -= mVector.y;
    
    [self setPoint:sPoint];
}


#pragma mark -


- (void)setSpeed:(CGFloat)aSpeed
{
    mVector.x = (NSInteger)aSpeed;
}


@end
