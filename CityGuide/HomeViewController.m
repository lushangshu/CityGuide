//
//  HomeViewController.m
//  CityGuide
//
//  Created by lushangshu on 15-7-16.
//  Copyright (c) 2015年 lushangshu. All rights reserved.
//

#import "HomeViewController.h"
#import "LeftMenuViewController.h"

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mySearch.delegate = self;
    self.myMapView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 503);
    self.portraitSlideOffsetSegment.selectedSegmentIndex = [self indexFromPixels:[SlideNavigationController sharedInstance].portraitSlideOffset];
    self.landscapeSlideOffsetSegment.selectedSegmentIndex = [self indexFromPixels:[SlideNavigationController sharedInstance].landscapeSlideOffset];
    self.panGestureSwitch.on = [SlideNavigationController sharedInstance].enableSwipeGesture;
    self.shadowSwitch.on = [SlideNavigationController sharedInstance].enableShadow;
    self.limitPanGestureSwitch.on = ([SlideNavigationController sharedInstance].panGestureSideOffset == 0) ? NO : YES;
    self.slideOutAnimationSwitch.on = ((LeftMenuViewController *)[SlideNavigationController sharedInstance].leftMenu).slideOutAnimationEnabled;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.mySearch resignFirstResponder];
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder geocodeAddressString:self.mySearch.text
                 completionHandler:^(NSArray *placemarks, NSError *error) {
                     CLPlacemark *placemark = [placemarks objectAtIndex:0];
                     
                     MKCoordinateRegion region;
                     CLLocationCoordinate2D newLocation = [placemark.location coordinate];
                     region.center = [(CLCircularRegion *)placemark.region center];
                     
                     MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
                     [annotation setCoordinate:newLocation];
                     [annotation setTitle:self.mySearch.text];
                     [self.myMapView addAnnotation:annotation];
                     
                     MKMapRect mr = [self.myMapView visibleMapRect];
                     MKMapPoint pt=MKMapPointForCoordinate([annotation coordinate]);
                     mr.origin.x = pt.x - mr.size.width*0.5;
                     mr.origin.y = pt.y - mr.size.height*0.25;
                     [self.myMapView setVisibleMapRect:mr animated:YES];
                     
                 }];
}


#pragma mark - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

- (BOOL)slideNavigationControllerShouldDisplayRightMenu
{
    return YES;
}

#pragma mark - IBActions -

- (IBAction)bounceMenu:(id)sender
{
    static Menu menu = MenuLeft;
    
    [[SlideNavigationController sharedInstance] bounceMenu:menu withCompletion:nil];
    
    menu = (menu == MenuLeft) ? MenuRight : MenuLeft;
}

- (IBAction)slideOutAnimationSwitchChanged:(UISwitch *)sender
{
    ((LeftMenuViewController *)[SlideNavigationController sharedInstance].leftMenu).slideOutAnimationEnabled = sender.isOn;
}

- (IBAction)limitPanGestureSwitchChanged:(UISwitch *)sender
{
    [SlideNavigationController sharedInstance].panGestureSideOffset = (sender.isOn) ? 50 : 0;
}

- (IBAction)changeAnimationSelected:(id)sender
{
    [[SlideNavigationController sharedInstance] openMenu:MenuRight withCompletion:nil];
}

- (IBAction)shadowSwitchSelected:(UISwitch *)sender
{
    [SlideNavigationController sharedInstance].enableShadow = sender.isOn;
}

- (IBAction)enablePanGestureSelected:(UISwitch *)sender
{
    [SlideNavigationController sharedInstance].enableSwipeGesture = sender.isOn;
}

- (IBAction)portraitSlideOffsetChanged:(UISegmentedControl *)sender
{
    [SlideNavigationController sharedInstance].portraitSlideOffset = [self pixelsFromIndex:sender.selectedSegmentIndex];
}

- (IBAction)landscapeSlideOffsetChanged:(UISegmentedControl *)sender
{
    [SlideNavigationController sharedInstance].landscapeSlideOffset = [self pixelsFromIndex:sender.selectedSegmentIndex];
}

#pragma mark - Helpers -

- (NSInteger)indexFromPixels:(NSInteger)pixels
{
    if (pixels == 60)
        return 0;
    else if (pixels == 120)
        return 1;
    else
        return 2;
}

- (NSInteger)pixelsFromIndex:(NSInteger)index
{
    switch (index)
    {
        case 0:
            return 60;
            
        case 1:
            return 120;
            
        case 2:
            return 200;
            
        default:
            return 0;
    }
}

@end