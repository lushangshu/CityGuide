//
//  ConfigurationViewController.h
//  CityGuide
//
//  Created by lushangshu on 15-7-16.
//  Copyright (c) 2015年 lushangshu. All rights reserved.
//

#import "ViewController.h"
#import "SlideNavigationController.h"
#import "IntroView.h"

@interface ConfigurationViewController : ViewController <SlideNavigationControllerDelegate,IntroViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *subview;

@end
