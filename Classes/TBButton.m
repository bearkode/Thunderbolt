/*
 *  TBButton.m
 *  Thunderbolt
 *
 *  Created by cgkim on 13. 10. 22..
 *  Copyright (c) 2013 Tinybean. All rights reserved.
 *
 */

#import "TBButton.h"


static NSString *const kLPAnimationKeyPath      = @"transform.scale";

static NSString *const kTBScaleUpAnimationKey   = @"ScaleUpAnimation";
static NSString *const kTBScaleDownAnimationKey = @"ScaleDownAnimation";
static NSString *const kTBScaleModeKey          = @"ScaleMode";
static NSString *const kTBScaleUpKey            = @"Up";
static NSString *const kTBScaleDownKey          = @"Down";

static CGFloat   const kScaleUpDuration         = 0.05;
static CGFloat   const kScaleDownDuration       = 0.12;

static CGFloat   const kMaxScale                = 1.1;
static CGFloat   const kMinScale                = 0.9;
static CGFloat   const kNormalScale             = 1.0;


@implementation TBButton
{
    BOOL mAnimated;
}


@synthesize animated = mAnimated;


#pragma mark -


- (void)beginScaleUpAnimation
{
    CABasicAnimation *sAnimation = [CABasicAnimation animationWithKeyPath:kLPAnimationKeyPath];
    [sAnimation setFromValue:[NSNumber numberWithFloat:kNormalScale]];
    [sAnimation setToValue:[NSNumber numberWithFloat:kMaxScale]];
    
    CAAnimationGroup *sAnimationGroup = [CAAnimationGroup animation];
    [sAnimationGroup setDelegate:self];
    [sAnimationGroup setDuration:kScaleUpDuration];
    [sAnimationGroup setValue:kTBScaleUpKey forKey:kTBScaleModeKey];
    [sAnimationGroup setAnimations:[NSArray arrayWithObjects:sAnimation, nil]];
    
    [[self layer] setTransform:CATransform3DMakeScale(kMaxScale, kMaxScale, 1.0)];
    [[self layer] addAnimation:sAnimationGroup forKey:kTBScaleUpAnimationKey];
}


- (void)beginScaleDownAnimation
{
    CABasicAnimation *sAnimation1 = [CABasicAnimation animationWithKeyPath:kLPAnimationKeyPath];
    [sAnimation1 setFromValue:[NSNumber numberWithFloat:kMaxScale]];
    [sAnimation1 setToValue:[NSNumber numberWithFloat:kMinScale]];
    
    CABasicAnimation *sAnimation2 = [CABasicAnimation animationWithKeyPath:kLPAnimationKeyPath];
    [sAnimation2 setFromValue:[NSNumber numberWithFloat:kMinScale]];
    [sAnimation2 setToValue:[NSNumber numberWithFloat:kNormalScale]];
    
    CAAnimationGroup *sAnimationGroup = [CAAnimationGroup animation];
    [sAnimationGroup setDelegate:self];
    [sAnimationGroup setDuration:kScaleDownDuration];
    [sAnimationGroup setValue:kTBScaleDownKey forKey:kTBScaleModeKey];
    [sAnimationGroup setAnimations:[NSArray arrayWithObjects:sAnimation1, sAnimation2, nil]];
    
    [[self layer] setTransform:CATransform3DMakeScale(kNormalScale, kNormalScale, 1.0)];
    [[self layer] addAnimation:sAnimationGroup forKey:kTBScaleDownAnimationKey];
}


#pragma mark -


- (void)touchesBegan:(NSSet *)aTouches withEvent:(UIEvent *)aEvent
{
    [super touchesBegan:aTouches withEvent:aEvent];
    
    if ([self isAnimated])
    {
        [self beginScaleUpAnimation];
    }
}


- (void)touchesEnded:(NSSet *)aTouches withEvent:(UIEvent *)aEvent
{
    [super touchesEnded:aTouches withEvent:aEvent];
    
    if ([self isAnimated])
    {
        [self beginScaleDownAnimation];
    }
}


- (void)touchesCancelled:(NSSet *)aTouches withEvent:(UIEvent *)aEvent
{
    [super touchesCancelled:aTouches withEvent:aEvent];
    
    if ([self isAnimated])
    {
        [self beginScaleDownAnimation];
    }
}


#pragma mark -


- (void)animationDidStop:(CAAnimation *)aAnimation finished:(BOOL)aFlag
{
    if (aFlag)
    {
        [[self layer] removeAllAnimations];
    }
}


@end
