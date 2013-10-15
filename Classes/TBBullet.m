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


#pragma mark -


- (id)init
{
    self = [super initWithImageNamed:kTexBullet];
    
    if (self)
    {
        [self setTileSize:[self textureSize]];
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

    [self setLife:200];
}


- (void)action
{
    if ([self life] > 0)
    {
        CGPoint sPoint  = [self point];
        CGPoint sVector = [self vector];
        
        sPoint.x += sVector.x;
        sPoint.y += sVector.y;
        
        [self setPoint:sPoint];

        if (sPoint.y < kMapGround)
        {
            [self setLife:0];
            [self setAvailable:NO];
        }
        else
        {
            [self decreaseLife];
        }
    }
    else
    {
        [self setAvailable:NO];
    }
}


@end
