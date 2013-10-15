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
- (void)didPresent;
- (void)didDismiss;


@end


@protocol TBSceneControllerDelegate <NSObject>


- (void)sceneController:(TBSceneController *)aController didAction:(id)aSender;


@end