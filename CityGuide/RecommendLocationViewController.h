//
//  RecommendLocationViewController.h
//  CityGuide
//
//  Created by lushangshu on 15-7-29.
//  Copyright (c) 2015年 lushangshu. All rights reserved.
//

#import "ViewController.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RecommendLocationViewController : ViewController

@property (nonatomic,strong) IBOutlet UITableView *tView;
@end


@interface Location : NSObject
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *crossStreet;
@property (nonatomic, strong) NSString *postalCode;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSNumber *distance;
@property (nonatomic, strong) NSNumber *lat;
@property (nonatomic, strong) NSNumber *lng;
@end

@interface Stats : NSObject
@property (nonatomic, strong) NSNumber *checkins;
@property (nonatomic, strong) NSNumber *tips;
@property (nonatomic, strong) NSNumber *users;
@end


@interface Venue : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) Location *location;
@property (nonatomic, strong) Stats *stats;
@end

