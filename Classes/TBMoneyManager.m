//
//  TBMoneyManager.m
//  Thunderbolt
//
//  Created by jskim on 10. 5. 18..
//  Copyright 2010 Tinybean. All rights reserved.
//

#import "TBMoneyManager.h"
#import "TBUnit.h"


static TBMoneyManager *gMoneyManager = nil;


@implementation TBMoneyManager


@synthesize delegate = mDelegate;


#pragma mark -
#pragma mark for Singleton


+ (id)allocWithZone:(NSZone *)aZone
{
    @synchronized(self)
    {
        if (!gMoneyManager)
        {
            gMoneyManager = [super allocWithZone:aZone];
            return gMoneyManager;
        }
    }
    
    return nil;
}


- (id)copyWithZone:(NSZone *)aZone
{
    return self;
}


- (id)retain
{
    return self;
}


- (unsigned)retainCount
{
    return UINT_MAX;
}

- (oneway void)release
{
}


- (id)autorelease
{
    return self;
}


#pragma mark -


+ (TBMoneyManager *)sharedManager
{
    @synchronized(self)
    {
        if (!gMoneyManager)
        {
            gMoneyManager = [[self alloc] init];
        }
    }
    
    return gMoneyManager;
}


+ (void)useMoney:(NSUInteger)aValue
{
    [[TBMoneyManager sharedManager] useMoney:aValue];
}


#pragma mark -


- (id)init
{
    self = [super init];
    if (self)
    {
        mSum = 1800;
    }
    
    return self;
}


#pragma mark -


- (void)saveMoney:(NSUInteger)aValue
{
    mSum += aValue;
    [mDelegate moneyManager:self sumDidChange:mSum];
}


- (void)saveMoneyForUnit:(TBUnit *)aUnit
{
    if ([aUnit isKindOfUnit:kTBUnitTank])
    {
        mSum += kTBCashPrizeTank;
    }
    else if ([aUnit isKindOfUnit:kTBUnitArmoredVehicle])
    {
        mSum += kTBCashPrizeArmoredVehicle;
    }
    else if ([aUnit isKindOfUnit:kTBUnitSoldier])
    {
        mSum += kTBCashPrizeSoldier;
    }
    
    [mDelegate moneyManager:self sumDidChange:mSum];    
}


- (void)useMoney:(NSUInteger)aValue
{
    mSum -= aValue;
    [mDelegate moneyManager:self sumDidChange:mSum];
}


- (NSUInteger)sum
{
    return mSum;
}


@end
