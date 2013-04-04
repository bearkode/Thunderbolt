//
//  TBWeapon.h
//  Thunderbolt
//
//  Created by jskim on 10. 5. 14..
//  Copyright 2010 Tinybean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBGameConst.h"


@class TBSprite;
@class TBUnit;


@interface TBWeapon : NSObject
{
    TBSprite *mBody;
    TBTeam mTeam;
    
    NSUInteger mReloadCount;
    NSUInteger mAmmoCount;
    
    NSUInteger mReloadTime;
    CGFloat    mMaxRange;
}

@property (nonatomic, readonly) TBTeam team;

@property (nonatomic, readonly) NSUInteger reloadCount;
@property (nonatomic, readonly) NSUInteger ammoCount;

@property (nonatomic, readonly) NSUInteger reloadTime;
@property (nonatomic, readonly) CGFloat    maxRange;


- (id)initWithBody:(TBSprite *)aBody team:(TBTeam)aTeam;

- (void)action;

- (BOOL)isReloaded;
- (void)reload;

- (BOOL)fireAt:(TBUnit *)aUnit;
- (void)supplyAmmo:(NSUInteger)aCount;

@end
