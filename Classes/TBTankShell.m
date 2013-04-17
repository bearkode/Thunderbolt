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
    CGPoint   mVector;
}


@synthesize life   = mLife;
@synthesize vector = mVector;


#pragma mark -


- (id)init
{
    self = [super init];
    
    if (self)
    {
        PBTexture *sTexture = [PBTextureManager textureWithImageName:kTexBullet];
        [sTexture loadIfNeeded];
        [self setTexture:sTexture];

        [self reset];
        [self setDestructivePower:kTankShellPower];
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
