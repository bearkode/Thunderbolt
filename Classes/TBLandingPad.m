//
//  TBLandingPad.m
//  Thunderbolt
//
//  Created by jskim on 10. 3. 6..
//  Copyright 2010 tinybean. All rights reserved.
//

#import "TBLandingPad.h"
#import "TBTextureNames.h"
#import "TBTextureManager.h"
#import "TBUnitManager.h"
#import "TBHelicopter.h"


@implementation TBLandingPad


- (id)initWithTeam:(TBTeam)aTeam
{
    TBTextureInfo *sInfo;
    
    self = [super initWithTeam:aTeam];
    if (self)
    {
        [self setDurability:kLandingPadDurability];
        
        sInfo = [TBTextureManager textureInfoForKey:kTexLandingPad00];
        [self setTextureID:[sInfo textureID]];
        [self setTextureSize:[sInfo textureSize]];
        [self setContentSize:[sInfo contentSize]];
        
        mFillUpCount = 0;
    }
    
    return self;
}


- (void)action
{
    [super action];
    
    if (![self isDestroyed])
    {
        TBHelicopter *sHelicopter = (mTeam == kTBTeamAlly) ? [[TBUnitManager sharedManager] allyHelicopter] : [[TBUnitManager sharedManager] enemyHelicopter];
        
        if (mFillUpCount == 0)
        {
            if ([self intersectWith:sHelicopter])
            {
                [sHelicopter repairDamage:kLandingPadRepairDamage];
                [sHelicopter fillUpBullets:kLandingPadFillUpBullets];
                [sHelicopter fillUpBombs:kLandingPadFillUpBombs];
            }
            mFillUpCount = 20;
        }
        else
        {
            mFillUpCount--;
        }
    }
}


@end
