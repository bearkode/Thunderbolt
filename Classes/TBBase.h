//
//  TBBase.h
//  Thunderbolt
//
//  Created by jskim on 10. 3. 5..
//  Copyright 2010 tinybean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBStructure.h"


@class TBAAVulcan;
@class TBMissileLauncher;


@interface TBBase : TBStructure
{
    NSUInteger         mTextureIndex;
    NSArray           *mTextureKeys;
    
    TBAAVulcan        *mAAVulcan;
    TBMissileLauncher *mMissileLauncher;
}

@end
