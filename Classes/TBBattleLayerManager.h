/*
 *  TBBattleLayerManager.h
 *  Thunderbolt
 *
 *  Created by cgkim on 13. 10. 15..
 *  Copyright (c) 2013 Tinybean. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import <PBKit.h>


@interface TBBattleLayerManager : NSObject


@property (nonatomic, readonly) PBNode *radarLayer;
@property (nonatomic, readonly) PBNode *interfaceLayer;
@property (nonatomic, readonly) PBNode *effectLayer;
@property (nonatomic, readonly) PBNode *smokeLayer;
@property (nonatomic, readonly) PBNode *warheadLayer;
@property (nonatomic, readonly) PBNode *explosionLayer;
@property (nonatomic, readonly) PBNode *unitLayer;
@property (nonatomic, readonly) PBNode *structureLayer;
@property (nonatomic, readonly) PBNode *backgroundLayer;


- (NSArray *)layers;


@end
