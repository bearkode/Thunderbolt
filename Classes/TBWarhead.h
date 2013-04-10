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
{
    TBTeam    mTeam;
    BOOL      mIsAvailable;
    NSInteger mDestructivePower;
}


@property (nonatomic, assign) TBTeam    team;
@property (nonatomic, assign) NSInteger destructivePower;


- (BOOL)isAlly;
- (BOOL)isAvailable;
- (void)setAvailable:(BOOL)aFlag;


@end
