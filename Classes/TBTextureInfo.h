//
//  TBTextureInfo.h
//  Thunderbolt
//
//  Created by jskim on 10. 1. 25..
//  Copyright 2010 tinybean. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TBTextureInfo : NSObject
{
    GLuint mTextureID;
    CGSize mTextureSize;
    CGSize mContentSize;
}

@property (nonatomic, assign) GLuint textureID;
@property (nonatomic, assign) CGSize textureSize;
@property (nonatomic, assign) CGSize contentSize;

@end
