/*
 *  TBUnit.m
 *  Thunderbolt
 *
 *  Created by bearkode on 10. 1. 31..
 *  Copyright 2010 tinybean. All rights reserved.
 *
 */

#import "TBUnit.h"


@implementation TBUnit


@synthesize type       = mType;
@synthesize unitID     = mUnitID;
@synthesize team       = mTeam;
@synthesize durability = mDurability;
@synthesize damage     = mDamage;
@synthesize fuel       = mFuel;


#pragma mark -


- (id)initWithUnitID:(NSNumber *)aUnitID team:(TBTeam)aTeam
{
    self = [super init];
    
    if (self)
    {
        [self setUnitID:aUnitID];
        
        mTeam       = aTeam;
        mDurability = 100;
        mDamage     = 0;
        mFuel       = 8000;
    }
    
    return self;
}


- (void)dealloc
{
    [mUnitID release];
    
    [super dealloc];
}


- (void)action
{
    [super action];
    
    mFuel = (mFuel == 0) ? 0 : mFuel - 1;
}


#pragma mark -


- (BOOL)isKindOfUnit:(TBUnitType)aType
{
    return (mType == aType) ? YES : NO;
}


- (BOOL)isAlly
{
    return (mTeam == kTBTeamAlly) ? YES : NO;
}


- (void)addDamage:(NSInteger)aDamage
{
    mDamage += aDamage;
    if (mDamage > mDurability)
    {
        mDamage = mDurability;
    }
}


- (BOOL)isAvailable
{
    if (mDamage >= mDurability)
    {
        return NO;
    }
    
    return YES;
}


- (CGFloat)damageRate
{
    return 1.0 - ((CGFloat)mDamage / (CGFloat)mDurability);
}


@end
