//
//  GenerateRouteViewController.m
//  CityGuide
//
//  Created by lushangshu on 15-7-29.
//  Copyright (c) 2015年 lushangshu. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>
#import "RouteTabbar.h"
#import "GenerateRouteViewController.h"
#import "HomeViewController.h"
#import "AFNetworking.h"
#import "FSVenue.h"
#import "FSConverter.h"
#import "RouteCell.h"

@interface GenerateRouteViewController () <CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    float myLat,myLon;
    MKRoute *rout;
    
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    NSMutableArray *blockRoutes;
    
    unsigned long totalLength;
}

@end

@implementation GenerateRouteViewController

@synthesize map_View,route_View,venueArray,userVenue,responseRoute;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.responseRoute = [[NSMutableArray alloc]init];
    totalLength = 0;
     self.segment.hidden = NO;
    self.mapView.delegate=self;
    self.mapView.showsUserLocation=YES;
    [self.arr setText:@"Destination"];
    
    //to get the current location
    locationManager=[[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    
    float OSVer=[[[UIDevice currentDevice] systemVersion] floatValue];
    
    if (OSVer>=8) {
        [locationManager requestAlwaysAuthorization];
        if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            
            [locationManager requestWhenInUseAuthorization];
            
        }
    }
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserProfileSuccess:) name:@"Notification_GetUserProfileSuccess" object:nil];
    
    [locationManager startUpdatingLocation];
    
    //NSLog(@"%@",[[self.venueArray objectAtIndex:0]location]);

}

- (void) getUserProfileSuccess: (NSNotification*) aNotification
{
    NSString *b = [aNotification object];
    NSLog(@"!!@!@!@ test notification is sdfew %@",b);
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(IBAction)GenerateRoute{
    FSVenue *venueDeparture = [[FSVenue alloc]init];
   
    int i_1 = arc4random()%[self.venueArray count];
    int i_2 = arc4random()%[self.venueArray count];
    int i_3 = arc4random()%[self.venueArray count];
    int i_4 = arc4random()%[self.venueArray count];
    FSVenue *venueItem1 = [self.venueArray objectAtIndex:0];
    FSVenue *venueItem2 = [self.venueArray objectAtIndex:1];
    FSVenue *venueItem3 = [self.venueArray objectAtIndex:2];
    FSVenue *venueItem4 = [self.venueArray objectAtIndex:3];
    
    [self showLinesFromSourceLati:self.userVenue Long:venueItem1];
    [self showLinesFromSourceLati:venueItem1 Long:venueItem2];
    [self showLinesFromSourceLati:venueItem2 Long:venueItem3];
    
}

-(IBAction)ReloadRoute:(id)sender
{
    [self.routeTable reloadData];
}

-(IBAction)segmentValueChanged:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.segment.hidden = NO;
            self.map_View.hidden = NO;
            self.route_View.hidden = YES;
            break;
        case 1:
            self.segment.hidden = NO;
            self.map_View.hidden = YES;
            self.route_View.hidden = NO;
            break;
        default:
            break;
    }
}

#pragma mark - CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
    NSLog(@"Error: %@", error);
    NSLog(@"Failed to get location! :(");
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self.mapView showsUserLocation];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //NSLog(@"Location: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    if (currentLocation != nil) {
        //        self.latitude.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        //        self.longitude.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
    }
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            [self.dep setText:[NSString stringWithFormat:@"%@,%@",placemark.thoroughfare,placemark.subThoroughfare]];
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
    
    [self.locationManager stopUpdatingLocation];
    
}
-(void)routeWithMultipleDirections:(NSArray *)venueList
{
    [[venueList objectAtIndex:0] name];

}

- (void)showLinesFromSourceLati:(FSVenue *)deP Long:(FSVenue *)Arr
{
    
    //NSLog(@" ******** route from %@ to %@",deP.name,Arr.name);
    CLLocationCoordinate2D coordinateDe = deP.location.coordinate;
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:coordinateDe];
    [annotation setTitle:deP.name];
    [_mapView addAnnotation:annotation];
    
    //To zoom in to the source location
    CLLocationCoordinate2D startCoord = deP.location.coordinate;
    //    CLLocationCoordinate2D startCoord = CLLocationCoordinate2DMake(lat, Lon);
    MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:MKCoordinateRegionMakeWithDistance(startCoord, 2000, 2000)];
    [_mapView setRegion:adjustedRegion animated:YES];
    //Setting up Source point // start point
    MKPlacemark *source = [[MKPlacemark alloc]initWithCoordinate:deP.location.coordinate addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil]];
    MKMapItem *srcMapItem = [[MKMapItem alloc]initWithPlacemark:source];
    [srcMapItem setName:deP.name];
    // ------------------------------------------------- Set Destination Point
    //Setting the destination
    MKPlacemark *destination = [[MKPlacemark alloc]initWithCoordinate:Arr.location.coordinate addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil] ];
    MKMapItem *distMapItem = [[MKMapItem alloc]initWithPlacemark:destination];
    [distMapItem setName:Arr.name];
    
    //Place annotation for the destination
    CLLocationCoordinate2D coordinate1 = Arr.location.coordinate;
    MKPointAnnotation *annotation1 = [[MKPointAnnotation alloc] init];
    [annotation1 setCoordinate:coordinate1];
    [annotation1 setTitle:Arr.name];
    [_mapView addAnnotation:annotation1];
    
//    NSArray *annotas = [[NSArray alloc] initWithObjects:deP.name,Arr.name, nil];
//    [_mapView addAnnotations:annotas];
    
    //--------------------------------------------------- Get Direction
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc]init];
    [request setSource:srcMapItem];
    [request setDestination:distMapItem];
    request.requestsAlternateRoutes = YES;
    [request setTransportType:MKDirectionsTransportTypeWalking];
    MKDirections *direction = [[MKDirections alloc] initWithRequest:request];
