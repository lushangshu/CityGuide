//
//  RightMenuViewController.m
//  CityGuide
//
//  Created by lushangshu on 15-7-15.
//  Copyright (c) 2015年 lushangshu. All rights reserved.
//

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "RightMenuViewController.h"

@implementation RightMenuViewController

#pragma mark - UIViewController Methods -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.center = self.view.center;
    [self.view addSubview:loginButton];
    
    self.tableView.separatorColor = [UIColor lightGrayColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftMenu.jpg"]];
    self.tableView.backgroundView = imageView;
    
    self.view.layer.borderWidth = .6;
    self.view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self RequestFacebookEvents];
}

-(void)RequestFacebookEvents
{
//    NSDictionary *params = @{
//                             @"q": @"event",
//                             @"center":@"53.38,-1.46"
//                             };
//    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
//                                  initWithGraphPath:@"search?"
//                                  parameters:params
//                                  HTTPMethod:@"GET"];
//    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
//                                          id result,
//                                          NSError *error) {
//        if (error) {
//            NSLog(@"eror is %@",error.description);
//        }else{
//            NSLog(@"result is %@",result);
//        }
//    }];
//        NSDictionary *params = @{
//                                 @"fieldname": @"{id}",
//                                 };
//    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
//                                  initWithGraphPath:@"/me"
//                                  parameters:params
//                                  HTTPMethod:@"GET"];
//    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
//                                          id result,
//                                          NSError *error) {
//                if (error) {
//                    NSLog(@"eror is %@",error.description);
//                }else{
//                    NSLog(@"result is %@",result);
//                }    }];
}

#pragma mark - UITableView Delegate & Datasrouce -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 11;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 20)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rightMenuCell"];
    cell.textLabel.textAlignment = NSTextAlignmentRight;
    
    switch (indexPath.row)
    {
        case 0:
            cell.textLabel.text = @"Events From Local";
            break;
            
        case 1:
            cell.textLabel.text = @"Creamfields UK 2015 28 August - 30 August Daresbury · Buy Tickets";
            break;
            
        case 2:
            cell.textLabel.text = @"SLIP + SLIDE YORK 29 August at 10:00 SLIP + SLIDE YORK";
            break;
            
        case 3:
            cell.textLabel.text = @"Leeds Festival 2015 28 August - 30 August Leeds Festival · Buy Tickets";
            break;
            
        case 4:
            cell.textLabel.text = @"CITY SLIDE NOTTINGHAM Saturday at 00:00 Nottingham, United Kingdom";
            break;
            
        case 5:
            cell.textLabel.text = @"Cannon Hall Farm Food Festival 28 August - 31 August Cannon Hall Farm";
            break;
            
        case 6:
            cell.textLabel.text = @"Creamfields UK 2015 28 August - 30 August Daresbury · Buy Tickets";
            break;
            
        case 7:
            cell.textLabel.text = @"SLIP + SLIDE YORK 29 August at 10:00 SLIP + SLIDE YORK";
            break;
            
        case 8:
            cell.textLabel.text = @"Leeds Festival 2015 28 August - 30 August Leeds Festival · Buy Tickets";
            break;
            
        case 9:
            cell.textLabel.text = @"CITY SLIDE NOTTINGHAM Saturday at 00:00 Nottingham, United Kingdom";
            break;
            
        case 10:
            cell.textLabel.text = @"Cannon Hall Farm Food Festival 28 August - 31 August Cannon Hall Farm";
            break;

    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id <SlideNavigationContorllerAnimator> revealAnimator;
    
    switch (indexPath.row)
    {
        case 0:
            revealAnimator = nil;
            break;
            
        case 1:
            revealAnimator = [[SlideNavigationContorllerAnimatorSlide alloc] init];
            break;
            
        case 2:
            revealAnimator = [[SlideNavigationContorllerAnimatorFade alloc] init];
            break;
            
        case 3:
            revealAnimator = [[SlideNavigationContorllerAnimatorSlideAndFade alloc] initWithMaximumFadeAlpha:.8 fadeColor:[UIColor blackColor] andSlideMovement:100];
            break;
            
        case 4:
            revealAnimator = [[SlideNavigationContorllerAnimatorScale alloc] init];
            break;
            
        case 5:
            revealAnimator = [[SlideNavigationContorllerAnimatorScaleAndFade alloc] initWithMaximumFadeAlpha:.6 fadeColor:[UIColor blackColor] andMinimumScale:.8];
            break;
            
        default:
            return;
    }
    
    [[SlideNavigationController sharedInstance] closeMenuWithCompletion:^{
        [SlideNavigationController sharedInstance].menuRevealAnimator = revealAnimator;
    }];
}

@end