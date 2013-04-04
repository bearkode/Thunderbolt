//
//  TBMoneyManager.h
//  Thunderbolt
//
//  Created by jskim on 10. 5. 18..
//  Copyright 2010 Tinybean. All rights reserved.
//

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
{
    id         mDelegate;
    NSUInteger mSum;
}


@property (nonatomic, assign) id delegate;


+ (TBMoneyManager *)sharedManager;
+ (void)useMoney:(NSUInteger)aValue;

- (void)saveMoney:(NSUInteger)aValue;
- (void)saveMoneyForUnit:(TBUnit *)aUnit;
- (void)useMoney:(NSUInteger)aValue;
- (NSUInteger)sum;

@end


@interface NSObject (TBMoneyManagerDelegate)

- (void)moneyManager:(TBMoneyManager *)aMoneyManager sumDidChange:(NSUInteger)aSum;

@end