/*
 *  TBRadar.h
 *  Thunderbolt
 *
 *  Created by bearkode on 10. 5. 20..
 *  Copyright 2010 Tinybean. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "TBSprite.h"


@interface TBRadar : PBDynamicNode


- (void)setCanvasSize:(CGSize)aCanvasSize;
- (void)update;


@end
