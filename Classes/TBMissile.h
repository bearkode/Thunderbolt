//
//  TBMissile.h
//  Thunderbolt
//
//  Created by jskim on 10. 5. 8..
//  Copyright 2010 tinybean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBUnit.h"


@interface TBMissile : TBUnit
{
    NSNumber *mTargetID;
    NSInteger mDestructivePower;
    CGFloat   mSpeed;
}

@property (nonatomic, copy)   NSNumber *targetID;
@property (nonatomic, assign) NSInteger destructivePower;

@end
