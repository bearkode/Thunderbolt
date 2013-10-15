/*
 *  TBUnit.m
 *  Thunderbolt
 *
 *  Created by bearkode on 10. 1. 31..
 *  Copyright 2010 tinybean. All rights reserved.
 *
 */

#import "TBUnit.h"
#import "TBExplosionManager.h"


@implementation TBUnit
{
    TBUnitType mType;
    NSNumber  *mUnitID;
    TBTeam     mTeam;
    NSInteger  mDurability;
    NSInteger  mDamage;
    BOOL       mAvailable;
}


#pragma mark -


@synthesize type       = mType;
@synthesize unitID     = mUnitID;
@synthesize team       = mTeam;
@synthesize durability = mDurability;
@synthesize damage     = mDamage;
@synthesize available  = mAvailable;


#pragma mark -


- (id)initWithUnitID:(NSNumber *)aUnitID team:(TBTeam)aTeam
{
    self = [super init];
    
    if (self)
    {
        [self setUnitID:aUnitID];
//        [[self mesh] setMeshRenderOption:kPBMeshRenderOptionUsingMeshQueue];
        
        mTeam       = aTeam;
        mDurability = 100;
        mDamage     = 0;
        mAvailable  = YES;
    }
    
    return self;
}


- (void)dealloc
{
    [mUnitID release];
    
    [super dealloc];
}


#pragma mark -


- (void)action
{
    [super action];
    
    if ([self isAvailable])
    {
        if (([self point].x > (kMaxMapXPos + 50)) ||
            ([self point].x < (kMinMapXPos -50)))
        {
            mAvailable = NO;
        }
    }
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


- (TBTeam)opponentTeam
{
    return (mTeam == kTBTeamAlly) ? kTBTeamEnemy : kTBTeamAlly;
}


- (void)addDamage:(NSInteger)aDamage
{
    mDamage += aDamage;
    if (mDamage > mDurability)
    {
        mDamage    = mDurability;
        mAvailable = NO;
        
        [[TBExplosionManager sharedManager] addExplosionWithUnit:self];
    }
}


- (void)repair:(NSInteger)aValue
{
    if (mDamage)
    {
        mDamage -= aValue;
        mDamage = (mDamage < 0) ? 0 : mDamage;
    }
}


- (CGFloat)damageRate
{
    return 1.0 - ((CGFloat)mDamage / (CGFloat)mDurability);
}


@end
