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


@implementation TBSmokeManager
{
    PBNode         *mSmokeLayer;

    TBObjectPool   *mObjectPool;
    NSMutableArray *mSmokes;
}


SYNTHESIZE_SHARED_INSTANCE(TBSmokeManager, sharedManager)


- (id)init
{
    self = [super init];
    
    if (self)
    {
        mObjectPool = [[TBObjectPool alloc] initWithCapacity:100 storableClass:[TBSmoke class]];
        mSmokes     = [[NSMutableArray alloc] init];
    }
    
    return self;
}


- (void)reset
{
    [mSmokeLayer removeFromSuperNode];
    [mSmokeLayer release];
    mSmokeLayer = nil;
    
    //  TODO : finish using in array?
    for (TBSmoke *sSmoke in mSmokes)
    {
        [mObjectPool finishUsing:sSmoke];
    }
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
    [mSmokeLayer addSubNode:sSmoke];
    [mSmokes addObject:sSmoke];
}


@end
