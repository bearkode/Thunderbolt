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
#import "TBMacro.h"


@implementation TBTankShell


- (id)init
{
    self = [super initWithImageNamed:kTexBullet];
    
    if (self)
    {
        [self setTileSize:[self textureSize]];
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


- (void)setVector:(CGPoint)aVector
{
    [super setVector:aVector];
    
    CGFloat sAngle = 90 - TBRadiansToDegrees(TBAngleBetweenToPoints(CGPointMake(0, 0), aVector));
    
    [self setAngle:PBVertex3Make(0, 0, sAngle)];
}


@end
