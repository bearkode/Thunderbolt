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


@class TBWeapon;
@class TBHelicopterInfo;


@interface TBHelicopter : TBUnit


@property (nonatomic, assign)                          id              delegate;

/*  Movement  */
@property (nonatomic, readonly)                        TBControlLever *controlLever;
@property (nonatomic, readonly, getter = isLeftAhead)  BOOL            leftAhead;
@property (nonatomic, readonly, getter = isLanded)     BOOL            landed;
@property (nonatomic, readonly)                        CGFloat         speed;

/*  Weapon  */
@property (nonatomic, assign)                          TBWeapon       *selectedWeapon;


#pragma mark -


- (id)initWithUnitID:(NSNumber *)aUnitID team:(TBTeam)aTeam info:(TBHelicopterInfo *)aInfo;


- (void)setEnableSound:(BOOL)aFlag;

- (CGPoint)pointWithSpeedLever:(CGFloat)aSpeedLever oldPoint:(CGPoint)aPoint;
- (CGPoint)pointWithAltitudeLever:(CGFloat)aAltitudeLever oldPoint:(CGPoint)aPoint;

- (void)repairDamage:(NSInteger)aValue;
- (void)fillUpAmmos;
- (NSInteger)bulletCount;
- (NSInteger)bombCount;

- (void)selectNextWeapon;
- (void)setFire:(BOOL)aFire;


- (void)spin;


@end


#pragma mark -


@protocol TBHelicopterDelegate <NSObject>


- (void)helicopterDamageDidChange:(TBHelicopter *)aHelicopter;
- (void)helicopterDidRepair:(TBHelicopter *)aHelicopter;
- (void)helicopterWeaponDidReload:(TBHelicopter *)aHelicopter;
- (void)helicopter:(TBHelicopter *)aHelicopter weaponDidFire:(NSInteger)aWeaponIndex;
- (void)helicopterDidDestroy:(TBHelicopter *)aHelicopter;


@end

