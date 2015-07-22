//
//  CityDetailViewController.h
//  CityGuide
//
//  Created by lushangshu on 15-7-16.
//  Copyright (c) 2015年 lushangshu. All rights reserved.
//

#import "ViewController.h"
#import "SlideNavigationController.h"


@interface CityDetailViewController : ViewController <SlideNavigationControllerDelegate>

@property (nonatomic) IBOutlet UILabel * label_c;
@property (nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSMutableArray *placeList;

@end

