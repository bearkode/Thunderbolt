/*
 *  TBMainSceneController.m
 *  Thunderbolt
 *
 *  Created by cgkim on 13. 10. 15..
 *  Copyright (c) 2013 Tinybean. All rights reserved.
 *
 */

#import "TBMainSceneController.h"
#import "TBHelicopter.h"
#import "TBHelicopterInfo.h"


@implementation TBMainSceneController
{
    NSMutableArray *mHelicopters;
}


- (void)setupHelicopters
{
    TBHelicopter     *sHelicopter = nil;
    TBHelicopterInfo *sHeliInfo   = nil;
    
    sHeliInfo   = [TBHelicopterInfo MD500Info];
    sHelicopter = [[[TBHelicopter alloc] initWithUnitID:nil team:kTBTeamAlly info:sHeliInfo] autorelease];
    [sHelicopter setEnableSound:NO];
    [sHelicopter setScale:PBVertex3Make(0.7, 0.7, 1.0)];
    [mHelicopters addObject:sHelicopter];
    
//    sHeliInfo = [TBHelicopterInfo UH1Info];
//    sHelicopter = [[[TBHelicopter alloc] initWithUnitID:nil team:kTBTeamAlly info:sHeliInfo] autorelease];
//    [mHelicopters addObject:sHelicopter];

    sHeliInfo = [TBHelicopterInfo UH1NInfo];
    sHelicopter = [[[TBHelicopter alloc] initWithUnitID:nil team:kTBTeamAlly info:sHeliInfo] autorelease];
    [sHelicopter setEnableSound:NO];
    [sHelicopter setScale:PBVertex3Make(0.7, 0.7, 1.0)];
    [mHelicopters addObject:sHelicopter];

    sHeliInfo = [TBHelicopterInfo AH1CobraInfo];
    sHelicopter = [[[TBHelicopter alloc] initWithUnitID:nil team:kTBTeamAlly info:sHeliInfo] autorelease];
    [sHelicopter setEnableSound:NO];
    [sHelicopter setScale:PBVertex3Make(0.7, 0.7, 1.0)];
    [mHelicopters addObject:sHelicopter];

    sHeliInfo = [TBHelicopterInfo AH1WSuperCobraInfo];
    sHelicopter = [[[TBHelicopter alloc] initWithUnitID:nil team:kTBTeamAlly info:sHeliInfo] autorelease];
    [sHelicopter setEnableSound:NO];
    [sHelicopter setScale:PBVertex3Make(0.7, 0.7, 1.0)];
    [mHelicopters addObject:sHelicopter];
}


#pragma mark -


- (id)initWithDelegate:(id)aDelegate
{
    self = [super initWithDelegate:aDelegate];
    
    if (self)
    {
        mHelicopters = [[NSMutableArray alloc] init];
        
        [self setupHelicopters];
    }
    
    return self;
}


- (void)dealloc
{
    [mHelicopters release];
    
    [super dealloc];
}


#pragma mark -


- (void)sceneDidPresent
{
    [[self canvas] setBackgroundColor:[PBColor blackColor]];

    [[self scene] addSubNodes:mHelicopters];

    NSInteger x = -190;
    for (TBHelicopter *sHelicopter in mHelicopters)
    {
        [sHelicopter selectTileAtIndex:0];
        [sHelicopter setPoint:CGPointMake(x, 80)];
        x += 120;
    }
}


#pragma mark -


- (void)pbSceneWillUpdate:(PBScene *)aScene
{
    static BOOL sOdd = YES;
    
    if (sOdd)
    {
        for (TBHelicopter *sHelicopter in mHelicopters)
        {
            [sHelicopter spin];
        }
    }
    
    sOdd = !sOdd;
}


- (void)pbSceneDidUpdate:(PBScene *)aScene
{

}


#pragma mark -


- (void)setPositions:(NSArray *)aPositions
{
    for (NSInteger i = 0; i < [aPositions count]; i++)
    {
        TBHelicopter *sHelicopter  = [mHelicopters objectAtIndex:i];
        NSValue      *sPointValue  = [aPositions objectAtIndex:i];
        CGPoint       sPoint       = [sPointValue CGPointValue];
        CGPoint       sCanvasPoint = [[self canvas] canvasPointFromViewPoint:sPoint];
        
        [sHelicopter setPoint:sCanvasPoint];
    }
}


@end
