//
//  MapShopsViewController.m
//  CityGuide
//
//  Created by lushangshu on 15-7-15.
//  Copyright (c) 2015年 lushangshu. All rights reserved.
//

#import "MapShopsViewController.h"
#import "JPSThumbnailAnnotation.h"

@interface MapShopsViewController ()

@end

@implementation MapShopsViewController

- (void)viewDidLoad {
    // Map View
    MKMapView *mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    CLLocationCoordinate2D noLocation;
    MKCoordinateRegion viewRegion;
    viewRegion.center.latitude = 53.38;
    viewRegion.center.longitude = -1.46;
    viewRegion.span.latitudeDelta = 0.112872;
    viewRegion.span.longitudeDelta = 0.109863;
    //= MKCoordinateRegionMakeWithDistance(noLocation, 500, 500);
    MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
    [mapView setRegion:adjustedRegion animated:YES];
    mapView.showsUserLocation = YES;
    mapView.delegate = self;
    [self.view addSubview:mapView];
    
    // Annotations
    [mapView addAnnotations:[self generateAnnotations]];

}

- (NSArray *)generateAnnotations {
    NSMutableArray *annotations = [[NSMutableArray alloc] initWithCapacity:3];
    
    // Empire State Building
    JPSThumbnail *empire = [[JPSThumbnail alloc] init];
    empire.image = [UIImage imageNamed:@"empire.jpg"];
    empire.title = @"Empire State Building";
    empire.subtitle = @"NYC Landmark";
    empire.coordinate = CLLocationCoordinate2DMake(53.38, -1.46);
    empire.disclosureBlock = ^{ NSLog(@"selected Empire"); };
    
    [annotations addObject:[[JPSThumbnailAnnotation alloc] initWithThumbnail:empire]];
    
    // Apple HQ
    JPSThumbnail *apple = [[JPSThumbnail alloc] init];
    apple.image = [UIImage imageNamed:@"apple.jpg"];
    apple.title = @"Apple HQ";
    apple.subtitle = @"Apple Headquarters";
    apple.coordinate = CLLocationCoordinate2DMake(53.38, -1.47);
    apple.disclosureBlock = ^{ NSLog(@"selected Appple"); };
    
    [annotations addObject:[[JPSThumbnailAnnotation alloc] initWithThumbnail:apple]];
    
    // Parliament of Canada
    JPSThumbnail *ottawa = [[JPSThumbnail alloc] init];
    ottawa.image = [UIImage imageNamed:@"ottawa.jpg"];
    ottawa.title = @"Parliament of Canada";
    ottawa.subtitle = @"Oh Canada!";
    ottawa.coordinate = CLLocationCoordinate2DMake(53.39, -1.48);
    ottawa.disclosureBlock = ^{ NSLog(@"selected Ottawa"); };
    
    [annotations addObject:[[JPSThumbnailAnnotation alloc] initWithThumbnail:ottawa]];
    
    return annotations;
}



#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if ([view conformsToProtocol:@protocol(JPSThumbnailAnnotationViewProtocol)]) {
        [((NSObject<JPSThumbnailAnnotationViewProtocol> *)view) didSelectAnnotationViewInMap:mapView];
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if ([view conformsToProtocol:@protocol(JPSThumbnailAnnotationViewProtocol)]) {
        [((NSObject<JPSThumbnailAnnotationViewProtocol> *)view) didDeselectAnnotationViewInMap:mapView];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation conformsToProtocol:@protocol(JPSThumbnailAnnotationProtocol)]) {
        return [((NSObject<JPSThumbnailAnnotationProtocol> *)annotation) annotationViewInMap:mapView];
    }
    return nil;
}

@end