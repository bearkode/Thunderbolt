/*
 *  TBUserStatusManager.h
 *  Thunderbolt
 *
 *  Created by cgkim on 13. 4. 19..
 *  Copyright (c) 2013 Tinybean. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


@interface TBUserStatusManager : NSObject


+ (id)sharedManager;

- (void)saveStatus;
- (void)loadStatus;


@end
