/*
 *  TBMoneyManager.h
 *  Thunderbolt
 *
 *  Created by bearkode on 10. 5. 18..
 *  Copyright 2010 Tinybean. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


#define kTBPriceHelicopter          600
#define kTBPriceTank                100
#define kTBPriceRepair              10
#define kTBPriceBullet              5
#define kTBPriceBomb                1


#define kTBCashPrizeTank            50
#define kTBCashPrizeArmoredVehicle  30
#define kTBCashPrizeSoldier         10


@class TBUnit;


@interface TBMoneyManager : NSObject


@property (nonatomic, assign) id delegate;


+ (TBMoneyManager *)sharedManager;
+ (BOOL)useMoney:(NSUInteger)aValue;

- (void)setBalance:(NSUInteger)aValue;
- (NSUInteger)balance;

- (void)saveMoney:(NSUInteger)aValue;
- (void)saveMoneyForUnit:(TBUnit *)aUnit;
- (BOOL)useMoney:(NSUInteger)aValue;


@end


#pragma mark -


@protocol TBMoneyManagerDelegate <NSObject>


- (void)moneyManager:(TBMoneyManager *)aMoneyManager balanceDidChange:(NSUInteger)aBalance;


@end