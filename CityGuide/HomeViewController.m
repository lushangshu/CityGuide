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
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 503);

    [self searchBarSearchButtonClicked:self.mySearch];
//    MKCoordinateRegion viewRegion;
//    viewRegion.center.latitude = 53.38;
//    viewRegion.center.longitude = -1.46;
//    viewRegion.span.latitudeDelta = 0.112872;
//    viewRegion.span.longitudeDelta = 0.109863;
//    //= MKCoordinateRegionMakeWithDistance(noLocation, 500, 500);
//    MKCoordinateRegion adjustedRegion = [self.myMapView regionThatFits:viewRegion];
//    [self.myMapView setRegion:adjustedRegion animated:YES];
//    self.myMapView.showsUserLocation = YES;
//    [self.myMapView addAnnotation:(id)[self generateAnnotations]];
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
                     empire.image = [UIImage imageNamed:@"empire.jpg"];
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
- (NSMutableArray *)generateAnnotations {
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