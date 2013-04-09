/*
 *  TBSoldier.m
 *  Thunderbolt
 *
 *  Created by bearkode on 10. 7. 22..
 *  Copyright 2010 Tinybean. All rights reserved.
 *
 */

#import "TBSoldier.h"
#import "TBRifle.h"
#import "TBUnitManager.h"


@implementation TBSoldier


- (id)initWithUnitID:(NSNumber *)aUnitID team:(TBTeam)aTeam
{
    self = [super initWithUnitID:aUnitID team:aTeam];
    
    if (self)
    {
        [self setType:kTBUnitSoldier];
        [self setDurability:kSoldierDurability];
        [self setPoint:CGPointMake(kMaxMapXPos + 50, 53)];
        
        mTick         = 1;
        mTextureArray = [[NSMutableArray alloc] init];
        [mTextureArray addObject:[NSString stringWithFormat:@"em00.png"]];
        [mTextureArray addObject:[NSString stringWithFormat:@"em01.png"]];
        [mTextureArray addObject:[NSString stringWithFormat:@"em02.png"]];
        [mTextureArray addObject:[NSString stringWithFormat:@"em03.png"]];
        [mTextureArray addObject:[NSString stringWithFormat:@"em04.png"]];
        [mTextureArray addObject:[NSString stringWithFormat:@"em05.png"]];
        [mTextureArray addObject:[NSString stringWithFormat:@"em06.png"]];
        
        mRifle = [[TBRifle alloc] initWithBody:self team:aTeam];
    }
    
    return self;
}


- (void)dealloc
{
    [mTextureArray release];
    [mRifle        release];
    
    [super dealloc];
}


- (void)action
{
    CGFloat sAngle;
    TBUnit *sUnit;
    BOOL    sFire = NO;
    
    [super action];
    [mRifle action];
    
    sUnit = [[TBUnitManager sharedManager] opponentUnitOf:self inRange:kRifleMaxRange];
    if (sUnit)
    {
        sAngle = [self angleWith:sUnit];
        if ((sAngle >= -100.0 && sAngle <= -85.0) ||
            (sAngle <= 100.0 && sAngle >= 85.0))
        {
            [mRifle fireAt:sUnit];
            sFire = YES;
        }
    }

    if (!sFire)
    {
        CGPoint sPoint = [self point];
        sPoint.x += ([self isAlly]) ? 1.0 : -1.0;
        [self setPoint:sPoint];
    }
}


- (void)draw
{
    mTick = (mTick == 24) ? 0 : mTick + 1;
    
    PBTexture *sTexture = [mTextureArray objectAtIndex:(NSUInteger)(mTick / 5) + 1];

    [self setTexture:sTexture];
//    [self setTextureID:[sInfo textureID]];
//    [self setTextureSize:[sInfo textureSize]];
//    [self setContentSize:[sInfo contentSize]];
//    
//    [super draw];
}


@end
