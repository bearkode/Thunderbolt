//
//  TBExplosionManager.h
//  Thunderbolt
//
//  Created by jskim on 10. 5. 9..
//  Copyright 2010 Tinybean. All rights reserved.
//

#import <Foundation/Foundation.h>


@class TBExplosion;
@class TBUnit;


@interface TBExplosionManager : NSObject
{
    NSMutableArray *mExplosionArray;
}

+ (TBExplosionManager *)sharedManager;

+ (void)explosionWithUnit:(TBUnit *)aUnit;
+ (TBExplosion *)tankExplosionAtPoistion:(CGPoint)aPosition;
+ (TBExplosion *)bombExplosionAtPosition:(CGPoint)aPosition;
+ (TBExplosion *)helicopterExplosionAtPosition:(CGPoint)aPosition isLeftAhead:(BOOL)aIsLeftAhead;
+ (TBExplosion *)missileExplosionAtPosition:(CGPoint)aPosition angle:(CGFloat)aAngle;

- (void)doActions;
- (void)removeFinishedExplosion;

@end
