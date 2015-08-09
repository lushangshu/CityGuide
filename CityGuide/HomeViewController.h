//
//  HomeViewController.h
//  CityGuide
//
//  Created by lushangshu on 15-7-16.
//  Copyright (c) 2015年 lushangshu. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"

@interface HomeViewController : UIViewController <UISearchBarDelegate, MKMapViewDelegate,CLLocationManagerDelegate,SlideNavigationControllerDelegate>


@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (strong,nonatomic) IBOutlet UISearchBar *mySearch;
@property (strong,nonatomic) IBOutlet MKMapView *myMapView;
@property (strong,nonatomic) CLLocationManager *locationManager;


@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loading;
@property (nonatomic) NSMutableArray *res;
@property (strong, nonatomic) NSArray *nearbyVenues;
@property (nonatomic,strong) IBOutlet UITableView *tableV;
@property (nonatomic,strong) IBOutlet UILabel *selectedVenus;

-(IBAction)backToLocation:(id)sender;

//- (IBAction)bounceMenu:(id)sender;
//- (IBAction)changeAnimationSelected:(id)sender;

@end
