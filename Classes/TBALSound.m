//
//  TBALSound.m
//  Thunderbolt
//
//  Created by jskim on 10. 2. 16..
//  Copyright 2010 tinybean. All rights reserved.
//

#import "TBALSound.h"


void *getOpenALAudioData(CFURLRef aFileURL, ALsizei *aOutDataSize, ALenum *aOutDataFormat, ALsizei *aOutSampleRate)
{
    OSStatus                    sErr = noErr;	
	SInt64						sFileLengthInFrames = 0;
	AudioStreamBasicDescription	sFileFormat;
	UInt32						sPropertySize = sizeof(sFileFormat);
	ExtAudioFileRef				sExtRef = NULL;
	void                       *sData = NULL;
	AudioStreamBasicDescription	sOutputFormat;
    UInt32                      sDataSize;
    AudioBufferList             sDataBuffer;
    
	sErr = ExtAudioFileOpenURL(aFileURL, &sExtRef);
	if (sErr)
    {
        printf("MyGetOpenALAudioData: ExtAudioFileOpenURL FAILED, Error = %ld\n", sErr);
        goto Exit;
    }
    
	sErr = ExtAudioFileGetProperty(sExtRef, kExtAudioFileProperty_FileDataFormat, &sPropertySize, &sFileFormat);
	if (sErr)
    {
        printf("MyGetOpenALAudioData: ExtAudioFileGetProperty(kExtAudioFileProperty_FileDataFormat) FAILED, Error = %ld\n", sErr);
        goto Exit;
    }
	
    if (sFileFormat.mChannelsPerFrame > 2)
    {
        printf("MyGetOpenALAudioData - Unsupported Format, channel count is greater than stereo\n");
        goto Exit;
    }
    
	sOutputFormat.mSampleRate       = sFileFormat.mSampleRate;
	sOutputFormat.mChannelsPerFrame = sFileFormat.mChannelsPerFrame;
	sOutputFormat.mFormatID         = kAudioFormatLinearPCM;
	sOutputFormat.mBytesPerPacket   = 2 * sOutputFormat.mChannelsPerFrame;
	sOutputFormat.mFramesPerPacket  = 1;
	sOutputFormat.mBytesPerFrame    = 2 * sOutputFormat.mChannelsPerFrame;
	sOutputFormat.mBitsPerChannel   = 16;
	sOutputFormat.mFormatFlags      = kAudioFormatFlagsNativeEndian | kAudioFormatFlagIsPacked | kAudioFormatFlagIsSignedInteger;
	
	sErr = ExtAudioFileSetProperty(sExtRef, kExtAudioFileProperty_ClientDataFormat, sizeof(sOutputFormat), &sOutputFormat);
	if (sErr)
    {
        printf("MyGetOpenALAudioData: ExtAudioFileSetProperty(kExtAudioFileProperty_ClientDataFormat) FAILED, Error = %ld\n", sErr);
        goto Exit;
    }
	
    sPropertySize = sizeof(sFileLengthInFrames);
	sErr = ExtAudioFileGetProperty(sExtRef, kExtAudioFileProperty_FileLengthFrames, &sPropertySize, &sFileLengthInFrames);
	if (sErr)
    {
        printf("MyGetOpenALAudioData: ExtAudioFileGetProperty(kExtAudioFileProperty_FileLengthFrames) FAILED, Error = %ld\n", sErr);
        goto Exit;
    }
	
    sDataSize = sFileLengthInFrames * sOutputFormat.mBytesPerFrame;;
    sData     = malloc(sDataSize);
	if (sData)
	{
        sDataBuffer.mNumberBuffers              = 1;
        sDataBuffer.mBuffers[0].mDataByteSize   = sDataSize;
        sDataBuffer.mBuffers[0].mNumberChannels = sOutputFormat.mChannelsPerFrame;
        sDataBuffer.mBuffers[0].mData           = sData;
		
		sErr = ExtAudioFileRead(sExtRef, (UInt32*)&sFileLengthInFrames, &sDataBuffer);
		if(sErr == noErr)
		{
			*aOutDataSize   = (ALsizei)sDataSize;
			*aOutDataFormat = (sOutputFormat.mChannelsPerFrame > 1) ? AL_FORMAT_STEREO16 : AL_FORMAT_MONO16;
			*aOutSampleRate = (ALsizei)sOutputFormat.mSampleRate;
		}
		else 
		{ 
			free(sData);
			sData = NULL;
			printf("MyGetOpenALAudioData: ExtAudioFileRead FAILED, Error = %ld\n", sErr);
            goto Exit;
		}	
	}
	
Exit:
	if (sExtRef)
    {
        ExtAudioFileDispose(sExtRef);
    }
    
	return sData;
}


@interface TBALSound (Privates)
@end


@implementation TBALSound (Privates)


- (void)initBuffer
{
    ALenum    sError  = AL_NO_ERROR;
    NSString *sName   = [mName stringByDeletingPathExtension];
    NSString *sExt    = [mName pathExtension];
    NSBundle *sBundle = [NSBundle mainBundle];
    CFURLRef  sFileURL;
    void     *sData;
    ALsizei   sSize;
    ALenum    sFormat;
    ALsizei   sFreq;
    
    sFileURL = (CFURLRef)[NSURL fileURLWithPath:[sBundle pathForResource:sName ofType:sExt]];
    sData    = getOpenALAudioData(sFileURL, &sSize, &sFormat, &sFreq);
    
    alBufferData(mBuffer, sFormat, sData, sSize, sFreq);
    
    if ((sError = alGetError()) != AL_NO_ERROR)
    {
        NSLog(@"error loading sound: %x\n", sError);
        exit(1);
    }
}


- (void)initSource
{
	ALenum sError       = AL_NO_ERROR;
	float  sSourcePos[] = { mPosition.x, mDistance, mPosition.y };

    alGetError();

    alSourcei(mSource, AL_LOOPING, mIsLooping);
	alSourcefv(mSource, AL_POSITION, sSourcePos);
	alSourcef(mSource, AL_REFERENCE_DISTANCE, 50.0f);
	alSourcei(mSource, AL_BUFFER, mBuffer);

    if((sError = alGetError()) != AL_NO_ERROR)
    {
		NSLog(@"Error attaching buffer to source: %x\n", sError);
		exit(1);
	}	
}


@end


@implementation TBALSound


@synthesize name      = mName;
@synthesize source    = mSource;
@synthesize buffer    = mBuffer;
@synthesize position  = mPosition;
@synthesize isPlaying = mIsPlaying;
@synthesize isLooping = mIsLooping;


#pragma mark -


- (id)initWithName:(NSString *)aName isLooping:(BOOL)aIsLooping
{
    self = [super init];
    if (self)
    {
        [self setName:aName];
        
        mDistance  = 25.0;
        mPosition  = CGPointMake(0, 0);
        mIsPlaying = NO;
        mIsLooping = aIsLooping;
        
        alGenSources(1, &mSource);
        alGenBuffers(1, &mBuffer);
        
        [self initBuffer];
        [self initSource];
    }
    
    return self;
}


- (void)dealloc
{
    [mName release];
    
    alDeleteBuffers(1, &mBuffer);
    alDeleteSources(1, &mSource);
    
    [super dealloc];
}


@end
