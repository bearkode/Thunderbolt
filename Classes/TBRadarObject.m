/*
 *  TBRadarObject.m
 *  Thunderbolt
 *
 *  Created by bearkode on 10. 5. 21..
 *  Copyright 2010 Tinybean. All rights reserved.
 *
 */

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
    self = [super initWithImageName:kTexRadarObject];
    
    if (self)
    {

    }
    
    return self;
}


@end
