/*
 *  TBExplosion.m
 *  Thunderbolt
 *
 *  Created by bearkode on 10. 2. 7..
 *  Copyright 2010 tinybean. All rights reserved.
 *
 */

#import "TBExplosion.h"
#import "TBTextureNames.h"
#import "TBGameConst.h"


@implementation TBExplosion
{
    NSInteger       mAniIndex;
    NSMutableArray *mTextureArray;
    NSMutableArray *mPositionArray;
    PBSoundSource  *mSoundSource;
}


#pragma mark -


- (id)init
{
    self = [super init];
    
    if (self)
    {
        mAniIndex         = 0;
        mTextureArray     = [[NSMutableArray alloc] init];
        mPositionArray    = [[NSMutableArray alloc] init];
        mSoundSource      = [[PBSoundManager sharedManager] retainSoundSource];
        
        [mSoundSource setLooping:NO];
    }
    
    return self;
}


- (void)dealloc
{
    [mTextureArray release];
    [mPositionArray release];
    [[PBSoundManager sharedManager] releaseSoundSource:mSoundSource];
    
    [super dealloc];
}


#pragma mark -


- (void)action
{
    if (mAniIndex == 0)
    {
        [mSoundSource play];
    }
    
    if (![self isFinished])
    {
        PBTexture *sTexture  = [mTextureArray objectAtIndex:mAniIndex];
        NSValue   *sPosition = [mPositionArray objectAtIndex:mAniIndex];
        
        [self setTexture:sTexture];
        [self setTileSize:[sTexture size]];
        [self setPoint:[sPosition CGPointValue]];
        
        mAniIndex++;
    }
}


#pragma mark -


- (void)reset
{
    mAniIndex = 0;
    
    [mTextureArray removeAllObjects];
    [mPositionArray removeAllObjects];
    [self setAngle:PBVertex3Make(0.0, 0.0, 0.0)];
    
    [self setHidden:NO];
}


- (void)setSound:(PBSound *)aSound
{
    [mSoundSource setSound:aSound];
}


- (void)addTexture:(PBTexture *)aTexture atPosition:(CGPoint)aPosition
{
    if (aTexture)
    {
        [mTextureArray addObject:aTexture];
        [mPositionArray addObject:[NSValue valueWithCGPoint:aPosition]];
    }
}


- (BOOL)isFinished
{
    if (mAniIndex == [mTextureArray count])
    {
        if (![mSoundSource isPlaying])
        {
            return YES;
        }

        [self setHidden:YES];
    }

    if (mAniIndex >= [mTextureArray count])
    {
        mAniIndex = [mTextureArray count] - 1;
    }
    
    return NO;
}


@end
