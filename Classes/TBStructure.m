/*
 *  TBStructure.m
 *  Thunderbolt
 *
 *  Created by bearkode on 10. 3. 5..
 *  Copyright 2010 tinybean. All rights reserved.
 *
 */

#import "TBStructure.h"


@implementation TBStructure
{
    TBTeam    mTeam;
    NSInteger mDurability;
    NSInteger mDamage;
    BOOL      mDestroyed;
    id        mDelegate;
}


@synthesize team       = mTeam;
@synthesize durability = mDurability;
@synthesize damage     = mDamage;
@synthesize destroyed  = mDestroyed;
@synthesize delegate   = mDelegate;


#pragma mark -


- (id)initWithTeam:(TBTeam)aTeam
{
    self = [super init];
    
    if (self)
    {
        mTeam       = aTeam;
        mDurability = 0;
        mDamage     = 0;
        mDestroyed  = NO;
        mDelegate   = nil;
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
    if (!mDestroyed)
    {
        mDamage += aDamage;
        
        if (mDamage >= mDurability)
        {
            mDestroyed = YES;
            if ([mDelegate respondsToSelector:@selector(structureDidDestroyed:)])
            {
                [mDelegate structureDidDestroyed:self];
            }
        }
    }
}


@end
