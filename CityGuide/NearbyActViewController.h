//
//  NearbyActViewController.h
//  CityGuide
//
//  Created by lushangshu on 15-7-3.
//  Copyright (c) 2015年 lushangshu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"

@interface NearbyActViewController : UIViewController <UITableViewDataSource,SlideNavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
