/*
 *  TBControlStickValue.h
 *  Thunderbolt
 *
 *  Created by bearkode on 13. 4. 8..
 *  Copyright (c) 2013 Tinybean. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


@interface TBControlLever : NSObject


- (id)initWithHelicopter:(id)aHelicopter;


- (void)setAltitude:(CGFloat)aAltitude speed:(CGFloat)aSpeed;


@end
