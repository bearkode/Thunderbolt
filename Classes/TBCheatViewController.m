/*
 *  TBCheatViewController.m
 *  Thunderbolt
 *
 *  Created by cgkim on 13. 4. 19..
 *  Copyright (c) 2013 Tinybean. All rights reserved.
 *
 */

#import "TBCheatViewController.h"


@implementation TBCheatViewController


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
    
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
