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
#import "FSVenue.h"


@interface GenerateRouteViewController : UIViewController <MKMapViewDelegate,CLLocationManagerDelegate>
@property (strong,nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UITableView *routeTable;

@property (strong,nonatomic) IBOutlet UIView *map_View;
@property (strong,nonatomic) IBOutlet UIView *route_View;
@property (strong,nonatomic) IBOutlet UISegmentedControl *segment;


@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@property (strong,nonatomic) IBOutlet UIView *searchSubV;
@property (strong,nonatomic) IBOutlet UISearchBar *dep;
@property (strong,nonatomic) IBOutlet UISearchBar *arr;
@property (strong,nonatomic) IBOutlet UIButton *search;

@property (strong,nonatomic) NSArray *venueArray;
@property (strong,nonatomic) CLLocation *UserCurrentLocation;
@property (strong,nonatomic) FSVenue *userVenue;

@property (strong,nonatomic) __block NSMutableArray *responseRoute;

-(IBAction)GenerateRoute;
-(IBAction)segmentValueChanged:(id)sender;
-(IBAction)ReloadRoute:(id)sender;
@end
