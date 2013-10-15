/*
 *  TBSmoke.m
 *  Thunderbolt
 *
 *  Created by cgkim on 13. 4. 29..
 *  Copyright (c) 2013 cgkim. All rights reserved.
 *
 */

#import "TBSmoke.h"


@implementation TBSmoke
{
    NSUInteger mIndex;
}


#pragma mark -


- (id)init
{
    self = [super init];
    
    if (self)
    {
        PBTexture *sTexture = [PBTextureManager textureWithImageName:@"smoke"];
        [self setTexture:sTexture];
        [self setTileSize:[sTexture size]];

        [self setAngle:PBVertex3Make(0, 0, rand())];
    }
    
    return self;
}


- (void)dealloc
{
    [super dealloc];
}


#pragma mark -


- (void)reset
{
    mIndex = 0;
    [self setAngle:PBVertex3Make(0, 0, rand())];
    [self setScale:PBVertex3Make(0.1, 0.1, 0.0)];
    [self setAlpha:1.0];
}


- (BOOL)action
{
    mIndex++;
    
    CGFloat sScale = (0.0 + mIndex / 20.0);
    [self setScale:PBVertex3Make(sScale, sScale, 0.0)];
    [self setAlpha:(1.0 - mIndex / 15.0)];
    
    if (mIndex > 15)
    {
        return NO;
    }
    
    return YES;
}


@end
