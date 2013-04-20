/*
 *  TBUserStatusManager.m
 *  Thunderbolt
 *
 *  Created by cgkim on 13. 4. 19..
 *  Copyright (c) 2013 Tinybean. All rights reserved.
 *
 */

#import "TBUserStatusManager.h"
#import "TBMoneyManager.h"
#import <PBObjCUtil.h>


const NSUInteger kMinMoney = 5000;


NSString *const kLastPlayDateKey = @"TBLastPlayDate";
NSString *const kMoneyKey        = @"TBMoney";


@implementation TBUserStatusManager
{

}


SYNTHESIZE_SHARED_INSTANCE(TBUserStatusManager, sharedManager)


+ (void)initialize
{
    NSUserDefaults      *sUserDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *sAppDefaults  = [NSMutableDictionary dictionary];
                                      
    [sAppDefaults setObject:[NSDate dateWithTimeIntervalSince1970:0] forKey:kLastPlayDateKey];
    [sAppDefaults setObject:[NSNumber numberWithInteger:kMinMoney] forKey:kMoneyKey];

    [sUserDefaults registerDefaults:sAppDefaults];
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


- (void)saveStatus
{
    NSUInteger      sMoney        = [[TBMoneyManager sharedManager] balance];
    NSUserDefaults *sUserDefaults = [NSUserDefaults standardUserDefaults];

    [sUserDefaults setObject:[NSDate date] forKey:kLastPlayDateKey];
    [sUserDefaults setInteger:sMoney forKey:kMoneyKey];
    [sUserDefaults synchronize];
}


- (void)loadStatus
{
    NSUserDefaults *sUserDefaults = [NSUserDefaults standardUserDefaults];
    NSDate         *sLastPlayDate = [[sUserDefaults objectForKey:kLastPlayDateKey] retain];
    NSUInteger      sMoney        = [[sUserDefaults objectForKey:kMoneyKey] integerValue];
    
    NSLog(@"sLastPlayDate = %@", sLastPlayDate);
    NSLog(@"sMoney = %d", sMoney);
    
    sMoney = (sMoney < kMinMoney) ? kMinMoney : sMoney;
    
    [[TBMoneyManager sharedManager] setBalance:sMoney];
}


@end
