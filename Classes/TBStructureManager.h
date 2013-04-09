/*
 *  TBStructureManager.h
 *  Thunderbolt
 *
 *  Created by bearkode on 10. 7. 5..
 *  Copyright 2010 Tinybean. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import <PBObjCUtil.h>


@class TBStructure;
@class TBWarhead;


@interface TBStructureManager : NSObject


+ (TBStructureManager *)sharedManager;


- (void)addStructure:(TBStructure *)aStructure;
- (void)doActions;


- (TBStructure *)intersectedOpponentStructure:(TBWarhead *)aWarhead;


@end
