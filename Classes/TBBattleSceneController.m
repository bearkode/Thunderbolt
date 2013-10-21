/*
 *  TBBattleSceneController.m
 *  Thunderbolt
 *
 *  Created by cgkim on 13. 10. 15..
 *  Copyright (c) 2013 Tinybean. All rights reserved.
 *
 */

#import "TBBattleSceneController.h"
#import <PBKit.h>

#import "TBUnitManager.h"
#import "TBWarheadManager.h"
#import "TBExplosionManager.h"
#import "TBStructureManager.h"
#import "TBSmokeManager.h"
#import "TBMoneyManager.h"
#import "TBScoreManager.h"
#import "TBBattleLayerManager.h"

#import "TBRadar.h"
#import "TBControlLever.h"
#import "TBHelicopter.h"
#import "TBHelicopterInfo.h"
#import "TBBase.h"

#import "TBEventView.h"
#import "TBController.h"


#if (1)
#define kUnitDeployDuration (60 * 5)
#else
#warning UNIT FAST DEPLOY
#define kUnitDeployDuration (10)
#endif


@implementation TBBattleSceneController
{
    /*  Layers : not retained  */
    TBBattleLayerManager *mLayerManager;

    /*  User Interface : not retained  */
    TBEventView          *mEventView;
    
    UILabel              *mAmmoLabel;
    UILabel              *mScoreLabel;
    UILabel              *mMoneyLabel;
    UIButton             *mTankButton;
    UIButton             *mAmmoButton;

    TBRadar              *mRadar;
    TBHelicopterInfo     *mHeliInfo;
    
    CGFloat               mBackPoint;
    CGFloat               mCameraXPos;
    NSInteger             mTimeTick;
    
    /*  BGM  */
    PBSoundSource        *mBGMSoundSource;

    TBController         *mController;
}


@synthesize helicopterInfo = mHeliInfo;


#pragma mark -


