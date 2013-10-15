/*
 *  TBGatlingGun.m
 *  Thunderbolt
 *
 *  Created by cgkim on 13. 4. 22..
 *  Copyright (c) 2013 Tinybean. All rights reserved.
 *
 */

#import "TBGatlingGun.h"
#import <PBKit.h>
#import "TBMacro.h"
#import "TBHelicopter.h"
#import "TBBullet.h"
#import "TBWarheadManager.h"
#import "TBMoneyManager.h"


const NSInteger kFireDelay = 8;


@implementation TBGatlingGun
{
    PBSoundSource *mSoundSource;
    BOOL           mFire;
    NSInteger      mFireDelay;
}


#pragma mark -


- (void)setupSoundSource
{
    mSoundSource = [[PBSoundManager sharedManager] retainSoundSource];
    [mSoundSource setSound:[[PBSoundManager sharedManager] soundForKey:kTBSoundVulcan]];
    [mSoundSource setDistance:1];
    [mSoundSource setLooping:YES];
}


#pragma mark -


- (id)init
{
    self = [super init];
    
    if (self)
    {
        [self setupSoundSource];
        mFire = NO;
    }
    
    return self;
}


- (void)dealloc
{
    [[PBSoundManager sharedManager] releaseSoundSource:mSoundSource];
    
    [super dealloc];
}


#pragma mark -


- (BOOL)canFire
{
    TBHelicopter *sHelicopter = (TBHelicopter *)[self body];
    
    return (![sHelicopter isLanded] && [self ammoCount] > 0);
}


- (void)setFire:(BOOL)aFlag
{
    if (mFire != aFlag)
    {
        if (aFlag == YES && [self canFire])
        {
            mFire = YES;
            mFireDelay = 0;
            [mSoundSource play];
        }
        else
        {
            mFire = NO;
            [mSoundSource stop];
        }
    }
}


- (void)fillUp
{
    if ([TBMoneyManager useMoney:kTBPriceBullet])
    {
        TBHelicopter *sHelicopter = (TBHelicopter *)[self body];
        [self supplyAmmo:kLandingPadFillUpBullets];
        [[sHelicopter delegate] helicopterWeaponDidReload:sHelicopter];
    }
}


#pragma mark -


- (void)action
{
    if (mFireDelay > 0)
    {
        mFireDelay--;
    }
    else
    {
        if (mFire)
        {
            if ([self ammoCount] > 0)
            {
                TBHelicopter *sBody   = (TBHelicopter *)[self body];
                PBVertex3     sAngle3 = [sBody angle];
                CGFloat       sAngle;
                CGPoint       sPos1;
                CGPoint       sPos2;
                CGPoint       sBulletPos = CGPointZero;
                
                sAngle = TBDegreesToRadians(sAngle3.z);
                sPos1  = [[self body] point];
                sPos2  = sPos1;
                
                if ([sBody isLeftAhead])
                {
                    sPos2.x -= 30;
                    sPos2.y -= 10;
                }
                else
                {
                    sPos2.x += 30;
                    sPos2.y -= 10;
                }
                
                sAngle = -sAngle;
                sBulletPos.x = sPos1.x + (sPos2.x - sPos1.x) * cos(sAngle) - (sPos2.y - sPos1.y) * sin(sAngle);
                sBulletPos.y = sPos1.y + (sPos2.x - sPos1.x) * sin(sAngle) + (sPos2.y - sPos1.y) * cos(sAngle);
                
                CGPoint sVector = CGPointMake((sBulletPos.x - sPos1.x) / 3.5, (sBulletPos.y - sPos2.y) / 3.5);
                
                TBBullet *sBullet = [[TBWarheadManager sharedManager] addBulletWithTeam:kTBTeamAlly position:sBulletPos vector:sVector power:kVulcanBulletPower];
                [sBullet setLife:100];
                [self decreaseAmmoCount];
                
                [[sBody delegate] helicopter:sBody weaponFired:0];
            }
            
            if ([self ammoCount] == 0)
            {
                [self setFire:NO];
            }
            else
            {
                mFireDelay = kFireDelay;
            }
        }
    }
}


@end
