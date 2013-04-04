//
//  TBALPlayback.h
//  Thunderbolt
//
//  Created by jskim on 10. 2. 11..
//  Copyright 2010 tinybean. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <OpenAL/al.h>
#import <OpenAL/alc.h>


#define kDefaultDistance 25.0


@interface TBALPlayback : NSObject
{
    ALCdevice*  mDevice;
    ALCcontext* mContext;
    
/*    ALuint      mSource01;
    ALuint      mBuffer01;
    ALuint      mSource02;
    ALuint      mBuffer02;
    ALuint      mSource03;
    ALuint      mBuffer03;
    
    CGPoint     mSourcePos;*/
    CGPoint     mListenerPos;
    CGFloat     mListenerRotation;
//    BOOL        mIsPlaying;
    BOOL        mWasInterrupted;
    
//    NSTimer    *mTimer;
    
    NSMutableDictionary *mSoundDict;
}

@property (nonatomic, readonly) ALCcontext *context;
//@property (nonatomic, assign)   BOOL        isPlaying;                // Whether the sound is playing or stopped
@property (nonatomic, assign)   BOOL        wasInterrupted;           // Whether playback was interrupted by the system
//@property (nonatomic, assign)   CGPoint     sourcePos;                // The coordinates of the sound source
@property (nonatomic, assign)   CGPoint     listenerPos;              // The coordinates of the listener
@property (nonatomic, assign)   CGFloat     listenerRotation;         // The rotation angle of the listener in radians

//- (void)startSound;
//- (void)stopSound;

+ (TBALPlayback *)sharedPlayback;

- (void)startSound:(NSString *)aSoundID;
- (void)stopSound:(NSString *)aSoundID;

@end
