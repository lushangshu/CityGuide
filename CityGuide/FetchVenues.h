//
//  FetchVenues.h
//  CityGuide
//
//  Created by lushangshu on 15-8-9.
//  Copyright (c) 2015年 lushangshu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface FetchVenues : NSObject

@property (nonatomic,strong) NSArray * venues;

-(NSArray *)FetchVenues :(CLLocation *)location;

@end
