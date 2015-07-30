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

@property (strong,nonatomic) IBOutlet UIView *searchSubV;
@property (strong,nonatomic) IBOutlet UISearchBar *dep;
@property (strong,nonatomic) IBOutlet UISearchBar *arr;
@property (strong,nonatomic) IBOutlet UIButton *search;

-(IBAction)GenerateRoute;

@end
