//
//  GenerateRouteViewController.h
//  CityGuide
//
//  Created by lushangshu on 15-7-29.
//  Copyright (c) 2015年 lushangshu. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>


@interface GenerateRouteViewController : UIViewController <MKMapViewDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;


@end
