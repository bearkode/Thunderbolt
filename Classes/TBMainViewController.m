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


@implementation TBMainViewController


- (id)initWithNibName:(NSString *)aNibNameOrNil bundle:(NSBundle *)aNibBundleOrNil
{
    self = [super initWithNibName:aNibNameOrNil bundle:aNibBundleOrNil];
    
    if (self)
    {

    }
    
    return self;
}


- (void)dealloc
{
    [super dealloc];
}


#pragma mark -


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect sBounds = [[self view] bounds];

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
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)viewWillAppear:(BOOL)aAnimated
{
    [super viewWillAppear:aAnimated];
    
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
}


#pragma mark -


- (IBAction)startButtonTapped:(id)aSender
{    
    TBBattleViewController *sViewController = [[[TBBattleViewController alloc] initWithNibName:nil bundle:nil] autorelease];

    [[TBMoneyManager sharedManager] setMoney:1800];
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


@end
