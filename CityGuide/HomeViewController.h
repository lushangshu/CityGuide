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

@property (nonatomic, strong) IBOutlet UISwitch *limitPanGestureSwitch;
@property (nonatomic, strong) IBOutlet UISwitch *slideOutAnimationSwitch;
@property (nonatomic, strong) IBOutlet UISwitch *shadowSwitch;
@property (nonatomic, strong) IBOutlet UISwitch *panGestureSwitch;
@property (nonatomic, strong) IBOutlet UISegmentedControl *portraitSlideOffsetSegment;
@property (nonatomic, strong) IBOutlet UISegmentedControl *landscapeSlideOffsetSegment;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

@property (strong,nonatomic) IBOutlet UISearchBar *mySearch;
@property (strong,nonatomic) IBOutlet MKMapView *myMapView;

- (IBAction)bounceMenu:(id)sender;
- (IBAction)slideOutAnimationSwitchChanged:(id)sender;
- (IBAction)limitPanGestureSwitchChanged:(id)sender;
- (IBAction)changeAnimationSelected:(id)sender;
- (IBAction)shadowSwitchSelected:(id)sender;
- (IBAction)enablePanGestureSelected:(id)sender;
- (IBAction)portraitSlideOffsetChanged:(id)sender;
- (IBAction)landscapeSlideOffsetChanged:(id)sender;

@end
