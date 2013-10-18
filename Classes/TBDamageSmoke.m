/*
 *  TBDamageSmoke.m
 *  Thunderbolt
 *
 *  Created by cgkim on 13. 10. 17..
 *  Copyright (c) 2013 Tinybean. All rights reserved.
 *
 */

#import "TBDamageSmoke.h"


@implementation TBDamageSmoke
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
        [self setColor:[PBColor blackColor]];
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
    
    CGFloat sScale = (0.5 + mIndex / 15.0);
    CGPoint sPoint = [self point];

    [self setScale:PBVertex3Make(sScale, sScale, 0.0)];
    [self setAlpha:(1.0 - mIndex / 15.0)];
    [self setPoint:CGPointMake(sPoint.x, sPoint.y + 2)];
    
    if (mIndex > 60)
    {
        return NO;
    }
    
    return YES;
}


@end
