//
//  TBALPlayback.m
//  Thunderbolt
//
//  Created by jskim on 10. 2. 11..
//  Copyright 2010 tinybean. All rights reserved.
//
#import "TBALPlayback.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/ExtendedAudioFile.h>
#import "TBGameConst.h"
#import "TBALSound.h"


void interruptionListener(void *aClientData, UInt32 aInterruptionState)
{
    OSStatus      sResult;
    TBALPlayback *sPlayback = (TBALPlayback*)aClientData;
    
	if (aInterruptionState == kAudioSessionBeginInterruption)
	{
        alcMakeContextCurrent(NULL);		
//        if ([sPlayback isPlaying])
//        {
            [sPlayback setWasInterrupted:YES];
//        }
	}
	else if (aInterruptionState == kAudioSessionEndInterruption)
	{
        sResult = AudioSessionSetActive(true);
		if (sResult)
        {
            NSLog(@"Error setting audio session active! %ld\n", sResult);
        }
        
		alcMakeContextCurrent([sPlayback context]);
        
		if ([sPlayback wasInterrupted])
		{
//			[sPlayback startSound];			
            [sPlayback setWasInterrupted:NO];
		}
	}
}


void routeChangeListener(void *aClientData, AudioSessionPropertyID aID, UInt32 aDataSize, const void *aData)
{
	CFDictionaryRef sDict     = (CFDictionaryRef)aData;
	CFStringRef     sOldRoute = CFDictionaryGetValue(sDict, CFSTR(kAudioSession_AudioRouteChangeKey_OldRoute));
	UInt32          sSize     = sizeof(CFStringRef);
	CFStringRef     sNewRoute;
	OSStatus        sResult   = AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &sSize, &sNewRoute);
    
	NSLog(@"result: %ld Route changed from %@ to %@", sResult, sOldRoute, sNewRoute);
}


static TBALPlayback *gSharedPlayback = nil;


@interface TBALPlayback (Privates)
@end


@implementation TBALPlayback (Privates)


- (void)initOpenAL
{
	ALenum sError;
	
	mDevice  = alcOpenDevice(NULL);
    mContext = alcCreateContext(mDevice, 0);
    
    alcMakeContextCurrent(mContext);

    sError = (alGetError()) != AL_NO_ERROR;
    if (sError)
    {
        NSLog(@"Error %x\n", sError);
        exit(1);
    }
}


- (void)releaseALObjects
{	
    alcDestroyContext(mContext);
    alcCloseDevice(mDevice);
}


- (void)loadHeliSound
{
    TBALSound *sSound;
    
    sSound = [[[TBALSound alloc] initWithName:kTBSoundHeli isLooping:YES] autorelease];
    [mSoundDict setObject:sSound forKey:kTBSoundHeli];
}


- (void)loadVulcanSound
{
    TBALSound *sSound;
    
    sSound = [[[TBALSound alloc] initWithName:kTBSoundVulcan isLooping:YES] autorelease];
    [mSoundDict setObject:sSound forKey:kTBSoundVulcan];
}


- (void)loadBombExplosionSound
{
    TBALSound *sSound;
    
    sSound = [[[TBALSound alloc] initWithName:kTBSoundBombExplosion isLooping:NO] autorelease];
    [mSoundDict setObject:sSound forKey:kTBSoundBombExplosion];
}


- (void)loadTankExplosionSound
{
    TBALSound *sSound;
    
    sSound = [[[TBALSound alloc] initWithName:kTBSoundTankExplosion isLooping:NO] autorelease];
    [mSoundDict setObject:sSound forKey:kTBSoundTankExplosion];
}


@end


@implementation TBALPlayback


@synthesize context          = mContext;
@synthesize wasInterrupted   = mWasInterrupted;
@synthesize listenerRotation = mListenerRotation;
@dynamic    listenerPos;


#pragma mark -


+ (TBALPlayback *)sharedPlayback
{
    if (!gSharedPlayback)
    {
        gSharedPlayback = [[TBALPlayback alloc] init];
    }
    
    return gSharedPlayback;
}


#pragma mark Object Init / Maintenance


