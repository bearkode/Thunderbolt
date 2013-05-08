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
    NSUInteger mBalance;
}


@synthesize delegate = mDelegate;


SYNTHESIZE_SINGLETON_CLASS(TBMoneyManager, sharedManager);


+ (BOOL)useMoney:(NSUInteger)aValue
{
    return [[TBMoneyManager sharedManager] useMoney:aValue];
}


#pragma mark -


- (id)init
{
    self = [super init];
    if (self)
    {

    }
    
    return self;
}


#pragma mark -


- (void)setBalance:(NSUInteger)aValue
{
    mBalance = aValue;
    [mDelegate moneyManager:self balanceDidChange:mBalance];
}


- (NSUInteger)balance
{
    return mBalance;
}


#pragma mark -


- (void)saveMoney:(NSUInteger)aValue
{
    mBalance += aValue;
    [mDelegate moneyManager:self balanceDidChange:mBalance];
}


- (void)saveMoneyForUnit:(TBUnit *)aUnit
{
    if ([aUnit isKindOfUnit:kTBUnitTank])
    {
        mBalance += kTBCashPrizeTank;
    }
    else if ([aUnit isKindOfUnit:kTBUnitArmoredVehicle])
    {
        mBalance += kTBCashPrizeArmoredVehicle;
    }
    else if ([aUnit isKindOfUnit:kTBUnitSoldier])
    {
        mBalance += kTBCashPrizeSoldier;
    }
    
    [mDelegate moneyManager:self balanceDidChange:mBalance];
}


- (BOOL)useMoney:(NSUInteger)aValue
{
    if (mBalance > aValue)
    {
        mBalance -= aValue;
        [mDelegate moneyManager:self balanceDidChange:mBalance];
        return YES;
    }
    
    return NO;
}


@end
