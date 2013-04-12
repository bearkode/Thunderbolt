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
    
    /*  Models  */
    PBSprite      *mStar0;
    PBSprite      *mStar1;
    PBSprite      *mStar2;
    
    /*  BGM  */
    PBSoundSource *mBGMSoundSource;

    CGFloat        mBackPoint;
    CGFloat        mCameraXPos;
    NSInteger      mTimeTick;
}


#pragma mark -
#pragma mark Privates


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
    TBBase       *sBase;
    TBLandingPad *sLandingPad;
    TBAAGunSite  *sAAGunSite;
    
    sBase = [[[TBBase alloc] initWithTeam:kTBTeamAlly] autorelease];
    [sBase setPoint:CGPointMake(kMinMapXPos + 100, kMapGround + 30)];
    [[TBStructureManager sharedManager] addStructure:sBase];
    [mStructureLayer addSublayer:sBase];

    sBase = [[[TBBase alloc] initWithTeam:kTBTeamEnemy] autorelease];
    [sBase setPoint:CGPointMake(kMaxMapXPos - 100, kMapGround + 30)];
    [[TBStructureManager sharedManager] addStructure:sBase];
    [mStructureLayer addSublayer:sBase];

    sLandingPad = [[[TBLandingPad alloc] initWithTeam:kTBTeamAlly] autorelease];
    [sLandingPad setPoint:CGPointMake(kMinMapXPos + 200, kMapGround + 6)];
    [[TBStructureManager sharedManager] addStructure:sLandingPad];
    [mStructureLayer addSublayer:sLandingPad];
    
    sLandingPad = [[[TBLandingPad alloc] initWithTeam:kTBTeamEnemy] autorelease];
    [sLandingPad setPoint:CGPointMake(kMaxMapXPos - 200, kMapGround + 6)];
    [[TBStructureManager sharedManager] addStructure:sLandingPad];
    [mStructureLayer addSublayer:sLandingPad];
    
    sAAGunSite = [[[TBAAGunSite alloc] initWithTeam:kTBTeamAlly] autorelease];
    [sAAGunSite setPoint:CGPointMake(kMinMapXPos + 800, kMapGround + 15)];
    [[TBStructureManager sharedManager] addStructure:sAAGunSite];
    [mStructureLayer addSublayer:sAAGunSite];
    
    sAAGunSite = [[[TBAAGunSite alloc] initWithTeam:kTBTeamEnemy] autorelease];
    [sAAGunSite setPoint:CGPointMake(kMaxMapXPos - 800, kMapGround + 15)];
    [[TBStructureManager sharedManager] addStructure:sAAGunSite];
    [mStructureLayer addSublayer:sAAGunSite];
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
    
    [mStar0 autorelease];
    mStar0 = [[PBSprite alloc] initWithImageName:kTexGreen];
    [mStar0 setPoint:CGPointMake(kMinMapXPos, kMapGround + ([[mStar0 mesh] size].height / 2))];
    [mBackgroundLayer addSublayer:mStar0];

    [mStar1 autorelease];
    mStar1 = [[PBSprite alloc] initWithImageName:kTexGreen];
    [mStar1 setPoint:CGPointMake(kMaxMapXPos / 2, kMapGround + ([[mStar0 mesh] size].height / 2))];
    [mBackgroundLayer addSublayer:mStar1];

    [mStar2 autorelease];
    mStar2 = [[PBSprite alloc] initWithImageName:kTexGreen];
    [mStar2 setPoint:CGPointMake(kMaxMapXPos, kMapGround + ([[mStar0 mesh] size].height / 2))];
    [mBackgroundLayer addSublayer:mStar2];
    
    PBSprite *sSprite = [[[PBSprite alloc] initWithImageName:kTexGreen] autorelease];
    [sSprite setPoint:CGPointMake(0, 0)];
    [mBackgroundLayer addSublayer:sSprite];
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
    
    
    [[TBWarheadManager sharedManager] setWarheadLayer:mWarheadLayer];
    [[TBExplosionManager sharedManager] setExplosionLayer:mExplosionLayer];
    [[TBUnitManager sharedManager] setUnitLayer:mUnitLayer];
    
    [self setupBackgroundLayer];
    [self setupStructureLayer];
    [self setupRadarLayer];
}


- (void)makeNewAllyHelicopter
{
    if ([[TBMoneyManager sharedManager] sum] >= kTBPriceHelicopter)
    {
        [TBMoneyManager useMoney:kTBPriceHelicopter];
        [TBUnitManager helicopterWithTeam:kTBTeamAlly delegate:self];
    }
    else
    {
        [self performSelector:@selector(makeNewAllyHelicopter) withObject:nil afterDelay:3.0];
    }
}


