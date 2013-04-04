//
//  TBTank.h
//  Thunderbolt
//
//  Created by jskim on 10. 1. 29..
//  Copyright 2010 tinybean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBUnit.h"


@class TBTankGun;


@interface TBTank : TBUnit
{
    NSInteger   mTextureNormal;
    NSInteger   mTextureHit;
    
    NSInteger   mHitDiscount;
    
    TBTankGun  *mTankGun;
}

@end
