/*
 *  TBBase.m
 *  Thunderbolt
 *
 *  Created by jskim on 10. 3. 5..
 *  Copyright 2010 tinybean. All rights reserved.
 *
 */

#import "TBBase.h"
#import "TBTextureNames.h"
#import "TBTextureManager.h"
#import "TBUnitManager.h"
#import "TBWarheadManager.h"
#import "TBHelicopter.h"

#import "TBAAVulcan.h"
#import "TBMissileLauncher.h"


@implementation TBBase


#pragma mark -


- (id)initWithTeam:(TBTeam)aTeam
{
    self = [super initWithTeam:aTeam];

    if (self)
    {
        [self setDurability:kBaseDurability];
        
        
        PBTexture *sTexture = [PBTextureManager textureWithImageName:kTexBase00];
        [self setTexture:sTexture];

        mTextureIndex    = 0;
        mTextureKeys     = [[NSArray alloc] initWithObjects:kTexBase00, kTexBase00, kTexBase00,
                                                            kTexBase01, kTexBase01, kTexBase01,
                                                            kTexBase02, kTexBase02, kTexBase02,
                                                            kTexBase03, kTexBase03, kTexBase03,
                                                            kTexBase04, kTexBase04, kTexBase04,
                                                            kTexBase05, kTexBase05, kTexBase05,
                                                            kTexBase06, kTexBase06, kTexBase06,
                                                            kTexBase07, kTexBase07, kTexBase07, nil];
        
        mAAVulcan        = [[TBAAVulcan alloc] initWithBody:self team:aTeam];
        mMissileLauncher = [[TBMissileLauncher alloc] initWithBody:self team:aTeam];
    }
    
    return self;
}


- (void)dealloc
{
    [mTextureKeys     release];
    [mAAVulcan        release];
    [mMissileLauncher release];
    
    [super dealloc];
}


- (void)action
{
    [super action];
    
    if (![self isDestroyed])
    {
        PBTexture *sTexture = [PBTextureManager textureWithImageName:[mTextureKeys objectAtIndex:mTextureIndex]];
        [self setTexture:sTexture];
        
        mTextureIndex++;
        if (mTextureIndex == 22)
        {
            mTextureIndex = 0;
        }
        
        TBUnit *sTarget;
        
        sTarget = (mTeam == kTBTeamAlly) ? [[TBUnitManager sharedManager] enemyHelicopter] : [[TBUnitManager sharedManager] allyHelicopter];
        
        [mAAVulcan action];
        [mMissileLauncher action];
        
        /*    if (sTarget)
         {
         if ([mAAVulcan fireAt:sTarget])
         {
         [mAAVulcan supplyAmmo:1];
         }
         }*/
        
        if (sTarget)
        {
            if ([mMissileLauncher fireAt:sTarget])
            {
                [mMissileLauncher supplyAmmo:1];
            }
        }
    }
}


@end
