//
//  TBTextureManager.h
//  Thunderbolt
//
//  Created by jskim on 10. 1. 25..
//  Copyright 2010 tinybean. All rights reserved.
//

#import <Foundation/Foundation.h>


@class TBTextureInfo;


@interface TBTextureManager : NSObject
{
    NSMutableDictionary *mTextureInfoDict;
}

+ (TBTextureManager *)sharedManager;
+ (TBTextureInfo *)textureInfoForKey:(NSString *)aKey;

- (void)loadTextures;
- (void)loadTextureWithName:(NSString *)aName forKey:(NSString *)aKey;
- (TBTextureInfo *)textureInfoForKey:(NSString *)aKey;

@end