- (void)setupUIs
{
    CGRect   sBounds    = [[self controlView] bounds];
    UIColor *sBackColor = [UIColor clearColor];
    UIFont  *sFont      = [UIFont fontWithName:@"LetsgoDigital-Regular" size:20];

//    for(NSString* family in [UIFont familyNames]) {
//        NSLog(@"%@", family);
//        for(NSString* name in [UIFont fontNamesForFamilyName: family]) {
//            NSLog(@"  %@", name);
//        }
//    }
    
    mAmmoLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 40, 140, 30)] autorelease];
    [mAmmoLabel setAutoresizingMask:(UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin)];
    [mAmmoLabel setBackgroundColor:sBackColor];
    [mAmmoLabel setTextColor:[UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.5]];
    [mAmmoLabel setFont:sFont];
    [[self controlView] addSubview:mAmmoLabel];
    
    mScoreLabel = [[[UILabel alloc] initWithFrame:CGRectMake(sBounds.size.width - 300, 40, 100, 30)] autorelease];
    [mScoreLabel setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin)];
    [mScoreLabel setBackgroundColor:sBackColor];
    [mScoreLabel setTextColor:[UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.5]];
    [mScoreLabel setFont:sFont];
    [mScoreLabel setTextAlignment:NSTextAlignmentCenter];
    [[self controlView] addSubview:mScoreLabel];
    
    mMoneyLabel = [[[UILabel alloc] initWithFrame:CGRectMake(sBounds.size.width - 130, 40, 120, 30)] autorelease];
    [mMoneyLabel setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin)];
    [mMoneyLabel setBackgroundColor:sBackColor];
    [mMoneyLabel setTextColor:[UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.5]];
    [mMoneyLabel setFont:sFont];
    [mMoneyLabel setTextAlignment:NSTextAlignmentRight];
    [[self controlView] addSubview:mMoneyLabel];
    
    mTankButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [mTankButton setFrame:CGRectMake(10, sBounds.size.height - 35, 60, 30)];
    [mTankButton setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    [mTankButton setTitle:@"Tank" forState:UIControlStateNormal];
    [mTankButton addTarget:self action:@selector(tankButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [[self controlView] addSubview:mTankButton];
    
    mAmmoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [mAmmoButton setFrame:CGRectMake(410, sBounds.size.height - 35, 60, 30)];
    [mAmmoButton setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    [mAmmoButton setTitle:@"Ammo" forState:UIControlStateNormal];
    [mAmmoButton addTarget:self action:@selector(ammoButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [[self controlView] addSubview:mAmmoButton];
}


- (void)setupStructureLayer
{
    [[TBStructureManager sharedManager] addBaseWithTeam:kTBTeamAlly position:kMinMapXPos + 100];
    [[TBStructureManager sharedManager] addBaseWithTeam:kTBTeamEnemy position:kMaxMapXPos - 100];
    [[TBStructureManager sharedManager] addLandingPadWithTeam:kTBTeamAlly position:kMinMapXPos + 200];
    [[TBStructureManager sharedManager] addLandingPadWithTeam:kTBTeamEnemy position:kMaxMapXPos - 200];
    [[TBStructureManager sharedManager] addAAGunSiteWithTeam:kTBTeamAlly position:kMinMapXPos + 800];
    [[TBStructureManager sharedManager] addAAGunSiteWithTeam:kTBTeamAlly position:kMinMapXPos + 1500];
    [[TBStructureManager sharedManager] addAAGunSiteWithTeam:kTBTeamEnemy position:kMaxMapXPos - 800];
    [[TBStructureManager sharedManager] addAAGunSiteWithTeam:kTBTeamEnemy position:kMaxMapXPos - 1500];
}




- (void)setupRadarLayer
{
    PBNode *sRadarLayer = [mLayerManager radarLayer];
    
    mRadar = [[[TBRadar alloc] init] autorelease];
    [sRadarLayer addSubNode:mRadar];
}


- (void)setupLayers
{
    [[TBStructureManager sharedManager] setStructureLayer:[mLayerManager structureLayer]];
    [[TBWarheadManager sharedManager] setWarheadLayer:[mLayerManager warheadLayer]];
    [[TBExplosionManager sharedManager] setExplosionLayer:[mLayerManager explosionLayer]];
    [[TBUnitManager sharedManager] setUnitLayer:[mLayerManager unitLayer]];
    [[TBSmokeManager sharedManager] setSmokeLayer:[mLayerManager unitLayer]];
    
    [self setupStructureLayer];
    [self setupRadarLayer];
}


#pragma mark -
#pragma mark Update UIs


- (void)updateAmmoLabel
{
    TBHelicopter *sHelicopter = [[TBUnitManager sharedManager] allyHelicopter];
    NSString     *sAmmoText;
    
    if (sHelicopter)
    {
        sAmmoText = [NSString stringWithFormat:@"V:%d B:%d D:%3.2f", [sHelicopter bulletCount], [sHelicopter bombCount], [sHelicopter damageRate]];
        [mAmmoLabel setText:sAmmoText];
    }
}


- (void)updateMoneyLabel:(NSUInteger)aSum
{
    [mMoneyLabel setText:[NSString stringWithFormat:@"$ %d", aSum]];
}


- (void)updateScoreLabel:(NSUInteger)aScore
{
    [mScoreLabel setText:[NSString stringWithFormat:@"%d", aScore]];
}


- (void)updateCameraPositoin
{
    TBHelicopter *sHelicopter = [[TBUnitManager sharedManager] allyHelicopter];
    CGPoint       sHeliPos    = [sHelicopter point];
    
    if ([sHelicopter isLeftAhead])
    {
        mBackPoint -= (mBackPoint > -80) ? 8 : 0;
    }
    else
    {
        mBackPoint += (mBackPoint < 80) ? 8 : 0;
    }
    
    mCameraXPos = (NSInteger)(sHeliPos.x + mBackPoint);
}


#pragma mark -


- (id)initWithDelegate:(id)aDelegate
{
    self = [super initWithDelegate:aDelegate];
    
    if (self)
    {
        mLayerManager = [[TBBattleLayerManager alloc] init];
        
        mBackPoint = 0;
        mTimeTick  = 0;
        
        mController = [[TBController alloc] init];
        [mController setControllerMode:kTBControllerModeMotion];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(baseDidDestroyNotification:)
                                                     name:kTBBaseDidDestroyNotificaton
                                                   object:nil];
        
        [PBSoundListener setOrientation:0];
        mBGMSoundSource = [[PBSoundManager sharedManager] retainSoundSource];
        [mBGMSoundSource setSound:[[PBSoundManager sharedManager] soundForKey:kTBSoundValkyries]];
        [mBGMSoundSource setLooping:YES];
        [mBGMSoundSource play];
        
        CGRect sBounds = [[self controlView] bounds];
        mEventView = [[[TBEventView alloc] initWithFrame:sBounds] autorelease];
        [mEventView setDelegate:self];
        [mEventView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [[self controlView] addSubview:mEventView];
        
        [self setupLayers];
    }
    
    return self;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kTBBaseDidDestroyNotificaton object:nil];
    
    [[PBSoundManager sharedManager] releaseSoundSource:mBGMSoundSource];
    
    [mLayerManager release];

    [mController setControllerMode:kTBControllerModeNone];
    [mController release];
    
    [mHeliInfo release];

    [[TBStructureManager sharedManager] reset];
    [[TBStructureManager sharedManager] setStructureLayer:nil];
    [[TBWarheadManager sharedManager] reset];
    [[TBWarheadManager sharedManager] setWarheadLayer:nil];
    [[TBExplosionManager sharedManager] reset];
    [[TBExplosionManager sharedManager] setExplosionLayer:nil];
    [[TBUnitManager sharedManager] reset];
    [[TBUnitManager sharedManager] setUnitLayer:nil];
    [[TBSmokeManager sharedManager] reset];
    [[TBSmokeManager sharedManager] setSmokeLayer:nil];
    
    [[TBMoneyManager sharedManager] setDelegate:nil];
    [[TBScoreManager sharedManager] reset];
    [[TBScoreManager sharedManager] setDelegate:nil];

    
    [super dealloc];
}


#pragma mark -


- (void)sceneDidPresent
{
    [super sceneDidResize];
    
    CGRect sBounds = [[UIScreen mainScreen] bounds];
    
    [[self canvas] setDisplayFrameRate:kPBDisplayFrameRateHigh];
    [[self canvas] setBackgroundColor:[PBColor colorWithRed:0.2 green:0.3 blue:0.7 alpha:1.0]];
    [[[self canvas] camera] setPosition:CGPointMake(sBounds.size.height / 2, sBounds.size.width / 2)];
    [[self scene] setSubNodes:[mLayerManager layers]];
    
    [self setupUIs];
    
    [[TBMoneyManager sharedManager] setDelegate:self];
    [[TBScoreManager sharedManager] setDelegate:self];

#if TARGET_IPHONE_SIMULATOR
    [mEventView setControlMode:YES];
#endif

    [self deployNewAllyHelicopter];
}


- (void)sceneDidResize
{
    [super sceneDidResize];
    
    [mRadar setCanvasSize:[[self controlView] bounds].size];
}


#pragma mark -
#pragma mark Actions


- (IBAction)tankButtonTapped:(id)aSender
{
    if ([[TBMoneyManager sharedManager] balance] >= kTBPriceTank)
    {
        [TBMoneyManager useMoney:kTBPriceTank];
        [[TBUnitManager sharedManager] addTankWithTeam:kTBTeamAlly];
    }
}


- (IBAction)ammoButtonTapped:(id)aSender
{
    TBHelicopter *sHelicopter = [[TBUnitManager sharedManager] allyHelicopter];
    
    [sHelicopter selectNextWeapon];
}


#pragma mark -
#pragma mark PBScene delegate


- (void)pbSceneWillUpdate:(PBScene *)aScene
{
    [super pbSceneWillUpdate:aScene];

    CGPoint sCameraPos = [[[self canvas] camera] position];
    [[[self canvas] camera] setPosition:CGPointMake(mCameraXPos, sCameraPos.y)];
    
    [mRadar setPoint:CGPointMake(mCameraXPos, 300.0)];
    [mRadar update];

    [self deployEnemyUnit];
    
    [[TBStructureManager sharedManager] doActions];
    [[TBUnitManager      sharedManager] doActions];
    [[TBWarheadManager   sharedManager] doActions];
    [[TBExplosionManager sharedManager] doActions];
    [[TBSmokeManager     sharedManager] doActions];
    
    TBHelicopter *sHelicopter = [[TBUnitManager sharedManager] allyHelicopter];
    if (sHelicopter)
    {
        CGFloat sAltitude = [mController yAxisValue];
        CGFloat sSpeed    = [mController xAxisValue];
        
        [[sHelicopter controlLever] setAltitude:sAltitude speed:sSpeed];
        [self updateCameraPositoin];
    }
}


#pragma mark -


- (void)deployNewAllyHelicopter
{
    if ([TBMoneyManager useMoney:kTBPriceHelicopter])
    {
        [[TBUnitManager sharedManager] setHelicopterInfo:mHeliInfo];
        [[TBUnitManager sharedManager] addHelicopterWithTeam:kTBTeamAlly delegate:self];
        [self updateCameraPositoin];
        [self updateAmmoLabel];
    }
    else
    {
        if ([[self delegate] respondsToSelector:@selector(battleScene:didFinishBattle:)])
        {
            [[self delegate] battleScene:self didFinishBattle:NO];
        }
    }
}


- (void)deployEnemyUnit
{
    if ([[[TBUnitManager sharedManager] enemyUnits] count] < 50)
    {
        if (++mTimeTick == kUnitDeployDuration)
        {
            mTimeTick = 0;
            NSInteger sUnitType = rand() % 4;
            
            if (sUnitType == 0)
            {
                [[TBUnitManager sharedManager] addArmoredVehicleWithTeam:kTBTeamEnemy];
            }
            else if (sUnitType == 1)
            {
                [[TBUnitManager sharedManager] addTankWithTeam:kTBTeamEnemy];
            }
            else
            {
                [[TBUnitManager sharedManager] addRiflemanWithTeam:kTBTeamEnemy];
            }
            
            [[TBMoneyManager sharedManager] saveMoney:10];
        }
    }
    else
    {
        NSLog(@"UNIT MAX");
    }
}


#pragma mark -
#pragma mark Manager Delegates


- (void)moneyManager:(TBMoneyManager *)aMoneyManager balanceDidChange:(NSUInteger)aBalance
{
    [self updateMoneyLabel:aBalance];
}


- (void)scoreManager:(TBScoreManager *)aScoreManager scoreDidChange:(NSUInteger)aScore
{
    [self updateScoreLabel:aScore];
}


#pragma mark -
#pragma mark Helicopter Delegates


- (void)helicopterDamageDidChange:(TBHelicopter *)aHelicopter
{
    if ([aHelicopter isAlly])
    {
        [self updateAmmoLabel];
    }
}


- (void)helicopterDidRepair:(TBHelicopter *)aHelicopter
{

}


- (void)helicopterWeaponDidReload:(TBHelicopter *)aHelicopter
{
    if ([aHelicopter isAlly])
    {
        [self updateAmmoLabel];
    }
}


- (void)helicopter:(TBHelicopter *)aHelicopter weaponDidFire:(NSInteger)aWeaponIndex
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
        [self performSelector:@selector(deployNewAllyHelicopter) withObject:nil afterDelay:3.0];
    }
}


#pragma mark -
#pragma mark EventView Delegate


- (void)eventView:(TBEventView *)aEventView controlAltitude:(CGFloat)aAltitude speed:(CGFloat)aSpeed
{
    TBHelicopter *sHelicopter = [[TBUnitManager sharedManager] allyHelicopter];

    if (sHelicopter)
    {
        [[sHelicopter controlLever] setAltitude:aAltitude speed:aSpeed];
        [self updateCameraPositoin];
    }
}


- (void)eventView:(TBEventView *)aEventView touchBegan:(CGPoint)aPoint
{
    [[[TBUnitManager sharedManager] allyHelicopter] setFire:YES];
}


- (void)eventView:(TBEventView *)aEventView touchCancelled:(CGPoint)aPoint
{
    [[[TBUnitManager sharedManager] allyHelicopter] setFire:NO];
}


- (void)eventView:(TBEventView *)aEventView touchEnded:(CGPoint)aPoint
{
    [[[TBUnitManager sharedManager] allyHelicopter] setFire:NO];
}


- (void)eventView:(TBEventView *)aEventView touchTapCount:(NSInteger)aTabCount
{

}


#pragma mark -
#pragma mark Notifications


- (void)baseDidDestroyNotification:(NSNotification *)aNotification
{
    TBBase *sBase  = (TBBase *)[[aNotification userInfo] objectForKey:@"base"];
    BOOL    sIsWin = ([sBase team] == kTBTeamEnemy) ? YES : NO;

    if ([[self delegate] respondsToSelector:@selector(battleScene:didFinishBattle:)])
    {
        [[self delegate] battleScene:self didFinishBattle:sIsWin];
    }
}


@end
