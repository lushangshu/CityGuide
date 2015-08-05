//
//  CityDetailViewController.h
//  CityGuide
//
//  Created by lushangshu on 15-7-16.
//  Copyright (c) 2015年 lushangshu. All rights reserved.
//

#import "ViewController.h"
#import "SlideNavigationController.h"
#import <MapKit/MapKit.h>


@interface CityDetailViewController : ViewController <SlideNavigationControllerDelegate>

@property (nonatomic,weak) IBOutlet UILabel * label_c;
@property (nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSString *cityName;
@property (nonatomic,strong) IBOutlet UITextField *searchCity;

@property (nonatomic) NSMutableArray *placeList;

@end

