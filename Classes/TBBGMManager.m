//
//  TBSoundManager.m
//  Thunderbolt
//
//  Created by jskim on 10. 2. 6..
//  Copyright 2010 tinybean. All rights reserved.
//

#import "TBGameConst.h"


static TBBGMManager *gSoundManager = nil;


@interface TBBGMManager (Privates)

- (void)startSound:(NSString *)sSoundID numberOfLoop:(NSInteger)aLoop volume:(CGFloat)aVolume;
- (void)stopSound:(NSString *)sSoundID;

@end


@implementation TBBGMManager (Privates)


- (void)startSound:(NSString *)aSoundID numberOfLoop:(NSInteger)aLoop volume:(CGFloat)aVolume
{
    NSError       *sError;
    NSString      *sName = [aSoundID stringByDeletingPathExtension];
    NSString      *sExt  = [aSoundID pathExtension];
    NSString      *sPath = [[NSBundle mainBundle] pathForResource:sName ofType:sExt];
    NSData        *sData = [NSData dataWithContentsOfFile:sPath];
    
    if ([aSoundID isEqualToString:kTBSoundValkyries])
    {
        [self stopSound:kTBSoundValkyries];
        
        mBGMPlayer = [[AVAudioPlayer alloc] initWithData:sData error:&sError];
        [mBGMPlayer setVolume:aVolume];
        [mBGMPlayer setNumberOfLoops:aLoop];
        [mBGMPlayer play];
    }
}


- (void)stopSound:(NSString *)aSoundID
{
    if ([aSoundID isEqualToString:kTBSoundValkyries])
    {
        [mBGMPlayer stop];
        [mBGMPlayer release];
        mBGMPlayer = nil;
    }
}


@end


@implementation TBBGMManager


- (id)init
{
    self = [super init];
    
    if (self)
    {

    }
    
    return self;
}


+ (TBBGMManager *)sharedManager
{
    if (!gSoundManager)
    {
        gSoundManager = [[TBBGMManager alloc] init];
    }
    
    return gSoundManager;
}


+ (void)startBGMWithVolume:(CGFloat)aVolume
{
    [[TBBGMManager sharedManager] startSound:kTBSoundValkyries numberOfLoop:-1 volume:aVolume];
}


+ (void)stopBGM
{
    [[TBBGMManager sharedManager] stopSound:kTBSoundValkyries];
}


+ (void)tankExplosionWithVolume:(CGFloat)aVolume
{
    [[TBBGMManager sharedManager] startSound:kTBSoundTankExplosion numberOfLoop:0 volume:aVolume];
}


#pragma mark -


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)aPlayer successfully:(BOOL)aFlag
{

}


@end