#pragma mark -


- (id)initWithNibName:(NSString *)aNibNameOrNil bundle:(NSBundle *)aNibBundleOrNil
{
    self = [super initWithNibName:aNibNameOrNil bundle:aNibBundleOrNil];
    
    if (self)
    {
        mBackPoint = 0;
        mTimeTick  = 0;
        
        [[UIAccelerometer sharedAccelerometer] setUpdateInterval:1.0 / 30.0];
        [[UIAccelerometer sharedAccelerometer] setDelegate:self];
        
        [[TBMoneyManager sharedManager] setDelegate:self];
        [[TBScoreManager sharedManager] setDelegate:self];
        
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
    [mStar0 release];
    [mStar1 release];
    [mStar2 release];
    
    [[TBWarheadManager sharedManager] setWarheadLayer:nil];
    [[TBExplosionManager sharedManager] setExplosionLayer:nil];
    [[TBUnitManager sharedManager] setUnitLayer:nil];
    
    [[TBMoneyManager sharedManager] setDelegate:nil];
    [[TBScoreManager sharedManager] setDelegate:nil];
    
    [[PBSoundManager sharedManager] releaseSoundSource:mBGMSoundSource];
    
    [super dealloc];
}


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

    [self makeNewAllyHelicopter];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

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
    
    [[self canvas] setDisplayFrameRate:kPBDisplayFrameRateMid];
    [[[self canvas] camera] setPosition:CGPointMake(sBounds.size.width / 2, sBounds.size.height / 2)];
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
    if ([[TBMoneyManager sharedManager] sum] >= kTBPriceTank)
    {
        [TBMoneyManager useMoney:kTBPriceTank];
        [TBUnitManager tankWithTeam:kTBTeamAlly];
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
    }
    else
    {
        NSLog(@"UNIT MAX");
    }
}


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


- (void)accelerometer:(UIAccelerometer *)aAccelerometer didAccelerate:(UIAcceleration *)aAcceleration
{
    TBHelicopter *sHelicopter = [[TBUnitManager sharedManager] allyHelicopter];
    
    [[sHelicopter controlLever] setAltitude:[aAcceleration z] speed:[aAcceleration y]];
    [self updateCameraPositoin];
}


#pragma mark -
#pragma mark EventView Delegate


- (void)eventView:(TBEventView *)aEventView controlAltitude:(CGFloat)aAltitude speed:(CGFloat)aSpeed
{
    TBHelicopter *sHelicopter = [[TBUnitManager sharedManager] allyHelicopter];
    
    [[sHelicopter controlLever] setAltitude:aAltitude speed:aSpeed];
    [self updateCameraPositoin];    
}


- (void)eventView:(TBEventView *)aEventView touchBegan:(CGPoint)aPoint
{
    TBHelicopter *sHelicopter = [[TBUnitManager sharedManager] allyHelicopter];
    
    if ([sHelicopter selectedWeapon] == kWeaponVulcan &&
        [sHelicopter bulletCount] > 0 &&
        ![sHelicopter isLanded])
    {
        [sHelicopter setFireVulcan:YES];
    }
}


- (void)eventView:(TBEventView *)aEventView touchCancelled:(CGPoint)aPoint
{
    TBHelicopter *sHelicopter = [[TBUnitManager sharedManager] allyHelicopter];
    
    [sHelicopter setFireVulcan:NO];
}


- (void)eventView:(TBEventView *)aEventView touchEnded:(CGPoint)aPoint
{
    TBHelicopter *sHelicopter = [[TBUnitManager sharedManager] allyHelicopter];
    
    [sHelicopter setFireVulcan:NO];
}


- (void)eventView:(TBEventView *)aEventView touchTapCount:(NSInteger)aTabCount
{
    TBHelicopter *sHelicopter = [[TBUnitManager sharedManager] allyHelicopter];
    
    if ([sHelicopter selectedWeapon] == kWeaponBomb && ![sHelicopter isLanded])
    {
        [sHelicopter dropBomb];
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
        [mAmmoLabel setText:sAmmoText];
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
    [mMoneyLabel setText:[NSString stringWithFormat:@"$ %d", aSum]];
}


- (void)updateScoreLabel:(NSUInteger)aScore
{
    [mScoreLabel setText:[NSString stringWithFormat:@"%d", aScore]];
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
