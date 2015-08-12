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
@property (nonatomic,weak) IBOutlet UILabel * label_w;
@property (weak, nonatomic) IBOutlet UILabel *label_temp;
@property (weak, nonatomic) IBOutlet UILabel *tempRange;

@property (weak, nonatomic) IBOutlet UILabel *label_description;
@property (strong, nonatomic) IBOutlet UIImageView *image_weather;

@property (nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSString *cityName;
@property (nonatomic,strong) IBOutlet UITextField *searchCity;

@property (nonatomic) NSMutableArray *placeList;

@property (strong,nonatomic) NSString *w_main;
@property (nonatomic,strong) NSString *w_description;
@property (nonatomic,strong) NSString *w_temperature;
@property (nonatomic,strong) NSString *w_mintemp;
@property (nonatomic,strong) NSString *w_maxtemp;

@end

