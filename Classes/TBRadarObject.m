//
//  TBRadarObject.m
//  Thunderbolt
//
//  Created by jskim on 10. 5. 21..
//  Copyright 2010 Tinybean. All rights reserved.
//

#import "TBRadarObject.h"
#import "TBTextureManager.h"
#import "TBTextureNames.h"


static TBRadarObject *gUnitRadarObject;


@implementation TBRadarObject


+ (TBRadarObject *)unitRadarObject
{
    if (!gUnitRadarObject)
    {
        gUnitRadarObject = [[TBRadarObject alloc] init];
    }
    
    return gUnitRadarObject;
}


- (id)init
{
    TBTextureInfo *sInfo;
    
    self = [super init];
    if (self)
    {
        sInfo = [TBTextureManager textureInfoForKey:kTexRadarObject];
        
        [self setTextureID:[sInfo textureID]];
        [self setTextureSize:[sInfo textureSize]];
        [self setContentSize:[sInfo contentSize]];
    }
    
    return self;
}


@end
