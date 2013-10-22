/*
 *  TBHitPointsBar.m
 *  Thunderbolt
 *
 *  Created by cgkim on 13. 10. 22..
 *  Copyright (c) 2013 Tinybean. All rights reserved.
 *
 */

#import "TBHitPointsBar.h"


const CGSize  kCellSize = { 8, 10 };
const CGFloat kOnAlpha  = 0.5;
const CGFloat kOffAlpha = 0.1;


@implementation TBHitPointsBar
{
    CGFloat         mHitPoint;
    NSMutableArray *mHitPointCells;
    
    UIImage        *mImageG;
    UIImage        *mImageY;
    UIImage        *mImageR;
}


#pragma mark -


- (id)init
{
    CGRect sFrame = CGRectMake(0, 0, kCellSize.width * 20, kCellSize.height);
    
    self = [super initWithFrame:sFrame];
    
    if (self)
    {
        mHitPointCells = [[NSMutableArray alloc] init];
        
        mImageG        = [[UIImage imageNamed:@"energy"] retain];
        mImageY        = [[UIImage imageNamed:@"energy_y"] retain];
        mImageR        = [[UIImage imageNamed:@"energy_r"] retain];
        
        for (NSInteger i = 0; i < 20; i++)
        {
            UIView *sCellView = [[[UIImageView alloc] initWithImage:mImageG] autorelease];
            
            [sCellView setFrame:CGRectMake(i * kCellSize.width, 0, kCellSize.width, kCellSize.height)];
            [sCellView setAlpha:0.5];
            [self addSubview:sCellView];
            
            [mHitPointCells addObject:sCellView];
        }
    }
    
    return self;
}


- (void)dealloc
{
    [mHitPointCells release];
    
    [mImageG release];
    [mImageY release];
    [mImageR release];
    
    [super dealloc];
}


#pragma mark -


- (void)setHitPoint:(CGFloat)aHitPoint
{
    UIImage *sImage = mImageG;
    
    mHitPoint = aHitPoint;
    
    if (aHitPoint < 0.25)
    {
        sImage = mImageR;
    }
    else if (aHitPoint < 0.5)
    {
        sImage = mImageY;
    }
    
    for (UIImageView *sCellView in mHitPointCells)
    {
        if (aHitPoint > 0.0)
        {
            [sCellView setImage:sImage];
            [sCellView setAlpha:kOnAlpha];
        }
        else
        {
            [sCellView setImage:mImageG];
            [sCellView setAlpha:kOffAlpha];
        }
        
        aHitPoint -= 0.05;
    }
}


- (void)setLocation:(CGPoint)aPoint
{
    CGRect sFrame = [self frame];
    
    [self setFrame:CGRectMake(aPoint.x, aPoint.y, sFrame.size.width, sFrame.size.height)];
}


@end
