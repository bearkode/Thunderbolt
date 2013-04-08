/*
 *  TBExplosion.h
 *  Thunderbolt
 *
 *  Created by bearkode on 10. 2. 7..
 *  Copyright 2010 tinybean. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "TBSprite.h"


@interface TBExplosion : TBSprite


- (void)addTexture:(PBTexture *)aTexture atPosition:(CGPoint)aPosition;
- (BOOL)isFinished;


@end
