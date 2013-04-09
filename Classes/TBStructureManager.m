/*
 *  TBStructureManager.m
 *  Thunderbolt
 *
 *  Created by bearkode on 10. 7. 5..
 *  Copyright 2010 Tinybean. All rights reserved.
 *
 */

#import "TBStructureManager.h"
#import "TBGameConst.h"
#import "TBStructure.h"
#import "TBWarhead.h"


@implementation TBStructureManager
{
    NSMutableArray *mAllyStructures;
    NSMutableArray *mEnemyStructures;
}


SYNTHESIZE_SINGLETON_CLASS(TBStructureManager, sharedManager);


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
    [mAllyStructures makeObjectsPerformSelector:@selector(action)];
    [mEnemyStructures makeObjectsPerformSelector:@selector(action)];
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
