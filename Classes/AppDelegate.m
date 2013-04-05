/*
 *  AppDelegate.m
 *  Thunderbolt
 *
 *  Created by bearkode on 10. 1. 25..
 *  Copyright tinybean 2010. All rights reserved.
 *
 */

#import "AppDelegate.h"
#import "TBGLView.h"
#import "TBGameController.h"
#import "TBALPlayback.h"
#import "TBMacro.h"
#import "TBBattleViewController.h"


@implementation AppDelegate
{
    UIWindow *mWindow;
}

@synthesize window         = mWindow;
//@synthesize GLView         = mGLView;
//@synthesize gameController = mGameController;


#pragma mark -


- (void)dealloc
{
    [super dealloc];
}


#pragma mark -


- (BOOL)application:(UIApplication *)aApplication didFinishLaunchingWithOptions:(NSDictionary *)aLaunchOptions
{
    UIWindow *sWindow = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];

    [self setWindow:sWindow];
    [sWindow makeKeyAndVisible];
    
    TBBattleViewController *sViewController = [[[TBBattleViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    UINavigationController *sNaviController = [[[UINavigationController alloc] initWithRootViewController:sViewController] autorelease];

    [sWindow setRootViewController:sNaviController];

    
#if (0)
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];

    [mGLView setTransform:CGAffineTransformMakeRotation(TBDegreesToRadians(90))];
    [mGLView setFrame:CGRectMake(0, 0, 320, 480)];
    [mGLView startAnimation];
    
    [mGameController setGLView:mGLView];
#endif
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{

}


- (void)applicationDidEnterBackground:(UIApplication *)aApplication
{
    
}


- (void)applicationWillEnterForeground:(UIApplication *)aApplication
{
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{

}


- (void)applicationWillTerminate:(UIApplication *)application
{

}


@end
