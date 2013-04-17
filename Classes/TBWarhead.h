/*
 *  TBWarhead.h
 *  Thunderbolt
 *
 *  Created by bearkode on 10. 2. 3..
 *  Copyright 2010 tinybean. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "TBSprite.h"
#import "TBGameConst.h"


@interface TBWarhead : TBSprite


@property (nonatomic, assign)               TBTeam    team;
@property (nonatomic, assign)               NSInteger destructivePower;
@property (nonatomic, getter = isAvailable) BOOL      available;


- (BOOL)isAlly;


@end
