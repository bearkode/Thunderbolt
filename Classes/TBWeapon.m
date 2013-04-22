/*
 *  TBWeapon.m
 *  Thunderbolt
 *
 *  Created by bearkode on 10. 5. 14..
 *  Copyright 2010 Tinybean. All rights reserved.
 *
 */

#import "TBWeapon.h"
#import "TBSprite.h"
#import "TBUnit.h"
#import "TBStructure.h"


@implementation TBWeapon
{
    TBSprite  *mBody;
    TBTeam     mTeam;
    
    NSUInteger mReloadCount;
    NSUInteger mMaxAmmoCount;
    NSUInteger mAmmoCount;
    
    NSUInteger mReloadTime;
    CGFloat    mMaxRange;
}


@synthesize body         = mBody;
@synthesize team         = mTeam;

@synthesize reloadCount  = mReloadCount;
@synthesize maxAmmoCount = mMaxAmmoCount;
@synthesize ammoCount    = mAmmoCount;

@synthesize reloadTime   = mReloadTime;
@synthesize maxRange     = mMaxRange;


#pragma mark -


- (id)init
{
    self = [super init];
    
    if (self)
    {
        [self reset];
    }
    
    return self;
}


- (void)dealloc
{
    [super dealloc];
}


#pragma mark -


- (void)action
{
    if (mReloadCount > 0)
    {
        mReloadCount--;
    }
}


#pragma mark -


- (void)reset
{
    mBody        = nil;
    mTeam        = kTBTeamUnknown;
    mReloadCount = 0;
    mAmmoCount   = 0;
    mReloadTime  = 0;
    mMaxRange    = 0;
}


- (void)setBody:(TBSprite *)aBody
{
    mBody = aBody;
    
    if ([aBody isKindOfClass:[TBUnit class]])
    {
        mTeam = [(TBUnit *)aBody team];
    }
    else if ([aBody isKindOfClass:[TBStructure class]])
    {
        mTeam = [(TBStructure *)aBody team];
    }

}


- (BOOL)isReloaded
{
    return (mReloadCount == 0);
}


- (void)reload
{
    mReloadCount = mReloadTime;
}


- (void)decreaseAmmoCount
{
    if (mAmmoCount)
    {
        mAmmoCount--;
    }
}


- (CGPoint)mountPoint
{
    return [mBody point];
}


- (BOOL)inRange:(CGFloat)aDistance
{
    return (aDistance <= mMaxRange);
}


/*  For User Control  */
- (void)setFire:(BOOL)aFire
{

}


/*  For AI Control  */
- (BOOL)fireAt:(TBUnit *)aUnit
{
    return NO;
}


- (void)fillUp
{

}


- (void)supplyAmmo:(NSUInteger)aCount
{
    mAmmoCount += aCount;
    
    if (mAmmoCount > mMaxAmmoCount)
    {
        mAmmoCount = mMaxAmmoCount;
    }
}


@end
