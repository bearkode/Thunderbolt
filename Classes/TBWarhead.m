//
//  TBWarhead.m
//  Thunderbolt
//
//  Created by jskim on 10. 2. 3..
//  Copyright 2010 tinybean. All rights reserved.
//

#import "TBWarhead.h"


@implementation TBWarhead


@synthesize team             = mTeam;
@synthesize destructivePower = mDestructivePower;


#pragma mark -


- (id)init
{
    self = [super init];
    
    if (self)
    {
        mIsAvailable      = YES;
        mDestructivePower = 0;
    }
    
    return self;
}


#pragma mark -


- (BOOL)isAlly
{
    return (mTeam == kTBTeamAlly) ? YES : NO;
}


- (BOOL)isAvailable
{
    return mIsAvailable;
}


- (void)setAvailable:(BOOL)aFlag
{
    mIsAvailable = aFlag;
}



@end
