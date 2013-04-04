//
//  TBBullet.h
//  Thunderbolt
//
//  Created by jskim on 10. 1. 30..
//  Copyright 2010 tinybean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBWarhead.h"


@interface TBBullet : TBWarhead
{
    NSInteger mLife;
    CGPoint   mVector;
}

@property (nonatomic, assign) NSInteger life;
@property (nonatomic, assign) CGPoint   vector;

- (id)initWithDestructivePower:(NSUInteger)aDestructivePower;

- (void)reset;

@end
