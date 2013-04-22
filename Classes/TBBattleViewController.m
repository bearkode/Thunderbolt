/*
 *  TBBattleViewController.m
 *  Thunderbolt
 *
 *  Created by bearkode on 13. 4. 4..
 *  Copyright (c) 2013 Tinybean. All rights reserved.
 *
 */

#import "TBBattleViewController.h"
#import <PBKit.h>
#import "TBTextureNames.h"

#import "TBEventView.h"
#import "TBControlLever.h"

#import "TBMoneyManager.h"
#import "TBUnitManager.h"
#import "TBWarheadManager.h"
#import "TBExplosionManager.h"
#import "TBStructureManager.h"
#import "TBScoreManager.h"

#import "TBBase.h"
#import "TBLandingPad.h"
#import "TBAAGunSite.h"
#import "TBHelicopter.h"
#import "TBTank.h"

#import "TBRadar.h"


#if (1)
#define kUnitDeployDuration (60 * 10)
#else
#warning UNIT FAST DEPLOY
#define kUnitDeployDuration (10)
#endif


@implementation TBBattleViewController
{
    /*  User Interface : not retained  */
    TBEventView   *mEventView;
    
    UILabel       *mAmmoLabel;
    UILabel       *mScoreLabel;
    UILabel       *mMoneyLabel;
    UIButton      *mTankButton;
    UIButton      *mAmmoButton;
    
    TBRadar       *mRadar;
    
    /*  Layers : not retained  */
    PBLayer       *mRadarLayer;
    PBLayer       *mEffectLayer;
    PBLayer       *mWarheadLayer;
    PBLayer       *mExplosionLayer;
    PBLayer       *mUnitLayer;
    PBLayer       *mStructureLayer;
    PBLayer       *mBackgroundLayer;
    
    /*  BGM  */
    PBSoundSource *mBGMSoundSource;

    CGFloat        mBackPoint;
    CGFloat        mCameraXPos;
    NSInteger      mTimeTick;
}


#pragma mark -
#pragma mark Setups


