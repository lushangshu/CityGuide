//
//  MapViewController.h
//  CityGuide
//
//  Created by lushangshu on 15-6-30.
//  Copyright (c) 2015年 lushangshu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController :UIViewController <UISearchBarDelegate, MKMapViewDelegate>

@property (strong,nonatomic) IBOutlet UISearchBar *mySearch;
@property (strong,nonatomic) IBOutlet MKMapView *myMapView;
@end
