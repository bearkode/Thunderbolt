//
//  TBStructureManager.h
//  Thunderbolt
//
//  Created by jskim on 10. 7. 5..
//  Copyright 2010 Tinybean. All rights reserved.
//

#import <Foundation/Foundation.h>


@class TBStructure;
@class TBWarhead;


@interface TBStructureManager : NSObject
{
    NSMutableArray *mAllyStructures;
    NSMutableArray *mEnemyStructures;
}

+ (TBStructureManager *)sharedManager;

- (void)addStructure:(TBStructure *)aStructure;
- (void)doActions;

- (TBStructure *)intersectedOpponentStructure:(TBWarhead *)aWarhead;

@end