- (void)setupUIs
{
    CGRect   sBounds    = [[self view] bounds];
    UIColor *sBackColor = [UIColor clearColor];

    mAmmoLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 40, 140, 30)] autorelease];
    [mAmmoLabel setBackgroundColor:sBackColor];
    [mAmmoLabel setTextColor:[UIColor whiteColor]];
    [mAmmoLabel setFont:[UIFont systemFontOfSize:14]];
    [[self view] addSubview:mAmmoLabel];
    
    mScoreLabel = [[[UILabel alloc] initWithFrame:CGRectMake(190, 40, 100, 30)] autorelease];
    [mScoreLabel setBackgroundColor:sBackColor];
    [mScoreLabel setTextColor:[UIColor whiteColor]];
    [mScoreLabel setFont:[UIFont systemFontOfSize:14]];
    [mScoreLabel setTextAlignment:UITextAlignmentCenter];
    [[self view] addSubview:mScoreLabel];
    
    mMoneyLabel = [[[UILabel alloc] initWithFrame:CGRectMake(340, 40, 120, 30)] autorelease];
    [mMoneyLabel setBackgroundColor:sBackColor];
    [mMoneyLabel setTextColor:[UIColor whiteColor]];
    [mMoneyLabel setFont:[UIFont systemFontOfSize:14]];
    [mMoneyLabel setTextAlignment:UITextAlignmentRight];
    [[self view] addSubview:mMoneyLabel];
    
    mTankButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [mTankButton setFrame:CGRectMake(10, sBounds.size.height - 35, 60, 30)];
    [mTankButton setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    [mTankButton setTitle:@"Tank" forState:UIControlStateNormal];
    [mTankButton addTarget:self action:@selector(tankButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:mTankButton];
    
    mAmmoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [mAmmoButton setFrame:CGRectMake(410, sBounds.size.height - 35, 60, 30)];
    [mAmmoButton setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    [mAmmoButton setTitle:@"Ammo" forState:UIControlStateNormal];
    [mAmmoButton addTarget:self action:@selector(ammoButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:mAmmoButton];
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


- (void)setupBackgroundLayer
{
    PBTexture *sGroundTexture = [PBTextureManager textureWithImageName:@"ground.png"];
    [sGroundTexture loadIfNeeded];
    
    CGFloat y = [sGroundTexture size].height / 2;

    for (NSInteger x = -400; x <= kMaxMapXPos + 400; x += [sGroundTexture size].width)
    {
        PBLayer *sLayer = [[[PBLayer alloc] init] autorelease];
        [[sLayer mesh] setUsingMeshQueue:YES];
        [sLayer setTexture:sGroundTexture];
        [sLayer setPoint:CGPointMake(x, y)];
        [mBackgroundLayer addSublayer:sLayer];
    }
}


- (void)setupRadarLayer
{
    mRadar = [[[TBRadar alloc] init] autorelease];
    [mRadarLayer addSublayer:mRadar];
}


- (void)setupLayers
{
    mRadarLayer      = [[[PBLayer alloc] init] autorelease];
    mEffectLayer     = [[[PBLayer alloc] init] autorelease];
    mWarheadLayer    = [[[PBLayer alloc] init] autorelease];
    mExplosionLayer  = [[[PBLayer alloc] init] autorelease];
    mUnitLayer       = [[[PBLayer alloc] init] autorelease];
    mStructureLayer  = [[[PBLayer alloc] init] autorelease];
    mBackgroundLayer = [[[PBLayer alloc] init] autorelease];
    
    [[[self canvas] rootLayer] setSublayers:[NSArray arrayWithObjects:mBackgroundLayer,
                                                                      mStructureLayer,
                                                                      mUnitLayer,
                                                                      mExplosionLayer,
                                                                      mWarheadLayer,
                                                                      mEffectLayer,
                                                                      mRadarLayer, nil]];
    
    [[TBStructureManager sharedManager] setStructureLayer:mStructureLayer];
    [[TBWarheadManager sharedManager] setWarheadLayer:mWarheadLayer];
    [[TBExplosionManager sharedManager] setExplosionLayer:mExplosionLayer];
    [[TBUnitManager sharedManager] setUnitLayer:mUnitLayer];
    
    [self setupBackgroundLayer];
    [self setupStructureLayer];
    [self setupRadarLayer];
}


- (void)deployNewAllyHelicopter
{
    if ([[TBMoneyManager sharedManager] balance] >= kTBPriceHelicopter)
    {
        [TBMoneyManager useMoney:kTBPriceHelicopter];
        [[TBUnitManager sharedManager] addHelicopterWithTeam:kTBTeamAlly delegate:self];
        [self updateAmmoLabel];
    }
    else
    {
        [[self navigationController] popViewControllerAnimated:NO];
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
                [[TBUnitManager sharedManager] addSoldierWithTeam:kTBTeamEnemy];
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
    
    mCameraXPos = sHeliPos.x + mBackPoint;
}


#pragma mark -
#pragma mark Init / dealloc


- (id)initWithNibName:(NSString *)aNibNameOrNil bundle:(NSBundle *)aNibBundleOrNil
{
    self = [super initWithNibName:aNibNameOrNil bundle:aNibBundleOrNil];
    
    if (self)
    {
        mBackPoint = 0;
        mTimeTick  = 0;
        
        [[UIAccelerometer sharedAccelerometer] setUpdateInterval:1.0 / 60.0];
        [[UIAccelerometer sharedAccelerometer] setDelegate:self];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(baseDidDestroyNotification:)
                                                     name:kTBBaseDidDestroyNotificaton
                                                   object:nil];
        
        [PBSoundListener setOrientation:0];
        mBGMSoundSource = [[PBSoundManager sharedManager] retainSoundSource];
        [mBGMSoundSource setSound:[[PBSoundManager sharedManager] soundForKey:kTBSoundValkyries]];
        [mBGMSoundSource setLooping:YES];
        [mBGMSoundSource play];
        
    }
    
    return self;
}


- (void)dealloc
{
    [[UIAccelerometer sharedAccelerometer] setDelegate:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:kTBBaseDidDestroyNotificaton object:nil];
    
    [[TBStructureManager sharedManager] reset];
    [[TBStructureManager sharedManager] setStructureLayer:nil];
    [[TBWarheadManager sharedManager] reset];
    [[TBWarheadManager sharedManager] setWarheadLayer:nil];
    [[TBExplosionManager sharedManager] reset];
    [[TBExplosionManager sharedManager] setExplosionLayer:nil];
    [[TBUnitManager sharedManager] reset];
    [[TBUnitManager sharedManager] setUnitLayer:nil];
    
    [[TBMoneyManager sharedManager] setDelegate:nil];
    [[TBScoreManager sharedManager] reset];
    [[TBScoreManager sharedManager] setDelegate:nil];
    
    [[PBSoundManager sharedManager] releaseSoundSource:mBGMSoundSource];
    
    [super dealloc];
}


#pragma mark -
#pragma mark Inherited


- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES];
    
    CGRect sBounds = [[self view] bounds];

    mEventView = [[[TBEventView alloc] initWithFrame:sBounds] autorelease];
    [mEventView setDelegate:self];
    [mEventView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [[self view] addSubview:mEventView];

#if TARGET_IPHONE_SIMULATOR
    [mEventView setControlMode:YES];
#endif
    
    [[self canvas] setBackgroundColor:[PBColor colorWithRed:0.5 green:0.5 blue:1.0 alpha:1.0]];
    [self setupUIs];
    [self setupLayers];

    [self deployNewAllyHelicopter];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    [[TBStructureManager sharedManager] setStructureLayer:nil];
    [[TBWarheadManager sharedManager] setWarheadLayer:nil];
    [[TBExplosionManager sharedManager] setExplosionLayer:nil];
    [[TBUnitManager sharedManager] setUnitLayer:nil];
    
    mEventView       = nil;
    
    mAmmoLabel       = nil;
    mScoreLabel      = nil;
    mMoneyLabel      = nil;
    mTankButton      = nil;
    mAmmoButton      = nil;
    
    mRadar           = nil;
    
    mRadarLayer      = nil;
    mEffectLayer     = nil;
    mWarheadLayer    = nil;
    mExplosionLayer  = nil;
    mUnitLayer       = nil;
    mStructureLayer  = nil;
    mBackgroundLayer = nil;
    
}


- (void)viewDidAppear:(BOOL)aAnimated
{
    [super viewDidAppear:aAnimated];
    
    PBCanvas *sCanvas = [self canvas];
    CGRect    sBounds = [sCanvas bounds];
    
    [[self canvas] setDisplayFrameRate:kPBDisplayFrameRateHigh];
    [[[self canvas] camera] setPosition:CGPointMake(sBounds.size.width / 2, sBounds.size.height / 2)];
    
    [[TBMoneyManager sharedManager] setDelegate:self];
    [[TBScoreManager sharedManager] setDelegate:self];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)aInterfaceOrientation
{
    if (aInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        return YES;
    }
    else
    {
        return NO;
    }
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
#pragma mark PBCanvas delegate


- (void)pbCanvasWillUpdate:(PBCanvas *)aView
{
//    PBBeginTimeCheck();
    CGPoint sCameraPos = [[[self canvas] camera] position];
    [[[self canvas] camera] setPosition:CGPointMake(mCameraXPos, sCameraPos.y)];

    [self deployEnemyUnit];

    [[TBStructureManager sharedManager] doActions];
    [[TBUnitManager      sharedManager] doActions];
    [[TBWarheadManager   sharedManager] doActions];
    [[TBExplosionManager sharedManager] doActions];

    [mRadar updateWithCanvas:[self canvas]];
//    PBEndTimeCheck();
}


#pragma mark -
#pragma mark Accelerometer delegate


- (void)accelerometer:(UIAccelerometer *)aAccelerometer didAccelerate:(UIAcceleration *)aAcceleration
{
    TBHelicopter *sHelicopter = [[TBUnitManager sharedManager] allyHelicopter];
    
    if (sHelicopter)
    {
        [[sHelicopter controlLever] setAltitude:[aAcceleration z] speed:[aAcceleration y]];
        [self updateCameraPositoin];
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
#pragma mark Helicopter Delegates


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
        [self performSelector:@selector(deployNewAllyHelicopter) withObject:nil afterDelay:3.0];
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


- (void)baseDidDestroyNotification:(NSNotification *)aNotification
{
    TBBase *sBase = (TBBase *)[[aNotification userInfo] objectForKey:@"base"];
    
    if ([sBase team] == kTBTeamAlly)
    {
        NSLog(@"Defeat");
        [[self navigationController] popViewControllerAnimated:NO];
    }
    else
    {
        NSLog(@"Win");
        [[self navigationController] popViewControllerAnimated:NO];
    }
}


@end
