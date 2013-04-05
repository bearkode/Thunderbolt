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


- (id)init
{
    self = [super initWithImageName:kTexRadarBackground];
    
    if (self)
    {

    }
    
    return self;
}


- (void)drawAt:(CGFloat)aXPos
{
    [self setPoint:CGPointMake(aXPos + 240.0, 300.0)];
//    [super draw];
    
    TBRadarObject *sUnitObject = [TBRadarObject unitRadarObject];
    CGPoint        sPosition;
    NSArray       *sUnits;
    TBUnit        *sUnit;

    sUnits = [[TBUnitManager sharedManager] allyUnits];
    for (sUnit in sUnits)
    {
        sPosition = [sUnit point];
        [sUnitObject setPoint:CGPointMake(aXPos + 480 * sPosition.x / kMaxMapXPos, 280.0 + 40 * sPosition.y / 320)];
//        [sUnitObject draw];
    }
    
    sUnits = [[TBUnitManager sharedManager] enemyUnits];
    for (sUnit in sUnits)
    {
        sPosition = [sUnit point];
        [sUnitObject setPoint:CGPointMake(aXPos + 480 * sPosition.x / kMaxMapXPos, 280.0 + 40 * sPosition.y / 320)];
//        [sUnitObject draw];
    }
}


@end
