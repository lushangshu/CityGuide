//
//  CityDetailWebViewController.m
//  CityGuide
//
//  Created by lushangshu on 15-8-9.
//  Copyright (c) 2015年 lushangshu. All rights reserved.
//

#import "CityDetailWebViewController.h"

@interface CityDetailWebViewController ()

@end

@implementation CityDetailWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationHandlerURL) name:@"mynotification" object:nil];
    
    
    
}

-(void) notificationHandlerURL:(NSNotification *) notification2{
    //NSDictionary *dict = [notification2 object];
    NSURL *url = [notification2 object];
    NSLog(@"object is %@",[notification2 object]);
    NSLog(@"url is %@",url);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.web loadRequest:request];
}

-(void) notificationHandler:(NSNotification *) notification{
    
   NSString *url = [notification object];
    NSLog(@"url is %@",url);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
