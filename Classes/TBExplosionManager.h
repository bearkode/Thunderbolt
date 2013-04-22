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


- (void)addExplosionWithUnit:(TBUnit *)aUnit;

- (TBExplosion *)addTankExplosionAtPoistion:(CGPoint)aPosition;
- (TBExplosion *)addBombExplosionAtPosition:(CGPoint)aPosition;
- (TBExplosion *)addHelicopterExplosionAtPosition:(CGPoint)aPosition leftAhead:(BOOL)aLeftAhead;
- (TBExplosion *)addMissileExplosionAtPosition:(CGPoint)aPosition angle:(CGFloat)aAngle;


- (void)reset;
- (void)setExplosionLayer:(PBLayer *)aExplosionLayer;
- (void)doActions;


@end
