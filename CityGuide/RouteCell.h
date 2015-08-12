//
//  RouteCell.h
//  CityGuide
//
//  Created by lushangshu on 15-8-12.
//  Copyright (c) 2015年 lushangshu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RouteCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *RoutName;
@property (weak, nonatomic) IBOutlet UILabel *RouteLength;

@end
