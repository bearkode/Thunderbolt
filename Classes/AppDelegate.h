//
//  ThunderboltAppDelegate.h
//  Thunderbolt
//
//  Created by jskim on 10. 1. 25..
//  Copyright tinybean 2010. All rights reserved.
//

#import <UIKit/UIKit.h>


@class TBGLView;
@class TBGameController;


@interface AppDelegate : NSObject <UIApplicationDelegate>
{
    UIWindow         *mWindow;
    TBGLView         *mGLView;
    TBGameController *mGameController;
}

@property (nonatomic, retain) IBOutlet UIWindow         *window;
@property (nonatomic, retain) IBOutlet TBGLView         *GLView;
@property (nonatomic, assign) IBOutlet TBGameController *gameController;

@end

