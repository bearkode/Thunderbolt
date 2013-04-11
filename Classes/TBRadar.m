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
        
        [sTexture loadIfNeeded];
        [self setTexture:sTexture];
        
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
        [self addSublayer:sResult];
        [sResult release];
    }
    
    mUseIndex++;
    
    return sResult;
}


- (void)updateWithCanvas:(PBCanvas *)aCanvas
{
    CGSize sRadarSize    = [[self mesh] size];
    CGRect sCanvasBounds = [aCanvas bounds];

    mUseIndex = 0;
    [self setPoint:CGPointMake([[aCanvas camera] position].x, 300.0)];
    
    for (TBRadarObject *sObject in mObjects)
    {
        [sObject setHidden:YES];
    }

    for (TBUnit *sUnit in [[TBUnitManager sharedManager] allyUnits])
    {
        CGPoint        sPoint       = [sUnit point];
        TBRadarObject *sRadarObject = [self radarObject];
        
        sPoint    = CGPointMake(sPoint.x / kMaxMapXPos * sRadarSize.width, sPoint.y / sCanvasBounds.size.height * sRadarSize.height);
        sPoint.x -= (sRadarSize.width / 2);
        sPoint.y -= (sRadarSize.height / 2);
        
        [sRadarObject setHidden:NO];
        [sRadarObject setPoint:sPoint];
    }
    
    for (TBUnit *sUnit in [[TBUnitManager sharedManager] enemyUnits])
    {
        CGPoint        sPoint       = [sUnit point];
        TBRadarObject *sRadarObject = [self radarObject];
        
        sPoint    = CGPointMake(sPoint.x / kMaxMapXPos * sRadarSize.width, sPoint.y / sCanvasBounds.size.height * sRadarSize.height);
        sPoint.x -= (sRadarSize.width / 2);
        sPoint.y -= (sRadarSize.height / 2);
        
        [sRadarObject setHidden:NO];
        [sRadarObject setPoint:sPoint];
    }
}


@end
