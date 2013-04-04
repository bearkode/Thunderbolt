//
//  TBALSound.h
//  Thunderbolt
//
//  Created by jskim on 10. 2. 16..
//  Copyright 2010 tinybean. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TBALSound : NSObject
{
    NSString *mName;
    
    ALuint    mSource;
    ALuint    mBuffer;
    CGFloat   mDistance;
    CGPoint   mPosition;
    BOOL      mIsPlaying;
    BOOL      mIsLooping;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) ALuint    source;
@property (nonatomic, assign) ALuint    buffer;
@property (nonatomic, assign) CGPoint   position;
@property (nonatomic, assign) BOOL      isPlaying;
@property (nonatomic, assign) BOOL      isLooping;

- (id)initWithName:(NSString *)aName isLooping:(BOOL)aIsLooping;

@end


void *getOpenALAudioData(CFURLRef aFileURL, ALsizei *aOutDataSize, ALenum *aOutDataFormat, ALsizei *aOutSampleRate);