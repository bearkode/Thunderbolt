//
//  TBStructure.m
//  Thunderbolt
//
//  Created by jskim on 10. 3. 5..
//  Copyright 2010 tinybean. All rights reserved.
//

#import "TBStructure.h"


@implementation TBStructure


@synthesize team        = mTeam;
@synthesize durability  = mDurability;
@synthesize damage      = mDamage;
@synthesize isDestroyed = mIsDestroyed;


#pragma mark -


- (id)initWithTeam:(TBTeam)aTeam
{
    self = [super init];
    if (self)
    {
        mTeam        = aTeam;
        mDurability  = 0;
        mDamage      = 0;
        mIsDestroyed = NO;
    }
    
    return self;
}


- (void)dealloc
{
    [super dealloc];
}


#pragma mark -


- (void)addDamage:(NSUInteger)aDamage
{
    if (!mIsDestroyed)
    {
        mDamage += aDamage;    
        if (mDurability <= mDamage)
        {
            mIsDestroyed = YES;
        }
    }
}


@end
