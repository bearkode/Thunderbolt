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

#import "TBEventView.h"
#import "TBControlLever.h"

#import "TBTextureNames.h"

#import "TBMoneyManager.h"
#import "TBUnitManager.h"
#import "TBWarheadManager.h"
#import "TBExplosionManager.h"
#import "TBStructureManager.h"
#import "TBTextureManager.h"
#import "TBScoreManager.h"
#import "TBBGMManager.h"

#import "TBBase.h"
#import "TBLandingPad.h"
#import "TBAAGunSite.h"

#import "TBHelicopter.h"
#import "TBTank.h"

#import "TBRadar.h"


@implementation TBBattleViewController (Privates)


- (void)removeDisabledSprite
{
    [[TBUnitManager sharedManager] removeDisabledUnits];
    [[TBWarheadManager sharedManager] removeDisabledSprite];
    [[TBExplosionManager sharedManager] removeFinishedExplosion];
}


@end


@implementation TBBattleViewController
{
    /*  User Interface : not retained  */
    TBEventView *mEventView;
    
    UILabel     *mAmmoLabel;
    UILabel     *mScoreLabel;
    UILabel     *mMoneyLabel;
    UIButton    *mTankButton;
    UIButton    *mAmmoButton;
    
    /*  Layers : not retained  */
    PBLayer     *mRadarLayer;
    PBLayer     *mEffectLayer;
    PBLayer     *mWarheadLayer;
    PBLayer     *mExplosionLayer;
    PBLayer     *mUnitLayer;
    PBLayer     *mStructureLayer;
    PBLayer     *mBackgroundLayer;
    
    /*  Models  */
    PBSprite    *mStar0;
    PBSprite    *mStar1;
    PBSprite    *mStar2;
    
    TBRadar     *mRadar;
    
    CGFloat      mBackPoint;
    NSInteger    mTimeTick;
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
    [sBase setPoint:CGPointMake(kMinMapXPos + 100, MAP_GROUND + 30)];
    [[TBStructureManager sharedManager] addStructure:sBase];
    [mStructureLayer addSublayer:sBase];

    sBase = [[[TBBase alloc] initWithTeam:kTBTeamEnemy] autorelease];
    [sBase setPoint:CGPointMake(kMaxMapXPos - 100, MAP_GROUND + 30)];
    [[TBStructureManager sharedManager] addStructure:sBase];
    [mStructureLayer addSublayer:sBase];

    sLandingPad = [[[TBLandingPad alloc] initWithTeam:kTBTeamAlly] autorelease];
    [sLandingPad setPoint:CGPointMake(kMinMapXPos + 200, MAP_GROUND + 6)];
    [[TBStructureManager sharedManager] addStructure:sLandingPad];
    [mStructureLayer addSublayer:sLandingPad];
    
    sLandingPad = [[[TBLandingPad alloc] initWithTeam:kTBTeamEnemy] autorelease];
    [sLandingPad setPoint:CGPointMake(kMaxMapXPos - 200, MAP_GROUND + 6)];
    [[TBStructureManager sharedManager] addStructure:sLandingPad];
    [mStructureLayer addSublayer:sLandingPad];
    
    sAAGunSite = [[[TBAAGunSite alloc] initWithTeam:kTBTeamAlly] autorelease];
    [sAAGunSite setPoint:CGPointMake(kMinMapXPos + 800, MAP_GROUND + 15)];
    [[TBStructureManager sharedManager] addStructure:sAAGunSite];
    [mStructureLayer addSublayer:sAAGunSite];
    
    sAAGunSite = [[[TBAAGunSite alloc] initWithTeam:kTBTeamEnemy] autorelease];
    [sAAGunSite setPoint:CGPointMake(kMaxMapXPos - 800, MAP_GROUND + 15)];
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
    [mStar0 setPoint:CGPointMake(kMinMapXPos, MAP_GROUND + ([[mStar0 mesh] size].height / 2))];
    [mBackgroundLayer addSublayer:mStar0];

    [mStar1 autorelease];
    mStar1 = [[PBSprite alloc] initWithImageName:kTexGreen];
    [mStar1 setPoint:CGPointMake(kMaxMapXPos / 2, MAP_GROUND + ([[mStar0 mesh] size].height / 2))];
    [mBackgroundLayer addSublayer:mStar1];

    [mStar2 autorelease];
    mStar2 = [[PBSprite alloc] initWithImageName:kTexGreen];
    [mStar2 setPoint:CGPointMake(kMaxMapXPos, MAP_GROUND + ([[mStar0 mesh] size].height / 2))];
    [mBackgroundLayer addSublayer:mStar2];
    
    PBSprite *sSprite = [[[PBSprite alloc] initWithImageName:kTexGreen] autorelease];
    [sSprite setPoint:CGPointMake(0, 0)];
    [mBackgroundLayer addSublayer:sSprite];
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
    
    [self setupBackgroundLayer];
    [self setupStructureLayer];
}


