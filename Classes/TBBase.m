/*
 *  TBBase.m
 *  Thunderbolt
 *
 *  Created by bearkode on 10. 3. 5..
 *  Copyright 2010 tinybean. All rights reserved.
 *
 */

#import "TBBase.h"
#import "TBTextureNames.h"
#import "TBUnitManager.h"
#import "TBWarheadManager.h"
#import "TBHelicopter.h"

#import "TBVulcan.h"
#import "TBMissileLauncher.h"


@implementation TBBase
{
    NSUInteger         mTextureIndex;
    NSArray           *mTextureKeys;
    
    TBVulcan          *mVulcan;
    TBMissileLauncher *mMissileLauncher;
}


#pragma mark -


- (id)initWithTeam:(TBTeam)aTeam
{
    self = [super initWithTeam:aTeam];

    if (self)
    {
        [self setDurability:kBaseDurability];
        
        
        PBTexture *sTexture = [PBTextureManager textureWithImageName:kTexBase00];
        [sTexture loadIfNeeded];
        [self setTexture:sTexture];

        mTextureIndex    = 0;
        mTextureKeys     = [[NSArray alloc] initWithObjects:kTexBase00, kTexBase00, kTexBase00, kTexBase00, kTexBase00,
                                                            kTexBase01, kTexBase01, kTexBase01, kTexBase01, kTexBase01,
                                                            kTexBase02, kTexBase02, kTexBase02, kTexBase02, kTexBase02,
                                                            kTexBase03, kTexBase03, kTexBase03, kTexBase03, kTexBase03,
                                                            kTexBase04, kTexBase04, kTexBase04, kTexBase04, kTexBase04,
                                                            kTexBase05, kTexBase05, kTexBase05, kTexBase05, kTexBase05,
                                                            kTexBase06, kTexBase06, kTexBase06, kTexBase06, kTexBase06,
                                                            kTexBase07, kTexBase07, kTexBase07, kTexBase07, kTexBase07, nil];
        
        mVulcan        = [[TBVulcan alloc] init];
        mMissileLauncher = [[TBMissileLauncher alloc] init];
        
        [mVulcan setBody:self];
        [mMissileLauncher setBody:self];
    }
    
    return self;
}


- (void)dealloc
{
    [mTextureKeys     release];
    [mVulcan        release];
    [mMissileLauncher release];
    
    [super dealloc];
}


- (void)action
{
    [super action];
    
    if (![self isDestroyed])
    {
        NSString  *sTextureName = [mTextureKeys objectAtIndex:mTextureIndex];
        PBTexture *sTexture     = [PBTextureManager textureWithImageName:sTextureName];
        
        if ([self texture] != sTexture)
        {
            [sTexture loadIfNeeded];
            [self setTexture:sTexture];
        }
        
        if (++mTextureIndex >= [mTextureKeys count])
        {
            mTextureIndex = 0;
        }
        
        TBUnit *sTarget = ([self team] == kTBTeamAlly) ? [[TBUnitManager sharedManager] enemyHelicopter] : [[TBUnitManager sharedManager] allyHelicopter];
        [mVulcan action];
        [mMissileLauncher action];
        
#if (0)
        if (sTarget)
        {
            if ([mAAVulcan fireAt:sTarget])
            {
                [mAAVulcan supplyAmmo:1];
            }
        }
#else
        if (sTarget)
        {
            if ([mMissileLauncher fireAt:sTarget])
            {
                NSLog(@"missile fire = %d", [self team]);
                [mMissileLauncher supplyAmmo:1];
            }
        }
    }
#endif
}


@end
