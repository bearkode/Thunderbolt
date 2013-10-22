/*
 *  TBAmmoView.m
 *  Thunderbolt
 *
 *  Created by cgkim on 13. 10. 22..
 *  Copyright (c) 2013 Tinybean. All rights reserved.
 *
 */

#import "TBAmmoView.h"


@implementation TBAmmoView
{
    UILabel *mBulletLabel;
    UILabel *mBombLabel;
}


- (id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, 100, 50)];
    
    if (self)
    {
        UIFont *sFont = [UIFont fontWithName:@"LetsgoDigital-Regular" size:20];

        [self setBackgroundColor:[UIColor clearColor]];
        
        UIImageView *sBulletIconView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gatling_gun_ico"]] autorelease];
        UIImageView *sBombIconView   = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bomb_ico"]] autorelease];
        
        [sBulletIconView setAlpha:0.5];
        [sBombIconView setAlpha:0.5];
        [sBulletIconView setFrame:CGRectMake(0, 0, 20, 20)];
        [sBombIconView setFrame:CGRectMake(0, 22, 20, 20)];
        
        [self addSubview:sBulletIconView];
        [self addSubview:sBombIconView];
        
        mBulletLabel = [[[UILabel alloc] initWithFrame:CGRectMake(22, 0, 70, 20)] autorelease];
        [mBulletLabel setBackgroundColor:[UIColor clearColor]];
        [mBulletLabel setTextColor:[UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.5]];
        [mBulletLabel setFont:sFont];
        [self addSubview:mBulletLabel];

        mBombLabel = [[[UILabel alloc] initWithFrame:CGRectMake(22, 22, 70, 20)] autorelease];
        [mBombLabel setBackgroundColor:[UIColor clearColor]];
        [mBombLabel setTextColor:[UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.5]];
        [mBombLabel setFont:sFont];
        [self addSubview:mBombLabel];
    }
    
    return self;
}


- (void)dealloc
{
    [super dealloc];
}


- (void)setBulletCount:(NSInteger)aBulletCount
{
    [mBulletLabel setText:[NSString stringWithFormat:@": %d", aBulletCount]];
}


- (void)setBombCount:(NSInteger)aBombCount
{
    [mBombLabel setText:[NSString stringWithFormat:@": %d", aBombCount]];
}


@end
