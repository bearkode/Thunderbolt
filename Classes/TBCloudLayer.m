/*
 *  TBCloudLayer.m
 *  Thunderbolt
 *
 *  Created by cgkim on 13. 10. 22..
 *  Copyright (c) 2013 Tinybean. All rights reserved.
 *
 */

#import "TBCloudLayer.h"


@implementation TBCloudLayer


- (id)init
{
    self = [super init];
    
    if (self)
    {
        for (NSInteger i = 0; i < 20; i++)
        {
            PBSpriteNode *sCloudNode = [PBSpriteNode spriteNodeWithImageNamed:@"cloud1"];
            CGPoint       sPoint     = CGPointZero;
            
            sPoint.x = arc4random() % 4000;
            sPoint.y = arc4random() % 200;
            
            [sCloudNode setPoint:sPoint];
            [sCloudNode setAlpha:0.8];
            
            [self addSubNode:sCloudNode];
        }

        for (NSInteger i = 0; i < 20; i++)
        {
            PBSpriteNode *sCloudNode = [PBSpriteNode spriteNodeWithImageNamed:@"cloud2"];
            CGPoint       sPoint     = CGPointZero;
            
            sPoint.x = arc4random() % 4000;
            sPoint.y = arc4random() % 200;
            
            [sCloudNode setPoint:sPoint];
            [sCloudNode setAlpha:0.8];
            
            [self addSubNode:sCloudNode];
        }
    }
    
    return self;
}


- (void)dealloc
{
    [super dealloc];
}


@end
