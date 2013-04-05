/*
 *  TBGameController.m
 *  Thunderbolt
 *
 *  Created by bearkode on 10. 1. 26..
 *  Copyright 2010 tinybean. All rights reserved.
 *
 */

#import "TBGameController.h"
#import "TBGameConst.h"
#import "TBMacro.h"
#import "AppDelegate.h"
#import "TBGLView.h"

#import "TBTextureNames.h"
#import "TBTextureManager.h"
#import "TBBGMManager.h"
#import "TBALPlayback.h"

#import "TBMoneyManager.h"
#import "TBScoreManager.h"

#import "TBUnitManager.h"
#import "TBWarheadManager.h"
#import "TBExplosionManager.h"

#import "TBHelicopter.h"
#import "TBTank.h"
#import "TBBullet.h"
#import "TBBomb.h"
#import "TBMissile.h"
#import "TBExplosion.h"

#import "TBStructureManager.h"
#import "TBBase.h"
#import "TBLandingPad.h"
#import "TBAAGunSite.h"

#import "TBRadar.h"


@interface TBGameController (Privates)
@end


@implementation TBGameController (Privates)


- (void)makeNewAllyHelicopter
{
    if ([[TBMoneyManager sharedManager] sum] >= kTBPriceHelicopter)
    {
        [TBUnitManager helicopterWithTeam:kTBTeamAlly delegate:self];
        [TBMoneyManager useMoney:kTBPriceHelicopter];
    }
    else
    {
        [self performSelector:@selector(makeNewAllyHelicopter) withObject:nil afterDelay:3.0];
    }
}


- (void)removeDisabledSprite
{
    [[TBUnitManager sharedManager] removeDisabledUnits];
    [[TBWarheadManager sharedManager] removeDisabledSprite];
    [[TBExplosionManager sharedManager] removeFinishedExplosion];
}


@end


@implementation TBGameController


@synthesize GLView = mGLView;


#pragma mark -


- (void)setupStructures
{
    TBBase *sBase;
    sBase = [[TBBase alloc] initWithTeam:kTBTeamAlly];
    [sBase setPosition:CGPointMake(kMinMapXPos + 100, MAP_GROUND + 30)];
    [[TBStructureManager sharedManager] addStructure:sBase];
    
    sBase = [[TBBase alloc] initWithTeam:kTBTeamEnemy];
    [sBase setPosition:CGPointMake(kMaxMapXPos - 100, MAP_GROUND + 30)];
    [[TBStructureManager sharedManager] addStructure:sBase];
    
    TBLandingPad *sLandingPad;
    sLandingPad = [[TBLandingPad alloc] initWithTeam:kTBTeamAlly];
    [sLandingPad setPosition:CGPointMake(kMinMapXPos + 200, MAP_GROUND + 6)];
    [[TBStructureManager sharedManager] addStructure:sLandingPad];
    
    sLandingPad = [[TBLandingPad alloc] initWithTeam:kTBTeamEnemy];
    [sLandingPad setPosition:CGPointMake(kMaxMapXPos - 200, MAP_GROUND + 6)];
    [[TBStructureManager sharedManager] addStructure:sLandingPad];
    
    TBAAGunSite *sAAGunSite;
    sAAGunSite = [[TBAAGunSite alloc] initWithTeam:kTBTeamAlly];
    [sAAGunSite setPosition:CGPointMake(kMinMapXPos + 800, MAP_GROUND + 15)];
    [[TBStructureManager sharedManager] addStructure:sAAGunSite];
    
    sAAGunSite = [[TBAAGunSite alloc] initWithTeam:kTBTeamEnemy];
    [sAAGunSite setPosition:CGPointMake(kMaxMapXPos - 800, MAP_GROUND + 15)];
    [[TBStructureManager sharedManager] addStructure:sAAGunSite];
}


