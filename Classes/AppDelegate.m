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
#import "TBBattleViewController.h"


@implementation AppDelegate
{
    UIWindow *mWindow;
}


@synthesize window = mWindow;


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
    
    /*  Setup SoundManager  */
    PBSoundManager *sSoundManager = [PBSoundManager sharedManager];
    [sSoundManager loadSoundNamed:kTBSoundValkyries forKey:kTBSoundValkyries];
    [sSoundManager loadSoundNamed:kTBSoundHeli forKey:kTBSoundHeli];
    [sSoundManager loadSoundNamed:kTBSoundVulcan forKey:kTBSoundVulcan];
    
    /*  Setup ViewController  */
    TBBattleViewController *sViewController = [[[TBBattleViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    UINavigationController *sNaviController = [[[UINavigationController alloc] initWithRootViewController:sViewController] autorelease];

    [sWindow setRootViewController:sNaviController];

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
