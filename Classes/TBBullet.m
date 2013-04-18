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
}


@synthesize life   = mLife;


#pragma mark -


- (id)init
{
    self = [super initWithImageName:kTexBullet];
    
    if (self)
    {
        [[self mesh] setUsingMeshQueue:YES];
        
        mLife = 200;
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
    [super reset];
    
    mLife = 200;
}


- (void)action
{
    if (mLife > 0)
    {
        CGPoint sPoint  = [self point];
        CGPoint sVector = [self vector];
        
        sPoint.x += sVector.x;
        sPoint.y += sVector.y;
        
        [self setPoint:sPoint];

        if (sPoint.y < kMapGround)
        {
            mLife = 0;
            [self setAvailable:NO];
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