- (id)init
{	
    OSStatus sResult;
    UInt32   sIsiPodPlaying;
    UInt32   sSize;
    UInt32   sCategory;
    
    self = [super init];
    
	if (self)
    {
		mListenerPos      = CGPointMake(0., 0.);
        mListenerRotation = 0.0;
		mWasInterrupted   = NO;
		
        sResult = AudioSessionInitialize(NULL, NULL, interruptionListener, self);
		if (sResult)
        {
            NSLog(@"Error initializing audio session! %ld\n", sResult);
        }
        
        sSize = sizeof(sIsiPodPlaying);
        sResult = AudioSessionGetProperty(kAudioSessionProperty_OtherAudioIsPlaying, &sSize, &sIsiPodPlaying);
        if (sResult)
        {
            NSLog(@"Error getting other audio playing property! %ld", sResult);
        }
        
        sCategory = (sIsiPodPlaying) ? kAudioSessionCategory_AmbientSound : kAudioSessionCategory_SoloAmbientSound;
        sResult = AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sCategory), &sCategory);
        if (sResult)
        {
            NSLog(@"Error setting audio session category! %ld\n", sResult);
        }
        
        sResult = AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange, routeChangeListener, self);
        if (sResult)
        {
            NSLog(@"Couldn't add listener: %ld", sResult);
        }           
        sResult = AudioSessionSetActive(true);
        if (sResult)
        {
            NSLog(@"Error setting audio session active! %ld\n", sResult);
        }
        
		[self initOpenAL];
        
        mSoundDict = [[NSMutableDictionary alloc] init];
        
        [self loadVulcanSound];
        [self loadHeliSound];
        [self loadBombExplosionSound];
        [self loadTankExplosionSound];
	}
    
	return self;
}


- (void)dealloc
{
	[self releaseALObjects];
    [mSoundDict release];
    
	[super dealloc];
}


#pragma mark AVAudioPlayer


/*- (void)timerFired:(NSTimer *)aTimer
{
    ALint sValue;
    
    alGetSourcei(mSource02, AL_SOURCE_STATE, &sValue);
    if (sValue == AL_INITIAL || sValue == AL_STOPPED)
    {
        alSourcePlay(mSource02);
    }
    else
    {
        alGetSourcei(mSource03, AL_SOURCE_STATE, &sValue);
        if (sValue == AL_INITIAL || sValue == AL_STOPPED)
        {
            alSourcePlay(mSource03);
        }
    }
}*/


#pragma mark Play / Pause


/*- (void)startSound
{
	ALenum sError;
	
	alSourcePlay(mSource01);
    
	if ((sError = alGetError()) != AL_NO_ERROR)
    {
		NSLog(@"error starting source: %x\n", sError);
	}
    else
    {
        mIsPlaying = YES;
	}
}


- (void)stopSound
{
	ALenum sError;
	
	alSourceStop(mSource01);
    
	if ((sError = alGetError()) != AL_NO_ERROR)
    {
		NSLog(@"error stopping source: %x\n", sError);
	}
    else
    {
        mIsPlaying = NO;
	}
}*/


#pragma mark Setters / Getters


/*- (void)setSourcePos:(CGPoint)aSourcePos
{
	float sSourcePos[3];
    
	mSourcePos = aSourcePos;
    
    sSourcePos[0] = mSourcePos.x;
    sSourcePos[1] = kDefaultDistance;
    sSourcePos[2] = mSourcePos.y;
    
	alSourcefv(mSource01, AL_POSITION, sSourcePos);
}*/


- (CGPoint)listenerPos
{
	return mListenerPos;
}


- (void)setListenerPos:(CGPoint)aListenerPos
{
	float sListenerPos[3];
    
    mListenerPos = aListenerPos;
    
    sListenerPos[0] = mListenerPos.x;
    sListenerPos[1] = 0;
    sListenerPos[2] = mListenerPos.y;
    
	alListenerfv(AL_POSITION, sListenerPos);
}


- (CGFloat)listenerRotation
{
	return mListenerRotation;
}


- (void)setListenerRotation:(CGFloat)aRadians
{
	float sOrientation[6];
    
    mListenerRotation = aRadians;
    
    sOrientation[0] = cos(aRadians + M_PI_2);
    sOrientation[1] = sin(aRadians + M_PI_2);
    sOrientation[2] = 0.0;
    sOrientation[3] = 0.0;
    sOrientation[4] = 0.0;
    sOrientation[5] = 1.0;    
    
	alListenerfv(AL_ORIENTATION, sOrientation);
}


#pragma mark -


- (void)startSound:(NSString *)aSoundID
{
    id         sObject = [mSoundDict objectForKey:aSoundID];
    TBALSound *sSound;
    
    if ([sObject isMemberOfClass:[TBALSound class]])
    {
        sSound = (TBALSound *)sObject;
        alSourcePlay([sSound source]);
        [sSound setIsPlaying:YES];
    }
    else
    {
    
    }
}


- (void)stopSound:(NSString *)aSoundID
{
    id         sObject = [mSoundDict objectForKey:aSoundID];
    TBALSound *sSound;
    
    if ([sObject isMemberOfClass:[TBALSound class]])
    {
        sSound = (TBALSound *)sObject;
        alSourceStop([sSound source]);
        [sSound setIsPlaying:NO];
    }
    else
    {
        
    }
}


@end
