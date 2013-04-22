/*
 *  TBMissile.h
 *  Thunderbolt
 *
 *  Created by bearkode on 10. 5. 8..
 *  Copyright 2010 tinybean. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "TBUnit.h"


@interface TBMissile : TBUnit


@property (nonatomic, copy)   NSNumber *targetID;
@property (nonatomic, assign) NSInteger power;


@end