- (id)init
{
    TBTextureManager *sTextureMan;
    TBTextureInfo    *sInfo;
    
    self = [super init];
    if (self)
    {
        sTextureMan = [TBTextureManager sharedManager];
        [sTextureMan loadTextures];

        [self setupStructures];
        
        sInfo = [sTextureMan textureInfoForKey:kTexGreen];
         
        mStar0 = [[TBSprite alloc] init];
        [mStar0 setTextureID:[sInfo textureID]];
        [mStar0 setTextureSize:[sInfo textureSize]];
        [mStar0 setPosition:CGPointMake(kMinMapXPos, MAP_GROUND + ([sInfo contentSize].height / 2))];

        mStar1 = [[TBSprite alloc] init];
        [mStar1 setTextureID:[sInfo textureID]];
        [mStar1 setTextureSize:[sInfo textureSize]];
        [mStar1 setPosition:CGPointMake(kMaxMapXPos / 2, MAP_GROUND + ([sInfo contentSize].height / 2))];

        mStar2 = [[TBSprite alloc] init];
        [mStar2 setTextureID:[sInfo textureID]];
        [mStar2 setTextureSize:[sInfo textureSize]];
        [mStar2 setPosition:CGPointMake(kMaxMapXPos, MAP_GROUND + ([sInfo contentSize].height / 2))];
        
        mRadar = [[TBRadar alloc] init];
        
        [self makeNewAllyHelicopter];
        
        mBackPoint = 240;
        mTimeTick  = 0;
        
        [[UIAccelerometer sharedAccelerometer] setUpdateInterval:1.0 / 30.0];
        [[UIAccelerometer sharedAccelerometer] setDelegate:self];
        
        [[TBMoneyManager sharedManager] setDelegate:self];
        [[TBScoreManager sharedManager] setDelegate:self];
        
        [TBBGMManager startBGMWithVolume:0.5];
    }
    
    return self;
}


- (void)dealloc
{
    [mStar0 release];
    [mStar1 release];
    [mStar2 release];
    
    [mRadar release];
    
    [[TBMoneyManager sharedManager] setDelegate:nil];
    [[TBScoreManager sharedManager] setDelegate:nil];

    [super dealloc];
}


