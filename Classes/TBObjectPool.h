/*
 *  TBObjectPool.h
 *  Thunderbolt
 *
 *  Created by cgkim on 13. 4. 17..
 *  Copyright (c) 2013 Tinybean. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


@interface TBObjectPool : NSObject


- (id)initWithCapacity:(NSUInteger)aCapacity storableClass:(Class)aClass;


- (id)object;
- (void)finishUsing:(id)aObject;
- (void)vacate;


@end
