/*
 *  TBRifleman.m
 *  Thunderbolt
 *
 *  Created by bearkode on 10. 7. 22..
 *  Copyright 2010 Tinybean. All rights reserved.
 *
 */

#import "TBRifleman.h"
#import "TBTextureNames.h"
#import "TBRifle.h"
#import "TBUnitManager.h"


const CGFloat kSoldierSpeed = 0.5;


#pragma mark -


@implementation TBRifleman
{
    NSUInteger mTick;
    NSUInteger mIndex;
    TBRifle   *mRifle;
}


#pragma mark -


+ (Class)meshClass
{
    return [PBTileMesh class];
}


- (void)setupTexture
{
    [(PBTileMesh *)[self mesh] setTileSize:CGSizeMake(21, 21)];
    
    PBTexture *sTexture = [PBTextureManager textureWithImageName:kTexRifleman];
    [sTexture loadIfNeeded];
    [self setTexture:sTexture];
    
    mTick  = 0;
    mIndex = 0;
}


- (void)setupAttrs
{
    [self setType:kTBUnitSoldier];
    [self setDurability:kSoldierDurability];
    [self setPoint:CGPointMake(kMaxMapXPos + 50, 51)];
    
    mRifle = [[TBRifle alloc] init];
    [mRifle setBody:self];
}


#pragma mark -


- (id)initWithUnitID:(NSNumber *)aUnitID team:(TBTeam)aTeam
{
    self = [super initWithUnitID:aUnitID team:aTeam];
    
    if (self)
    {
        [self setupAttrs];
        [self setupTexture];
    }
    
    return self;
}


- (void)dealloc
{
    [mRifle release];
    
    [super dealloc];
}


#pragma mark -


- (void)action
{
    [super action];
    
    BOOL sFire = NO;
    
    [mRifle action];
    
    TBUnit *sUnit = [[TBUnitManager sharedManager] opponentUnitOf:self inRange:kRifleMaxRange];
    if (sUnit)
    {
        CGFloat sAngle = [self angleWith:sUnit];
        
        if ((sAngle >= -100.0 && sAngle <= -85.0) ||
            (sAngle <= 100.0 && sAngle >= 85.0))
        {
            [mRifle fireAt:sUnit];
            sFire = YES;
        }
    }

    if (sFire)
    {
        [(PBTileMesh *)[self mesh] selectTileAtIndex:12];
    }
    else
    {
        [self moveWithVector:CGPointMake(([self isAlly]) ? kSoldierSpeed : -kSoldierSpeed, 0)];
        [(PBTileMesh *)[self mesh] selectTileAtIndex:mIndex];
    }
    
    if (mTick++ == 1)
    {
        mTick = 0;
        mIndex = (mIndex > 10) ? 0 : (mIndex + 1);
    }
}


@end
