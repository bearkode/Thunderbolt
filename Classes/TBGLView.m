//
//  EAGLView.m
//  Thunderbolt
//
//  Created by jskim on 10. 1. 25..
//  Copyright tinybean 2010. All rights reserved.
//

#import "TBGLView.h"
#import "TBGameConst.h"


#define USE_DEPTH_BUFFER 1


@interface TBGLView (Privates)
@end


@implementation TBGLView (Privates)


- (BOOL)createFramebuffer
{
    glGenFramebuffersOES(1, &mViewFramebuffer);
    glGenRenderbuffersOES(1, &mViewRenderbuffer);
    
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, mViewFramebuffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, mViewRenderbuffer);
    [mContext renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(CAEAGLLayer *)[self layer]];
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, mViewRenderbuffer);
    
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &mBackingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &mBackingHeight);
    
    if (USE_DEPTH_BUFFER)
    {
        glGenRenderbuffersOES(1, &mDepthRenderbuffer);
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, mDepthRenderbuffer);
        glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, mBackingWidth, mBackingHeight);
        glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, mDepthRenderbuffer);
    }
    
    if (glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES)
    {
        NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return NO;
    }
    
    return YES;
}


- (void)destroyFramebuffer
{
    glDeleteFramebuffersOES(1, &mViewFramebuffer);
    mViewFramebuffer = 0;
    glDeleteRenderbuffersOES(1, &mViewRenderbuffer);
    mViewRenderbuffer = 0;
    
    if (mDepthRenderbuffer)
    {
        glDeleteRenderbuffersOES(1, &mDepthRenderbuffer);
        mDepthRenderbuffer = 0;
    }
}


@end


@implementation TBGLView

@synthesize tankButton = mTankButton;
@synthesize ammoButton = mAmmoButton;
@synthesize ammoLabel  = mAmmoLabel;
@synthesize scoreLabel = mScoreLabel;
@synthesize moneyLabel = mMoneyLabel;

@synthesize delegate   = mDelegate;
@synthesize xPos       = mXPos;


#pragma mark -


+ (Class)layerClass
{
    return [CAEAGLLayer class];
}


- (id)initWithCoder:(NSCoder*)aCoder
{    
    CAEAGLLayer  *sEAGLLayer;
    NSDictionary *sProperties;
    
    self = [super initWithCoder:aCoder];
    if (self)
	{
        sEAGLLayer  = (CAEAGLLayer *)[self layer];
        sProperties = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:FALSE], kEAGLDrawablePropertyRetainedBacking,
                                                                 kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
        [sEAGLLayer setOpaque:YES];
        [sEAGLLayer setDrawableProperties:sProperties];
        
        mContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
        
        if (!mContext || ![EAGLContext setCurrentContext:mContext])
        {
            [self release];
            return nil;
        }
		
        mIsAnimating      = FALSE;
        mAniFrameInterval = 1;
        mAniTimer         = nil;
        
        //  Top Consol
        UIColor *sBackColor = [UIColor clearColor];
        
        mAmmoLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 40, 140, 30)] autorelease];
        [mAmmoLabel setBackgroundColor:sBackColor];
        [mAmmoLabel setTextColor:[UIColor whiteColor]];
        [mAmmoLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:mAmmoLabel];
        
        mScoreLabel = [[[UILabel alloc] initWithFrame:CGRectMake(190, 40, 100, 30)] autorelease];
        [mScoreLabel setBackgroundColor:sBackColor];
        [mScoreLabel setTextColor:[UIColor whiteColor]];
        [mScoreLabel setFont:[UIFont systemFontOfSize:14]];
        [mScoreLabel setTextAlignment:UITextAlignmentCenter];
        [self addSubview:mScoreLabel];
        
        mMoneyLabel = [[[UILabel alloc] initWithFrame:CGRectMake(340, 40, 120, 30)] autorelease];
        [mMoneyLabel setBackgroundColor:sBackColor];
        [mMoneyLabel setTextColor:[UIColor whiteColor]];
        [mMoneyLabel setFont:[UIFont systemFontOfSize:14]];
        [mMoneyLabel setTextAlignment:UITextAlignmentRight];
        [self addSubview:mMoneyLabel];
        
        //  Bottom Consol
        UIView *sGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 320 - MAP_GROUND, 480, MAP_GROUND)];
        [sGroundView setBackgroundColor:[UIColor grayColor]];
        [self addSubview:sGroundView];
        [sGroundView release];
        
        mTankButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [mTankButton setFrame:CGRectMake(10, 5, 60, 30)];
        [mTankButton setTitle:@"Tank" forState:UIControlStateNormal];
        [sGroundView addSubview:mTankButton];
        
        mAmmoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [mAmmoButton setFrame:CGRectMake(410, 5, 60, 30)];
        [mAmmoButton setTitle:@"Ammo" forState:UIControlStateNormal];
        [sGroundView addSubview:mAmmoButton];
    }
	
    return self;
}


