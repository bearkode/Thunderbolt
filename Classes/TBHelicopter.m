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

#import "TBGatlingGun.h"
#import "TBBombChamber.h"

#import "TBBullet.h"
#import "TBBomb.h"

#import "TBWarheadManager.h"
#import "TBMoneyManager.h"


const NSUInteger kHardPointCount      = 2;

const NSUInteger kMaxBullets          = 100;
const NSInteger  kMaxBombs            = 5;
const NSInteger  kMaxMissiles         = 2;

const CGFloat    kAltitudeSensitivity = 15.0;


#pragma mark -


@implementation TBHelicopter
{
    id              mDelegate;
    TBControlLever *mControlLever;
    
    NSInteger       mTick;
    
    BOOL            mLeftAhead;
    BOOL            mLanded;
    CGFloat         mSpeed;
    NSInteger       mTextureIndex;
    
    NSMutableArray *mTextureArray;
    NSMutableArray *mContentRectArray;
    CGRect          mContentRect;    
    
    NSMutableArray *mHardPoints;
    TBWeapon       *mSelectedWeapon;
    NSInteger       mBombCount;
    NSInteger       mMissileCount;
    
    PBSoundSource  *mSoundSource;
}


@synthesize delegate        = mDelegate;
@synthesize controlLever    = mControlLever;
@synthesize leftAhead       = mLeftAhead;
@synthesize landed          = mLanded;
@synthesize speed           = mSpeed;
@synthesize selectedWeapon  = mSelectedWeapon;
//@synthesize bulletCount     = mBulletCount;
//@synthesize bombCount       = mBombCount;
//@synthesize missileCount    = mMissileCount;
//@synthesize fireVulcan      = mFireVulcan;


#pragma mark -


- (void)setupHardPoints
{
    mHardPoints = [[NSMutableArray alloc] initWithCapacity:kHardPointCount];
    
    TBGatlingGun *sGatlingGun = [[[TBGatlingGun alloc] init] autorelease];
    [sGatlingGun setBody:self];
    [sGatlingGun setMaxAmmoCount:kMaxBullets];
    [sGatlingGun supplyAmmo:kSupplyAmmoToMax];
    [mHardPoints addObject:sGatlingGun];
    
    TBBombChamber *sBombChamber = [[[TBBombChamber alloc] init] autorelease];
    [sBombChamber setBody:self];
    [sBombChamber setMaxAmmoCount:kMaxBombs];
    [sBombChamber supplyAmmo:kSupplyAmmoToMax];
    [mHardPoints addObject:sBombChamber];
    
    mSelectedWeapon = sGatlingGun;
}


#pragma mark -


- (id)initWithUnitID:(NSNumber *)aUnitID team:(TBTeam)aTeam
{
    self = [super initWithUnitID:aUnitID team:aTeam];

    if (self)
    {
        [self setType:kTBUnitHelicopter];
        [self setDurability:kHelicopterDurability];
        
        mControlLever = [[TBControlLever alloc] initWithHelicopter:self];
        
        mTick         = 0;
        
        mLeftAhead    = (aTeam == kTBTeamAlly) ? NO : YES;
        mSpeed        = 0;
        mTextureIndex = (aTeam == kTBTeamAlly) ? 8 : 0;
        
        mTextureArray = [[NSMutableArray alloc] init];
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
        
        /*  Arm  */
        [self setupHardPoints];
        
//        mBulletCount     = kMaxBullets;
//        mBombCount       = kMaxBombs;
//        mMissileCount    = kMaxMissiles;
//        mFireVulcan      = NO;
        mLanded          = YES;
        
        mSoundSource = [[PBSoundManager sharedManager] retainSoundSource];
        [mSoundSource setSound:[[PBSoundManager sharedManager] soundForKey:kTBSoundHeli]];
        [mSoundSource setDistance:1];
        [mSoundSource setLooping:YES];
        [mSoundSource play];
    }
    
    return self;
}


