/*
 *  TBRadar.m
 *  Thunderbolt
 *
 *  Created by bearkode on 10. 5. 20..
 *  Copyright 2010 Tinybean. All rights reserved.
 *
 */

#import "TBRadar.h"
#import "TBTextureManager.h"
#import "TBTextureNames.h"
#import "TBRadarObject.h"
#import "TBUnitManager.h"
#import "TBUnit.h"


@implementation TBRadar
{
    CGRect mCanvasBounds;
}


- (id)init
{
    self = [super init];
    
    if (self)
    {
        PBTexture *sTexture = [PBTextureManager textureWithImageName:kTexRadarBackground];
        
        [sTexture loadIfNeeded];
        [self setTexture:sTexture];
    }
    
    return self;
}


- (void)addRadarObjectWithUnit:(TBUnit *)aUnit
{
    CGPoint        sPosition;
    CGSize         sRadarSize = [[self mesh] size];
    TBRadarObject *sRadarObject = [[[TBRadarObject alloc] init] autorelease];

    [self addSublayer:sRadarObject];
    
    sPosition = [aUnit point];
    
    CGPoint sPoint = CGPointMake(sPosition.x / kMaxMapXPos * sRadarSize.width, sPosition.y / mCanvasBounds.size.height * sRadarSize.height);
    sPoint.x -= (sRadarSize.width / 2);
    sPoint.y -= (sRadarSize.height / 2);
    
    [sRadarObject setPoint:sPoint];
}


#warning Tuning needed


- (void)updateWithCanvas:(PBCanvas *)aCanvas
{
    CGPoint  sCameraPos = [[aCanvas camera] position];
    NSArray *sUnits;
    
    [self setPoint:CGPointMake(sCameraPos.x, 300.0)];
    [self removeSublayers:[self sublayers]];

    mCanvasBounds = [aCanvas bounds];
    
    sUnits = [[TBUnitManager sharedManager] allyUnits];
    for (TBUnit *sUnit in sUnits)
    {
        [self addRadarObjectWithUnit:sUnit];
    }
    
    sUnits = [[TBUnitManager sharedManager] enemyUnits];
    for (TBUnit *sUnit in sUnits)
    {
        [self addRadarObjectWithUnit:sUnit];
    }
}


@end
