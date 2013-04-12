/*
 *  TBHelicopter.m
 *  Thunderbolt
 *
 *  Created by bearkode on 10. 1. 24..
 *  Copyright 2010 tinybean. All rights reserved.
 *
 */

#import "TBHelicopter.h"
#import "TBGameConst.h"
#import "TBMacro.h"
#import "TBBullet.h"
#import "TBBomb.h"

#import "TBWarheadManager.h"
#import "TBMoneyManager.h"


#define MAX_BULLETS     100
#define MAX_BOMBS       5
#define MAX_MISSILE     2

#define kVulcanDelay    8


@implementation TBHelicopter
{
    TBControlLever *mControlLever;
    
    NSInteger       mTick;
    
    BOOL            mIsLeftAhead;
    BOOL            mIsLanded;
    CGFloat         mSpeed;
    NSInteger       mTextureIndex;
    
    NSMutableArray *mTextureArray;
    NSMutableArray *mContentRectArray;
    CGRect          mContentRect;    
    
    TBWeaponType    mSelectedWeapon;
    NSInteger       mVulcanDelay;
    NSInteger       mBulletCount;
    NSInteger       mBombCount;
    NSInteger       mMissileCount;
    BOOL            mIsVulcanFire;
    BOOL            mIsBombDrop;
    BOOL            mIsMissileLaunch;
    
    PBSoundSource  *mSoundSource;
    PBSoundSource  *mVulcanSoundSource;
}


@synthesize controlLever    = mControlLever;
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
        
        mControlLever    = [[TBControlLever alloc] initWithHelicopter:self];
        
        mTick            = 0;
        
        mIsLeftAhead     = (aTeam == kTBTeamAlly) ? NO : YES;
        mSpeed           = 0;
        mTextureIndex    = (aTeam == kTBTeamAlly) ? 8 : 0;
        
        mTextureArray    = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < 9; i++)
        {
            [mTextureArray addObject:[NSString stringWithFormat:@"heli%02d.png", i]];
        }
        
        PBTexture *sTexture = [PBTextureManager textureWithImageName:[mTextureArray objectAtIndex:mTextureIndex]];
        [sTexture loadIfNeeded];
        [self setTexture:sTexture];
        
        mContentRectArray = [[NSMutableArray alloc] init];
        [mContentRectArray addObject:[NSValue valueWithCGRect:CGRectMake(12, 4, 72, 28)]];    // 0
        [mContentRectArray addObject:[NSValue valueWithCGRect:CGRectMake(12, 4, 72, 28)]];    // 1
        [mContentRectArray addObject:[NSValue valueWithCGRect:CGRectMake(19, 7, 46, 24)]];    // 2
        [mContentRectArray addObject:[NSValue valueWithCGRect:CGRectMake(21, 7, 32, 24)]];    // 3
        [mContentRectArray addObject:[NSValue valueWithCGRect:CGRectMake(28, 6, 32, 25)]];    // 4
        [mContentRectArray addObject:[NSValue valueWithCGRect:CGRectMake(37, 7, 32, 25)]];    // 5
        [mContentRectArray addObject:[NSValue valueWithCGRect:CGRectMake(16, 7, 48, 25)]];    // 6
        [mContentRectArray addObject:[NSValue valueWithCGRect:CGRectMake(0, 6, 79, 26)]];     // 7
        [mContentRectArray addObject:[NSValue valueWithCGRect:CGRectMake(0, 6, 79, 26)]];     // 8
        
        mBulletCount     = MAX_BULLETS;
        mBombCount       = MAX_BOMBS;
        mMissileCount    = MAX_MISSILE;
        mIsVulcanFire    = NO;
        mIsBombDrop      = NO;
        mIsMissileLaunch = NO;
        
        mIsLanded        = YES;
        
        PBSoundManager *sSoundManager = [PBSoundManager sharedManager];
        
        mSoundSource = [sSoundManager retainSoundSource];
        [mSoundSource setSound:[sSoundManager soundForKey:kTBSoundHeli]];
        [mSoundSource setDistance:1];
        [mSoundSource setLooping:YES];
        [mSoundSource play];
        
        mVulcanSoundSource = [sSoundManager retainSoundSource];
        [mVulcanSoundSource setSound:[sSoundManager soundForKey:kTBSoundVulcan]];
        [mVulcanSoundSource setDistance:1];
        [mVulcanSoundSource setLooping:YES];
    }
    
    return self;
}


- (void)dealloc
{
    [mControlLever release];
    
    [mTextureArray     release];
    [mContentRectArray release];

    [[PBSoundManager sharedManager] releaseSoundSource:mSoundSource];
    [[PBSoundManager sharedManager] releaseSoundSource:mVulcanSoundSource];
    
    [super dealloc];
}


- (CGRect)contentRect
{
    return mContentRect;
}


- (void)setPoint:(CGPoint)aPoint
{
    [super setPoint:aPoint];
    
    CGSize sSize     = [[self mesh] size];
    CGRect sContRect = [[mContentRectArray objectAtIndex:mTextureIndex] CGRectValue];

    mContentRect.origin.x    = aPoint.x - ((sSize.width  - 30) / 2);
    mContentRect.origin.y    = aPoint.y - ((sSize.height - 30) / 2);

    mContentRect.origin.x   += sContRect.origin.x;
    mContentRect.origin.y   -= sContRect.size.height;
    mContentRect.size.width  = sContRect.size.width;
    mContentRect.size.height = sContRect.size.height;
}


