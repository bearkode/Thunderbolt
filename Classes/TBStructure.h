//
//  TBStructure.h
//  Thunderbolt
//
//  Created by jskim on 10. 3. 5..
//  Copyright 2010 tinybean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBSprite.h"
#import "TBGameConst.h"


@interface TBStructure : TBSprite
{
    TBTeam     mTeam;
    NSInteger  mDurability;
    NSInteger  mDamage;
    BOOL       mIsDestroyed;
}

@property (nonatomic, readonly) TBTeam    team;
@property (nonatomic, assign)   NSInteger durability;
@property (nonatomic, assign)   NSInteger damage;
@property (nonatomic, readonly) BOOL      isDestroyed;

- (id)initWithTeam:(TBTeam)aTeam;

- (void)addDamage:(NSUInteger)aDamage;

@end
