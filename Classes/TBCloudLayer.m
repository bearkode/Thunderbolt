/*
 *  TBCloudLayer.m
 *  Thunderbolt
 *
 *  Created by cgkim on 13. 10. 22..
 *  Copyright (c) 2013 Tinybean. All rights reserved.
 *
 */

#import "TBCloudLayer.h"
#import "TBGameConst.h"


@implementation TBCloudLayer
{
    PBNode *mNearNode;
    PBNode *mParNode;
}


- (id)init
{
    self = [super init];
    
    if (self)
    {
        mNearNode = [[[PBNode alloc] init] autorelease];
        mParNode  = [[[PBNode alloc] init] autorelease];

        [self addSubNode:mParNode];
        [self addSubNode:mNearNode];
        
        NSArray  *sNodes  = @[mNearNode, mParNode];
        NSInteger sIndex = 0;
        
        for (PBNode *sNode in sNodes)
        {
            NSInteger sWidth = (sIndex == 0) ? kMaxMapXPos : kMaxMapXPos / 2.0;
            CGFloat   sScale = (sIndex == 0) ? 1.0 : 0.6;
            
            sIndex++;
            
            for (NSInteger i = 0; i < 10; i++)
            {
                PBSpriteNode *sCloudNode = [PBSpriteNode spriteNodeWithImageNamed:@"cloud1"];
                CGPoint       sPoint     = CGPointZero;
                
                sPoint.x = arc4random() % sWidth;
                sPoint.y = arc4random() % 300;  //  FIXME
                
                [sCloudNode setPoint:sPoint];
                [sCloudNode setAlpha:0.8];
                [sCloudNode setScale:PBVertex3Make(sScale, sScale, 1.0)];
                
                [sNode addSubNode:sCloudNode];
            }
            
            for (NSInteger i = 0; i < 10; i++)
            {
                PBSpriteNode *sCloudNode = [PBSpriteNode spriteNodeWithImageNamed:@"cloud2"];
                CGPoint       sPoint     = CGPointZero;
                
                sPoint.x = arc4random() % sWidth;
                sPoint.y = arc4random() % 300;  //  FIXME
                
                [sCloudNode setPoint:sPoint];
                [sCloudNode setAlpha:0.8];
                [sCloudNode setScale:PBVertex3Make(sScale, sScale, 1.0)];

                [sNode addSubNode:sCloudNode];
            }
        }
    }
    
    return self;
}


- (void)dealloc
{
    [super dealloc];
}


- (void)updateWithCameraPositioin:(CGPoint)aCameraPosition
{
    CGFloat sX = aCameraPosition.x / kMaxMapXPos * 2000;
    
    [mParNode setPoint:CGPointMake(sX, 0)];
}


@end
