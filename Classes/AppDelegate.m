/*
 *  AppDelegate.m
 *  Thunderbolt
 *
 *  Created by bearkode on 10. 1. 25..
 *  Copyright tinybean 2010. All rights reserved.
 *
 */

#import "AppDelegate.h"
#import <PBKit.h>
#import "TBGameConst.h"
#import "TBMacro.h"
#import "TBMainViewController.h"
#import "TBBattleViewController.h"
#import "TBUserStatusManager.h"
#import "ProfilingOverlay.h"


@implementation AppDelegate
{
    UIWindow *mWindow;
}


@synthesize window = mWindow;


#pragma mark -


- (void)showPrifilingOverlay
{
    [ProfilingOverlay setHidden:NO];
    [[ProfilingOverlay sharedManager] startCPUMemoryUsages];
}


#pragma mark -


- (void)dealloc
{
    [super dealloc];
}


#pragma mark -


- (BOOL)application:(UIApplication *)aApplication didFinishLaunchingWithOptions:(NSDictionary *)aLaunchOptions
{
#if (0)
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
#endif
    
    /*  Setup Window  */
    UIWindow *sWindow = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];

    [self setWindow:sWindow];
    [sWindow makeKeyAndVisible];
    
    [aApplication setStatusBarHidden:YES];
    
    /*  Setup SoundManager  */
    PBSoundManager *sSoundManager = [PBSoundManager sharedManager];
    [sSoundManager loadSoundNamed:kTBSoundValkyries forKey:kTBSoundValkyries];
    [sSoundManager loadSoundNamed:kTBSoundHeli forKey:kTBSoundHeli];
    [sSoundManager loadSoundNamed:kTBSoundMD500 forKey:kTBSoundMD500];
    [sSoundManager loadSoundNamed:kTBSoundVulcan forKey:kTBSoundVulcan];
    [sSoundManager loadSoundNamed:kTBSoundTankExplosion forKey:kTBSoundTankExplosion];
    [sSoundManager loadSoundNamed:kTBSoundBombExplosion forKey:kTBSoundBombExplosion];

    /*  Setup ViewController  */
#if (0)
    TBBattleViewController *sViewController = [[[TBBattleViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    UINavigationController *sNaviController = [[[UINavigationController alloc] initWithRootViewController:sViewController] autorelease];
#else
    TBMainViewController   *sViewController = [[[TBMainViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    UINavigationController *sNaviController = [[[UINavigationController alloc] initWithRootViewController:sViewController] autorelease];
#endif

    [sWindow setRootViewController:sNaviController];

//    [self performSelector:@selector(showPrifilingOverlay) withObject:nil afterDelay:0.5];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{

}


- (void)applicationDidEnterBackground:(UIApplication *)aApplication
{
    [[TBUserStatusManager sharedManager] saveStatus];
}


- (void)applicationWillEnterForeground:(UIApplication *)aApplication
{

}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[TBUserStatusManager sharedManager] loadStatus];
}


- (void)applicationWillTerminate:(UIApplication *)application
{

}


@end
