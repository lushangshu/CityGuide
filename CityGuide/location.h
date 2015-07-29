//
//  location.h
//  CityGuide
//
//  Created by lushangshu on 15-7-22.
//  Copyright (c) 2015年 lushangshu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface location : NSObject
@property(nonatomic, strong) NSString *url;
@property(nonatomic, strong) NSString *label;
@property(nonatomic, strong) NSString *lat;
@property(nonatomic, strong) NSString *lont;
@end
