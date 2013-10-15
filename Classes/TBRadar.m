/*
 *  TBRadar.m
 *  Thunderbolt
 *
 *  Created by bearkode on 10. 5. 20..
 *  Copyright 2010 Tinybean. All rights reserved.
 *
 */

#import "TBRadar.h"
#import "TBTextureNames.h"
#import "TBRadarObject.h"
#import "TBUnitManager.h"
#import "TBUnit.h"


@implementation TBRadar
{
    NSInteger       mUseIndex;
    NSMutableArray *mObjects;
}


- (id)init
{
    self = [super init];
    
    if (self)
    {
        PBTexture *sTexture = [PBTextureManager textureWithImageName:kTexRadarBackground];
        [self setTexture:sTexture];
        [self setTileSize:[sTexture size]];
        
        mObjects = [[NSMutableArray alloc] initWithCapacity:100];
    }
    
    return self;
}


- (void)dealloc
{
    [mObjects release];
    
    [super dealloc];
}


#pragma mark -


- (TBRadarObject *)radarObject
{
    TBRadarObject *sResult = nil;
    
    if ([mObjects count] > mUseIndex)
    {
        sResult = [mObjects objectAtIndex:mUseIndex];
    }
    else
    {
        sResult = [[TBRadarObject alloc] init];
        [mObjects addObject:sResult];
        [self addSubNode:sResult];
        [sResult release];
    }
    
    mUseIndex++;
    
    return sResult;
}


- (void)setRadarObjectWithUnit:(TBUnit *)aUnit canvas:(PBCanvas *)aCanvas
{
    CGSize         sRadarSize    = [self tileSize];
    CGRect         sCanvasBounds = [aCanvas bounds];
    CGPoint        sPoint        = [aUnit point];
    TBRadarObject *sRadarObject  = [self radarObject];
    
    if ([aUnit isKindOfUnit:kTBUnitHelicopter] || [aUnit isKindOfUnit:kTBUnitMissile])
    {
        sPoint = CGPointMake(sPoint.x / kMaxMapXPos * sRadarSize.width, sPoint.y / sCanvasBounds.size.height * sRadarSize.height);
    }
    else
    {
        sPoint = CGPointMake(sPoint.x / kMaxMapXPos * sRadarSize.width, [sRadarObject tileSize].height);
    }
    
    sPoint.x -= (sRadarSize.width / 2);
    sPoint.y -= (sRadarSize.height / 2);
    
    [sRadarObject setHidden:NO];
    [sRadarObject setPoint:sPoint];
}


- (void)updateWithCanvas:(PBCanvas *)aCanvas
{
    mUseIndex = 0;
    [self setPoint:CGPointMake([[aCanvas camera] position].x, 300.0)];
    
    for (TBRadarObject *sObject in mObjects)
    {
        [sObject setHidden:YES];
    }

    for (TBUnit *sUnit in [[TBUnitManager sharedManager] allyUnits])
    {
        [self setRadarObjectWithUnit:sUnit canvas:aCanvas];
    }
    
    for (TBUnit *sUnit in [[TBUnitManager sharedManager] enemyUnits])
    {
        [self setRadarObjectWithUnit:sUnit canvas:aCanvas];
    }
}


@end
