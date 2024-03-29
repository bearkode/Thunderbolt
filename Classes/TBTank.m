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


const CGFloat kTankSpeed = 0.5;


#pragma mark -


@implementation TBTank
{
    PBTexture *mTextureNormal;
    PBTexture *mTextureHit;
    
    NSInteger  mHitDiscount;
    TBTankGun *mTankGun;
}


- (void)setTexture
{
    NSString *sTexTank;
    NSString *sTexTankShoot;
    
    if ([self isAlly])
    {
        sTexTank      = kTexAllyTank;
        sTexTankShoot = kTexAllyTankShoot;
    }
    else
    {
        sTexTank      = kTexEnemyTank;
        sTexTankShoot = kTexEnemyTankShoot;
    }
    
    mTextureNormal = [[PBTextureManager textureWithImageName:sTexTank] retain];
    mTextureHit    = [[PBTextureManager textureWithImageName:sTexTankShoot] retain];
    
    [self setTexture:mTextureNormal];
    [self setTileSize:[mTextureNormal size]];
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
        
        CGSize sSize = [self tileSize];
        
        if ([self isAlly])
        {
            [self setPoint:CGPointMake(-50, kMapGround + (sSize.height / 2))];
        }
        else
        {
            [self setPoint:CGPointMake(kMaxMapXPos + 50, kMapGround + (sSize.height / 2))];
        }
        
        mTankGun = [[TBTankGun alloc] init];
        [mTankGun setBody:self];
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

    BOOL sFire = NO;

    [mTankGun action];

    // TODO : 현재 로직으로는 적 탱크 앞에 헬기가 공중에 떠 있으면 다음으로 가까운 앞의 탱크를 공격하지 않는다.
    if ([mTankGun isReloaded])
    {
        TBUnit *sUnit = [[TBUnitManager sharedManager] opponentUnitOf:self inRange:kTankGunMaxRange];

        if ([sUnit state] == kTBUnitStateNormal)
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
        [self moveWithVector:CGPointMake(([self isAlly]) ? kTankSpeed : -kTankSpeed, 0)];
    }
    
    if (mHitDiscount-- == 0)
    {
        [self setTexture:mTextureNormal];
        [self setTileSize:[mTextureNormal size]];
    }
}


- (BOOL)addDamage:(NSInteger)aDamage
{
    BOOL sDestroyed = [super addDamage:aDamage];
    
    [self setTexture:mTextureHit];
    [self setTileSize:[mTextureHit size]];
    mHitDiscount = 10;
    
    if (sDestroyed)
    {
        [self setState:kTBUnitStateDestroyed];
    }
    
    return sDestroyed;
}


@end
