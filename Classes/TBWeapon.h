/*
 *  TBWeapon.h
 *  Thunderbolt
 *
 *  Created by bearkode on 10. 5. 14..
 *  Copyright 2010 Tinybean. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "TBGameConst.h"


@class TBSprite;
@class TBUnit;


#define kSupplyAmmoToMax    1000


@interface TBWeapon : NSObject


@property (nonatomic, readonly) TBSprite  *body;
@property (nonatomic, readonly) TBTeam     team;

@property (nonatomic, readonly) NSUInteger reloadCount;
@property (nonatomic, assign)   NSUInteger maxAmmoCount;
@property (nonatomic, assign)   NSUInteger ammoCount;

@property (nonatomic, assign)   NSUInteger reloadTime;
@property (nonatomic, assign)   CGFloat    maxRange;


- (void)setBody:(TBSprite *)aBody;

- (void)action;

- (void)reset;

- (BOOL)isReloaded;
- (void)reload;
- (void)decreaseAmmoCount;
- (CGPoint)mountPoint;
- (BOOL)inRange:(CGFloat)aDistance;

- (void)setFire:(BOOL)aFire;
- (BOOL)fireAt:(TBUnit *)aUnit;

- (BOOL)fillUp;
- (BOOL)supplyAmmo:(NSUInteger)aCount;


@end
