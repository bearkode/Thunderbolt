/*
 *  TBRadar.m
 *  Thunderbolt
 *
 *  Created by bearkode on 10. 5. 20..
 *  Copyright 2010 Tinybean. All rights reserved.
 *
 */

#import "TBRadar.h"
#import "TBTextureNames.h"
#import "TBRadarObject.h"
#import "TBUnitManager.h"
#import "TBUnit.h"
#import "TBObjectPool.h"


@implementation TBRadar
{
    TBObjectPool        *mObjectPool;
    NSMutableDictionary *mUsingObjects;
    PBSpriteNode        *mRadarMove;
    
    CGSize               mCanvasSize;
    CGFloat              mRadarMoveStartX;
    CGFloat              mRadarMoveEndX;
}


#pragma mark -


- (id)init
{
    self = [super initWithSize:CGSizeMake(1, 1)];
    
    if (self)
    {
        mObjectPool   = [[TBObjectPool alloc] initWithCapacity:100 storableClass:[TBRadarObject class]];
        mUsingObjects = [[NSMutableDictionary alloc] init];
        mRadarMove    = [[PBSpriteNode alloc] initWithImageNamed:@"radar_move"];
        
        [mRadarMove setAlpha:0.0];
        [self addSubNode:mRadarMove];
    }
    
    return self;
}


- (void)dealloc
{
    [mObjectPool release];
    [mUsingObjects release];
    [mRadarMove release];
    
    [super dealloc];
}


#pragma mark -


- (void)drawInRect:(CGRect)aRect context:(CGContextRef)aContext
{
    UIImage *sLeftImage  = [UIImage imageNamed:@"radar_back_l"];
    UIImage *sMidImage   = [UIImage imageNamed:@"radar_back_m"];
    UIImage *sRightImage = [UIImage imageNamed:@"radar_back_r"];
    CGSize   sImageSize  = [sLeftImage size];
    CGRect   sCenterRect = CGRectZero;
    
    sImageSize.width  *= [[UIScreen mainScreen] scale];
    sImageSize.height *= [[UIScreen mainScreen] scale];
    sCenterRect        = CGRectMake(sImageSize.width, 0, aRect.size.width - ((sImageSize.width) * 2.0), sImageSize.height);
    
    sMidImage = [sMidImage stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    
    CGContextClearRect(aContext, aRect);

    CGContextDrawImage(aContext, CGRectMake(0, 0, sImageSize.width, sImageSize.height), [sLeftImage CGImage]);
    CGContextDrawImage(aContext, CGRectMake(aRect.size.width - sImageSize.width, 0, sImageSize.width, sImageSize.height), [sRightImage CGImage]);
    CGContextDrawImage(aContext, sCenterRect, [sMidImage CGImage]);
}


#pragma mark -


- (void)setCanvasSize:(CGSize)aCanvasSize
{
    mCanvasSize = aCanvasSize;
    
    [self setTextureSize:CGSizeMake(aCanvasSize.width, 40)];
    
    mRadarMoveStartX = -aCanvasSize.width / 2.0;
    mRadarMoveEndX   = aCanvasSize.width / 2.0 - 20;
    
    [mRadarMove setPoint:CGPointMake(mRadarMoveStartX, 0)];
}


- (void)updateRadarObject:(TBRadarObject *)aRadarObject withUnit:(TBUnit *)aUnit
{
    CGSize  sRadarSize  = [self textureSize];
    CGPoint sPoint      = [aUnit point];
    CGSize  sObjectSize = [aRadarObject textureSize];
    CGFloat sAlpha      = [aRadarObject alpha] - 0.005;
    
    if ([aUnit isKindOfUnit:kTBUnitHelicopter] || [aUnit isKindOfUnit:kTBUnitMissile])
    {
        sPoint = CGPointMake(sPoint.x / (kMaxMapXPos) * sRadarSize.width, (NSInteger)sPoint.y / mCanvasSize.height * sRadarSize.height - sObjectSize.height / 2.0);
    }
    else
    {
        sPoint = CGPointMake(sPoint.x / (kMaxMapXPos) * sRadarSize.width, sObjectSize.height / 2.0 - 1.0);
    }
    
    sPoint.x -= (sRadarSize.width / 2);
    sPoint.y -= (sRadarSize.height / 2);
    
    sPoint.x *= 0.9;
    sPoint.y *= 0.75;
    
    [aRadarObject setAlpha:sAlpha];
    [aRadarObject setPoint:sPoint];
    [aRadarObject setHidden:NO];
}


- (void)updateUsingObjectsWithUnits:(NSArray *)aUnits
{
    NSMutableSet *sAllUnitIDs   = [NSMutableSet setWithArray:[mUsingObjects allKeys]];
    NSMutableSet *sUsingUnitIDs = [NSMutableSet set];
    
    for (TBUnit *sUnit in aUnits)
    {
        NSNumber      *sUnitID = [sUnit unitID];
        TBRadarObject *sObject = [mUsingObjects objectForKey:sUnitID];
        
        if (!sObject)
        {
            TBRadarObject *sRadarObject = [mObjectPool object];
            
            [sRadarObject setAlpha:0.0];
            [sRadarObject setHidden:YES];
            [mUsingObjects setObject:sRadarObject forKey:sUnitID];
        }
        
        [self updateRadarObject:sObject withUnit:sUnit];
        [sUsingUnitIDs addObject:sUnitID];
    }
    
    [sAllUnitIDs minusSet:sUsingUnitIDs];
    
    for (NSNumber *sUnitID in sAllUnitIDs)
    {
        TBRadarObject *sObject = [mUsingObjects objectForKey:sUnitID];
        
        [sObject setHidden:YES];
        [mObjectPool finishUsing:sObject];
        [mUsingObjects removeObjectForKey:sUnitID];
    }
}


- (void)update
{
    [self updateUsingObjectsWithUnits:[[TBUnitManager sharedManager] allUnits]];
    
    {
        CGPoint sPoint = [mRadarMove point];
        sPoint.x += 4.0;

        if (sPoint.x > (mRadarMoveEndX))
        {
            sPoint.x = mRadarMoveStartX;
            [mRadarMove setAlpha:0.0];
        }
        
        CGFloat sAlpha = [mRadarMove alpha];
        if (sPoint.x < (mRadarMoveStartX + 100))
        {
            [mRadarMove setAlpha:sAlpha + 0.025];
        }
        else if (sPoint.x > (mRadarMoveEndX - 100))
        {
            [mRadarMove setAlpha:sAlpha - 0.025];
        }
        
        [mRadarMove setPoint:sPoint];
        
        for (TBRadarObject *sObject in [mUsingObjects allValues])
        {
            CGPoint sObjectPoint = [sObject point];
            
            if (sObjectPoint.x > (sPoint.x - 20) &&
                sObjectPoint.x < (sPoint.x + 20))
            {
                [sObject setAlpha:0.7];
            }
        }
    }
    
    [self setSubNodes:[mUsingObjects allValues]];
    [self addSubNode:mRadarMove];
}


@end
