//
//  TBAAGun.h
//  Thunderbolt
//
//  Created by jskim on 10. 7. 4..
//  Copyright 2010 Tinybean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBStructure.h"


@class TBAAVulcan;


@interface TBAAGunSite : TBStructure
{
    TBAAVulcan *mAAVulcan;
    
    NSArray    *mTextureArray;
}

@end
