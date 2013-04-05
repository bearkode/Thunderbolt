/*
 *  TBHelicopter.m
 *  Thunderbolt
 *
 *  Created by bearkode on 10. 1. 24..
 *  Copyright 2010 tinybean. All rights reserved.
 *
 */

#import "TBHelicopter.h"
#import "TBTextureManager.h"
#import "TBGameConst.h"
#import "TBMacro.h"
#import "TBBullet.h"
#import "TBBomb.h"

#import "TBWarheadManager.h"
#import "TBMoneyManager.h"
#import "TBALPlayback.h"


#define MAX_BULLETS     100
#define MAX_BOMBS       5
#define MAX_MISSILE     2

#define kVulcanDelay    4


@interface TBHelicopter (Privates)
@end


@implementation TBHelicopter (Privates)


- (void)loadImages
{
    NSInteger i;
    
    for (i = 0; i < 9; i++)
    {
        [mTextureArray addObject:[NSString stringWithFormat:@"heli%02d.png", i]];
    }
}


@end


@implementation TBHelicopter


@synthesize selectedWeapon  = mSelectedWeapon;
@synthesize bulletCount     = mBulletCount;
@synthesize bombCount       = mBombCount;
@synthesize missileCount    = mMissileCount;
@synthesize isBombDrop      = mIsBombDrop;
@synthesize isMissileLaunch = mIsMissileLaunch;


#pragma mark -


- (id)initWithUnitID:(NSNumber *)aUnitID team:(TBTeam)aTeam
{
    self = [super initWithUnitID:aUnitID team:aTeam];
    if (self)
    {
        [self setType:kTBUnitHelicopter];
        [self setDurability:kHelicopterDurability];
        
        mTick            = 0;
        
        mIsLeftAhead     = (aTeam == kTBTeamAlly) ? NO : YES;
        mSpeed           = 0;
        mTextureIndex    = (aTeam == kTBTeamAlly) ? 8 : 0;
        
        mTextureArray    = [[NSMutableArray alloc] init];
        [self loadImages];
        
        mContentRectArray = [[NSMutableArray alloc] init];
        [mContentRectArray addObject:NSStringFromCGRect(CGRectMake(12, 4, 72, 28))];    // 0
        [mContentRectArray addObject:NSStringFromCGRect(CGRectMake(12, 4, 72, 28))];    // 1
        [mContentRectArray addObject:NSStringFromCGRect(CGRectMake(19, 7, 46, 24))];    // 2
        [mContentRectArray addObject:NSStringFromCGRect(CGRectMake(21, 7, 32, 24))];    // 3
        [mContentRectArray addObject:NSStringFromCGRect(CGRectMake(28, 6, 32, 25))];    // 4
        [mContentRectArray addObject:NSStringFromCGRect(CGRectMake(37, 7, 32, 25))];    // 5 
        [mContentRectArray addObject:NSStringFromCGRect(CGRectMake(16, 7, 48, 25))];    // 6
        [mContentRectArray addObject:NSStringFromCGRect(CGRectMake(0, 6, 79, 26))];     // 7
        [mContentRectArray addObject:NSStringFromCGRect(CGRectMake(0, 6, 79, 26))];     // 8
        
        mBulletCount     = MAX_BULLETS;
        mBombCount       = MAX_BOMBS;
        mMissileCount    = MAX_MISSILE;
        mIsVulcanFire    = NO;
        mIsBombDrop      = NO;
        mIsMissileLaunch = NO;
        
        mIsLanded        = YES;
        
        [[TBALPlayback sharedPlayback] startSound:kTBSoundHeli];
   }
    
    return self;
}


- (void)dealloc
{
    [mTextureArray     release];
    [mContentRectArray release];

    [[TBALPlayback sharedPlayback] stopSound:kTBSoundHeli];
    
    [super dealloc];
}


