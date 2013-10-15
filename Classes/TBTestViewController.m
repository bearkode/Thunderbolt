/*
 *  TBTestViewController.m
 *  Thunderbolt
 *
 *  Created by cgkim on 13. 4. 19..
 *  Copyright (c) 2013 Tinybean. All rights reserved.
 *
 */

#import "TBTestViewController.h"
#import "TBWarheadManager.h"
#import "TBExplosionManager.h"
#import "TBUnitManager.h"
#import "TBEventView.h"
#import "TBHelicopter.h"
#import "TBMissile.h"


@implementation TBTestViewController
{
    TBEventView  *mEventView;
    
    TBHelicopter *mTarget;
    TBMissile    *mMissile;
}


#pragma mark -


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
    NSLog(@"testviewcontroller dealloc");
    [[TBWarheadManager sharedManager] reset];
    [[TBWarheadManager sharedManager] setWarheadLayer:nil];
    [[TBExplosionManager sharedManager] reset];
    [[TBExplosionManager sharedManager] setExplosionLayer:nil];
    [[TBUnitManager sharedManager] reset];
    [[TBUnitManager sharedManager] setUnitLayer:nil];
    
    [super dealloc];
}


#pragma mark -


- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    
    CGRect sBounds = [[self view] bounds];

    mEventView = [[[TBEventView alloc] initWithFrame:sBounds] autorelease];
    [mEventView setDelegate:self];
    [mEventView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [[self view] addSubview:mEventView];
    
    [[self canvas] setBackgroundColor:[PBColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]];

//    PBNode *sLayer = [[self canvas] rootLayer];
    // TODO : scene으로 구조 변경.
    
//    [[TBWarheadManager sharedManager] setWarheadLayer:sLayer];
//    [[TBExplosionManager sharedManager] setExplosionLayer:sLayer];
//    [[TBUnitManager sharedManager] setUnitLayer:sLayer];
    
    mTarget  = [[TBUnitManager sharedManager] addHelicopterWithTeam:kTBTeamAlly delegate:nil];
    mMissile = [[TBUnitManager sharedManager] addMissileWithTeam:kTBTeamEnemy position:CGPointMake(280, 160) target:mTarget];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    [[TBWarheadManager sharedManager] setWarheadLayer:nil];
    [[TBExplosionManager sharedManager] setExplosionLayer:nil];
    [[TBUnitManager sharedManager] setUnitLayer:nil];
    
    mEventView = nil;
}


- (void)viewDidAppear:(BOOL)aAnimated
{
    [super viewDidAppear:aAnimated];
    
    PBCanvas *sCanvas = [self canvas];
    CGRect    sBounds = [sCanvas bounds];
    
    [[self canvas] setDisplayFrameRate:kPBDisplayFrameRateHigh];
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


- (void)pbCanvasWillUpdate:(PBCanvas *)aView
{
    [[TBUnitManager      sharedManager] doActions];
    [[TBWarheadManager   sharedManager] doActions];
    [[TBExplosionManager sharedManager] doActions];
}


#pragma mark EventView Delegate


- (void)eventView:(TBEventView *)aEventView controlAltitude:(CGFloat)aAltitude speed:(CGFloat)aSpeed
{

}


- (void)eventView:(TBEventView *)aEventView touchBegan:(CGPoint)aPoint
{

}


- (void)eventView:(TBEventView *)aEventView touchCancelled:(CGPoint)aPoint
{

}


- (void)eventView:(TBEventView *)aEventView touchEnded:(CGPoint)aPoint
{
    CGPoint sCanvasPoint = [[self canvas] canvasPointFromViewPoint:aPoint];
    
    [mTarget setPoint:sCanvasPoint];
}


- (void)eventView:(TBEventView *)aEventView touchTapCount:(NSInteger)aTabCount
{

}


@end
