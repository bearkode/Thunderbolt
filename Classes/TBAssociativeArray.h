/*
 *  TBAssociativeArray.h
 *  Thunderbolt
 *
 *  Created by cgkim on 13. 4. 17..
 *  Copyright (c) 2013 Tinybean. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


@interface TBAssociativeArray : NSObject


@property (nonatomic, readonly) NSArray *array;


- (void)setObject:(id)aObject forKey:(id)aKey;
- (void)removeObjectForKey:(id)aKey;
- (id)objectForKey:(id)aKey;

- (void)removeAllObjects;


@end
