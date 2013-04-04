//
//  TBRadar.m
//  Thunderbolt
//
//  Created by jskim on 10. 5. 20..
//  Copyright 2010 Tinybean. All rights reserved.
//

#import "TBRadar.h"
#import "TBTextureManager.h"
#import "TBTextureNames.h"
#import "TBRadarObject.h"
#import "TBUnitManager.h"
#import "TBUnit.h"


@implementation TBRadar


- (id)init
{
    TBTextureInfo *sInfo = nil;
    
    self = [super init];
    if (self)
    {
        sInfo = [TBTextureManager textureInfoForKey:kTexRadarBackground];
        [self setTextureID:[sInfo textureID]];
        [self setTextureSize:[sInfo textureSize]];
        [self setContentSize:[sInfo contentSize]];
        
        NSLog(@"textureSize = %@", NSStringFromCGSize([sInfo textureSize]));
    }
    
    return self;
}


- (void)drawAt:(CGFloat)aXPos
{
    [self setPosition:CGPointMake(aXPos + 240.0, 300.0)];
    [super draw];
    
    TBRadarObject *sUnitObject = [TBRadarObject unitRadarObject];
    CGPoint        sPosition;
    NSArray       *sUnits;
    TBUnit        *sUnit;

    sUnits = [[TBUnitManager sharedManager] allyUnits];
    for (sUnit in sUnits)
    {
        sPosition = [sUnit position];
        [sUnitObject setPosition:CGPointMake(aXPos + 480 * sPosition.x / MAX_MAP_XPOS, 280.0 + 40 * sPosition.y / 320)];
        [sUnitObject draw];
    }
    
    sUnits = [[TBUnitManager sharedManager] enemyUnits];
    for (sUnit in sUnits)
    {
        sPosition = [sUnit position];
        [sUnitObject setPosition:CGPointMake(aXPos + 480 * sPosition.x / MAX_MAP_XPOS, 280.0 + 40 * sPosition.y / 320)];
        [sUnitObject draw];
    }
}


@end
