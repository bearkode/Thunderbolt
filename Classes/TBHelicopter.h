/*
 *  TBHelicopter.h
 *  Thunderbolt
 *
 *  Created by bearkode on 10. 1. 24..
 *  Copyright 2010 tinybean. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import "TBUnit.h"
#import "TBControlLever.h"


typedef enum
{
    kWeaponVulcan   = 0,
    kWeaponBomb,
    kWeaponMissile,
} TBWeaponType;


@interface TBHelicopter : TBUnit


@property (nonatomic, readonly) TBControlLever *controlLever;
@property (nonatomic, assign)   TBWeaponType    selectedWeapon;
@property (nonatomic, assign)   NSInteger       bulletCount;
@property (nonatomic, assign)   NSInteger       bombCount;
@property (nonatomic, assign)   NSInteger       missileCount;
@property (nonatomic, assign)   BOOL            isBombDrop;
@property (nonatomic, assign)   BOOL            isMissileLaunch;


- (void)setSpeedLever:(CGFloat)aSpeedLever;
- (void)setAltitudeLever:(CGFloat)aAltitudeLever;
- (void)setFireVulcan:(BOOL)aFlag;

- (void)repairDamage:(NSInteger)aValue;
- (void)fillUpBullets:(NSInteger)aCount;
- (void)fillUpBombs:(NSInteger)aCount;

- (BOOL)isVulcanFiring;
- (void)dropBomb;

- (BOOL)isLeftAhead;
- (BOOL)isLanded;


@end


@interface NSObject (TBHelicopterProtocol)


- (void)helicopterDamageChanged:(TBHelicopter *)aHelicopter;
- (void)helicopterWeaponDidReload:(TBHelicopter *)aHelicopter;
- (void)helicopter:(TBHelicopter *)aHelicopter weaponFired:(NSInteger)aWeaponIndex;
- (void)helicopterDidDestroy:(TBHelicopter *)aHelicopter;


@end

