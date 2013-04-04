//
//  TBWeapon.m
//  Thunderbolt
//
//  Created by jskim on 10. 5. 14..
//  Copyright 2010 Tinybean. All rights reserved.
//

#import "TBWeapon.h"
#import "TBSprite.h"


@implementation TBWeapon


@synthesize team        = mTeam;
@synthesize reloadCount = mReloadCount;
@synthesize ammoCount   = mAmmoCount;

@synthesize reloadTime  = mReloadTime;
@synthesize maxRange    = mMaxRange;


#pragma mark -


- (id)initWithBody:(TBSprite *)aBody team:(TBTeam)aTeam
{
    self = [super init];
    
    if (self)
    {
        mBody = aBody;
        mTeam = aTeam;
    }
    
    return self;
}


#pragma mark -


- (BOOL)isReloaded
{
    return (mReloadCount == 0) ? YES : NO;
}


- (void)reload
{
    mReloadCount = mReloadTime;
}


- (void)action
{
    if (mReloadCount > 0)
    {
        mReloadCount--;
    }
}


- (BOOL)fireAt:(TBUnit *)aUnit
{
    return NO;
}


- (void)supplyAmmo:(NSUInteger)aCount
{
    mAmmoCount += aCount;
}


@end
