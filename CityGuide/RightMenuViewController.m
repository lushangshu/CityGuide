//
//  RightMenuViewController.m
//  CityGuide
//
//  Created by lushangshu on 15-7-15.
//  Copyright (c) 2015年 lushangshu. All rights reserved.
//

#import "RightMenuViewController.h"

@implementation RightMenuViewController

#pragma mark - UIViewController Methods -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorColor = [UIColor lightGrayColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftMenu.jpg"]];
    self.tableView.backgroundView = imageView;
    
    self.view.layer.borderWidth = .6;
    self.view.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

#pragma mark - UITableView Delegate & Datasrouce -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
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
            cell.textLabel.text = @"Events 1";
            break;
            
        case 2:
            cell.textLabel.text = @"Events 2";
            break;
            
        case 3:
            cell.textLabel.text = @"Events 3";
            break;
            
        case 4:
            cell.textLabel.text = @"Events 4";
            break;
            
        case 5:
            cell.textLabel.text = @"Events 5";
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