//
//  TBGameController.h
//  Thunderbolt
//
//  Created by jskim on 10. 1. 26..
//  Copyright 2010 tinybean. All rights reserved.
//

#import <Foundation/Foundation.h>


@class TBGLView;
@class TBSprite;
@class TBBase;
@class TBLandingPad;
@class TBAAGunSite;
@class TBRadar;


@interface TBGameController : NSObject <UIAccelerometerDelegate>
{
    TBGLView  *mGLView;

    TBSprite  *mStar0;
    TBSprite  *mStar1;
    TBSprite  *mStar2;
    
    TBRadar   *mRadar;
    
    CGFloat    mBackPoint;
    NSInteger  mTimeTick;
}

@property (nonatomic, assign) TBGLView *GLView;

@end
