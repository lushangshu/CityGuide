//
//  FSVenueDetail.h
//  CityGuide
//
//  Created by lushangshu on 15-8-12.
//  Copyright (c) 2015年 lushangshu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSVenueDetail : NSObject

@property (nonatomic,strong) NSArray *formattedAddress;
@property (nonatomic,strong) NSString *canonicalUrl;
@property (nonatomic,strong) NSString *rating;
@property (nonatomic,strong) NSString *phone;
@end
