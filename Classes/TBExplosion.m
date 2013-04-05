/*
 *  TBExplosion.m
 *  Thunderbolt
 *
 *  Created by bearkode on 10. 2. 7..
 *  Copyright 2010 tinybean. All rights reserved.
 *
 */

#import "TBExplosion.h"
#import "TBTextureManager.h"
#import "TBTextureNames.h"
#import "TBALPlayback.h"
#import "TBGameConst.h"


@implementation TBExplosion


- (id)init
{
    self = [super init];
    
    if (self)
    {
        mAniIndex         = 0;
        mTextureInfoArray = [[NSMutableArray alloc] init];
        mPositionArray    = [[NSMutableArray alloc] init];
    }
    
    return self;
}


- (void)dealloc
{
    [mTextureInfoArray release];
    [mPositionArray    release];
    
    [super dealloc];
}


- (void)action
{
    NSValue       *sPosition;
    
    if (![self isFinished])
    {
        PBTexture *sTexture = [mTextureInfoArray objectAtIndex:mAniIndex];
        sPosition = [mPositionArray objectAtIndex:mAniIndex];

        [self setTexture:sTexture];
//        [self setTextureID:[sInfo textureID]];
//        [self setTextureSize:[sInfo textureSize]];
        [self setPoint:[sPosition CGPointValue]];
        
        mAniIndex++;
    }
}


#pragma mark -


- (void)addTextureInfo:(TBTextureInfo *)aInfo atPosition:(CGPoint)aPosition
{
    [mTextureInfoArray addObject:aInfo];
    [mPositionArray    addObject:[NSValue valueWithCGPoint:aPosition]];
}


- (BOOL)isFinished
{
    if (mAniIndex == [mTextureInfoArray count])
    {
        return YES;
    }
    
    return NO;
}


#pragma mark -


/*+ (TBExplosion *)tankExplosionAtPoistion:(CGPoint)aPosition
{
    TBExplosion   *sExplosion = [[TBExplosion alloc] init];
    TBTextureInfo *sInfo      = nil;
    
    sInfo = [TBTextureManager textureInfoForKey:kTexTankExp00];
    [sExplosion addTextureInfo:sInfo atPosition:aPosition];
    [sExplosion addTextureInfo:sInfo atPosition:aPosition];    
    sInfo = [TBTextureManager textureInfoForKey:kTexTankExp01];
    [sExplosion addTextureInfo:sInfo atPosition:aPosition];
    [sExplosion addTextureInfo:sInfo atPosition:aPosition];    
    sInfo = [TBTextureManager textureInfoForKey:kTexTankExp02];
    [sExplosion addTextureInfo:sInfo atPosition:aPosition];
    [sExplosion addTextureInfo:sInfo atPosition:aPosition];    

    [[TBALPlayback sharedPlayback] startSound:kTBSoundTankExplosion];

    return [sExplosion autorelease];
}


+ (TBExplosion *)bombExplosionAtPosition:(CGPoint)aPosition
{
    TBExplosion   *sExplosion = [[TBExplosion alloc] init];
    TBTextureInfo *sInfo      = nil;
    
    sInfo = [TBTextureManager textureInfoForKey:kTexBombExp00];
    [sExplosion addTextureInfo:sInfo atPosition:aPosition];
    [sExplosion addTextureInfo:sInfo atPosition:aPosition];    
    sInfo = [TBTextureManager textureInfoForKey:kTexBombExp01];
    [sExplosion addTextureInfo:sInfo atPosition:aPosition];
    [sExplosion addTextureInfo:sInfo atPosition:aPosition];    
    sInfo = [TBTextureManager textureInfoForKey:kTexBombExp02];
    [sExplosion addTextureInfo:sInfo atPosition:aPosition];
    [sExplosion addTextureInfo:sInfo atPosition:aPosition];    
    
    [[TBALPlayback sharedPlayback] startSound:kTBSoundBombExplosion];
    
    return [sExplosion autorelease];
}*/


@end
