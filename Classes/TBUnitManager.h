//
//  TBUnitManager.h
//  Thunderbolt
//
//  Created by jskim on 10. 3. 7..
//  Copyright 2010 tinybean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBGameConst.h"


@class TBUnit;
@class TBWarhead;
@class TBHelicopter;
@class TBTank;
@class TBArmoredVehicle;
@class TBSoldier;
@class TBMissile;


@interface TBUnitManager : NSObject
{
    NSInteger            mNextUnitID;
    
    TBUnit              *mAllyHelicopter;
    TBUnit              *mEnemyHelicopter;

    NSMutableDictionary *mAllyUnitDict;
    NSMutableDictionary *mEnemyUnitDict;
}

+ (TBUnitManager *)sharedManager;

- (NSNumber *)nextUnitID;
- (void)addUnit:(TBUnit *)aUnit;
- (TBUnit *)unitForUnitID:(NSNumber *)aUnitID;

- (NSArray *)allyUnits;
- (NSArray *)enemyUnits;

- (void)doActions;

- (TBUnit *)intersectedOpponentUnit:(TBWarhead *)aWarhead;
- (TBUnit *)opponentUnitOf:(TBUnit *)aUnit inRange:(CGFloat)aRange;

- (NSArray *)removeDisabledUnits;

- (TBHelicopter *)allyHelicopter;
- (TBHelicopter *)enemyHelicopter;
- (TBHelicopter *)opponentHeicopter:(TBTeam)aTeam;

+ (TBHelicopter *)helicopterWithTeam:(TBTeam)aTeam delegate:(id)aDelegate;
+ (TBTank *)tankWithTeam:(TBTeam)aTeam;
+ (TBArmoredVehicle *)armoredVehicleWithTeam:(TBTeam)aTeam;
+ (TBSoldier *)soldierWithTeam:(TBTeam)aTeam;
+ (TBMissile *)missileWithTeam:(TBTeam)aTeam position:(CGPoint)aPosition target:(TBUnit *)aTarget;

@end
