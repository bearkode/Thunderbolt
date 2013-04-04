//
//  TBExplosion.h
//  Thunderbolt
//
//  Created by jskim on 10. 2. 7..
//  Copyright 2010 tinybean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBSprite.h"


@class TBTextureInfo;


@interface TBExplosion : TBSprite
{
    NSInteger       mAniIndex;
    NSMutableArray *mTextureInfoArray;
    NSMutableArray *mPositionArray;
}

- (void)addTextureInfo:(TBTextureInfo *)aInfo atPosition:(CGPoint)aPosition;
- (BOOL)isFinished;

@end
