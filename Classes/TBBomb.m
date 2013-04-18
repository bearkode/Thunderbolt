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


- (id)init
{
    self = [super initWithImageName:kTexBomb];
    
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


- (void)action
{
    CGPoint sVector = [self vector];
    
    if (sVector.x == 0)
    {
    
    }
    else if (sVector.x < 0)
    {
        sVector.x += 1.0;
    }
    else if (sVector.x > 0)
    {
        sVector.x -= 1.0;
    }
    
    sVector.y += 0.4;
    [self setVector:sVector];
    
    CGPoint sPoint = [self point];
    
    sPoint.x += sVector.x;
    sPoint.y -= sVector.y;
    
    [self setPoint:sPoint];
}


#pragma mark -


- (void)reset
{
    [super reset];
    
    [self setPower:kBombPower];
}


- (void)setSpeed:(CGFloat)aSpeed
{
    CGPoint sVector = [self vector];

    sVector.x = aSpeed;
    
    [self setVector:sVector];
}


@end
