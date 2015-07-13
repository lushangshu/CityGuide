//
//  MapViewController.m
//  CityGuide
//
//  Created by lushangshu on 15-6-30.
//  Copyright (c) 2015年 lushangshu. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>

@interface MapViewController ()

@end

@implementation MapViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mySearch.delegate = self;
    self.myMapView.delegate = self;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
