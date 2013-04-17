/*
 *  TBBullet.h
 *  Thunderbolt
 *
 *  Created by bearkode on 10. 1. 30..
 *  Copyright 2010 tinybean. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "TBWarhead.h"


@interface TBBullet : TBWarhead


@property (nonatomic, assign) NSInteger life;
@property (nonatomic, assign) CGPoint   vector;


- (void)reset;


@end
