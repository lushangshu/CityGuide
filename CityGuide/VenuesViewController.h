//
//  VenuesViewController.h
//  CityGuide
//
//  Created by lushangshu on 15-7-29.
//  Copyright (c) 2015年 lushangshu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VenuesViewController : UIViewController


@property (nonatomic) NSMutableArray *res;
@property (strong, nonatomic) NSArray *nearbyVenues;
@property (nonatomic,strong) IBOutlet UITableView *tableV;

@end
