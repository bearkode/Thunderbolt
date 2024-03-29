/*
 *  TBLandingPad.m
 *  Thunderbolt
 *
 *  Created by bearkode on 10. 3. 6..
 *  Copyright 2010 tinybean. All rights reserved.
 *
 */

#import "TBLandingPad.h"
#import "TBTextureNames.h"
#import "TBUnitManager.h"
#import "TBHelicopter.h"


@implementation TBLandingPad
{
    NSUInteger mFillUpCount;
}


#pragma mark -


- (id)initWithTeam:(TBTeam)aTeam
{
    self = [super initWithTeam:aTeam];
    
    if (self)
    {
        [self setTexture:[PBTextureManager textureWithImageName:kTexLandingPad00]];
        [self setTileSize:[self textureSize]];
        [self setDurability:kLandingPadDurability];
        
        mFillUpCount = 0;
    }
    
    return self;
}


- (void)dealloc
{
    [super dealloc];
}


#pragma mark -


- (void)action
{
    [super action];
    
    if (![self isDestroyed])
    {
        if (mFillUpCount == 0)
        {
            TBHelicopter *sHelicopter = ([self team] == kTBTeamAlly) ? [[TBUnitManager sharedManager] allyHelicopter] : [[TBUnitManager sharedManager] enemyHelicopter];
            
            if ([self intersectWith:sHelicopter])
            {
                [sHelicopter repairDamage:kLandingPadRepairDamage];
                [sHelicopter fillUpAmmos];
            }
            
            mFillUpCount = 40;
        }
        else
        {
            mFillUpCount--;
        }
    }
}


@end
