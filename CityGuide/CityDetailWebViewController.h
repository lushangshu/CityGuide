//
//  CityDetailWebViewController.h
//  CityGuide
//
//  Created by lushangshu on 15-8-9.
//  Copyright (c) 2015年 lushangshu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityDetailWebViewController : UIViewController

@property (strong,nonatomic) IBOutlet UIWebView *web;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UIButton *Refresh;
@property (weak, nonatomic) IBOutlet UIButton *Forward;


-(IBAction)RedirectToPage:(id)sender;

@end
