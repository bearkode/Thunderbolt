/*
 *  TBBullet.m
 *  Thunderbolt
 *
 *  Created by bearkode on 10. 1. 30..
 *  Copyright 2010 tinybean. All rights reserved.
 *
 */

#import "TBBullet.h"
#import "TBGameConst.h"
#import "TBTextureNames.h"


@implementation TBBullet


@synthesize life   = mLife;
@synthesize vector = mVector;


#pragma mark -


- (id)initWithDestructivePower:(NSUInteger)aDestructivePower
{
    self = [super initWithImageName:kTexBullet];
    
    if (self)
    {
        [self setDestructivePower:aDestructivePower];
        
        mLife   = 100;
        mVector = CGPointZero;
    }
    
    return self;
}


- (void)dealloc
{
    [super dealloc];
}


- (void)reset
{
    [self setAvailable:YES];
    mLife   = 100;
    mVector = CGPointZero;
}


- (void)action
{
    CGPoint sPoint = [self point];
    
    if (mLife > 0)
    {
        sPoint.x += mVector.x;
        sPoint.y += mVector.y;
        [self setPoint:sPoint];
        
        if (sPoint.y < MAP_GROUND)
        {
            mLife = 0;
        }
        else
        {
            mLife--;
        }
    }
    else
    {
        mIsAvailable = NO;
    }
}


@end
