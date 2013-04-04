//
//  TBSAM.h
//  Thunderbolt
//
//  Created by jskim on 10. 5. 16..
//  Copyright 2010 Tinybean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBUnit.h"


@class TBAAVulcan;
@class TBMissileLauncher;


@interface TBArmoredVehicle : TBUnit
{
    NSInteger          mTextureNormal;
    NSInteger          mTextureHit;
    NSInteger          mHitDiscount;
    
    TBAAVulcan        *mAAVulcan;
    TBMissileLauncher *mMissileLauncher;
}

@end
