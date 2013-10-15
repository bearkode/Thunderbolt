/*
 *  TBSmokeManager.h
 *  Thunderbolt
 *
 *  Created by cgkim on 13. 5. 13..
 *  Copyright (c) 2013 Tinybean. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import <PBKit.h>


@interface TBSmokeManager : NSObject


+ (id)sharedManager;

- (void)reset;
- (void)doActions;
- (void)setSmokeLayer:(PBNode *)aLayer;
- (void)addSmokeAtPoint:(CGPoint)aPoint;


@end
