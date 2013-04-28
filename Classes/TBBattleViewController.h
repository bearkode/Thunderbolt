/*
 *  TBBattleViewController.h
 *  Thunderbolt
 *
 *  Created by bearkode on 13. 4. 4..
 *  Copyright (c) 2013 Tinybean. All rights reserved.
 *
 */

#import "PBViewController.h"


@class TBHelicopterInfo;


@interface TBBattleViewController : PBViewController <UIAccelerometerDelegate>


- (void)setHelicopterInfo:(TBHelicopterInfo *)aHelicopterInfo;

@end
