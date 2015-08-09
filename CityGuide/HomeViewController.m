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
#import "FSVenueViewController.h"
#import "AFNetworking.h"
#import "FSVenue.h"
#import "FSConverter.h"
#import "FSMainMapCell.h"

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableV.tableHeaderView = self.myMapView;
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    
    self.mySearch.delegate = self;
    self.myMapView.delegate = self;
    [self.myMapView setShowsUserLocation:YES];
    
    //self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 503);
    [self searchBarSearchButtonClicked:self.mySearch];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationHandler2:) name:@"mynotification2" object:nil];
    [self.locationManager startUpdatingLocation];
}

-(void) notificationHandler2:(NSNotification *) notification2{
    
    NSDictionary *dict = [notification2 object];
//    NSLog(@"!!!!! receive dict :%@,",dict);
    NSMutableArray *annot = [self generateAnnotations:dict];
    [self.myMapView addAnnotations:annot];
}

- (void)removeAllAnnotationExceptOfCurrentUser {
    NSMutableArray *annForRemove = [[NSMutableArray alloc] initWithArray:self.myMapView.annotations];
    if ([self.myMapView.annotations.lastObject isKindOfClass:[MKUserLocation class]]) {
        [annForRemove removeObject:self.myMapView.annotations.lastObject];
    } else {
        for (id <MKAnnotation> annot_ in self.myMapView.annotations) {
            if ([annot_ isKindOfClass:[MKUserLocation class]] ) {
                [annForRemove removeObject:annot_];
                break;
            }
        }
    }
    
    [self.myMapView removeAnnotations:annForRemove];
}

- (void)MapProccessAnnotations {
    [self removeAllAnnotationExceptOfCurrentUser];
    [self.myMapView addAnnotations:self.nearbyVenues];
}

-(void) fetching : (CLLocation *)location{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *lat = [NSString stringWithFormat:@"%f",location.coordinate.latitude ];
    NSString *lon = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
    
    NSString *locat = [[lat stringByAppendingString:@","]stringByAppendingString:lon];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"M0AY5MCIO3I5HKZAU35MC1E4WQIBIVUFVPSL2MY0TSRP5JTI" forKey:@"client_id"];
    [params setObject:@"O3DM3WRVRABPMTMWMMGXC4WDEHUUIGGIRHP1Y0PTUEW2WTK3" forKey:@"client_secret"];
    [params setObject:@" " forKey:@"query"];
    [params setObject:locat forKey:@"ll"];
    [params setObject:@"20140118" forKey:@"v"];
    [params setObject:@"30" forKey:@"limit"];
    
    [manager GET:@"https://api.foursquare.com/v2/venues/search" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        NSDictionary *dic = responseObject;
        NSArray *venues = [dic valueForKeyPath:@"response.venues"];
        FSConverter *converter = [[FSConverter alloc]init];
        self.nearbyVenues = [converter convertToObjects:venues];
        for (int i=0; i<[self.nearbyVenues count]; i++) {
            FSVenue *v =self.nearbyVenues[i];
            //NSLog(@"address is +++ %@",v.location.address);
        }
        [self.tableV reloadData];
        [self MapProccessAnnotations ];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
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
- (NSMutableArray *)generateAnnotations: (NSMutableArray *)dic {
    NSMutableArray *annotations = [[NSMutableArray alloc] initWithCapacity:[dic count]];
    
    for (int i=0; i<[dic count]; i++) {
        NSArray *obj = [dic objectAtIndex:i];
        
        JPSThumbnail *empire = [[JPSThumbnail alloc] init];
        //empire.image = [UIImage imageNamed:@"1.png"];
        empire.title = obj[0];
        empire.subtitle = obj[1];
        NSString *lati = obj[2];
        NSString *lon = obj[3];
        empire.coordinate = CLLocationCoordinate2DMake([lati doubleValue],[lon doubleValue]);
        empire.disclosureBlock = ^{ NSLog(@"selected %@",obj[0]); };
        
        [annotations addObject:[[JPSThumbnailAnnotation alloc] initWithThumbnail:empire]];
    }
    
    return annotations;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)backToLocation:(id)sender
{
    //[self.myMapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    [self.myMapView setCenterCoordinate:self.locationManager.location.coordinate animated:YES];
    [self.tableV setContentOffset:CGPointZero animated:YES];
}
#pragma mark -cllocation delegate
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    [self.locationManager stopUpdatingLocation];
    [self fetching:newLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    NSLog(@"Location manager did fail with error %@", error);
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [manager startUpdatingLocation];
    }
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

- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.nearbyVenues.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.nearbyVenues.count) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    FSMainMapCell *cell = [self.tableV dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    FSVenue *venue = self.nearbyVenues[indexPath.row];
    [cell.venuName setText:[venue name]];
    NSString *venueImg = [venue.prefix stringByAppendingString:venue.suffix];
    cell.imageView.image = [UIImage imageNamed:@"0.png"];
    [self downloadImageWithURL:[NSURL URLWithString:venueImg] completionBlock:^(BOOL succeeded, UIImage *image) {
        if (succeeded) {
            // change the image in the cell
            cell.icon.image = image;
        }
    }];
    if (venue.location.address) {
        [cell.venueAddress setText: [NSString stringWithFormat:@"%@m, %@",
                                     venue.location.distance,
                                     venue.location.address]];
    } else {
        [cell.venueAddress setText: [NSString stringWithFormat:@"%@m",
                                     venue.location.distance]];
    }
    return cell;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"VenueDetailSeg"]) {
        NSIndexPath *indexPath = [self.tableV indexPathForSelectedRow];
        FSVenueViewController *venuViewController = segue.destinationViewController;
        FSVenue *venue = self.nearbyVenues[indexPath.row];
        venuViewController.venueName = venue.name;
    }
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