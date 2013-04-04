//
//  TBSoundManager.h
//  Thunderbolt
//
//  Created by jskim on 10. 2. 6..
//  Copyright 2010 tinybean. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TBBGMManager : NSObject <AVAudioPlayerDelegate>
{
    AVAudioPlayer  *mBGMPlayer;
}

+ (TBBGMManager *)sharedManager;

+ (void)startBGMWithVolume:(CGFloat)aVolume;
+ (void)stopBGM;

@end
