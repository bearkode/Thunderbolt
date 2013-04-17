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
{
    NSInteger mLife;
    CGPoint   mVector;
}


@synthesize life   = mLife;
@synthesize vector = mVector;


#pragma mark -


- (id)init
{
    self = [super initWithImageName:kTexBullet];
    
    if (self)
    {
        [[self mesh] setUsingMeshQueue:YES];
        
        mLife   = 200;
        mVector = CGPointZero;
    }
    
    return self;
}


- (void)dealloc
{
    [super dealloc];
}


#pragma mark -


- (void)reset
{
    [self setAvailable:YES];
    mLife   = 200;
    mVector = CGPointZero;
}


- (void)action
{
    if (mLife > 0)
    {
        CGPoint sPoint = [self point];
        sPoint.x += mVector.x;
        sPoint.y += mVector.y;
        [self setPoint:sPoint];
        
        if (sPoint.y < kMapGround)
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
        [self setAvailable:NO];
    }
}


@end
