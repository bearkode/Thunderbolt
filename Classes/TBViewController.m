/*
 *  TBViewController.m
 *  Thunderbolt
 *
 *  Created by cgkim on 13. 10. 15..
 *  Copyright (c) 2013 Tinybean. All rights reserved.
 *
 */

#import "TBViewController.h"
#import "TBSceneController.h"


@implementation TBViewController
{
    TBSceneController *mSceneController;
    UIView            *mControlView;
}


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
    [mSceneController release];
    
    [super dealloc];
}


#pragma mark -


- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark -


- (void)presentSceneController:(TBSceneController *)aSceneController
{
    if (mSceneController != aSceneController)
    {
        [mSceneController autorelease];
        mSceneController = [aSceneController retain];
        
        [[self canvas] presentScene:[mSceneController scene]];
        [mSceneController setCanvas:[self canvas]];
        
        UIView *sControlView = [mSceneController controlView];
        [sControlView setFrame:[[self view] bounds]];
        [sControlView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
        [[self view] addSubview:sControlView];
        
        [[self view] sendSubviewToBack:sControlView];
        [[self view] sendSubviewToBack:[self canvas]];
        
        [mSceneController didPresent];
    }
}


- (void)dismissSceneController
{
    [mSceneController didDismiss];
}


@end
