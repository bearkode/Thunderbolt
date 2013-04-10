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

- (void)setControlMode:(BOOL)aFlag;

@end


#pragma mark -


@protocol TBEventViewDelegate <NSObject>


- (void)eventView:(TBEventView *)aEventView controlAltitude:(CGFloat)aAltitude speed:(CGFloat)aSpeed;

- (void)eventView:(TBEventView *)aEventView touchBegan:(CGPoint)aPoint;
- (void)eventView:(TBEventView *)aEventView touchCancelled:(CGPoint)aPoint;
- (void)eventView:(TBEventView *)aEventView touchMoved:(CGPoint)aPoint;
- (void)eventView:(TBEventView *)aEventView touchEnded:(CGPoint)aPoint;
- (void)eventView:(TBEventView *)aEventView touchTapCount:(NSInteger)aTabCount;


@end
