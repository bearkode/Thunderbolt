/*
 *  TBHelicopterInfo.h
 *  Thunderbolt
 *
 *  Created by cgkim on 13. 4. 20..
 *  Copyright (c) 2013 Tinybean. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


@interface TBHelicopterInfo : NSObject


@property (nonatomic, assign) CGSize    tileSize;
@property (nonatomic, retain) NSString *imageName;
@property (nonatomic, retain) NSString *soundName;


+ (TBHelicopterInfo *)MD500Info;
+ (TBHelicopterInfo *)UH1Info;
+ (TBHelicopterInfo *)UH1NInfo;
+ (TBHelicopterInfo *)AH1CobraInfo;
+ (TBHelicopterInfo *)AH1WSuperCobraInfo;


@end