- (void)dealloc
{
    [self stopAnimation];
    
    if ([EAGLContext currentContext] == mContext)
    {
        [EAGLContext setCurrentContext:nil];
    }
    [mContext release];
    
    [super dealloc];
}


- (void)touchesBegan:(NSSet *)aTouches withEvent:(UIEvent *)aEvent
{
    UITouch *sTouch = [[aTouches allObjects] objectAtIndex:0];
    mBeginPoint = [sTouch locationInView:self];
    
    if ([mDelegate respondsToSelector:@selector(glView:touchBegan:)])
    {
        [mDelegate glView:self touchBegan:mBeginPoint];
    }
}


- (void)touchesCancelled:(NSSet *)aTouches withEvent:(UIEvent *)aEvent
{
    UITouch *sTouch = [[aTouches allObjects] objectAtIndex:0];
    CGPoint  sPoint = [sTouch locationInView:self];
    
    mBeginPoint = CGPointMake(-1, -1);
    
    if ([mDelegate respondsToSelector:@selector(glView:touchCancelled:)])
    {
        [mDelegate glView:self touchCancelled:sPoint];
    }
}


- (void)touchesMoved:(NSSet *)aTouches withEvent:(UIEvent *)aEvent
{
    UITouch *sTouch = [[aTouches allObjects] objectAtIndex:0];
    CGPoint  sPoint = [sTouch locationInView:self];
    
    if ([mDelegate respondsToSelector:@selector(glView:touchMoved:)])
    {
        [mDelegate glView:self touchMoved:sPoint];
    }
}


- (void)touchesEnded:(NSSet *)aTouches withEvent:(UIEvent *)aEvent
{
    UITouch  *sTouch = [[aTouches allObjects] objectAtIndex:0];
    CGPoint   sPoint = [sTouch locationInView:self];
    NSInteger sCount = [sTouch tapCount];
//    NSInteger sSwipe = (sPoint.y < mBeginPoint.y) ? kGLViewSwipeUp : kGLViewSwipeDown;
    
    if ([mDelegate respondsToSelector:@selector(glView:touchEnded:)])
    {
        [mDelegate glView:self touchEnded:sPoint];
    }
    
/*    if (sCount == 0)    //  SWIPE
    {
        if (abs(sPoint.y - mBeginPoint.y) > 30)
        {
            if ([mDelegate respondsToSelector:@selector(glView:touchSwipe:)])
            {
                [mDelegate glView:self touchSwipe:sSwipe];
            }
        }
    }
    else                //  TAP
    {*/
        if ([mDelegate respondsToSelector:@selector(glView:touchTapCount:)])
        {
            [mDelegate glView:self touchTapCount:sCount];
        }
/*    }*/
}


#pragma mark -


- (void)drawView:(id)sender
{
    CGRect sBounds = [self bounds];
    
    [EAGLContext setCurrentContext:mContext];
    
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, mViewFramebuffer);
    glViewport(0, 0, mBackingWidth, mBackingHeight);
    
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    
    glOrthof(mXPos, mXPos + sBounds.size.width, 0.0f, sBounds.size.height, -1000.0f, 1000.0f);    
    
    glEnable(GL_CULL_FACE);
    
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    
    glClearColor(0.5f, 0.5f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    glEnable(GL_TEXTURE_2D);
    glEnable(GL_BLEND);    
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

    [mDelegate glViewRenderObjects:self];
    
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, mViewRenderbuffer);
    [mContext presentRenderbuffer:GL_RENDERBUFFER_OES];
}


- (void)layoutSubviews
{
    [EAGLContext setCurrentContext:mContext];
    [self destroyFramebuffer];
    [self createFramebuffer];
    [self drawView:nil];
}


#pragma mark -


- (NSInteger)animationFrameInterval
{
	return mAniFrameInterval;
}


- (void)setAnimationFrameInterval:(NSInteger)aFrameInterval
{
	if (aFrameInterval >= 1)
	{
		mAniFrameInterval = aFrameInterval;
		
		if (mIsAnimating)
		{
			[self stopAnimation];
			[self startAnimation];
		}
	}
}


- (void)startAnimation
{
	if (!mIsAnimating)
	{
        mAniTimer = [NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval)((1.0 / 30.0) * mAniFrameInterval)
                                                     target:self
                                                   selector:@selector(drawView:)
                                                   userInfo:nil
                                                    repeats:YES];
		mIsAnimating = TRUE;
	}
}


- (void)stopAnimation
{
	if (mIsAnimating)
	{
        [mAniTimer invalidate];
        mAniTimer    = nil;
        mIsAnimating = FALSE;
	}
}


- (BOOL)isAnimating
{
    return mIsAnimating;
}


@end
