//
//  IntroView.h
//  CityGuide
//
//  Created by lushangshu on 15-8-13.
//  Copyright (c) 2015年 lushangshu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IntroViewDelegate <NSObject>

-(void)onDoneButtonPressed;

@end
@interface IntroView : UIView
@property id<IntroViewDelegate> delegate;
@end