- (void)setGLView:(TBGLView *)aGLView
{
    mGLView = aGLView;

    [mGLView setDelegate:self];
  
    [[mGLView tankButton] addTarget:self action:@selector(tankButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [[mGLView ammoButton] addTarget:self action:@selector(ammoButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark -
#pragma mark Actions


- (IBAction)tankButtonTapped:(id)aSender
{
    if ([[TBMoneyManager sharedManager] sum] >= kTBPriceTank)
    {
        [TBUnitManager tankWithTeam:kTBTeamAlly];
        [TBMoneyManager useMoney:kTBPriceTank];
    }
}


- (IBAction)ammoButtonTapped:(id)aSender
{
    TBHelicopter *sHelicopter = [[TBUnitManager sharedManager] allyHelicopter];
    
    if ([sHelicopter selectedWeapon] == kWeaponVulcan)
    {
        [sHelicopter setSelectedWeapon:kWeaponBomb];
    }
    else
    {
        [sHelicopter setSelectedWeapon:kWeaponVulcan];
    }
}


#pragma mark -
#pragma mark Delegates


- (void)glViewRenderObjects:(TBGLView *)aGLView
{
    [[TBStructureManager sharedManager] doActions];
    
    [mStar0 draw];
    [mStar1 draw];
    [mStar2 draw];
    
    if (++mTimeTick == 30 * 10)
    {
        mTimeTick = 0;
        NSInteger sUnitType = rand() % 4;
        
        if (sUnitType == 0)
        {
            [TBUnitManager armoredVehicleWithTeam:kTBTeamEnemy];
        }
        else if (sUnitType == 1)
        {
            [TBUnitManager tankWithTeam:kTBTeamEnemy];
        }
        else
        {
            [TBUnitManager soldierWithTeam:kTBTeamEnemy];
        }
        
        [[TBMoneyManager sharedManager] saveMoney:10];
    }

    [self removeDisabledSprite];
    
    [[TBUnitManager sharedManager] doActions];
    [[TBWarheadManager sharedManager] doActions];
    [[TBExplosionManager sharedManager] doActions];
    
    /*  RADAR  */
    [mRadar drawAt:[mGLView xPos]];
}


- (void)glView:(TBGLView *)aGLView touchBegan:(CGPoint)aPoint
{
    TBHelicopter *sHelicopter = [[TBUnitManager sharedManager] allyHelicopter];
    
    if ([sHelicopter selectedWeapon] == kWeaponVulcan &&
        [sHelicopter bulletCount] > 0 &&
        ![sHelicopter isLanded])
    {
        [[TBALPlayback sharedPlayback] startSound:kTBSoundVulcan];
        [sHelicopter setFireVulcan:YES];
    }
}


- (void)glView:(TBGLView *)aGLView touchCancelled:(CGPoint)aPoint
{
    TBHelicopter *sHelicopter = [[TBUnitManager sharedManager] allyHelicopter];
    
    [[TBALPlayback sharedPlayback] stopSound:kTBSoundVulcan];    
    [sHelicopter setFireVulcan:NO];
}


- (void)glView:(TBGLView *)aGLView touchMoved:(CGPoint)aPoint
{

}


- (void)glView:(TBGLView *)aGLView touchEnded:(CGPoint)aPoint
{
    TBHelicopter *sHelicopter = [[TBUnitManager sharedManager] allyHelicopter];
    
    [[TBALPlayback sharedPlayback] stopSound:kTBSoundVulcan];
    [sHelicopter setFireVulcan:NO];
}


- (void)glView:(TBGLView *)aGLView touchSwipe:(NSInteger)aDirection
{
}


- (void)glView:(TBGLView *)aGLView touchTapCount:(NSInteger)aTabCount
{
    TBHelicopter *sHelicopter = [[TBUnitManager sharedManager] allyHelicopter];
    
    if ([sHelicopter selectedWeapon] == kWeaponBomb && ![sHelicopter isLanded])
    {
        [sHelicopter dropBomb];
    }
}


#pragma mark -


- (void)accelerometer:(UIAccelerometer *)aAccelerometer didAccelerate:(UIAcceleration *)aAcceleration
{
    CGPoint       sPos;
    AppDelegate  *sAppDelegate;
    TBGLView     *sGLView;
    TBHelicopter *sHelicopter = [[TBUnitManager sharedManager] allyHelicopter];

    if (sHelicopter)
    {
        [sHelicopter setAltitudeLever:[aAcceleration z]];
        [sHelicopter setSpeedLever:[aAcceleration y]];    
        sPos = [sHelicopter position];
    
        if ([sHelicopter isLeftAhead])
        {
            if (mBackPoint < 330)
            {
                mBackPoint += 8;        
            }
        }
        else
        {
            if (mBackPoint > 150)
            {
                mBackPoint -= 8;
            }
        }

        sAppDelegate = [[UIApplication sharedApplication] delegate];
//        sGLView      = [sAppDelegate GLView];
        [sGLView setXPos:(sPos.x - mBackPoint)];
    }
}


#pragma mark -
#pragma mark Helicopter Delegates


- (void)updateAmmoLabel
{
    TBHelicopter *sHelicopter = [[TBUnitManager sharedManager] allyHelicopter];
    NSString     *sAmmoText;
    
    if (sHelicopter)
    {
        sAmmoText = [NSString stringWithFormat:@"V:%d B:%d D:%3.2f", [sHelicopter bulletCount], [sHelicopter bombCount], [sHelicopter damageRate]];
        [[mGLView ammoLabel] setText:sAmmoText];
    }
}


- (void)helicopterDamageChanged:(TBHelicopter *)aHelicopter
{
    if ([aHelicopter isAlly])
    {
        [self updateAmmoLabel];
    }
}


- (void)helicopterWeaponDidReload:(TBHelicopter *)aHelicopter
{
    if ([aHelicopter isAlly])
    {
        [self updateAmmoLabel];
    }
}


- (void)helicopter:(TBHelicopter *)aHelicopter weaponFired:(NSInteger)aWeaponIndex
{
    if ([aHelicopter isAlly])
    {
        [self updateAmmoLabel];
    }
}


- (void)helicopterDidDestroy:(TBHelicopter *)aHelicopter
{
    if ([aHelicopter isAlly])
    {
        [self performSelector:@selector(makeNewAllyHelicopter) withObject:nil afterDelay:3.0];
    }
}


#pragma mark -
#pragma mark TB****Manager Delegates


- (void)updateMoneyLabel:(NSUInteger)aSum
{
    [[mGLView moneyLabel] setText:[NSString stringWithFormat:@"$ %d", aSum]];
}


- (void)updateScoreLabel:(NSUInteger)aScore
{
    [[mGLView scoreLabel] setText:[NSString stringWithFormat:@"%d", aScore]];
}


- (void)moneyManager:(TBMoneyManager *)aMoneyManager sumDidChange:(NSUInteger)aSum
{
    [self updateMoneyLabel:aSum];
}


- (void)scoreManager:(TBScoreManager *)aScoreManager scoreDidChange:(NSUInteger)aScore
{
    [self updateScoreLabel:aScore];
}


@end
