//
//  TBScoreManager.m
//  Thunderbolt
//
//  Created by jskim on 10. 5. 19..
//  Copyright 2010 Tinybean. All rights reserved.
//

#import "TBScoreManager.h"
#import "TBUnit.h"


static TBScoreManager *gScoreManager = nil;


@implementation TBScoreManager


@synthesize delegate = mDelegate;
@synthesize score    = mScore;


#pragma mark -
#pragma mark for Singleton


+ (id)allocWithZone:(NSZone *)aZone
{
    @synchronized(self)
    {
        if (!gScoreManager)
        {
            gScoreManager = [super allocWithZone:aZone];
            return gScoreManager;
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


+ (TBScoreManager *)sharedManager
{
    @synchronized(self)
    {
        if (!gScoreManager)
        {
            gScoreManager = [[self alloc] init];
        }
    }
    
    return gScoreManager;
}


#pragma mark -


- (id)init
{
    self = [super init];
    if (self)
    {
        mScore = 0;
    }
    
    return self;
}


#pragma mark -


- (void)addScore:(NSUInteger)aScore
{
    mScore += aScore;
    [mDelegate scoreManager:self scoreDidChange:mScore];
}


- (void)addScoreForUnit:(TBUnit *)aUnit
{
    if ([aUnit isKindOfUnit:kTBUnitTank])
    {
        [self addScore:kTBScoreTank];
    }
    else if ([aUnit isKindOfUnit:kTBUnitArmoredVehicle])
    {
        [self addScore:kTBScoreArmoredVehicle];
    }
}


@end
