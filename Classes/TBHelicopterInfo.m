/*
 *  TBHelicopterInfo.m
 *  Thunderbolt
 *
 *  Created by cgkim on 13. 4. 20..
 *  Copyright (c) 2013 Tinybean. All rights reserved.
 *
 */

#import "TBHelicopterInfo.h"
#import "TBGameConst.h"
#import "TBTextureNames.h"


@implementation TBHelicopterInfo
{
    CGSize    mTileSize;
    NSString *mImageName;
    NSString *mSoundName;
    CGPoint   mTailRotorPosition;

    /*  Load  */
    NSUInteger mMaxBullet;
    NSUInteger mMaxBomb;
    NSUInteger mMaxRocket;
    NSUInteger mMaxMissile;
    NSUInteger mMaxParatrooper;
    
    NSUInteger mMaxFlare;
    NSUInteger mMaxChaff;
    
    CGFloat    mMaxSpeed;
    CGFloat    mAltitudeSensitivity;
    NSUInteger mDurability;
}


@synthesize tileSize          = mTileSize;
@synthesize imageName         = mImageName;
@synthesize soundName         = mSoundName;
@synthesize tailRotorPosition = mTailRotorPosition;


#pragma mark -


- (id)init
{
    self = [super init];
    
    if (self)
    {
    
    }
    
    return self;
}


- (void)dealloc
{
    [mImageName release];
    [mSoundName release];
    
    [super dealloc];
}


#pragma mark -


+ (TBHelicopterInfo *)MD500Info
{
    TBHelicopterInfo *sInfo = [[[TBHelicopterInfo alloc] init] autorelease];
    
    [sInfo setTileSize:CGSizeMake(138 / 2, 56 / 2)];
    [sInfo setImageName:kTexMD500];
    [sInfo setSoundName:kTBSoundMD500];
    [sInfo setTailRotorPosition:CGPointMake(28, 5)];
    
    return sInfo;
}


+ (TBHelicopterInfo *)UH1Info
{
    TBHelicopterInfo *sInfo = [[[TBHelicopterInfo alloc] init] autorelease];
    
    [sInfo setTileSize:CGSizeMake(180 / 2, 56 / 2)];
    [sInfo setImageName:kTexUH1];
    [sInfo setSoundName:kTBSoundHeli];
    [sInfo setTailRotorPosition:CGPointMake(40, 5)];

    return sInfo;
}


+ (TBHelicopterInfo *)UH1NInfo
{
    TBHelicopterInfo *sInfo = [[[TBHelicopterInfo alloc] init] autorelease];
    
    [sInfo setTileSize:CGSizeMake(264 / 2, 54 / 2)];
    [sInfo setImageName:kTexUH1N];
    [sInfo setSoundName:kTBSoundHeli];
    [sInfo setTailRotorPosition:CGPointMake(47, 5)];
    
    return sInfo;
}


+ (TBHelicopterInfo *)AH1CobraInfo
{
    TBHelicopterInfo *sInfo = [[[TBHelicopterInfo alloc] init] autorelease];
    
    [sInfo setTileSize:CGSizeMake(224 / 2, 54 / 2)];
    [sInfo setImageName:kTexAH1];
    [sInfo setSoundName:kTBSoundHeli];
    [sInfo setTailRotorPosition:CGPointMake(50, 5)];

    return sInfo;
}


+ (TBHelicopterInfo *)AH1WSuperCobraInfo
{
    TBHelicopterInfo *sInfo = [[[TBHelicopterInfo alloc] init] autorelease];

    [sInfo setTileSize:CGSizeMake(234 / 2, 56 / 2)];
    [sInfo setImageName:kTexSuperCobra];
    [sInfo setSoundName:kTBSoundHeli];
    [sInfo setTailRotorPosition:CGPointMake(55, 6)];
    
    return sInfo;
}


@end
