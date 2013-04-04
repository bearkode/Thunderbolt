//
//  TBHelicopter.h
//  Thunderbolt
//
//  Created by jskim on 10. 1. 24..
//  Copyright 2010 tinybean. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBUnit.h"


typedef enum
{
    kWeaponVulcan   = 0,
    kWeaponBomb,
    kWeaponMissile,
} TBWeaponType;


@interface TBHelicopter : TBUnit
{
    NSInteger       mTick;
    
    BOOL            mIsLeftAhead;
    BOOL            mIsLanded;
    CGFloat         mSpeed;
    NSInteger       mTextureIndex;
    
    NSMutableArray *mTextureArray;
    NSMutableArray *mContentRectArray;
    
    TBWeaponType    mSelectedWeapon;
    NSInteger       mVulcanDelay;
    NSInteger       mBulletCount;
    NSInteger       mBombCount;
    NSInteger       mMissileCount;
    BOOL            mIsVulcanFire;
    BOOL            mIsBombDrop;
    BOOL            mIsMissileLaunch;
}

@property (nonatomic, assign) TBWeaponType selectedWeapon;
@property (nonatomic, assign) NSInteger    bulletCount;
@property (nonatomic, assign) NSInteger    bombCount;
@property (nonatomic, assign) NSInteger    missileCount;
@property (nonatomic, assign) BOOL         isBombDrop;
@property (nonatomic, assign) BOOL         isMissileLaunch;

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

