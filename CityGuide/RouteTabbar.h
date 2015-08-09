//
//  RouteTabbar.h
//  CityGuide
//
//  Created by lushangshu on 15-8-9.
//  Copyright (c) 2015年 lushangshu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RouteTabbar : UITabBarController


@property (nonatomic,strong) NSArray *venueArray;
@property (nonatomic,strong) NSArray *passArray;

-(NSArray *)passData;
@end
