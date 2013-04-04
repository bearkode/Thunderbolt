//
//  TBBomb.m
//  Thunderbolt
//
//  Created by jskim on 10. 2. 3..
//  Copyright 2010 tinybean. All rights reserved.
//

#import "TBBomb.h"
#import "TBTextureNames.h"
#import "TBTextureManager.h"


@implementation TBBomb


@synthesize vector = mVector;


#pragma mark -


- (id)init
{
    TBTextureInfo *sInfo;
    
    self = [super init];
    
    if (self)
    {
        sInfo = [TBTextureManager textureInfoForKey:kTexBomb];
        
        [self setTextureID:[sInfo textureID]];
        [self setTextureSize:[sInfo textureSize]];
        [self setContentSize:[sInfo contentSize]];
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
    
    mPosition.x += mVector.x;
    mPosition.y -= mVector.y;
}


#pragma mark -


- (void)setSpeed:(CGFloat)aSpeed
{
    mVector.x = (NSInteger)aSpeed;
}


@end
