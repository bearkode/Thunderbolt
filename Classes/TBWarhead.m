/*
 *  TBWarhead.m
 *  Thunderbolt
 *
 *  Created by bearkode on 10. 2. 3..
 *  Copyright 2010 tinybean. All rights reserved.
 *
 */

#import "TBWarhead.h"
#import "TBObjectPool.h"


@implementation TBWarhead
{
    TBTeam        mTeam;
    NSInteger     mPower;
    NSInteger     mLife;
    BOOL          mAvailable;
    CGPoint       mVector;
    TBObjectPool *mObjectPool;
}


@synthesize team       = mTeam;
@synthesize power      = mPower;
@synthesize life       = mLife;
@synthesize available  = mAvailable;
@synthesize vector     = mVector;
@synthesize objectPool = mObjectPool;


#pragma mark -


- (id)init
{
    self = [super init];
    
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
    mTeam      = kTBTeamUnknown;
    mPower     = 0;
    mLife      = 0;
    mAvailable = YES;
    mVector    = CGPointZero;
}


- (void)decreaseLife
{
    if (mLife > 0)
    {
        mLife--;
    }
    else
    {
        mAvailable = NO;
    }
}


- (BOOL)isAlly
{
    return (mTeam == kTBTeamAlly) ? YES : NO;
}


@end
