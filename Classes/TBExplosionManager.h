/*
 *  TBExplosionManager.h
 *  Thunderbolt
 *
 *  Created by bearkode on 10. 5. 9..
 *  Copyright 2010 Tinybean. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import <PBKit.h>


@class TBExplosion;
@class TBUnit;


@interface TBExplosionManager : NSObject


+ (TBExplosionManager *)sharedManager;


+ (void)explosionWithUnit:(TBUnit *)aUnit;

+ (TBExplosion *)tankExplosionAtPoistion:(CGPoint)aPosition;
+ (TBExplosion *)bombExplosionAtPosition:(CGPoint)aPosition;
+ (TBExplosion *)helicopterExplosionAtPosition:(CGPoint)aPosition isLeftAhead:(BOOL)aIsLeftAhead;
+ (TBExplosion *)missileExplosionAtPosition:(CGPoint)aPosition angle:(CGFloat)aAngle;


- (void)setExplosionLayer:(PBLayer *)aExplosionLayer;
- (void)doActions;
- (void)removeFinishedExplosion;


@end
