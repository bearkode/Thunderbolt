/*
 *  TBSceneController.h
 *  Thunderbolt
 *
 *  Created by cgkim on 13. 10. 15..
 *  Copyright (c) 2013 Tinybean. All rights reserved.
 *
 */

#import <PBKit.h>


@interface TBSceneController : NSObject


@property (nonatomic, assign) id        delegate;
@property (nonatomic, retain) PBCanvas *canvas;
@property (nonatomic, retain) PBScene  *scene;
@property (nonatomic, retain) UIView   *controlView;


#pragma mark -


- (id)initWithDelegate:(id)aDelegate;


#pragma mark -


- (void)delegateAction:(id)aSender;
- (void)sceneDidPresent;
- (void)sceneDidResize;
- (void)sceneDidDismiss;


#pragma mark -

- (void)pbSceneWillResize:(PBScene *)aScene;
- (void)pbSceneDidResize:(PBScene *)aScene;

- (void)pbSceneWillUpdate:(PBScene *)aScene;
- (void)pbSceneDidUpdate:(PBScene *)aScene;
- (void)pbSceneWillRender:(PBScene *)aScene;
- (void)pbSceneDidRender:(PBScene *)aScene;

- (void)pbScene:(PBScene *)aScene didTapCanvasPoint:(CGPoint)aCanvasPoint;
- (void)pbScene:(PBScene *)aScene didLongTapCanvasPoint:(CGPoint)aCanvasPoint;


@end


@protocol TBSceneControllerDelegate <NSObject>


- (void)sceneController:(TBSceneController *)aController didAction:(id)aSender;


@end