//
//  ThunderboltAppDelegate.m
//  Thunderbolt
//
//  Created by jskim on 10. 1. 25..
//  Copyright tinybean 2010. All rights reserved.
//

#import "AppDelegate.h"
#import "TBGLView.h"
#import "TBGameController.h"
#import "TBALPlayback.h"
#import "TBMacro.h"


@implementation AppDelegate


@synthesize window         = mWindow;
@synthesize GLView         = mGLView;
@synthesize gameController = mGameController;


#pragma mark -


- (void)applicationDidFinishLaunching:(UIApplication *)application
{
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];

    [mGLView setTransform:CGAffineTransformMakeRotation(TBDegreesToRadians(90))];
    [mGLView setFrame:CGRectMake(0, 0, 320, 480)];
    [mGLView startAnimation];
    
    [mGameController setGLView:mGLView];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
	[mGLView stopAnimation];
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
	[mGLView startAnimation];
}


- (void)applicationWillTerminate:(UIApplication *)application
{
	[mGLView stopAnimation];
}


- (void)dealloc
{
	[mWindow release];
	[mGLView release];
	
	[super dealloc];
}


@end
