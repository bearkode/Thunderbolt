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
    NSMutableArray        *mHeliButtons;
    
    TBHelicopterInfo      *mHelicopterInfo;
}


#pragma mark -


- (void)updateMoneyLabel
{
    NSUInteger sMoney = [[TBMoneyManager sharedManager] balance];
    NSString  *sText  = [[[NSString alloc] initWithFormat:@"Money = %d", (int)sMoney] autorelease];
    
    [mMoneyLabel setText:sText];
}


- (void)setupButtons
{
    CGRect  sBounds = [[self view] bounds];
    UIView *sBoard  = [[[UIView alloc] initWithFrame:CGRectMake((sBounds.size.width - 430) / 2.0, 30, 430, 100)] autorelease];
    
    [sBoard setBackgroundColor:[UIColor clearColor]];
    [sBoard setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin)];
    [[self view] addSubview:sBoard];
    
    {
        NSArray  *sTitles    = @[@"MD500", @"UH1N", @"AH1", @"AH1W"];
        NSArray  *sSelectors = @[@"MD500ButtonTapped:", @"UH1NButtonTapped:", @"AH1ButtonTapped:", @"AH1WButtonTapped:"];
        NSInteger sXPos      = 0;
        
        [mHeliButtons removeAllObjects];
        
        for (NSInteger i = 0; i < [sTitles count]; i++)
        {
            NSString *sTitle    = [sTitles objectAtIndex:i];
            NSString *sSelector = [sSelectors objectAtIndex:i];
            UIButton *sButton   = [UIButton buttonWithType:UIButtonTypeCustom];
            
            [sButton setBackgroundImage:[UIImage imageNamed:@"button_n"] forState:UIControlStateNormal];
            [sButton setBackgroundImage:[UIImage imageNamed:@"button_h"] forState:UIControlStateSelected];
            [sButton setTitle:sTitle forState:UIControlStateNormal];
            [sButton setTitleEdgeInsets:UIEdgeInsetsMake(70, 0, 0, 0)];
            [[sButton titleLabel] setFont:[UIFont boldSystemFontOfSize:14]];
            [sButton addTarget:self action:NSSelectorFromString(sSelector) forControlEvents:UIControlEventTouchUpInside];
            [sButton setFrame:CGRectMake(sXPos, 0, 100, 100)];

            if (i == 0)
            {
                [sButton setSelected:YES];
            }
            
            [sBoard addSubview:sButton];
            [mHeliButtons addObject:sButton];
            
            sXPos += (100.0 + 10.0);
        }
    }
}


- (void)selectButton:(UIButton *)aButton
{
    for (UIButton *sButton in mHeliButtons)
    {
        [sButton setSelected:NO];
    }
    
    [aButton setSelected:YES];
}


#pragma mark -


- (id)initWithNibName:(NSString *)aNibNameOrNil bundle:(NSBundle *)aNibBundleOrNil
{
    self = [super initWithNibName:aNibNameOrNil bundle:aNibBundleOrNil];
    
    if (self)
    {
        mSceneController = [[TBMainSceneController alloc] initWithDelegate:self];
        mHeliButtons     = [[NSMutableArray alloc] init];
    }
    
    return self;
}


- (void)dealloc
{
    [mSceneController release];
    [mHeliButtons release];
    
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
    
    [self setupButtons];
    [self AH1WButtonTapped:[mHeliButtons lastObject]];
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


- (void)viewDidAppear:(BOOL)aAnimated
{
    [super viewDidAppear:aAnimated];

    NSMutableArray *sPositions = [NSMutableArray array];
    
    for (UIButton *sButton in mHeliButtons)
    {
        CGRect  sFrame       = [sButton frame];
        CGPoint sCenterPoint = CGPointMake(CGRectGetMidX(sFrame), CGRectGetMidY(sFrame));
        
        sCenterPoint = [[sButton superview] convertPoint:sCenterPoint toView:[self view]];

        [sPositions addObject:[NSValue valueWithCGPoint:sCenterPoint]];
    }
    
    [mSceneController setPositions:sPositions];
}


- (void)viewWillDisappear:(BOOL)aAnimated
{
    [super viewWillDisappear:aAnimated];
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
    
    [self selectButton:aSender];
}


- (IBAction)UH1ButtonTapped:(id)aSender
{
    [mHelicopterInfo autorelease];
    mHelicopterInfo = [[TBHelicopterInfo UH1Info] retain];
    
    [self selectButton:aSender];
}


- (IBAction)UH1NButtonTapped:(id)aSender
{
    [mHelicopterInfo autorelease];
    mHelicopterInfo = [[TBHelicopterInfo UH1NInfo] retain];
    
    [self selectButton:aSender];
}


- (IBAction)AH1ButtonTapped:(id)aSender
{
    [mHelicopterInfo autorelease];
    mHelicopterInfo = [[TBHelicopterInfo AH1CobraInfo] retain];
    
    [self selectButton:aSender];
}


- (IBAction)AH1WButtonTapped:(id)aSender
{
    [mHelicopterInfo autorelease];
    mHelicopterInfo = [[TBHelicopterInfo AH1WSuperCobraInfo] retain];
    
    [self selectButton:aSender];
}


#pragma mark -


- (void)moneyManager:(TBMoneyManager *)aMoneyManager balanceDidChange:(NSUInteger)aBalance;
{
    [self updateMoneyLabel];
}


@end
