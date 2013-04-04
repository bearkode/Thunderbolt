//
//  TBMissile.m
//  Thunderbolt
//
//  Created by jskim on 10. 5. 8..
//  Copyright 2010 Tinybean. All rights reserved.
//

#import "TBMissile.h"
#import "TBTextureManager.h"
#import "TBTextureNames.h"
#import "TBUnitManager.h"
#import "TBMacro.h"
#import "TBUnit.h"


#define MISSILE_FUEL        250.0
#define MISSILE_SPEED       11.7
#define MISSILE_SENSITIVE   2.8


@implementation TBMissile


@synthesize targetID         = mTargetID;
@synthesize destructivePower = mDestructivePower;


#pragma mark -


- (id)initWithUnitID:(NSNumber *)aUnitID team:(TBTeam)aTeam
{
    TBTextureInfo *sInfo;
    
    self = [super initWithUnitID:aUnitID team:aTeam];
    if (self)
    {
        [self setType:kTBUnitMissile];
        [self setDurability:kMissileDurability];
        [self setFuel:MISSILE_FUEL];

        mDestructivePower = kMissilePower;
        mSpeed            = 0.0;
        
        sInfo = [TBTextureManager textureInfoForKey:kTexMissile];
        
        [self setTextureID:[sInfo textureID]];
        [self setTextureSize:[sInfo textureSize]];
        [self setContentSize:CGSizeMake(20, 20)];
    }
    
    return self;
}


- (void)dealloc
{
    [super dealloc];
}


- (void)action
{
    TBUnit *sTarget = nil;
    
    [super action];

    if (mSpeed < MISSILE_SPEED)
    {
        mSpeed += 0.2;
    }
    
    sTarget = [[TBUnitManager sharedManager] unitForUnitID:mTargetID];
    if (sTarget)
    {
        CGFloat sAngle = TBRadiansToDegrees(TBAngleBetweenToPoints([self position], [sTarget position]));
        CGFloat sDelta = sAngle - mAngle;
        
        if (sDelta > 0)
        {
            mAngle = (sDelta < MISSILE_SENSITIVE) ? sAngle : mAngle + MISSILE_SENSITIVE;
        }
        else
        {
            mAngle = (sDelta > -MISSILE_SENSITIVE) ? sAngle : mAngle - MISSILE_SENSITIVE;
        }
    }

    CGFloat sX = cos(TBDegreesToRadians(mAngle)) * mSpeed;
    CGFloat sY = sin(TBDegreesToRadians(mAngle)) * mSpeed;
    
    if (mFuel > 0)
    {
        mPosition.x += sX;
        mPosition.y += sY;
    }
    else
    {
        mPosition.x += sX;
        mPosition.y -= 7.0;
        mSpeed = (mSpeed <= 0) ? 0.0 : mSpeed - 0.1;
    }
}


- (void)draw
{
    [super draw];
}


@end