- (CGRect)contentRect
{
    CGRect sResult   = CGRectZero;
    CGRect sContRect = CGRectFromString([mContentRectArray objectAtIndex:mTextureIndex]);
    
    sResult.origin.x    = mPosition.x - ((mContentSize.width  - 30) / 2);
    sResult.origin.y    = mPosition.y - ((mContentSize.height - 30) / 2);
    
    sResult.origin.x   += sContRect.origin.x;
    sResult.origin.y   -= sContRect.size.height;
    sResult.size.width  = sContRect.size.width;
    sResult.size.height = sContRect.size.height;
    
    return sResult;
}


- (void)setDelegate:(id)aDelegate
{
    [super setDelegate:aDelegate];
    
    [mDelegate helicopterWeaponDidReload:self];
}


- (void)addDamage:(NSInteger)aDamage
{
    if (mDamage < mDurability)
    {
        [super addDamage:aDamage];
        
        [mDelegate helicopterDamageChanged:self];

        if (mDamage >= mDurability)
        {
            [mDelegate helicopterDidDestroy:self];
        }
    }
}


#pragma mark -


#define kSpeedSensitivitiy   20.0
#define kAltitudeSensitivity 30.0


- (void)setSpeedLever:(CGFloat)aSpeedLever
{
    CGFloat sDegree = aSpeedLever * 50;
    
    if (aSpeedLever > 0.1 || aSpeedLever < -0.1)
    {
        mSpeed -= aSpeedLever * 2;
        if (mSpeed > 10)
        {
            mSpeed = 10;
        }
        else if (mSpeed < -10)
        {
            mSpeed = -10;
        }
    }
    
    if (mSpeed > 0)
    {
        mSpeed -= 0.04;
    }
    if (mSpeed < 0)
    {
        mSpeed += 0.04;
    }
    
    if (!mIsLanded && (mPosition.y - mContentSize.height) > MAP_GROUND) //  TODO : 헬기가 땅에 크래쉬하는걸 구현하려면 뒷부분 수정
    {
        mPosition.x += mSpeed;
        [self setAngle:sDegree];
        
        if (mSpeed > 0)
        {
            if (mIsLeftAhead == YES)
            {
                mIsLeftAhead = NO;
            }
        }
        else
        {
            if (mIsLeftAhead == NO)
            {
                mIsLeftAhead = YES;
            }
        }
    }
    else
    {
        mSpeed = 0;
        [self setAngle:0];
    }
    
    if (mPosition.x < kMinMapXPos)
    {
        mPosition.x = kMinMapXPos;
    }
    else if (mPosition.x > kMaxMapXPos)
    {
        mPosition.x = kMaxMapXPos;
    }
}


- (void)setAltitudeLever:(CGFloat)aAltitudeLever
{
    CGFloat sAltitudeLever = (aAltitudeLever + 0.68) * kAltitudeSensitivity;

    mPosition.y -= sAltitudeLever;

    if ((mPosition.y - mContentSize.height / 2) < MAP_GROUND)
    {
        mIsLanded   = YES;
        mPosition.y = MAP_GROUND + mContentSize.height / 2;
    }
    else if (mPosition.y > 300)
    {
        mPosition.y = 300;
        mIsLanded = NO;        
    }
    else
    {
        mIsLanded = NO;
    }
}


- (void)setFireVulcan:(BOOL)aFlag
{
    mIsVulcanFire = aFlag;
    if (mIsVulcanFire)
    {
        mVulcanDelay = 0;
    }
}


- (void)repairDamage:(NSInteger)aValue
{
    if (mDamage > 0)
    {
        mDamage -= aValue;
        if (mDamage < 0)
        {
            mDamage = 0;
        }
        [mDelegate helicopterDamageChanged:self];
        [TBMoneyManager useMoney:kTBPriceRepair];
    }
}


- (void)fillUpBullets:(NSInteger)aCount
{
    if (mBulletCount < MAX_BULLETS)
    {
        mBulletCount += aCount;
        if (mBulletCount > MAX_BULLETS)
        {
            mBulletCount = MAX_BULLETS;
        }
        [mDelegate helicopterWeaponDidReload:self];
        [TBMoneyManager useMoney:kTBPriceBullet];        
    }
}


