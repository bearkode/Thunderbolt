/*
 *  TBAssociativeArray.m
 *  Thunderbolt
 *
 *  Created by cgkim on 13. 4. 17..
 *  Copyright (c) 2013 Tinybean. All rights reserved.
 *
 */

#import "TBAssociativeArray.h"


@implementation TBAssociativeArray
{
    NSMutableDictionary *mObjectDict;
    NSMutableArray      *mObjectArray;
}


@synthesize array = mObjectArray;


#pragma mark -


- (id)init
{
    self = [super init];
    
    if (self)
    {
        mObjectDict  = [[NSMutableDictionary alloc] init];
        mObjectArray = [[NSMutableArray alloc] init];
    }
    
    return self;
}


- (void)dealloc
{
    [mObjectDict release];
    [mObjectArray release];
    
    [super dealloc];
}


#pragma mark -


- (void)setObject:(id)aObject forKey:(id)aKey
{
    id sExistObject = [mObjectDict objectForKey:aKey];

    if (sExistObject)
    {
        [mObjectArray removeObject:sExistObject];
    }
    
    [mObjectDict setObject:aObject forKey:aKey];
    [mObjectArray addObject:aObject];
}


- (void)removeObjectForKey:(id)aKey
{
    id sExistObject = [mObjectDict objectForKey:aKey];
    
    if (sExistObject)
    {
        [mObjectDict removeObjectForKey:aKey];
        [mObjectArray removeObject:sExistObject];
    }
}


- (id)objectForKey:(id)aKey
{
    return [mObjectDict objectForKey:aKey];
}


- (void)removeAllObjects
{
    [mObjectDict removeAllObjects];
    [mObjectArray removeAllObjects];
}


@end
