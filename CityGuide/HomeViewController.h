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

@interface HomeViewController : UIViewController <UISearchBarDelegate, MKMapViewDelegate,SlideNavigationControllerDelegate>


@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (strong,nonatomic) IBOutlet UISearchBar *mySearch;
@property (strong,nonatomic) IBOutlet MKMapView *myMapView;

//- (IBAction)bounceMenu:(id)sender;
//- (IBAction)changeAnimationSelected:(id)sender;

@end
