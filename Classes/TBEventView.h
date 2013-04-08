/*
 *  TBEventView.h
 *  Thunderbolt
 *
 *  Created by bearkode on 13. 4. 8..
 *  Copyright (c) 2013 Tinybean. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@interface TBEventView : UIView


@property (nonatomic, assign) id delegate;


@end


@protocol TBEventViewDelegate <NSObject>

- (void)eventView:(TBEventView *)aEventView controlAltitude:(CGFloat)aAltitude speed:(CGFloat)aSpeed;

@end
