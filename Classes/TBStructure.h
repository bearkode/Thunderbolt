/*
 *  TBStructure.h
 *  Thunderbolt
 *
 *  Created by bearkode on 10. 3. 5..
 *  Copyright 2010 tinybean. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "TBSprite.h"
#import "TBGameConst.h"


@interface TBStructure : TBSprite


@property (nonatomic, readonly)                       TBTeam    team;
@property (nonatomic, assign)                         NSInteger durability;
@property (nonatomic, readonly)                       NSInteger damage;
@property (nonatomic, readonly, getter = isDestroyed) BOOL      destroyed;
@property (nonatomic, assign)                         id        delegate;


- (id)initWithTeam:(TBTeam)aTeam;

- (void)addDamage:(NSUInteger)aDamage;


@end


#pragma mark -


@protocol TBStructureDelegate <NSObject>


- (void)structureDidDestroyed:(TBStructure *)aStructure;


@end