/*
 *  TBWarhead.m
 *  Thunderbolt
 *
 *  Created by bearkode on 10. 2. 3..
 *  Copyright 2010 tinybean. All rights reserved.
 *
 */

#import "TBWarhead.h"


@implementation TBWarhead
{
    TBTeam    mTeam;
    BOOL      mAvailable;
    NSInteger mPower;
    CGPoint   mVector;    
}


@synthesize team      = mTeam;
@synthesize power     = mPower;
@synthesize available = mAvailable;
@synthesize vector    = mVector;


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
    mAvailable = YES;
    mPower     = 0;
    mVector    = CGPointZero;
}


- (BOOL)isAlly
{
    return (mTeam == kTBTeamAlly) ? YES : NO;
}


@end