- (void)makeNewAllyHelicopter
{
    if ([[TBMoneyManager sharedManager] sum] >= kTBPriceHelicopter)
    {
        [TBMoneyManager useMoney:kTBPriceHelicopter];
        
        TBHelicopter *sHelicopter = [TBUnitManager helicopterWithTeam:kTBTeamAlly delegate:self];
        [mUnitLayer addSublayer:sHelicopter];
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
        mRadar = [[TBRadar alloc] init];
        
        mBackPoint = 0;
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES];
    
    CGRect sBounds = [[self view] bounds];

    mEventView = [[[TBEventView alloc] initWithFrame:sBounds] autorelease];
    [mEventView setDelegate:self];
    [mEventView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [[self view] addSubview:mEventView];
    
    [[self canvas] setBackgroundColor:[PBColor colorWithRed:0.5 green:0.5 blue:1.0 alpha:1.0]];
    [self setupUIs];
    [self setupLayers];

    [self makeNewAllyHelicopter];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    mEventView  = nil;
    
    mAmmoLabel  = nil;
    mScoreLabel = nil;
    mMoneyLabel = nil;
    mTankButton = nil;
    mAmmoButton = nil;
}


- (void)viewDidAppear:(BOOL)aAnimated
{
    [super viewDidAppear:aAnimated];
    
    CGRect sBounds = [[self canvas] bounds];
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
        
        TBTank *sTank = [TBUnitManager tankWithTeam:kTBTeamAlly];
        [mUnitLayer addSublayer:sTank];
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


- (void)pbCanvasWillUpdate:(PBCanvas *)aView
{
    [[TBStructureManager sharedManager] doActions];

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
}


#pragma mark -


- (void)updateCameraPositoin
{
    TBHelicopter *sHelicopter = [[TBUnitManager sharedManager] allyHelicopter];
    CGPoint       sHeliPos    = [sHelicopter point];
    PBCamera     *sCamera     = [[self canvas] camera];
    CGPoint       sCameraPos  = [sCamera position];
    
    if ([sHelicopter isLeftAhead])
    {
        mBackPoint -= (mBackPoint > -80) ? 8 : 0;
    }
    else
    {
        mBackPoint += (mBackPoint < 80) ? 8 : 0;
    }
    
    sCameraPos.x = sHeliPos.x + mBackPoint;
    [sCamera setPosition:sCameraPos];
}


- (void)accelerometer:(UIAccelerometer *)aAccelerometer didAccelerate:(UIAcceleration *)aAcceleration
{
    TBHelicopter *sHelicopter = [[TBUnitManager sharedManager] allyHelicopter];
    
    [[sHelicopter controlLever] setAltitude:[aAcceleration z] speed:[aAcceleration y]];
    [self updateCameraPositoin];
}


- (void)eventView:(TBEventView *)aEventView controlAltitude:(CGFloat)aAltitude speed:(CGFloat)aSpeed
{
    TBHelicopter *sHelicopter = [[TBUnitManager sharedManager] allyHelicopter];
    
    [[sHelicopter controlLever] setAltitude:aAltitude speed:aSpeed];
    [self updateCameraPositoin];    
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
