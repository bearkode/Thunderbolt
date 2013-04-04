//
//  TBStructureManager.m
//  Thunderbolt
//
//  Created by jskim on 10. 7. 5..
//  Copyright 2010 Tinybean. All rights reserved.
//

#import "TBStructureManager.h"
#import "TBGameConst.h"
#import "TBStructure.h"
#import "TBWarhead.h"


static TBStructureManager *gStructureManager = nil;


@implementation TBStructureManager


+ (TBStructureManager *)sharedManager
{
    @synchronized(self)
    {
        if (!gStructureManager)
        {
            gStructureManager = [[self alloc] init];
        }
    }
    
    return gStructureManager;
}


+ (id)allocWithZone:(NSZone *)aZone
{
    @synchronized(self)
    {
        if (!gStructureManager)
        {
            gStructureManager = [super allocWithZone:aZone];
            return gStructureManager;
        }
    }
    
    return nil;
}


- (id)copyWithZone:(NSZone *)aZone
{
    return self;
}


- (id)retain
{
    return self;
}


- (unsigned)retainCount
{
    return UINT_MAX;
}

- (oneway void)release
{
}


- (id)autorelease
{
    return self;
}


#pragma mark -


- (id)init
{
    self = [super init];
    if (self)
    {
        mAllyStructures  = [[NSMutableArray alloc] init];
        mEnemyStructures = [[NSMutableArray alloc] init];
    }
    
    return self;
}


- (void)addStructure:(TBStructure *)aStructure
{
    if ([aStructure team] == kTBTeamAlly)
    {
        [mAllyStructures addObject:aStructure];
    }
    else if ([aStructure team] == kTBTeamEnemy)
    {
        [mEnemyStructures addObject:aStructure];
    }
}


- (void)doActions
{
//    static NSUInteger sCounter = 0;

    TBStructure *sStructure;
//    BOOL         sLog = ((sCounter++ % 10) == 0) ? YES : NO;
    
    for (sStructure in mAllyStructures)
    {
        [sStructure action];
        [sStructure draw];
/*        if (sLog)
        {
            NSLog(@"A %@ %d", [sStructure class], [sStructure damage]);
        }*/
    }

    for (sStructure in mEnemyStructures)
    {
        [sStructure action];
        [sStructure draw];
/*        if (sLog)
        {
            NSLog(@"E %@ %d", [sStructure class], [sStructure damage]);
        }*/
    }
}


- (TBStructure *)intersectedOpponentStructure:(TBWarhead *)aWarhead
{
    TBStructure *sResult     = nil;
    TBStructure *sStructure  = nil;
    NSArray     *sStructures = nil;
    
    sStructures = ([aWarhead isAlly]) ? mEnemyStructures : mAllyStructures;
    
    for (sStructure in sStructures)
    {
        if ([sStructure intersectWith:aWarhead])
        {
            sResult = sStructure;
            break;
        }
    }

    return sResult;
}


@end
