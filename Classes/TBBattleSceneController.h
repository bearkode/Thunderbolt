/*
 *  TBBattleSceneController.h
 *  Thunderbolt
 *
 *  Created by cgkim on 13. 10. 15..
 *  Copyright (c) 2013 Tinybean. All rights reserved.
 *
 */

#import "TBSceneController.h"


@class TBHelicopterInfo;


@interface TBBattleSceneController : TBSceneController


@property (nonatomic, retain) TBHelicopterInfo *helicopterInfo;


@end


@protocol TBBattleSceneControllerDelegate <NSObject>


- (void)battleScene:(TBBattleSceneController *)aSceneController didFinishBattle:(BOOL)aWin;


@end