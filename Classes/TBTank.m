//
//  TBTank.m
//  Thunderbolt
//
//  Created by jskim on 10. 1. 29..
//  Copyright 2010 tinybean. All rights reserved.
//

#import "TBTank.h"
#import "TBGameConst.h"
#import "TBTextureManager.h"
#import "TBTextureNames.h"
#import "TBTankGun.h"
#import "TBUnitManager.h"
#import "TBHelicopter.h"


#define kTankSpeed 1


@interface TBTank (Privates)
@end


@implementation TBTank (Privates)


- (void)setTexture
{
    TBTextureManager *sTextureMan = [TBTextureManager sharedManager];
    TBTextureInfo    *sInfo;
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
    
    sInfo          = [sTextureMan textureInfoForKey:sTexTank];
    mTextureNormal = [sInfo textureID];
    sInfo          = [sTextureMan textureInfoForKey:sTexTankShoot];
    mTextureHit    = [sInfo textureID];

    [self setTextureSize:[sInfo textureSize]];
    [self setContentSize:[sInfo contentSize]];
}


@end


@implementation TBTank


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
            [self setPosition:CGPointMake(MAX_MAP_XPOS + 50, MAP_GROUND + (mContentSize.height / 2))];
        }
        else
        {
            [self setPosition:CGPointMake(-50, MAP_GROUND + (mContentSize.height / 2))];        
        }
        
        mTankGun = [[TBTankGun alloc] initWithBody:self team:aTeam];
    }
    
    return self;
}


- (void)dealloc
{
    [mTankGun release];
    
    [super dealloc];
}


#pragma mark -


- (void)action
{
    CGFloat sAngle;
    TBUnit *sUnit;
    BOOL    sFire = NO;
    
    [super action];
    [mTankGun action];

    sUnit = [[TBUnitManager sharedManager] opponentUnitOf:self inRange:kTankGunMaxRange];
    if (sUnit)
    {
        sAngle = [self angleWith:sUnit];
        if ((sAngle >= -100.0 && sAngle <= -85.0) ||
            (sAngle <= 100.0 && sAngle >= 85.0))
        {
            [mTankGun fireAt:sUnit];
            sFire = YES;
        }
    }
    
    if (!sFire)
    {
        mPosition.x += ([self isAlly]) ? kTankSpeed : -kTankSpeed;
    }
}


- (void)addDamage:(NSInteger)aDamage
{
    [super addDamage:aDamage];
    
    mHitDiscount = 5;
}


- (void)draw
{
    if (mHitDiscount == 0)
    {
        [self setTextureID:mTextureNormal];
    }
    else
    {
        mHitDiscount--;
        [self setTextureID:mTextureHit];
    }
    
    [super draw];
}


@end
