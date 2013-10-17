/*
 *  TBRepairIndicator.h
 *  Thunderbolt
 *
 *  Created by cgkim on 13. 10. 17..
 *  Copyright (c) 2013 Tinybean. All rights reserved.
 *
 */

#import "PBSpriteNode.h"


@interface TBRepairIndicator : PBSpriteNode


- (void)setEnabled:(BOOL)aFlag;
- (BOOL)isEnabled;

- (void)action;


@end
