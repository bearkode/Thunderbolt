/*
 *  TBSAM.h
 *  Thunderbolt
 *
 *  Created by bearkode on 10. 5. 16..
 *  Copyright 2010 Tinybean. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "TBUnit.h"


@class TBAAVulcan;
@class TBMissileLauncher;


@interface TBArmoredVehicle : TBUnit
{
    NSInteger          mHitDiscount;
    
    TBAAVulcan        *mAAVulcan;
    TBMissileLauncher *mMissileLauncher;
}

@end