- (void)fillUpBombs:(NSInteger)aCount
{
    if (mBombCount < MAX_BOMBS)
    {
        mBombCount += aCount;
        if (mBombCount > MAX_BOMBS)
        {
            mBombCount = MAX_BOMBS;
        }
        [mDelegate helicopterWeaponDidReload:self];
        [TBMoneyManager useMoney:kTBPriceBomb];
    }
}


- (BOOL)isVulcanFiring
{
    return mIsVulcanFire;
}


- (void)dropBomb
{
    TBBomb *sBomb = nil;
    
    if (mBombCount > 0)
    {
        sBomb = [TBWarheadManager bombWithTeam:kTBTeamAlly position:CGPointMake(mPosition.x, mPosition.y - 10) speed:mSpeed];
        mBombCount--;
        
        [mDelegate helicopter:self weaponFired:1];
    }
}


- (void)fireVulcan
{
    CGFloat   sAngle;
    CGPoint   sPos1;
    CGPoint   sPos2;
    CGPoint   sBulletPos = CGPointZero;
    TBBullet *sBullet;
    
    if (mIsVulcanFire)
    {
        if (mBulletCount > 0)
        {
            sAngle = TBDegreesToRadians([self angle]);
            sPos1  = [self position];
            sPos2  = sPos1;

            if ([self isLeftAhead])
            {
                sPos2.x -= 30;
                sPos2.y -= 10;
            }
            else
            {
                sPos2.x += 30;
                sPos2.y -= 10;
            }
            
            sBulletPos.x = sPos1.x + (sPos2.x - sPos1.x) * cos(sAngle) - (sPos2.y - sPos1.y) * sin(sAngle);
            sBulletPos.y = sPos1.y + (sPos2.x - sPos1.x) * sin(sAngle) + (sPos2.y - sPos1.y) * cos(sAngle);

            CGPoint sVector = CGPointMake((sBulletPos.x - sPos1.x) / 1.5, (sBulletPos.y - sPos2.y) / 1.5);
            sBullet = [TBWarheadManager bulletWithTeam:kTBTeamAlly position:sBulletPos vector:sVector destructivePower:kVulcanBulletPower];
            [sBullet setLife:50];
            mBulletCount--;
            
            [mDelegate helicopter:self weaponFired:0];
        }

        if (mBulletCount == 0)
        {
            [[TBALPlayback sharedPlayback] stopSound:kTBSoundVulcan];
            mIsVulcanFire = NO;
        }
        else
        {
            mVulcanDelay = kVulcanDelay;
        }
    }
}


- (void)action
{
    [super action];
    
    if (mIsVulcanFire && mBulletCount > 0)
    {
        mVulcanDelay--;
        if (mVulcanDelay <= 0)
        {
            [self fireVulcan];
        }
    }
}


- (void)draw
{
    NSString      *sTextureKey = nil;
    TBTextureInfo *sInfo       = nil;

    if (++mTick == 100)
    {
        mTick = 0;
    }
    
    
    if ((mTick % 2) == 0)
    {
        if (mIsLeftAhead)
        {
            if (mTextureIndex > 2)
            {
                mTextureIndex--;
            }
            else
            {
                mTextureIndex = (mTextureIndex == 0) ? 1 : 0;
            }
        }
        else
        {
            if (mTextureIndex < 7)
            {
                mTextureIndex++;
            }
            else
            {
                mTextureIndex = (mTextureIndex == 7) ? 8 : 7;
            }
        }
    }
    
    sTextureKey = [mTextureArray objectAtIndex:mTextureIndex];    
    sInfo       = [[TBTextureManager sharedManager] textureInfoForKey:sTextureKey];
    
    [self setTextureID:[sInfo textureID]];
    [self setTextureSize:[sInfo textureSize]];
    [self setContentSize:[sInfo contentSize]];
    [super draw];
}


- (BOOL)isLeftAhead
{
    return mIsLeftAhead;
}


- (BOOL)isLanded
{
    return mIsLanded;
}


@end
