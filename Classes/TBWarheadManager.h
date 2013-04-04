//
//  TBWarheadManager.h
//  Thunderbolt
//
//  Created by jskim on 10. 5. 9..
//  Copyright 2010 Tinybean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBGameConst.h"


@class TBWarhead;
@class TBUnit;
@class TBBullet;
@class TBBomb;
@class TBTankShell;


@interface TBWarheadManager : NSObject
{
    NSMutableArray *mWarheadArray;
    
    NSMutableArray *mReusableBulletArray;
}

+ (TBWarheadManager *)sharedManager;

+ (TBBullet *)bulletWithTeam:(TBTeam)aTeam position:(CGPoint)aPos vector:(CGPoint)aVector destructivePower:(NSUInteger)aDestructivePower;
+ (TBBomb *)bombWithTeam:(TBTeam)aTeam position:(CGPoint)aPos speed:(CGFloat)aSpeed;
+ (TBTankShell *)tankShellWithTeam:(TBTeam)aTeam position:(CGPoint)aPos vector:(CGPoint)aVector;

- (void)addObject:(TBWarhead *)aWarhead;
- (NSArray *)allWarheads;

- (void)doActions;
- (void)removeDisabledSprite;

@end
