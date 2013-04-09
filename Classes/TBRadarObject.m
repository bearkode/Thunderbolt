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


@implementation TBRadarObject


- (id)init
{
    self = [super init];
    
    if (self)
    {
        PBTexture *sTexture = [PBTextureManager textureWithImageName:kTexRadarObject];
        
        [sTexture loadIfNeeded];
        [self setTexture:sTexture];
    }
    
    return self;
}


- (void)dealloc
{
    [super dealloc];
}


@end
