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

#import "TBRadar.h"


@implementation TBBattleViewController (Privates)


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


@implementation TBBattleViewController
{
    UILabel  *mAmmoLabel;
    UILabel  *mScoreLabel;
    UILabel  *mMoneyLabel;
    UIButton *mTankButton;
    UIButton *mAmmoButton;

    PBSprite *mStar0;
    PBSprite *mStar1;
    PBSprite *mStar2;
    
    TBRadar  *mRadar;
    
    CGFloat   mBackPoint;
    NSInteger mTimeTick;
}


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


#pragma mark -

- (id)initWithNibName:(NSString *)aNibNameOrNil bundle:(NSBundle *)aNibBundleOrNil
{
    TBTextureManager *sTextureMan;
    TBTextureInfo    *sInfo;

    self = [super initWithNibName:aNibNameOrNil bundle:aNibBundleOrNil];
    
    if (self)
    {
        sTextureMan = [TBTextureManager sharedManager];
        [sTextureMan loadTextures];
        
        [self setupStructures];
        
        sInfo = [sTextureMan textureInfoForKey:kTexGreen];
        
        mStar0 = [[PBSprite alloc] initWithImageName:kTexGreen];
        [mStar0 setPoint:CGPointMake(kMinMapXPos, MAP_GROUND + ([[mStar0 mesh] size].height / 2))];
        
        mStar1 = [[PBSprite alloc] initWithImageName:kTexGreen];
        [mStar1 setPoint:CGPointMake(kMaxMapXPos / 2, MAP_GROUND + ([[mStar0 mesh] size].height / 2))];
        
        mStar2 = [[PBSprite alloc] initWithImageName:kTexGreen];
        [mStar2 setPoint:CGPointMake(kMaxMapXPos, MAP_GROUND + ([[mStar0 mesh] size].height / 2))];
        
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self view] setBackgroundColor:[UIColor greenColor]];
    
    [[self navigationController] setNavigationBarHidden:YES];
    [[self canvas] setBackgroundColor:[PBColor colorWithRed:0.5 green:0.5 blue:1.0 alpha:1.0]];

    CGRect   sBounds    = [[self view] bounds];
    UIColor *sBackColor = [UIColor cyanColor];
    
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
    
    [[[self canvas] rootLayer] addSublayer:mStar0];
    [[[self canvas] rootLayer] addSublayer:mStar1];
    [[[self canvas] rootLayer] addSublayer:mStar2];
    
    PBSprite *sSprite = [[[PBSprite alloc] initWithImageName:kTexGreen] autorelease];
    [sSprite setPoint:CGPointMake(0, 0)];
    [[[self canvas] rootLayer] addSublayer:sSprite];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)viewDidAppear:(BOOL)aAnimated
{
    [super viewDidAppear:aAnimated];
    
    CGRect sBounds = [[self canvas] bounds];
    [[[self canvas] camera] setPosition:CGPointMake(sBounds.size.width / 2, sBounds.size.height / 2)];
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


- (void)pbCanvasWillUpdate:(PBCanvas *)aView
{
//    [[TBStructureManager sharedManager] doActions];
//    
//    [mStar0 draw];
//    [mStar1 draw];
//    [mStar2 draw];
//
//    if (++mTimeTick == 30 * 10)
//    {
//        mTimeTick = 0;
//        NSInteger sUnitType = rand() % 4;
//        
//        if (sUnitType == 0)
//        {
//            [TBUnitManager armoredVehicleWithTeam:kTBTeamEnemy];
//        }
//        else if (sUnitType == 1)
//        {
//            [TBUnitManager tankWithTeam:kTBTeamEnemy];
//        }
//        else
//        {
//            [TBUnitManager soldierWithTeam:kTBTeamEnemy];
//        }
//        
//        [[TBMoneyManager sharedManager] saveMoney:10];
//    }
//    
//    [self removeDisabledSprite];
//    
//    [[TBUnitManager sharedManager] doActions];
//    [[TBWarheadManager sharedManager] doActions];
//    [[TBExplosionManager sharedManager] doActions];
    

//    [mRadar drawAt:[mGLView xPos]];
}


#pragma mark -


- (void)accelerometer:(UIAccelerometer *)aAccelerometer didAccelerate:(UIAcceleration *)aAcceleration
{
    NSLog(@"accelerometer:didAccelerate:");
    CGPoint       sPos;
//    AppDelegate  *sAppDelegate;
//    TBGLView     *sGLView;
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
        
//        sAppDelegate = [[UIApplication sharedApplication] delegate];
//        sGLView      = [sAppDelegate GLView];
//        [sGLView setXPos:(sPos.x - mBackPoint)];
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
