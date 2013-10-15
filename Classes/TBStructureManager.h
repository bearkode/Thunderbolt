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
#import <PBKit.h>
#import "TBGameConst.h"


extern NSString *const kTBBaseDidDestroyNotificaton;


@class TBStructure;
@class TBWarhead;


@interface TBStructureManager : NSObject


+ (TBStructureManager *)sharedManager;


- (void)reset;
- (void)setStructureLayer:(PBNode *)aStructureLayer;

- (void)doActions;

- (TBStructure *)intersectedOpponentStructure:(TBWarhead *)aWarhead;

- (void)addStructure:(TBStructure *)aStructure;
- (void)addBaseWithTeam:(TBTeam)aTeam position:(CGFloat)aPosition;
- (void)addLandingPadWithTeam:(TBTeam)aTeam position:(CGFloat)aPosition;
- (void)addAAGunSiteWithTeam:(TBTeam)aTeam position:(CGFloat)aPosition;


@end
