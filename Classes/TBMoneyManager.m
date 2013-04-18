/*
 *  TBMoneyManager.m
 *  Thunderbolt
 *
 *  Created by bearkode on 10. 5. 18..
 *  Copyright 2010 Tinybean. All rights reserved.
 *
 */

#import "TBMoneyManager.h"
#import <PBObjCUtil.h>
#import "TBUnit.h"


@implementation TBMoneyManager
{
    id         mDelegate;
    NSUInteger mSum;
}


@synthesize delegate = mDelegate;


SYNTHESIZE_SINGLETON_CLASS(TBMoneyManager, sharedManager);


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


- (void)setMoney:(NSUInteger)aValue
{
    mSum = aValue;
    [mDelegate moneyManager:self sumDidChange:mSum];
}


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
