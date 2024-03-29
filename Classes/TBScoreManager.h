/*
 *  TBScoreManager.h
 *  Thunderbolt
 *
 *  Created by bearkode on 10. 5. 19..
 *  Copyright 2010 Tinybean. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


#define kTBScoreTank            100
#define kTBScoreArmoredVehicle  60


@class TBUnit;


@interface TBScoreManager : NSObject


@property (nonatomic, assign)   id         delegate;
@property (nonatomic, readonly) NSUInteger score;

+ (TBScoreManager *)sharedManager;

- (void)reset;
- (void)addScore:(NSUInteger)aScore;
- (void)addScoreForUnit:(TBUnit *)aUnit;

@end


@interface NSObject (TBScoreManagerDelegate)

- (void)scoreManager:(TBScoreManager *)aMoneyManager scoreDidChange:(NSUInteger)aScore;

@end