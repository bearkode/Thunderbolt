/*
 *  TBViewController.h
 *  Thunderbolt
 *
 *  Created by cgkim on 13. 10. 15..
 *  Copyright (c) 2013 Tinybean. All rights reserved.
 *
 */

#import <PBKit.h>


@class TBSceneController;


@interface TBViewController : PBViewController


- (void)presentSceneController:(TBSceneController *)aSceneController;
- (void)dismissSceneController;


@end