//    NSLog(@"!!!!!self respongse route is %@",self.responseRoute);
    [direction calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (error) {
            NSLog(@"error happend %@",error);
        }
        NSArray *arrRoutes = [response routes];
        //NSLog(@"%@, arrRoutes Count is %lu",arrRoutes,(unsigned long)[arrRoutes count]);
        
        for (int i=0; i<[arrRoutes count]; i++) {
            rout = [arrRoutes objectAtIndex:i];
            MKPolyline *line = [rout polyline];
            [_mapView addOverlay:line];
            NSArray *steps = [rout steps];
            totalLength = totalLength + [rout distance];
            for (int j=0; j<[steps count]; j++) {
                NSString *str_in = [[steps objectAtIndex:j] instructions];
                double dist = [[steps objectAtIndex:j] distance];
                NSNumber *num = [NSNumber numberWithDouble:dist];
                NSString *str_di = [num stringValue];
                NSArray *routeB = [[NSArray alloc]initWithObjects:rout.name,str_in,str_di, nil];
                //NSLog(@"route B in for loop %@",routeB);
                [self.responseRoute addObject:routeB];
                //NSLog(@"interesting %@",self.responseRoute);
            }
        }
      //NSLog(@"interesting %@",self.responseRoute);
      [self.routeTable reloadData];
        
        NSString *routeLength = [[NSNumber numberWithUnsignedLong:totalLength] stringValue];
        NSString *routedescri = [[@"Route length is " stringByAppendingString:routeLength]stringByAppendingString:@" m"];
        [self.RouteTotalDescription setText:routedescri];
    }];
    
//    [direction calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
//        if (error) {
//            NSLog(@"Error:::%@",error);
//        }
//        NSLog(@"response = %@",response);
//        NSArray *arrRoutes = [response routes];
//        NSLog(@"%@, arrRoutes Count is %lu",arrRoutes,(unsigned long)[arrRoutes count]);
//        [arrRoutes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            rout = obj;
//            MKPolyline *line = [rout polyline];
//            [_mapView addOverlay:line];
//            //NSLog(@"Rout Name : %@",rout.name);
//            //NSLog(@"Total Distance (in Meters) :%f",rout.distance);
//            
//            NSArray *steps = [rout steps];
//            //NSLog(@"Total Steps : %lu",(unsigned long)[steps count]);
//            [steps enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
////                NSLog(@"Rout Instruction : %@",[obj instructions]);
////                NSLog(@"Rout Distance : %f",[obj distance]);
//                NSString *str_in = [obj instructions];
//                NSString *str_di = [NSString stringWithFormat:@"%f",[obj distance]];
//                NSArray *routeB = [[NSArray alloc]initWithObjects:str_in,str_di ,nil];
//                NSLog(@"%@",routeB);
//                //NSLog(@"%@",self.responseRoute);
//            }];
//        }];
//        
//    }];
}

-(NSMutableArray *)GetDirections:(MKDirectionsRequest *)request :(NSMutableArray *)routeListMArray
{
    return routeListMArray;
    //NSLog(@"%@",self.responseRoute);
    
}

#pragma -mark To draw the poly line
//To draw the poly line
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id)overlay {
    
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineView* aView = [[MKPolylineView alloc]initWithPolyline:(MKPolyline*)overlay] ;
        aView.strokeColor = [[UIColor colorWithRed:69.0/255.0 green:147.0/255.0 blue:240.0/255.0 alpha:0.8] colorWithAlphaComponent:1];
        //        aView.strokeColor=[UIColor greenColor];
        aView.lineWidth = 10;
        return aView;
    }
    return nil;
}


-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotationPoint
{
    
//    static NSString *annotationIdentifier = @"annotationIdentifier";
//    MKPinAnnotationView *pinView = [[MKPinAnnotationView alloc]initWithAnnotation:annotationPoint reuseIdentifier:annotationIdentifier];
//    if ([[annotationPoint title] isEqualToString:@"Source"]) {
//        pinView.pinColor = MKPinAnnotationColorRed;
//    }
//    else{
//        pinView.pinColor = MKPinAnnotationColorGreen;
//    }
//    
//    return pinView;
    return nil;
}

#pragma mark - table view delegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.responseRoute count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    RouteCell *cell = [self.routeTable dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    NSArray *array = [self.responseRoute objectAtIndex:indexPath.row];
    NSString *routeStr = [[[[array objectAtIndex:1] stringByAppendingString:@" and "]stringByAppendingString:[array objectAtIndex:2]]stringByAppendingString:@" m"];
    [cell.RouteLength setText:routeStr];
    [cell.RoutName setText:[array objectAtIndex:0]];
    //[cell.RouteLength setText:[self.responseRoute objectAtIndex:indexPath.row]];
    //[cell.RoutName setText:[self.responseRoute objectAtIndex:indexPath.row]];

    return cell;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    if ([segue.identifier isEqualToString:@"VenueDetailSeg"]) {
//        NSIndexPath *indexPath = [self.tableV indexPathForSelectedRow];
//        FSVenueViewController *venuViewController = segue.destinationViewController;
//        FSVenue *venue = self.nearbyVenues[indexPath.row];
//        venuViewController.venueName = venue.name;
//    }
//    else if([segue.identifier isEqualToString:@"VenueArraySeg"]){
//        GenerateRouteViewController *grv = segue.destinationViewController;
//        grv.venueArray = self.nearbyVenues;
//        grv.UserCurrentLocation = self.locationManager.location;
//        grv.userVenue = self.userVenue;
//        //NSLog(@"@@@@@ %@,%f",self.userVenue.name,self.userVenue.location.coordinate.latitude);
//        
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

