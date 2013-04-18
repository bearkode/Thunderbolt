/*
 *  TBObjectPool.m
 *  Thunderbolt
 *
 *  Created by cgkim on 13. 4. 17..
 *  Copyright (c) 2013 Tinybean. All rights reserved.
 *
 */

#import "TBObjectPool.h"


@implementation TBObjectPool
{
    Class         mStorableClass;
    
    NSMutableSet *mIdleObjects;
    NSMutableSet *mBusyObjects;
}


- (id)initWithCapacity:(NSUInteger)aCapacity storableClass:(Class)aClass
{
    self = [super init];
    
    if (self)
    {
        mStorableClass = aClass;
        
        mIdleObjects   = [[NSMutableSet alloc] initWithCapacity:aCapacity];
        mBusyObjects   = [[NSMutableSet alloc] initWithCapacity:aCapacity];
    }
    
    return self;
}


- (void)dealloc
{
    [mIdleObjects release];
    [mBusyObjects release];
    
    [super dealloc];
}


#pragma mark -


- (id)object
{
    id sObject = nil;
    
    if ([mIdleObjects count])
    {
        sObject = [mIdleObjects anyObject];
        [mBusyObjects addObject:sObject];
        [mIdleObjects removeObject:sObject];
    }
    else
    {
        sObject = [[mStorableClass alloc] init];
        [mBusyObjects addObject:sObject];
        [sObject release];
    }

    return sObject;
}


- (void)finishUsing:(id)aObject
{
    [mIdleObjects addObject:aObject];
    [mBusyObjects removeObject:aObject];
}


- (void)reset
{
    [mIdleObjects addObjectsFromArray:[mBusyObjects allObjects]];
    [mBusyObjects removeAllObjects];
}


- (void)vacate
{
    [mIdleObjects removeAllObjects];
}


@end
