//
//  TBTextureManager.m
//  Thunderbolt
//
//  Created by jskim on 10. 1. 25..
//  Copyright 2010 tinybean. All rights reserved.
//

#import "TBTextureManager.h"
#import "TBTextureNames.h"
#import "TBTextureInfo.h"


TBTextureManager *gTextureManager;


@implementation TBTextureManager


+ (TBTextureManager *)sharedManager
{
    if (!gTextureManager)
    {
        gTextureManager = [[TBTextureManager alloc] init];
    }
    
    return gTextureManager;
}


+ (TBTextureInfo *)textureInfoForKey:(NSString *)aKey
{
    return [[TBTextureManager sharedManager] textureInfoForKey:aKey];
}


- (id)init
{
    self = [super init];
    if (self)
    {
        mTextureInfoDict = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}


- (void)dealloc
{
    TBTextureInfo *sInfo;
    NSEnumerator  *sEnum = [mTextureInfoDict objectEnumerator];
    GLuint         sTextureID;
    
    while (sInfo = [sEnum nextObject])
    {
        sTextureID = [sInfo textureID];
        glDeleteTextures(1, &sTextureID);
    }
    
    [mTextureInfoDict release];
    
    [super dealloc];
}


- (CGSize)textureSizeWithImageSize:(CGSize)aSize
{
    CGSize sResult = CGSizeMake(8.0, 8.0);
    
    if (aSize.width > 8)
    {
        sResult.width = 16;
    }
    if (aSize.width > 16)
    {
        sResult.width = 32;
    }
    if (aSize.width > 32)
    {
        sResult.width = 64;
    }
    if (aSize.width > 64)
    {
        sResult.width = 128;
    }
    if (aSize.width > 128)
    {
        sResult.width = 256;
    }
    if (aSize.width > 256)
    {
        sResult.width = 512;
    }
    
    if (aSize.height > 8)
    {
        sResult.height = 16;
    }
    if (aSize.height > 16)
    {
        sResult.height = 32;
    }
    if (aSize.height > 32)
    {
        sResult.height = 64;
    }
    if (aSize.height > 64)
    {
        sResult.height = 128;
    }
    
    return sResult;
}


- (GLubyte *)createTextureDataWithImage:(UIImage *)aImage textureSize:(CGSize)aTextureSize
{
    CGSize       sImageSize   = [aImage size];
    CGRect       sDrawRect    = CGRectMake((NSInteger)(aTextureSize.width - sImageSize.width) / 2,
                                           (NSInteger)(aTextureSize.height - sImageSize.height) / 2,
                                           sImageSize.width,
                                           sImageSize.height);
    GLubyte     *sData;
    CGContextRef sContext;
    
    sData = (GLubyte *)malloc(aTextureSize.width * aTextureSize.height * 4);
    memset(sData, 0, aTextureSize.width * aTextureSize.height * 4);
    
    sContext = CGBitmapContextCreate(sData,
                                     aTextureSize.width,
                                     aTextureSize.height,
                                     8,
                                     aTextureSize.width * 4,
                                     CGImageGetColorSpace([aImage CGImage]),
                                     kCGImageAlphaPremultipliedLast);
    
    CGContextTranslateCTM(sContext, 0, aTextureSize.height);
    CGContextScaleCTM(sContext, 1.0, -1.0);
    
    CGContextClearRect(sContext, CGRectMake(0, 0, aTextureSize.width, aTextureSize.height));
    
    CGContextDrawImage(sContext, sDrawRect, [aImage CGImage]);

//    CGContextSetStrokeColorWithColor(sContext, [[UIColor redColor] CGColor]);
//    CGContextStrokeRect(sContext, sDrawRect);
    
    CGContextRelease(sContext);
    
    return sData;
}


- (void)loadTextures
{
    NSString         *sTextureName;
    TBTextureManager *sTextureMan;
    NSArray          *sTextureArray = [NSArray arrayWithObjects:kTexHeli00,
                                                                kTexHeli01,
                                                                kTexHeli02,
                                                                kTexHeli03,
                                                                kTexHeli04,
                                                                kTexHeli05,
                                                                kTexHeli06,
                                                                kTexHeli07,
                                                                kTexHeli08,
                                                                kTexGreen,
                                                                kTexAllyTank,
                                                                kTexAllyTankShoot,
                                                                kTexAllyTankExp00,
                                                                kTexAllyTankExp01,
                                                                kTexAllyTankExp02,
                                                                kTexEnemyTank,
                                                                kTexEnemyTankShoot,
                                                                kTexEnemyTankExp00,
                                                                kTexEnemyTankExp01,
                                                                kTexEnemyTankExp02,
                                                                kTexEnemySoldier00,
                                                                kTexEnemySoldier01,
                                                                kTexEnemySoldier02,
                                                                kTexEnemySoldier03,
                                                                kTexEnemySoldier04,
                                                                kTexEnemySoldier05,
                                                                kTexEnemySoldier06,
                                                                kTexBullet,
                                                                kTexBomb,
                                                                kTexMissile,
                                                                kTexBombExp00,
                                                                kTexBombExp01,
                                                                kTexBombExp02,
                                                                kTexBase00,
                                                                kTexBase01,
                                                                kTexBase02,
                                                                kTexBase03,
                                                                kTexBase04,
                                                                kTexBase05,
                                                                kTexBase06,
                                                                kTexBase07,
                                                                kTexLandingPad00,
                                                                kTexAAGun00,
                                                                kTexAAGun01,
                                                                kTexAAGun02,
                                                                kTexAAGun03,
                                                                kTexAAGun04,
                                                                kTexAAGunDestroyed,
                                                                kTexSAM,
                                                                kTexSAMShoot,
                                                                kTexRadarBackground,
                                                                kTexRadarObject,
                                                                kTexHeliLExp00,
                                                                kTexHeliLExp01,
                                                                kTexHeliLExp02,
                                                                kTexHeliRExp00,
                                                                kTexHeliRExp01,
                                                                kTexHeliRExp02,
                                                                kTexMissileExp00,
                                                                kTexMissileExp01,
                                                                kTexMissileExp02,
                                                                nil];
    
    if ([mTextureInfoDict count] == 0)
    {
        sTextureMan = [TBTextureManager sharedManager];
        for (sTextureName in sTextureArray)
        {
            [sTextureMan loadTextureWithName:sTextureName forKey:sTextureName];
        }
    }
}


- (void)loadTextureWithName:(NSString *)aName forKey:(NSString *)aKey
{
    const GLfloat sTexcoords[] = { 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 1.0, 1.0 };
    GLuint        sTextureID;
    UIImage      *sImage       = [UIImage imageNamed:aName];
    CGSize        sImageSize   = [sImage size];
    CGSize        sTextureSize = [self textureSizeWithImageSize:sImageSize];    
    GLubyte      *sData        = [self createTextureDataWithImage:sImage textureSize:sTextureSize];
    
    if (sData)
    {
        glTexCoordPointer(2, GL_FLOAT, 0, sTexcoords);
        glEnableClientState(GL_TEXTURE_COORD_ARRAY);
        
        glGenTextures(1, &sTextureID);
        glBindTexture(GL_TEXTURE_2D, sTextureID);
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, sTextureSize.width, sTextureSize.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, sData);
        
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        
        NSLog(@"loadTexture... [%02d] %@ : %p", sTextureID, aName, sData);
        
        free(sData);
        
        TBTextureInfo *sTextureInfo = [[[TBTextureInfo alloc] init] autorelease];
        [sTextureInfo setTextureID:sTextureID];
        [sTextureInfo setTextureSize:sTextureSize];
        [sTextureInfo setContentSize:sImageSize];
        [mTextureInfoDict setObject:sTextureInfo forKey:aKey];
    }
}


- (TBTextureInfo *)textureInfoForKey:(NSString *)aKey
{
    return [mTextureInfoDict objectForKey:aKey];
}


@end
