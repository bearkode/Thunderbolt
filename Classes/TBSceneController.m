/*
 *  TBSceneController.m
 *  Thunderbolt
 *
 *  Created by cgkim on 13. 10. 15..
 *  Copyright (c) 2013 Tinybean. All rights reserved.
 *
 */

#import "TBSceneController.h"


@implementation TBSceneController
{
    id        mDelegate;
    PBCanvas *mCanvas;
    PBScene  *mScene;
    UIView   *mControlView;
}


@synthesize delegate    = mDelegate;
@synthesize canvas      = mCanvas;
@synthesize scene       = mScene;
@synthesize controlView = mControlView;


#pragma mark -


- (id)init
{
    [self release];
    self = nil;
    
    NSAssert(NO, @"");
    
    return self;
}


- (id)initWithDelegate:(id)aDelegate
{
    self = [super init];
    
    if (self)
    {
        mDelegate    = aDelegate;
        mScene       = [[PBScene alloc] initWithDelegate:self];
        mControlView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    }
    
    return self;
}


- (void)dealloc
{
    [mCanvas release];
    [mScene setDelegate:nil];
    [mScene release];
    [mControlView release];
    
    [super dealloc];
}


#pragma mark -


- (void)delegateAction:(id)aSender
{
    if ([mDelegate respondsToSelector:@selector(sceneController:didAction:)])
    {
        [mDelegate sceneController:self didAction:aSender];
    }
}


- (void)sceneDidPresent
{
    
}


- (void)sceneDidResize
{

}


- (void)sceneDidDismiss
{
    
}


#pragma mark -


- (void)pbSceneWillResize:(PBScene *)aScene
{

}


- (void)pbSceneDidResize:(PBScene *)aScene
{
    [self sceneDidResize];
}


- (void)pbSceneWillUpdate:(PBScene *)aScene
{

}


- (void)pbSceneDidUpdate:(PBScene *)aScene
{

}


- (void)pbSceneWillRender:(PBScene *)aScene
{

}


- (void)pbSceneDidRender:(PBScene *)aScene
{

}


- (void)pbScene:(PBScene *)aScene didTapCanvasPoint:(CGPoint)aCanvasPoint
{

}


- (void)pbScene:(PBScene *)aScene didLongTapCanvasPoint:(CGPoint)aCanvasPoint
{

}


@end
