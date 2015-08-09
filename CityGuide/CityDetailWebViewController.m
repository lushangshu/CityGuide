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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationHandlerURL:) name:@"mynotification3" object:nil];
    
    NSString *urlStr= @"http://www.wikipedia.com/";
    NSURL *url = [NSURL URLWithString:urlStr];
    NSLog(@"url is %@",url);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.Forward setEnabled:NO];
    [self.Refresh setEnabled:NO];
    [self.web loadRequest:request];
}



-(void)notificationHandlerURL:(NSNotification *) mynotification3
{
    //NSDictionary *dict = [notification2 object];
    NSLog(@"notification handler start");
    NSString *urlStr= @"http://www.wikipedia.com/";
    NSURL *url = [NSURL URLWithString:urlStr];
    NSLog(@"url is %@",url);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.web loadRequest:request];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textField resignFirstResponder];
    
    return YES;
}
//- (void) textFieldDidEndEditing:(UITextField *)textField {
//    
//}

- (void) loadWebPageFromString:(NSString *)string {
    NSURL *url = [NSURL URLWithString:string];
    
    if ([string rangeOfString:@"."].location != NSNotFound) {
        if (!url.scheme) {
            url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", string]];
        }
    }
    
    // If the string does not seem to be a valid url, format it as a google search url
    if (!url.host) {
        NSString *googleSearch = [string stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.wikipedia.com/search?q=%@", googleSearch]];
    }
    
    self.textField.text = [url absoluteString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [self.web loadRequest:request];
    [self.Forward setEnabled:YES];
    [self.Refresh setEnabled:YES];
}



-(IBAction)RedirectToPage:(id)sender
{
   [self loadWebPageFromString:self.textField.text];
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
