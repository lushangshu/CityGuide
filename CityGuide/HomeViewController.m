//
//  HomeViewController.m
//  CityGuide
//
//  Created by lushangshu on 15-7-16.
//  Copyright (c) 2015年 lushangshu. All rights reserved.
//

#import "HomeViewController.h"
#import "LeftMenuViewController.h"
#import "JPSThumbnailAnnotation.h"

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mySearch.delegate = self;
    self.myMapView.delegate = self;
    [self.myMapView setShowsUserLocation:YES];
    //self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 503);
    [self searchBarSearchButtonClicked:self.mySearch];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationHandler2:) name:@"mynotification2" object:nil];
}

-(void) notificationHandler2:(NSNotification *) notification2{
    
    NSDictionary *dict = [notification2 object];
    NSLog(@"!!!!! receive dict :%@,",dict);
    NSMutableArray *annot = [self generateAnnotations:dict];
    [self.myMapView addAnnotations:annot];
    
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
                     // add functions
                     JPSThumbnail *empire = [[JPSThumbnail alloc] init];
                     empire.image = [UIImage imageNamed:@"1.png"];
                     empire.title = self.mySearch.text;
                     empire.subtitle = @"Information required";
//                     empire.coordinate = CLLocationCoordinate2DMake(53.38, -1.46);
                     empire.coordinate = newLocation;
                     empire.disclosureBlock = ^{ NSLog(@"selected Empire"); };
                     
                     //added end

                     //[self.myMapView addAnnotation:annotation];
                     [self.myMapView addAnnotation:[[JPSThumbnailAnnotation alloc]initWithThumbnail:empire]];
                     MKMapRect mr = [self.myMapView visibleMapRect];
                     MKMapPoint pt=MKMapPointForCoordinate([annotation coordinate]);
                     mr.origin.x = pt.x - mr.size.width*0.5;
                     mr.origin.y = pt.y - mr.size.height*0.25;
                     [self.myMapView setVisibleMapRect:mr animated:YES];
                     
                 }];
}
- (NSMutableArray *)generateAnnotations: (NSMutableArray *)dic {
    NSMutableArray *annotations = [[NSMutableArray alloc] initWithCapacity:[dic count]];
    
    for (int i=0; i<[dic count]; i++) {
        NSArray *obj = [dic objectAtIndex:i];
        
        JPSThumbnail *empire = [[JPSThumbnail alloc] init];
        empire.image = [UIImage imageNamed:@"1.png"];
        empire.title = obj[0];
        empire.subtitle = obj[1];
        NSString *lati = obj[2];
        NSString *lon = obj[3];
        empire.coordinate = CLLocationCoordinate2DMake([lati doubleValue],[lon doubleValue]);
        empire.disclosureBlock = ^{ NSLog(@"selected %@",obj[0]); };
        
        [annotations addObject:[[JPSThumbnailAnnotation alloc] initWithThumbnail:empire]];
    }
    
//    // Empire State Building
//    JPSThumbnail *empire = [[JPSThumbnail alloc] init];
//    empire.image = [UIImage imageNamed:@"empire.jpg"];
//    empire.title = @"Empire State Building";
//    empire.subtitle = @"NYC Landmark";
//    empire.coordinate = CLLocationCoordinate2DMake(53.38, -1.46);
//    empire.disclosureBlock = ^{ NSLog(@"selected Empire"); };
//    
//    [annotations addObject:[[JPSThumbnailAnnotation alloc] initWithThumbnail:empire]];
//    
//    // Apple HQ
//    JPSThumbnail *apple = [[JPSThumbnail alloc] init];
//    apple.image = [UIImage imageNamed:@"apple.jpg"];
//    apple.title = @"Apple HQ";
//    apple.subtitle = @"Apple Headquarters";
//    apple.coordinate = CLLocationCoordinate2DMake(53.38, -1.47);
//    apple.disclosureBlock = ^{ NSLog(@"selected Appple"); };
//    
//    [annotations addObject:[[JPSThumbnailAnnotation alloc] initWithThumbnail:apple]];
//    
//    // Parliament of Canada
//    JPSThumbnail *ottawa = [[JPSThumbnail alloc] init];
//    ottawa.image = [UIImage imageNamed:@"ottawa.jpg"];
//    ottawa.title = @"Parliament of Canada";
//    ottawa.subtitle = @"Oh Canada!";
//    ottawa.coordinate = CLLocationCoordinate2DMake(53.39, -1.48);
//    ottawa.disclosureBlock = ^{ NSLog(@"selected Ottawa"); };
    
//    [annotations addObject:[[JPSThumbnailAnnotation alloc] initWithThumbnail:ottawa]];
    
    return annotations;
}

#pragma mark - MKMapViewDelegate

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    [mapView setRegion:MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.1f, 0.1f)) animated:YES];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if ([view conformsToProtocol:@protocol(JPSThumbnailAnnotationViewProtocol)]) {
        [((NSObject<JPSThumbnailAnnotationViewProtocol> *)view) didSelectAnnotationViewInMap:mapView];
    }
}

//- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
//    if ([view conformsToProtocol:@protocol(JPSThumbnailAnnotationViewProtocol)]) {
//        [((NSObject<JPSThumbnailAnnotationViewProtocol> *)view) didDeselectAnnotationViewInMap:mapView];
//    }
//}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation conformsToProtocol:@protocol(JPSThumbnailAnnotationProtocol)]) {
        return [((NSObject<JPSThumbnailAnnotationProtocol> *)annotation) annotationViewInMap:mapView];
    }
    return nil;
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



@end