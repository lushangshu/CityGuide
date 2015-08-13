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
#import "GenerateRouteViewController.h"
#import "RouteTabbar.h"

@implementation HomeViewController
@synthesize testString,userVenue;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.totalVenueList = [[NSMutableArray alloc]init];
    //[self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:43 green:164 blue:255 alpha:1]];
    [self.mySearch setText:@"Sheffield"];
    [self.mySearch setTintColor:[UIColor blackColor]];
    [self.mySearch setBackgroundColor:[UIColor colorWithRed:15 green:175 blue:255 alpha:0.5]];
    [self.loading startAnimating];
    //[self.view setUserInteractionEnabled:YES];
    self.tableV.tableHeaderView = self.myMapView;
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    
    self.mySearch.delegate = self;
    self.myMapView.delegate = self;
    
    //self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 503);
    [self searchBarSearchButtonClicked:self.mySearch];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationHandler2:) name:@"mynotification2" object:nil];
    
    [self.locationManager startUpdatingLocation];
    FSVenue *ve = [[FSVenue alloc]init];
    ve.location.coordinate = self.locationManager.location.coordinate;
    ve.name = @"user Location";
    ve.prefix = @"null";
    ve.suffix = @"null";
    ve.location.disTance = 0;
    ve.venueId = 0;
    
    self.userVenue = ve;
    [self showPlistFileCategories];

}
-(void)showPlistFileCategories
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"settings.plist"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        plistPath = [[NSBundle mainBundle] pathForResource:@"settings" ofType:@"plist"];
    }
    self.selectedCates = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    //self.selectedCateg = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSLog(@"$$$ %@",self.selectedCates);
    //NSLog(@"### %@",[dict objectForKey:@"name"]);
}

-(IBAction)RadioVenueData:(id)sender{
    NSString *a = @"";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_GetUserProfileSuccess" object: a userInfo:nil];
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
    
    NSString *category = [[NSString alloc]init];
    if ([self.selectedCates count]==0) {
        category = @" ";
        NSString *locat = [[lat stringByAppendingString:@","]stringByAppendingString:lon];
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:@"M0AY5MCIO3I5HKZAU35MC1E4WQIBIVUFVPSL2MY0TSRP5JTI" forKey:@"client_id"];
        [params setObject:@"O3DM3WRVRABPMTMWMMGXC4WDEHUUIGGIRHP1Y0PTUEW2WTK3" forKey:@"client_secret"];
        [params setObject:category forKey:@"query"];
        [params setObject:locat forKey:@"ll"];
        [params setObject:@"20140118" forKey:@"v"];
        [params setObject:@"30" forKey:@"limit"];
        [manager GET:@"https://api.foursquare.com/v2/venues/search" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //NSLog(@"JSON: %@", responseObject);
            NSDictionary *dic = responseObject;
            NSArray *venues = [dic valueForKeyPath:@"response.venues"];
            FSConverter *converter = [[FSConverter alloc]init];
            self.nearbyVenues = [converter convertToObjects:venues];
            
            [self.tableV reloadData];
            [self MapProccessAnnotations];
            [self.locationManager stopUpdatingLocation];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
    else{
        for (int i=0; i<[[self.selectedCates allKeys] count]; i++) {
            category = [[self.selectedCates allKeys] objectAtIndex:i];
            NSString *locat = [[lat stringByAppendingString:@","]stringByAppendingString:lon];
            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            [params setObject:@"M0AY5MCIO3I5HKZAU35MC1E4WQIBIVUFVPSL2MY0TSRP5JTI" forKey:@"client_id"];
            [params setObject:@"O3DM3WRVRABPMTMWMMGXC4WDEHUUIGGIRHP1Y0PTUEW2WTK3" forKey:@"client_secret"];
            [params setObject:category forKey:@"query"];
            [params setObject:locat forKey:@"ll"];
            [params setObject:@"20140118" forKey:@"v"];
            [params setObject:@"10" forKey:@"limit"];
            [manager GET:@"https://api.foursquare.com/v2/venues/search" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //NSLog(@"JSON: %@", responseObject);
                NSDictionary *dic = responseObject;
                NSArray *venues = [dic valueForKeyPath:@"response.venues"];
                FSConverter *converter = [[FSConverter alloc]init];
                self.nearbyVenues = [converter convertToObjects:venues];
                [self.totalVenueList addObjectsFromArray:self.nearbyVenues];
//                self.nearbyVenues = [self.totalVenueList copy];
                self.nearbyVenues =[[NSSet setWithArray:self.totalVenueList] allObjects];
                for (int i=0; i<[self.nearbyVenues count]; i++) {
                    NSLog(@"venues are %@",[[self.nearbyVenues objectAtIndex:i]name]);
                }
                [self.tableV reloadData];
                [self MapProccessAnnotations];
                [self.locationManager stopUpdatingLocation];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
            }];
        }
        
    }
}

+(id)sharedManager
{
    static HomeViewController *sharedHomeVC = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        sharedHomeVC = [self new];
    });
    return sharedHomeVC;
}
-(id)init{
    if (self = [super init]) {
        testString = @"hello test singleton";
    }
    return self;
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
    
    [self.myMapView showsUserLocation];
    [self.locationManager stopUpdatingLocation];
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
    [mapView setRegion:MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.03f, 0.03f)) animated:YES];
    
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

    if (annotation == mapView.userLocation)
        return nil;
    
    static NSString *s = @"ann";
    MKAnnotationView *pin = [mapView dequeueReusableAnnotationViewWithIdentifier:s];
    if (!pin) {
        pin = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:s];
        pin.canShowCallout = YES;
        pin.image = [UIImage imageNamed:@"pin1.png"];
        pin.calloutOffset = CGPointMake(0, 0);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        pin.rightCalloutAccessoryView = button;
        
    }
    return pin;

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
    NSString *venueImg = [[venue.prefix stringByAppendingString:@"bg_32"] stringByAppendingString: venue.suffix];
    [self downloadImageWithURL:[NSURL URLWithString:venueImg] completionBlock:^(BOOL succeeded, UIImage *image) {
        if (succeeded) {
            // change the image in the cell
            cell.icon.image = image;
        }
    }];
    if (venue.location.address) {
        [cell.venueAddress setText: [NSString stringWithFormat:@"%@m, %@",
                                     venue.location.disTance,
                                     venue.location.address]];
    } else {
        [cell.venueAddress setText: [NSString stringWithFormat:@"%@m",
                                     venue.location.disTance]];
    }
    return cell;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"VenueDetailSeg"]) {
        NSIndexPath *indexPath = [self.tableV indexPathForSelectedRow];
        FSVenueViewController *venuViewController = segue.destinationViewController;
        FSVenue *venue = self.nearbyVenues[indexPath.row];
        venuViewController.venueName = venue.name;
        venuViewController.venue = venue;
    }
    else if([segue.identifier isEqualToString:@"VenueArraySeg"]){
        GenerateRouteViewController *grv = segue.destinationViewController;
        grv.venueArray = self.nearbyVenues;
        grv.UserCurrentLocation = self.locationManager.location;
        grv.userVenue = self.userVenue;
       //NSLog(@"@@@@@ %@,%f",self.userVenue.name,self.userVenue.location.coordinate.latitude);
        
    }
}

#pragma mark - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

//- (BOOL)slideNavigationControllerShouldDisplayRightMenu
//{
//    return YES;
//}



@end