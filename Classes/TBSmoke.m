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
        [[self mesh] setMeshRenderOption:kPBMeshRenderOptionUsingMeshQueue];
        
        PBTexture *sTexture = [PBTextureManager textureWithImageName:@"smoke"];
        [sTexture loadIfNeeded];
        [self setTexture:sTexture];
        
        [[self transform] setAngle:PBVertex3Make(0, 0, rand())];
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
    [[self transform] setAngle:PBVertex3Make(0, 0, rand())];
    [[self transform] setScale:0.1];
    [[self transform] setAlpha:1.0];
}


- (BOOL)action
{
    mIndex++;
    
    [[self transform] setScale:(0.1 + mIndex / 19.0)];
    [[self transform] setAlpha:(1.0 - mIndex / 15.0)];
    
    if (mIndex > 15)
    {
        return NO;
    }
    
    return YES;
}


@end
