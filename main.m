//
//  main.m
//  Thunderbolt
//
//  Created by jskim on 10. 1. 25..
//  Copyright tinybean 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int aArgc, char *aArgv[])
{
    NSAutoreleasePool *sPool   = [[NSAutoreleasePool alloc] init];
    int                sResult = UIApplicationMain(aArgc, aArgv, nil, nil);
    [sPool release];
    return sResult;
}