- (void)setDelegate:(id)aDelegate
{
    [super setDelegate:aDelegate];
    
    [[self delegate] helicopterWeaponDidReload:self];
}


- (void)addDamage:(NSInteger)aDamage
{
    if (mDamage < mDurability)
    {
        [super addDamage:aDamage];
        
        [[self delegate] helicopterDamageChanged:self];

        if (mDamage >= mDurability)
        {
            [[self delegate] helicopterDidDestroy:self];
        }
    }
}


#pragma mark -


#define kSpeedSensitivitiy   20.0
#define kAltitudeSensitivity 30.0


- (void)setSpeedLever:(CGFloat)aSpeedLever
{
    CGFloat sDegree = aSpeedLever * -50;
    CGPoint sPoint  = [self point];
    
    if (aSpeedLever > 0.1 || aSpeedLever < -0.1)
    {
        mSpeed -= aSpeedLever * 2;
        mSpeed  = (mSpeed >  10.0) ?  10.0 : mSpeed;
        mSpeed  = (mSpeed < -10.0) ? -10.0 : mSpeed;
    }

    mSpeed -= (mSpeed > 0.0) ? 0.04 : 0.0;
    mSpeed += (mSpeed < 0.0) ? 0.04 : 0.0;
    
    if (!mIsLanded && ([self point].y - [[self mesh] size].height) > kMapGround) //  TODO : 헬기가 땅에 크래쉬하는걸 구현하려면 뒷부분 수정
    {
        sPoint.x += mSpeed;

        [[self transform] setAngle:PBVertex3Make(0, 0, sDegree)];
        
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
        [[self transform] setAngle:PBVertex3Make(0, 0, 0)];
    }
    
    sPoint.x = (sPoint.x < kMinMapXPos) ? kMinMapXPos : sPoint.x;
    sPoint.x = (sPoint.x > kMaxMapXPos) ? kMaxMapXPos : sPoint.x;
    
    [self setPoint:sPoint];
}


- (void)setAltitudeLever:(CGFloat)aAltitudeLever
{
    CGFloat sAltitudeLever = (aAltitudeLever + 0.68) * kAltitudeSensitivity;
    CGPoint sPoint         = [self point];
    CGSize  sMeshSize      = [[self mesh] size];

    sPoint.y -= sAltitudeLever;

    if ((sPoint.y - (sMeshSize.height / 2)) < kMapGround)
    {
        mIsLanded   = YES;
        sPoint.y = kMapGround + sMeshSize.height / 2;
    }
    else if (sPoint.y > 300)
    {
        sPoint.y = 300;
        mIsLanded = NO;
    }
    else
    {
        mIsLanded = NO;
    }

    [self setPoint:sPoint];
}


- (void)setFireVulcan:(BOOL)aFlag
{
    mIsVulcanFire = aFlag;

    if (mIsVulcanFire)
    {
        mVulcanDelay = 0;
        [mVulcanSoundSource play];
    }
    else
    {
        [mVulcanSoundSource stop];
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
        [[self delegate] helicopterDamageChanged:self];
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
        [[self delegate] helicopterWeaponDidReload:self];
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
        
        [[self delegate] helicopterWeaponDidReload:self];
        [TBMoneyManager useMoney:kTBPriceBomb];
    }
}


- (BOOL)isVulcanFiring
{
    return mIsVulcanFire;
}


- (void)dropBomb
{
    if (mBombCount > 0)
    {
        CGPoint sPoint = [self point];
        
        [TBWarheadManager bombWithTeam:kTBTeamAlly position:CGPointMake(sPoint.x, sPoint.y - 10) speed:mSpeed];
        mBombCount--;
        
        [[self delegate] helicopter:self weaponFired:1];
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
            PBVertex3 sAngle3 = [[self transform] angle];
            
            sAngle = TBDegreesToRadians(sAngle3.z);
            sPos1  = [self point];
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
            
            sAngle = -sAngle;
            sBulletPos.x = sPos1.x + (sPos2.x - sPos1.x) * cos(sAngle) - (sPos2.y - sPos1.y) * sin(sAngle);
            sBulletPos.y = sPos1.y + (sPos2.x - sPos1.x) * sin(sAngle) + (sPos2.y - sPos1.y) * cos(sAngle);

            CGPoint sVector = CGPointMake((sBulletPos.x - sPos1.x) / 3.5, (sBulletPos.y - sPos2.y) / 3.5);
            sBullet = [TBWarheadManager bulletWithTeam:kTBTeamAlly position:sBulletPos vector:sVector destructivePower:kVulcanBulletPower];
            [sBullet setLife:100];
            mBulletCount--;
            
            [[self delegate] helicopter:self weaponFired:0];
        }

        if (mBulletCount == 0)
        {
            [self setFireVulcan:NO];
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
    
    NSString  *sTextureName = [mTextureArray objectAtIndex:mTextureIndex];
    PBTexture *sTexture     = [PBTextureManager textureWithImageName:sTextureName];
    
    [sTexture loadIfNeeded];
    [self setTexture:sTexture];
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
