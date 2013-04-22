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
    
    [self setLife:200];
    [self setPower:kTankShellPower];    
}


- (void)action
{
    if ([self life] > 0)
    {
        CGPoint sVector = [self vector];
        CGPoint sPoint  = [self point];
        
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
