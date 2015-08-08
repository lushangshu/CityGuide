//
//  ActivityViewController.h
//  CityGuide
//
//  Created by lushangshu on 15-8-7.
//  Copyright (c) 2015年 lushangshu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "SlideNavigationController.h"

@interface ActivityViewController : UIViewController <SlideNavigationControllerDelegate,CLLocationManagerDelegate>


@property (nonatomic,strong) IBOutlet UICollectionView *collections;
@property (nonatomic,strong) IBOutlet UITableView *tableVi;
@property (nonatomic,strong) IBOutlet UITextField *textFFF;

@property (nonatomic,strong) NSArray *array;

@property (nonatomic,strong) NSString *cityName;
@property (nonatomic,strong) NSString *lat;
@property (nonatomic,strong) NSString *lont;
@end
