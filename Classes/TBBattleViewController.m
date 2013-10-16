/*
 *  TBBattleViewController.m
 *  Thunderbolt
 *
 *  Created by bearkode on 13. 4. 4..
 *  Copyright (c) 2013 Tinybean. All rights reserved.
 *
 */

#import "TBBattleViewController.h"
#import "TBBattleSceneController.h"


@implementation TBBattleViewController
{
    TBBattleSceneController *mSceneController;
}


#pragma mark -
#pragma mark Init / dealloc


- (id)initWithNibName:(NSString *)aNibNameOrNil bundle:(NSBundle *)aNibBundleOrNil
{
    self = [super initWithNibName:aNibNameOrNil bundle:aNibBundleOrNil];
    
    if (self)
    {
        mSceneController = [[TBBattleSceneController alloc] initWithDelegate:self];
    }
    
    return self;
}


- (void)dealloc
{
    [mSceneController setDelegate:nil];
    [mSceneController release];
    
    [super dealloc];
}


#pragma mark -
#pragma mark Inherited


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self navigationController] setNavigationBarHidden:YES];

    [self presentSceneController:mSceneController];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)viewDidAppear:(BOOL)aAnimated
{
    [super viewDidAppear:aAnimated];
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


- (void)setHelicopterInfo:(TBHelicopterInfo *)aHelicopterInfo
{
    [mSceneController setHelicopterInfo:aHelicopterInfo];
}


#pragma mark -


- (void)battleScene:(TBBattleSceneController *)aSceneController didFinishBattle:(BOOL)aWin
{
    [[self navigationController] popViewControllerAnimated:NO];
}


@end
