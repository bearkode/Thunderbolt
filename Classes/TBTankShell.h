//
//  TBTankShell.h
//  Thunderbolt
//
//  Created by jskim on 10. 5. 16..
//  Copyright 2010 Tinybean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBWarhead.h"


@interface TBTankShell : TBWarhead
{
    NSInteger mLife;
    CGPoint   mVector;
}

@property (nonatomic, assign) NSInteger life;
@property (nonatomic, assign) CGPoint   vector;

- (void)reset;

@end
