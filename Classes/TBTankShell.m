//
//  TBTankShell.m
//  Thunderbolt
//
//  Created by jskim on 10. 5. 16..
//  Copyright 2010 Tinybean. All rights reserved.
//

#import "TBTankShell.h"
#import "TBGameConst.h"
#import "TBTextureManager.h"
#import "TBTextureNames.h"


@implementation TBTankShell


@synthesize life   = mLife;
@synthesize vector = mVector;


#pragma mark -


- (id)init
{
    TBTextureInfo *sInfo;
    
    self = [super init];
    if (self)
    {
        sInfo = [TBTextureManager textureInfoForKey:kTexBullet];
        
        [self setTextureID:[sInfo textureID]];
        [self setTextureSize:[sInfo textureSize]];
        [self setContentSize:[sInfo contentSize]];
        [self setDestructivePower:kTankShellPower];
        
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
    if (mLife > 0)
    {
        mPosition.x += mVector.x;
        mPosition.y += mVector.y;
        
        if (mPosition.y < MAP_GROUND)
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
