/*
 *  TBMissile.m
 *  Thunderbolt
 *
 *  Created by bearkode on 10. 5. 8..
 *  Copyright 2010 Tinybean. All rights reserved.
 *
 */

#import "TBMissile.h"
#import "TBTextureNames.h"
#import "TBUnitManager.h"
#import "TBExplosionManager.h"
#import "TBSmokeManager.h"
#import "TBMacro.h"
#import "TBUnit.h"


const NSInteger kMissileFuel         = 300;
const CGFloat   kMissileSpeed        = 5.8;
const CGFloat   kMissileSensitive    = 2.8;
const CGFloat   kMissileAcceleration = 0.1;


@implementation TBMissile
{
    NSNumber *mTargetID;
    NSInteger mPower;
    CGFloat   mSpeed;
    NSInteger mFuel;
}


@synthesize targetID = mTargetID;
@synthesize power    = mPower;


#pragma mark -


- (id)initWithUnitID:(NSNumber *)aUnitID team:(TBTeam)aTeam
{
    self = [super initWithUnitID:aUnitID team:aTeam];
    
    if (self)
    {
        [self setTexture:[PBTextureManager textureWithImageName:kTexMissile]];
        [self setTileSize:[self textureSize]];

        [self setType:kTBUnitMissile];
        [self setDurability:kMissileDurability];
        
        mPower = kMissilePower;
        mSpeed = 0.0;
        mFuel  = kMissileFuel;
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
//    PBVertex3 sAngle3 = [[self transform] angle];
    PBVertex3 sAngle3 = [self angle];
    
    if (mSpeed < kMissileSpeed)
    {
        mSpeed += kMissileAcceleration;
    }
    
    sTarget = [[TBUnitManager sharedManager] unitForUnitID:mTargetID];
    if (sTarget)
    {
        CGFloat sAngle = 360 - TBRadiansToDegrees(TBAngleBetweenToPoints([self point], [sTarget point]));
        
        sAngle = (sAngle > 360) ? (sAngle - 360) : sAngle;
        
        CGFloat sDelta = (sAngle - sAngle3.z);
        
        if (sDelta < -180)
        {
            sDelta = 360 + sDelta;
        }
 
        if (sDelta > 0)
        {
            sAngle3.z = (sDelta < kMissileSensitive) ? sAngle : sAngle3.z + kMissileSensitive;
        }
        else
        {
            sAngle3.z = (sDelta > -kMissileSensitive) ? sAngle : sAngle3.z - kMissileSensitive;
        }
    }

    CGFloat sX = cos(TBDegreesToRadians(sAngle3.z)) * mSpeed;
    CGFloat sY = sin(TBDegreesToRadians(sAngle3.z)) * mSpeed;
    
    if (mFuel-- > 0)
    {
        sPoint.x += sX;
        sPoint.y -= sY;
    }
    else
    {
        sPoint.x += sX;
        sPoint.y -= 7.0;
        mSpeed = (mSpeed <= 0) ? 0.0 : mSpeed - 0.1;
    }

//    [[self transform] setAngle:sAngle3];
    [self setAngle:sAngle3];
    [self setPoint:sPoint];
    
    if ([self intersectWithGround])
    {
        [self addDamage:1000];
        [[TBExplosionManager sharedManager] addBombExplosionAtPosition:CGPointMake(sPoint.x, kMapGround + 18)];
    }
    
    if (mFuel > 230)
    {
        [[TBSmokeManager sharedManager] addSmokeAtPoint:sPoint];
    }
}


@end
