/*
 *  TBScoreManager.m
 *  Thunderbolt
 *
 *  Created by bearkode on 10. 5. 19..
 *  Copyright 2010 Tinybean. All rights reserved.
 *
 */

#import "TBScoreManager.h"
#import <PBObjCUtil.h>
#import "TBUnit.h"


@implementation TBScoreManager
{
    id         mDelegate;
    NSUInteger mScore;
}


@synthesize delegate = mDelegate;
@synthesize score    = mScore;


SYNTHESIZE_SINGLETON_CLASS(TBScoreManager, sharedManager)


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
