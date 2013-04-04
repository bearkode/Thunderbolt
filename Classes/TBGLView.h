//
//  EAGLView.h
//  Thunderbolt
//
//  Created by jskim on 10. 1. 25..
//  Copyright tinybean 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface TBGLView : UIView
{
    UIButton    *mTankButton;
    UIButton    *mAmmoButton;
    UILabel     *mAmmoLabel;
    UILabel     *mScoreLabel;
    UILabel     *mMoneyLabel;
    
    EAGLContext *mContext;
    GLint        mBackingWidth;
    GLint        mBackingHeight;
    GLuint       mViewRenderbuffer;
    GLuint       mViewFramebuffer;
    GLuint       mDepthRenderbuffer;
	
    BOOL         mIsAnimating;
    NSInteger    mAniFrameInterval;
    NSTimer     *mAniTimer;
    
    id           mDelegate;
    
    CGFloat      mXPos;
    
    //  TOUCHES
    CGPoint      mBeginPoint;
}

@property (nonatomic, readonly) UIButton *tankButton;
@property (nonatomic, readonly) UIButton *ammoButton;
@property (nonatomic, readonly) UILabel  *ammoLabel;
@property (nonatomic, readonly) UILabel  *scoreLabel;
@property (nonatomic, readonly) UILabel  *moneyLabel;

@property (nonatomic, assign) id        delegate;
@property (nonatomic, assign) CGFloat   xPos;

- (NSInteger)animationFrameInterval;
- (void)setAnimationFrameInterval:(NSInteger)aFrameInterval;
- (void)startAnimation;
- (void)stopAnimation;
- (BOOL)isAnimating;

@end


#define kGLViewSwipeUp      0
#define kGLViewSwipeDown    1


@protocol TBGLViewDelegate <NSObject>

- (void)glViewRenderObjects:(TBGLView *)aGLView;

- (void)glView:(TBGLView *)aGLView touchBegan:(CGPoint)aPoint;
- (void)glView:(TBGLView *)aGLView touchCancelled:(CGPoint)aPoint;
- (void)glView:(TBGLView *)aGLView touchMoved:(CGPoint)aPoint;
- (void)glView:(TBGLView *)aGLView touchEnded:(CGPoint)aPoint;
- (void)glView:(TBGLView *)aGLView touchSwipe:(NSInteger)aDirection;
- (void)glView:(TBGLView *)aGLView touchTapCount:(NSInteger)aTabCount;

@end