- (void)dealloc
{
    [mControlLever release];
    
    [mTextureArray release];
    [mContentRectArray release];
    
    [mHardPoints release];

    [[PBSoundManager sharedManager] releaseSoundSource:mSoundSource];
    
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


- (void)addDamage:(NSInteger)aDamage
{
    if ([self isAvailable])
    {
        [super addDamage:aDamage];
        
        [[self delegate] helicopterDamageChanged:self];

        if (![self isAvailable])
        {
            [[self delegate] helicopterDidDestroy:self];
        }
    }
}


#pragma mark -


- (CGPoint)pointWithSpeedLever:(CGFloat)aSpeedLever oldPoint:(CGPoint)aPoint
{
    CGFloat sDegree = aSpeedLever * -50;
    
    if (aSpeedLever > 0.1 || aSpeedLever < -0.1)
    {
        mSpeed -= aSpeedLever * 1;
        mSpeed  = (mSpeed >  5.0) ?  5.0 : mSpeed;
        mSpeed  = (mSpeed < -5.0) ? -5.0 : mSpeed;
    }

    mSpeed -= (mSpeed > 0.0) ? 0.04 : 0.0;
    mSpeed += (mSpeed < 0.0) ? 0.04 : 0.0;
    
    if (!mLanded && (aPoint.y - [[self mesh] size].height) > kMapGround) //  TODO : 헬기가 땅에 크래쉬하는걸 구현하려면 뒷부분 수정
    {
        aPoint.x += mSpeed;

        [[self transform] setAngle:PBVertex3Make(0, 0, sDegree)];
        
        if (mSpeed > 0)
        {
            if (mLeftAhead == YES)
            {
                mLeftAhead = NO;
            }
        }
        else
        {
            if (mLeftAhead == NO)
            {
                mLeftAhead = YES;
            }
        }
    }
    else
    {
        mSpeed = 0;
        [[self transform] setAngle:PBVertex3Make(0, 0, 0)];
    }
    
    aPoint.x = (aPoint.x < kMinMapXPos) ? kMinMapXPos : aPoint.x;
    aPoint.x = (aPoint.x > kMaxMapXPos) ? kMaxMapXPos : aPoint.x;
    
    return aPoint;
}


- (CGPoint)pointWithAltitudeLever:(CGFloat)aAltitudeLever oldPoint:(CGPoint)aPoint
{
    CGFloat sAltitudeLever = (aAltitudeLever + 0.68) * kAltitudeSensitivity;
    CGSize  sMeshSize      = [[self mesh] size];

    aPoint.y -= sAltitudeLever;

    if ((aPoint.y - (sMeshSize.height / 2)) < kMapGround)
    {
        mLanded  = YES;
        [mSelectedWeapon setFire:NO];
        aPoint.y = kMapGround + sMeshSize.height / 2;
    }
    else if (aPoint.y > 300)
    {
        aPoint.y = 300;
        mLanded = NO;
    }
    else
    {
        mLanded = NO;
    }

    return aPoint;
}


- (void)repairDamage:(NSInteger)aValue
{
    if ([self damage])
    {
        [self repair:aValue];
        [[self delegate] helicopterDamageChanged:self];
        [TBMoneyManager useMoney:kTBPriceRepair];
    }
}


- (void)fillUpAmmos
{
    [mHardPoints makeObjectsPerformSelector:@selector(fillUp)];
}


- (NSInteger)bulletCount
{
    for (TBWeapon *sWeapon in mHardPoints)
    {
        if ([sWeapon isKindOfClass:[TBGatlingGun class]])
        {
            return [sWeapon ammoCount];
        }
    }
    
    return 0;
}


- (NSInteger)bombCount
{
    for (TBWeapon *sWeapon in mHardPoints)
    {
        if ([sWeapon isKindOfClass:[TBBombChamber class]])
        {
            return [sWeapon ammoCount];
        }
    }
    
    return 0;
}


#pragma mark -


- (void)selectNextWeapon
{
    NSInteger sIndex = [mHardPoints indexOfObject:mSelectedWeapon];
    
    sIndex = (sIndex >= ([mHardPoints count] - 1)) ? 0 : (sIndex + 1);
    mSelectedWeapon = [mHardPoints objectAtIndex:sIndex];
}


- (void)setFire:(BOOL)aFire
{
    [mSelectedWeapon setFire:aFire];
}


- (void)action
{
    [super action];
    
    if (![self isLanded])
    {
        [mSelectedWeapon action];
    }
  
    if (++mTick == 100)
    {
        mTick = 0;
    }
    
    if ((mTick % 2) == 0)
    {
        if (mLeftAhead)
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


@end
