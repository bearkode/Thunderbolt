/*
 *  TBTankShell.m
 *  Thunderbolt
 *
 *  Created by bearkode on 10. 5. 16..
 *  Copyright 2010 Tinybean. All rights reserved.
 *
 */

#import "TBTankShell.h"
#import "TBGameConst.h"
#import "TBTextureNames.h"


@implementation TBTankShell
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
        [self reset];
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
    [self setPower:kTankShellPower];    
}


- (void)action
{
    if (mLife > 0)
    {
        CGPoint sVector = [self vector];
        CGPoint sPoint  = [self point];
        
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
