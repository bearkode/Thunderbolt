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
#import "TBTextureNames.h"

#import "TBGatlingGun.h"
#import "TBBombChamber.h"

#import "TBBullet.h"
#import "TBBomb.h"

#import "TBWarheadManager.h"
#import "TBMoneyManager.h"

#import "TBHelicopterInfo.h"


const NSUInteger kHardPointCount      = 2;

const NSUInteger kMaxBullets          = 100;
const NSInteger  kMaxBombs            = 5;
const NSInteger  kMaxMissiles         = 2;

const CGFloat    kAltitudeSensitivity = 7.0;


#pragma mark -


@implementation TBHelicopter
{
    PBSpriteNode   *mTailRotor;
    CGFloat         mRotorAngle;
    
    id              mDelegate;
    TBControlLever *mControlLever;
    
    NSInteger       mTick;
    
    BOOL            mLeftAhead;
    BOOL            mLanded;
    CGFloat         mSpeed;
    NSInteger       mTextureIndex;
    CGRect          mContentRect;
    
    NSMutableArray *mHardPoints;
    TBWeapon       *mSelectedWeapon;
    NSInteger       mBombCount;
    NSInteger       mMissileCount;
    
    TBHelicopterInfo *mInfo;
    
    PBSoundSource  *mSoundSource;
}


@synthesize delegate        = mDelegate;
@synthesize controlLever    = mControlLever;
@synthesize leftAhead       = mLeftAhead;
@synthesize landed          = mLanded;
@synthesize speed           = mSpeed;
@synthesize selectedWeapon  = mSelectedWeapon;


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


- (void)setupTailRotor
{
    PBTexture *sRotorTexture = [PBTextureManager textureWithImageName:@"TailRotor"];
    [sRotorTexture loadIfNeeded];
    
    mTailRotor = [[[PBSpriteNode alloc] init] autorelease];
    [mTailRotor setTexture:sRotorTexture];
    [mTailRotor setHidden:YES];
    [self addSubNode:mTailRotor];

    mRotorAngle = 0;
}


#pragma mark -


- (id)initWithUnitID:(NSNumber *)aUnitID team:(TBTeam)aTeam info:(TBHelicopterInfo *)aInfo
{
    self = [super initWithUnitID:aUnitID team:aTeam];

    if (self)
    {
        [self setType:kTBUnitHelicopter];
        [self setDurability:kHelicopterDurability];
        [self setupTailRotor];
        
        mControlLever = [[TBControlLever alloc] initWithHelicopter:self];
        mLeftAhead    = (aTeam == kTBTeamAlly) ? NO : YES;
        mLanded       = YES;
        mSpeed        = 0;
        mTick         = 0;
        mTextureIndex = (aTeam == kTBTeamAlly) ? 0 : 23;
        
        PBTexture *sTexture = [PBTextureManager textureWithImageName:[aInfo imageName]];
        [self setTexture:sTexture];
        [self setTileSize:[aInfo tileSize]];
        
        /*  Arm  */
        [self setupHardPoints];
        
        mSoundSource = [[PBSoundManager sharedManager] retainSoundSource];
        [mSoundSource setSound:[[PBSoundManager sharedManager] soundForKey:[aInfo soundName]]];
        [mSoundSource setDistance:1];
        [mSoundSource setLooping:YES];
        
        mInfo = [aInfo retain];
    }
    
    return self;
}


- (void)dealloc
{
    [mControlLever release];
    
    [mHardPoints release];

    [[PBSoundManager sharedManager] releaseSoundSource:mSoundSource];
    [mInfo release];
    
    [super dealloc];
}


- (CGRect)contentRect
{
    return mContentRect;
}


- (void)setPoint:(CGPoint)aPoint
{
    [super setPoint:aPoint];
    
    CGSize sSize = [self tileSize];

    mContentRect.origin.x    = aPoint.x - (sSize.width / 2);
    mContentRect.origin.y    = aPoint.y - (sSize.height / 2);
    mContentRect.size.width  = sSize.width;
    mContentRect.size.height = sSize.height;
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


- (void)setEnableSound:(BOOL)aFlag
{
    if (aFlag)
    {
        [mSoundSource play];
    }
    else
    {
        [mSoundSource stop];
    }
}


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
    
    CGSize sSize = [self tileSize];
    
    if (!mLanded && (aPoint.y - sSize.height) > kMapGround) //  TODO : 헬기가 땅에 크래쉬하는걸 구현하려면 뒷부분 수정
    {
        aPoint.x += mSpeed;

        [self setAngle:PBVertex3Make(0, 0, sDegree)];
        
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
        [self setAngle:PBVertex3Make(0, 0, 0)];
    }
    
    aPoint.x = (aPoint.x < kMinMapXPos) ? kMinMapXPos : aPoint.x;
    aPoint.x = (aPoint.x > kMaxMapXPos) ? kMaxMapXPos : aPoint.x;
    
    return aPoint;
}


- (CGPoint)pointWithAltitudeLever:(CGFloat)aAltitudeLever oldPoint:(CGPoint)aPoint
{
    CGFloat sAltitudeLever = aAltitudeLever * kAltitudeSensitivity;
    CGSize  sSize          = [self tileSize];

    aPoint.y += sAltitudeLever;

    if ((aPoint.y - (sSize.height / 2)) < kMapGround)
    {
        mLanded  = YES;
        [mSelectedWeapon setFire:NO];
        aPoint.y = kMapGround + sSize.height / 2;
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
        if ([TBMoneyManager useMoney:kTBPriceRepair])
        {
            [self repair:aValue];
            [[self delegate] helicopterDamageChanged:self];
        }
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


- (void)updateTailRotor
{
    mRotorAngle += 34;
    if (mRotorAngle > 360)
    {
        mRotorAngle -= 360;
    }

    [mTailRotor setAngle:PBVertex3Make(0, 0, mRotorAngle)];
    

    if ([mTailRotor hidden])
    {
        CGPoint sPoint = [mInfo tailRotorPosition];
        
        if (mTextureIndex == 0 || mTextureIndex == 1)
        {
            sPoint.x = -sPoint.x;
            [mTailRotor setHidden:NO];
            [mTailRotor setPoint:sPoint];
        }
        else if (mTextureIndex == 23 || mTextureIndex == 24)
        {
            [mTailRotor setHidden:NO];
            [mTailRotor setPoint:sPoint];
        }
    }
    else
    {
        if (mTextureIndex != 0 && mTextureIndex != 1 && mTextureIndex != 23 && mTextureIndex != 24)
        {
            [mTailRotor setHidden:YES];
        }
    }
}


- (void)action
{
    [super action];
    [self updateTailRotor];
    
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
        if (!mLeftAhead)
        {
            if (mTextureIndex > 1)
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
            if (mTextureIndex < 23)
            {
                mTextureIndex++;
            }
            else
            {
                mTextureIndex = (mTextureIndex == 23) ? 24 : 23;
            }
        }
        
        [self selectTileAtIndex:mTextureIndex];
    }
}


@end
