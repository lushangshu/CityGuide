//
//  LocalWeather.h
//  CityGuide
//
//  Created by lushangshu on 15-8-11.
//  Copyright (c) 2015年 lushangshu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalWeather : NSObject

@property (strong,nonatomic) NSString *w_main;
@property (nonatomic,strong) NSString *w_description;
@property (nonatomic,strong) NSString *w_temperature;
@property (nonatomic,strong) NSString *w_mintemp;
@property (nonatomic,strong) NSString *w_maxtemp;


@end
