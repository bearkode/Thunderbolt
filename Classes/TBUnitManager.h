/*
 *  TBUnitManager.h
 *  Thunderbolt
 *
 *  Created by bearkode on 10. 3. 7..
 *  Copyright 2010 tinybean. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import <PBKit.h>
#import <PBObjCUtil.h>
#import "TBGameConst.h"


@class TBUnit;
@class TBWarhead;
@class TBHelicopter;
@class TBTank;
@class TBArmoredVehicle;
@class TBRifleman;
@class TBMissile;

@class TBHelicopterInfo;


@interface TBUnitManager : NSObject


+ (TBUnitManager *)sharedManager;

/*  Config  */
- (void)reset;
- (void)setUnitLayer:(PBNode *)aUnitLayer;

/*  Actions  */
- (void)doActions;

/*  Access Units  */
- (NSArray *)allUnits;
- (NSArray *)allyUnits;
- (NSArray *)enemyUnits;
- (TBUnit *)unitForUnitID:(NSNumber *)aUnitID;
- (TBUnit *)intersectedOpponentUnit:(TBWarhead *)aWarhead;
- (TBUnit *)opponentUnitOf:(TBUnit *)aUnit inRange:(CGFloat)aRange;

/*  Helicopter  */
- (void)setHelicopterInfo:(TBHelicopterInfo *)aHelicopterInfo;
- (TBHelicopter *)allyHelicopter;
- (TBHelicopter *)enemyHelicopter;
- (TBHelicopter *)opponentHeicopter:(TBTeam)aTeam;

/*  Add New Unit  */
- (TBHelicopter *)addHelicopterWithTeam:(TBTeam)aTeam delegate:(id)aDelegate;
- (TBTank *)addTankWithTeam:(TBTeam)aTeam;
- (TBArmoredVehicle *)addArmoredVehicleWithTeam:(TBTeam)aTeam;
- (TBRifleman *)addRiflemanWithTeam:(TBTeam)aTeam;
- (TBMissile *)addMissileWithTeam:(TBTeam)aTeam position:(CGPoint)aPosition target:(TBUnit *)aTarget;


@end
