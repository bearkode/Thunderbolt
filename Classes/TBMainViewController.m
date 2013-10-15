/*
 *  TBMainViewController.m
 *  Thunderbolt
 *
 *  Created by cgkim on 13. 4. 18..
 *  Copyright (c) 2013 Tinybean. All rights reserved.
 *
 */

#import "TBMainViewController.h"
#import "TBBattleViewController.h"
#import "TBTestViewController.h"
#import "TBCheatViewController.h"
#import "TBMoneyManager.h"
#import "TBHelicopterInfo.h"
#import "TBMainSceneController.h"


@implementation TBMainViewController
{
    TBMainSceneController *mSceneController;

    UILabel               *mMoneyLabel;
    TBHelicopterInfo      *mHelicopterInfo;
}


#pragma mark -


- (void)updateMoneyLabel
{
    NSUInteger sMoney = [[TBMoneyManager sharedManager] balance];
    NSString  *sText  = [[[NSString alloc] initWithFormat:@"Money = %d", sMoney] autorelease];
    
    [mMoneyLabel setText:sText];
}


#pragma mark -


- (id)initWithNibName:(NSString *)aNibNameOrNil bundle:(NSBundle *)aNibBundleOrNil
{
    self = [super initWithNibName:aNibNameOrNil bundle:aNibBundleOrNil];
    
    if (self)
    {
        mSceneController = [[TBMainSceneController alloc] initWithDelegate:self];
    }
    
    return self;
}


- (void)dealloc
{
    [mSceneController release];
    
    if ([[TBMoneyManager sharedManager] delegate] == self)
    {
        [[TBMoneyManager sharedManager] setDelegate:nil];
    }
    
    [mHelicopterInfo release];
    
    [super dealloc];
}


#pragma mark -


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self presentSceneController:mSceneController];
    
    CGRect sBounds = [[self view] bounds];
    
    mMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 30)];
    [mMoneyLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [mMoneyLabel setTextColor:[UIColor whiteColor]];
    [mMoneyLabel setBackgroundColor:[UIColor clearColor]];
    [[self view] addSubview:mMoneyLabel];
    [mMoneyLabel release];

    UIButton *sCheatButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sCheatButton setAutoresizingMask:(UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin)];
    [sCheatButton setTitle:@"Cheat" forState:UIControlStateNormal];
    [sCheatButton setFrame:CGRectMake(sBounds.size.width - 280 - 20, sBounds.size.height - 44 - 20, 80, 44)];
    [sCheatButton addTarget:self action:@selector(cheatButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:sCheatButton];

    UIButton *sTestButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sTestButton setAutoresizingMask:(UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin)];
    [sTestButton setTitle:@"Test" forState:UIControlStateNormal];
    [sTestButton setFrame:CGRectMake(sBounds.size.width - 180 - 20, sBounds.size.height - 44 - 20, 80, 44)];
    [sTestButton addTarget:self action:@selector(testButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:sTestButton];
    
    UIButton *sStartButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sStartButton setAutoresizingMask:(UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin)];
    [sStartButton setTitle:@"Start" forState:UIControlStateNormal];
    [sStartButton setFrame:CGRectMake(sBounds.size.width - 80 - 20, sBounds.size.height - 44 - 20, 80, 44)];
    [sStartButton addTarget:self action:@selector(startButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:sStartButton];
    
    //  Helicopter
    UIButton *sMD500Button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sMD500Button setTitle:@"MD500" forState:UIControlStateNormal];
    [sMD500Button setFrame:CGRectMake(30, 30, 70, 35)];
    [sMD500Button addTarget:self action:@selector(MD500ButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:sMD500Button];

    UIButton *sUH1Button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sUH1Button setTitle:@"UH1" forState:UIControlStateNormal];
    [sUH1Button setFrame:CGRectMake(30 + 80, 30, 70, 35)];
    [sUH1Button addTarget:self action:@selector(UH1ButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:sUH1Button];

    UIButton *sUH1NButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sUH1NButton setTitle:@"UN1N" forState:UIControlStateNormal];
    [sUH1NButton setFrame:CGRectMake(30 + 80 * 2, 30, 70, 35)];
    [sUH1NButton addTarget:self action:@selector(UH1NButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:sUH1NButton];

    UIButton *sAH1Button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sAH1Button setTitle:@"AH1" forState:UIControlStateNormal];
    [sAH1Button setFrame:CGRectMake(30 + 80 * 3, 30, 70, 35)];
    [sAH1Button addTarget:self action:@selector(AH1ButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:sAH1Button];

    UIButton *sAH1WButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sAH1WButton setTitle:@"AH1W" forState:UIControlStateNormal];
    [sAH1WButton setFrame:CGRectMake(30 + 80 * 4, 30, 70, 35)];
    [sAH1WButton addTarget:self action:@selector(AH1WButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:sAH1WButton];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    mMoneyLabel = nil;
}


- (void)viewWillAppear:(BOOL)aAnimated
{
    [super viewWillAppear:aAnimated];
    
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    
    [[TBMoneyManager sharedManager] setDelegate:self];
    [[TBMoneyManager sharedManager] setBalance:1800];
    [self updateMoneyLabel];
}


- (void)viewWillDisappear:(BOOL)aAnimated
{
    [super viewWillDisappear:aAnimated];
    
    [[TBMoneyManager sharedManager] setDelegate:nil];
}


#pragma mark -


- (IBAction)startButtonTapped:(id)aSender
{    
    TBBattleViewController *sViewController = [[[TBBattleViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    
    [sViewController setHelicopterInfo:mHelicopterInfo];

    [[self navigationController] pushViewController:sViewController animated:NO];
}


- (IBAction)testButtonTapped:(id)aSender
{
    TBTestViewController *sViewController = [[[TBTestViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    
    [[self navigationController] pushViewController:sViewController animated:NO];
}


- (IBAction)cheatButtonTapped:(id)aSender
{
    TBCheatViewController *sViewController = [[[TBCheatViewController alloc] initWithNibName:@"TBCheatViewController" bundle:nil] autorelease];
    
    [[self navigationController] pushViewController:sViewController animated:NO];
}


- (IBAction)MD500ButtonTapped:(id)aSender
{
    [mHelicopterInfo autorelease];
    mHelicopterInfo = [[TBHelicopterInfo MD500Info] retain];
}


- (IBAction)UH1ButtonTapped:(id)aSender
{
    [mHelicopterInfo autorelease];
    mHelicopterInfo = [[TBHelicopterInfo UH1Info] retain];
}


- (IBAction)UH1NButtonTapped:(id)aSender
{
    [mHelicopterInfo autorelease];
    mHelicopterInfo = [[TBHelicopterInfo UH1NInfo] retain];
}


- (IBAction)AH1ButtonTapped:(id)aSender
{
    [mHelicopterInfo autorelease];
    mHelicopterInfo = [[TBHelicopterInfo AH1CobraInfo] retain];
}


- (IBAction)AH1WButtonTapped:(id)aSender
{
    [mHelicopterInfo autorelease];
    mHelicopterInfo = [[TBHelicopterInfo AH1WSuperCobraInfo] retain];
}


#pragma mark -


- (void)moneyManager:(TBMoneyManager *)aMoneyManager balanceDidChange:(NSUInteger)aBalance;
{
    [self updateMoneyLabel];
}


@end
