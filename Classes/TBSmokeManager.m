/*
 *  TBSmokeManager.m
 *  Thunderbolt
 *
 *  Created by cgkim on 13. 5. 13..
 *  Copyright (c) 2013 Tinybean. All rights reserved.
 *
 */

#import "TBSmokeManager.h"
#import <PBObjCUtil.h>
#import "TBObjectPool.h"
#import "TBSmoke.h"
#import "TBDamageSmoke.h"


@implementation TBSmokeManager
{
    PBNode         *mSmokeLayer;

    TBObjectPool   *mObjectPool;
    TBObjectPool   *mDamageSmokePool;
    
    NSMutableArray *mSmokes;
    NSMutableArray *mDamageSmokes;
}


SYNTHESIZE_SHARED_INSTANCE(TBSmokeManager, sharedManager)


- (id)init
{
    self = [super init];
    
    if (self)
    {
        mObjectPool      = [[TBObjectPool alloc] initWithCapacity:100 storableClass:[TBSmoke class]];
        mDamageSmokePool = [[TBObjectPool alloc] initWithCapacity:100 storableClass:[TBDamageSmoke class]];
        
        mSmokes          = [[NSMutableArray alloc] init];
        mDamageSmokes    = [[NSMutableArray alloc] init];
    }
    
    return self;
}


- (void)reset
{
    [mSmokeLayer removeFromSuperNode];
    [mSmokeLayer release];
    mSmokeLayer = nil;
    
    for (TBSmoke *sSmoke in mSmokes)
    {
        [mObjectPool finishUsing:sSmoke];
    }
    
    [mSmokes removeAllObjects];
    
    for (TBDamageSmoke *sSmoke in mDamageSmokes)
    {
        [mDamageSmokePool finishUsing:sSmoke];
    }
    
    [mDamageSmokes removeAllObjects];
}




- (void)doActions
{
    NSMutableArray *sDisabledSmokes = [NSMutableArray array];
    
    for (TBSmoke *sSmoke in mSmokes)
    {
        if (![sSmoke action])
        {
            [sSmoke removeFromSuperNode];
            [sDisabledSmokes addObject:sSmoke];
            [mObjectPool finishUsing:sSmoke];
        }
    }
    
    [mSmokes removeObjectsInArray:sDisabledSmokes];
    
    [sDisabledSmokes removeAllObjects];

    for (TBDamageSmoke *sSmoke in mDamageSmokes)
    {
        if (![sSmoke action])
        {
            [sSmoke removeFromSuperNode];
            [sDisabledSmokes addObject:sSmoke];
            [mDamageSmokePool finishUsing:sSmoke];
        }
    }
    
    [mDamageSmokes removeObjectsInArray:sDisabledSmokes];
}


- (void)setSmokeLayer:(PBNode *)aLayer
{
    [mSmokeLayer removeFromSuperNode];
    [mSmokeLayer autorelease];
    mSmokeLayer = [aLayer retain];
}


- (void)addSmokeAtPoint:(CGPoint)aPoint
{
    TBSmoke *sSmoke = (TBSmoke *)[mObjectPool object];

    [sSmoke reset];
    [sSmoke setPoint:aPoint];

    [mSmokes addObject:sSmoke];
    [mSmokeLayer addSubNode:sSmoke];
}


- (void)addDamageSmokeAtPoint:(CGPoint)aPoint
{
    TBDamageSmoke *sSmoke = (TBDamageSmoke *)[mDamageSmokePool object];
    
    [sSmoke reset];
    [sSmoke setPoint:aPoint];
    
    [mDamageSmokes addObject:sSmoke];
    [mSmokeLayer addSubNode:sSmoke];
}


@end
