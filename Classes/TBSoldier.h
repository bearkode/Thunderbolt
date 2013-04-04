//
//  TBSoldier.h
//  Thunderbolt
//
//  Created by jskim on 10. 7. 22..
//  Copyright 2010 Tinybean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBUnit.h"


@class TBRifle;


@interface TBSoldier : TBUnit
{
    NSUInteger      mTick;
    NSMutableArray *mTextureArray;
    
    TBRifle        *mRifle;
}

@end
