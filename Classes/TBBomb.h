//
//  TBBomb.h
//  Thunderbolt
//
//  Created by jskim on 10. 2. 3..
//  Copyright 2010 tinybean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBWarhead.h"


@interface TBBomb : TBWarhead
{
    CGPoint mVector;
}

@property (nonatomic, assign) CGPoint vector;

- (void)setSpeed:(CGFloat)aSpeed;

@end
