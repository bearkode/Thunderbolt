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
#import "TBGameConst.h"


@implementation TBExplosion
{
    NSInteger       mAniIndex;
    NSMutableArray *mTextureArray;
    NSMutableArray *mPositionArray;
}


- (id)init
{
    self = [super init];
    
    if (self)
    {
        mAniIndex         = 0;
        mTextureArray     = [[NSMutableArray alloc] init];
        mPositionArray    = [[NSMutableArray alloc] init];
    }
    
    return self;
}


- (void)dealloc
{
    [mTextureArray release];
    [mPositionArray release];
    
    [super dealloc];
}


- (void)action
{
    if (![self isFinished])
    {
        PBTexture *sTexture  = [mTextureArray objectAtIndex:mAniIndex];
        NSValue   *sPosition = [mPositionArray objectAtIndex:mAniIndex];
        
        [self setTexture:sTexture];
        [self setPoint:[sPosition CGPointValue]];
        
        mAniIndex++;
    }
}


#pragma mark -


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
        return YES;
    }
    
    return NO;
}


@end
