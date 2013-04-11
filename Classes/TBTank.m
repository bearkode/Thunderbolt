/*
 *  TBTank.m
 *  Thunderbolt
 *
 *  Created by bearkode on 10. 1. 29..
 *  Copyright 2010 tinybean. All rights reserved.
 *
 */

#import "TBTank.h"
#import "TBGameConst.h"
#import "TBTextureNames.h"
#import "TBTankGun.h"
#import "TBUnitManager.h"
#import "TBHelicopter.h"


#define kTankSpeed 0.5


@implementation TBTank
{
    PBTexture *mTextureNormal;
    PBTexture *mTextureHit;
    
    NSInteger  mHitDiscount;
    TBTankGun *mTankGun;
}


- (void)setTexture
{
    NSString         *sTexTank;
    NSString         *sTexTankShoot;
    
    if (mTeam == kTBTeamAlly)
    {
        sTexTank      = kTexAllyTank;
        sTexTankShoot = kTexAllyTankShoot;
    }
    else
    {
        sTexTank      = kTexEnemyTank;
        sTexTankShoot = kTexEnemyTankShoot;
    }
    
    [mTextureNormal autorelease];
    mTextureNormal = [[PBTextureManager textureWithImageName:sTexTank] retain];
    [mTextureNormal loadIfNeeded];
    
    [mTextureHit autorelease];
    mTextureHit = [[PBTextureManager textureWithImageName:sTexTankShoot] retain];
    [mTextureHit loadIfNeeded];
    
    [self setTexture:mTextureNormal];
}


#pragma mark -


- (id)initWithUnitID:(NSNumber *)aUnitID team:(TBTeam)aTeam
{
    self = [super initWithUnitID:aUnitID team:aTeam];
    
    if (self)
    {
        [self setType:kTBUnitTank];
        [self setDurability:kTankDurability];
        
        mHitDiscount = 0;

        [self setTexture];
        
        if (mTeam == kTBTeamEnemy)
        {
            [self setPoint:CGPointMake(kMaxMapXPos + 50, kMapGround + ([[self mesh] size].height / 2))];
        }
        else
        {
            [self setPoint:CGPointMake(-50, kMapGround + ([[self mesh] size].height / 2))];
        }
        
        mTankGun = [[TBTankGun alloc] initWithBody:self team:aTeam];
    }
    
    return self;
}


- (void)dealloc
{
    [mTextureNormal release];
    [mTextureHit release];
    
    [mTankGun release];
    
    [super dealloc];
}


#pragma mark -


- (void)action
{
    [super action];
    
    TBUnit *sUnit;
    BOOL    sFire = NO;

    [mTankGun action];

    // TODO : 현재 로직으로는 적 탱크 앞에 헬기가 공중에 떠 있으면 다음으로 가까운 앞의 탱크를 공격하지 않는다.
    if ([mTankGun isReloaded])
    {
        sUnit = [[TBUnitManager sharedManager] opponentUnitOf:self inRange:kTankGunMaxRange];
        if (sUnit)
        {
            CGFloat sAngle = [self angleWith:sUnit];
            if ((sAngle >= -100.0 && sAngle <= -85.0) ||
                (sAngle <= 100.0 && sAngle >= 85.0))
            {
                [mTankGun fireAt:sUnit];
                sFire = YES;
            }
        }
    }
    
    if (!sFire)
    {
        CGPoint sPoint = [self point];
        sPoint.x += ([self isAlly]) ? kTankSpeed : -kTankSpeed;
        [self setPoint:sPoint];
    }
    
    if (mHitDiscount-- == 0)
    {
        [self setTexture:mTextureNormal];
    }
}


- (void)addDamage:(NSInteger)aDamage
{
    [super addDamage:aDamage];
    
    [self setTexture:mTextureHit];
    mHitDiscount = 10;
}


@end
