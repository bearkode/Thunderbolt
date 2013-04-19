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
#import "TBBase.h"
#import "TBLandingPad.h"
#import "TBAAGunSite.h"

#import "TBWarhead.h"


@implementation TBStructureManager
{
    PBLayer        *mStructureLayer;
    
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


#pragma mark -


- (void)reset
{
    [mStructureLayer release];
    mStructureLayer = nil;
    
    [mAllyStructures removeAllObjects];
    [mEnemyStructures removeAllObjects];
}


- (void)setStructureLayer:(PBLayer *)aStructureLayer
{
    [mStructureLayer autorelease];
    mStructureLayer = [aStructureLayer retain];
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
    
    [mStructureLayer addSublayer:aStructure];
}


- (void)addBaseWithTeam:(TBTeam)aTeam position:(CGFloat)aPosition
{
    TBBase *sBase = [[[TBBase alloc] initWithTeam:aTeam] autorelease];
    
    [sBase setPoint:CGPointMake(aPosition, kMapGround + 30)];
    [self addStructure:sBase];
}


- (void)addLandingPadWithTeam:(TBTeam)aTeam position:(CGFloat)aPosition
{
    TBLandingPad *sLandingPad = [[[TBLandingPad alloc] initWithTeam:aTeam] autorelease];
    
    [sLandingPad setPoint:CGPointMake(aPosition, kMapGround + 6)];
    [self addStructure:sLandingPad];
}


- (void)addAAGunSiteWithTeam:(TBTeam)aTeam position:(CGFloat)aPosition
{
    TBAAGunSite *sAAGunSite = [[[TBAAGunSite alloc] initWithTeam:aTeam] autorelease];
    
    [sAAGunSite setPoint:CGPointMake(aPosition, kMapGround + 15)];
    [self addStructure:sAAGunSite];
}


@end
