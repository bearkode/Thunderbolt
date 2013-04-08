/*
 *  TBMissile.m
 *  Thunderbolt
 *
 *  Created by bearkode on 10. 5. 8..
 *  Copyright 2010 Tinybean. All rights reserved.
 *
 */

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
{
    NSNumber *mTargetID;
    NSInteger mDestructivePower;
    CGFloat   mSpeed;
}


@synthesize targetID         = mTargetID;
@synthesize destructivePower = mDestructivePower;


#pragma mark -


- (id)initWithUnitID:(NSNumber *)aUnitID team:(TBTeam)aTeam
{
    self = [super initWithUnitID:aUnitID team:aTeam];
    
    if (self)
    {
        [self setType:kTBUnitMissile];
        [self setDurability:kMissileDurability];
        [self setFuel:MISSILE_FUEL];

        mDestructivePower = kMissilePower;
        mSpeed            = 0.0;
        
        PBTexture *sTexture = [PBTextureManager textureWithImageName:kTexMissile];
        [sTexture loadIfNeeded];
        [self setTexture:sTexture];
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

    CGPoint   sPoint  = [self point];
    PBVertex3 sAngle3 = [[self transform] angle];
    
    if (mSpeed < MISSILE_SPEED)
    {
        mSpeed += 0.2;
    }
    
    sTarget = [[TBUnitManager sharedManager] unitForUnitID:mTargetID];
    if (sTarget)
    {
        CGFloat sAngle = TBRadiansToDegrees(TBAngleBetweenToPoints([self point], [sTarget point]));
        CGFloat sDelta = sAngle - sAngle3.z;
        
        if (sDelta > 0)
        {
            sAngle3.z = (sDelta < MISSILE_SENSITIVE) ? sAngle : sAngle3.z + MISSILE_SENSITIVE;
        }
        else
        {
            sAngle3.z = (sDelta > -MISSILE_SENSITIVE) ? sAngle : sAngle3.z - MISSILE_SENSITIVE;
        }
    }

    CGFloat sX = cos(TBDegreesToRadians(sAngle3.z)) * mSpeed;
    CGFloat sY = sin(TBDegreesToRadians(sAngle3.z)) * mSpeed;
    
    if (mFuel > 0)
    {
        sPoint.x += sX;
        sPoint.y += sY;
    }
    else
    {
        sPoint.x += sX;
        sPoint.y -= 7.0;
        mSpeed = (mSpeed <= 0) ? 0.0 : mSpeed - 0.1;
    }

    [[self transform] setAngle:sAngle3];
    [self setPoint:sPoint];
}


@end
