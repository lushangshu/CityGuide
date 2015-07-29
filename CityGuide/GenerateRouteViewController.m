//
//  GenerateRouteViewController.m
//  CityGuide
//
//  Created by lushangshu on 15-7-29.
//  Copyright (c) 2015年 lushangshu. All rights reserved.
//

#import "GenerateRouteViewController.h"

@interface GenerateRouteViewController ()
{
    CLLocationManager *locationManager;
    float myLat,myLon;
    MKRoute *rout;
}

@end

@implementation GenerateRouteViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.mapView.delegate=self;
    self.mapView.showsUserLocation=YES;
    
    //to get the current location
    locationManager=[[CLLocationManager alloc] init];
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
    [locationManager startUpdatingLocation];
    
    
    //To draw poly line between mok source and destination
    [self showLinesFromSourceLati:0.0 Long:0.0];
    
    
    
}


- (void)showLinesFromSourceLati:(float)lat Long:(float)Lon
{
    
    //    myLat=lat;
    //    myLon=Lon;
    
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake
    (53.38557900,-1.46176330);
    
    //Uncomment this below line to zoom at user current location and comment the above line
    //    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lat, Lon);
    
    //Place annotation for the Source
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:coordinate];
    [annotation setTitle:@"Source"];
    
    [_mapView addAnnotation:annotation];
    
    //To zoom in to the source location
    CLLocationCoordinate2D startCoord = CLLocationCoordinate2DMake
    (53.38, -1.46);
    //    CLLocationCoordinate2D startCoord = CLLocationCoordinate2DMake(lat, Lon);
    MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:MKCoordinateRegionMakeWithDistance(startCoord, 2000, 2000)];
    [_mapView setRegion:adjustedRegion animated:YES];
    
    //Setting up Source point // start point
    MKPlacemark *source = [[MKPlacemark alloc]initWithCoordinate:CLLocationCoordinate2DMake
                           (53.47557900,-1.46176330) addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil] ];
    //    MKPlacemark *source = [[MKPlacemark alloc]initWithCoordinate:CLLocationCoordinate2DMake(lat,Lon) addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil] ];
    
    MKMapItem *srcMapItem = [[MKMapItem alloc]initWithPlacemark:source];
    [srcMapItem setName:@"Source"];
    
    
    //Setting the destination
    MKPlacemark *destination = [[MKPlacemark alloc]initWithCoordinate:CLLocationCoordinate2DMake(53.36557900,-1.45176330) addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil] ];
    MKMapItem *distMapItem = [[MKMapItem alloc]initWithPlacemark:destination];
    [distMapItem setName:@"Destination"];
    
    //Place annotation for the destination
    CLLocationCoordinate2D coordinate1 = CLLocationCoordinate2DMake(53.36557900,-1.45176330);
    MKPointAnnotation *annotation1 = [[MKPointAnnotation alloc] init];
    [annotation1 setCoordinate:coordinate1];
    [annotation1 setTitle:@"Apple Inc"];
    [_mapView addAnnotation:annotation1];
    
    
    // Get Direction
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc]init];
    [request setSource:srcMapItem];
    [request setDestination:distMapItem];
    request.requestsAlternateRoutes = YES;
    [request setTransportType:MKDirectionsTransportTypeAutomobile];
    
    MKDirections *direction = [[MKDirections alloc] initWithRequest:request];
    
    [direction calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        
        if (error) {
            NSLog(@"Error:::%@",error);
        }
        
        NSLog(@"response = %@",response);
        NSArray *arrRoutes = [response routes];
        [arrRoutes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            rout = obj;
            
            MKPolyline *line = [rout polyline];
            [_mapView addOverlay:line];
            
            
//            NSLog(@"Rout Name : %@",rout.name);
//            NSLog(@"Total Distance (in Meters) :%f",rout.distance);
            
            NSArray *steps = [rout steps];
            
//            NSLog(@"Total Steps : %lu",(unsigned long)[steps count]);
            
            [steps enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                NSLog(@"Rout Instruction : %@",[obj instructions]);
//                NSLog(@"Rout Distance : %f",[obj distance]);
            }];
        }];
    }];
}




#pragma -mark To draw the poly line
//To draw the poly line
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id)overlay {
    
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineView* aView = [[MKPolylineView alloc]initWithPolyline:(MKPolyline*)overlay] ;
        aView.strokeColor = [[UIColor colorWithRed:69.0/255.0 green:147.0/255.0 blue:240.0/255.0 alpha:1.0] colorWithAlphaComponent:1];
        //        aView.strokeColor=[UIColor greenColor];
        aView.lineWidth = 10;
        return aView;
    }
    return nil;
}



-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotationPoint
{
    
    
    
    static NSString *annotationIdentifier = @"annotationIdentifier";
    
    MKPinAnnotationView *pinView = [[MKPinAnnotationView alloc]initWithAnnotation:annotationPoint reuseIdentifier:annotationIdentifier];
    if ([[annotationPoint title] isEqualToString:@"Source"]) {
        pinView.pinColor = MKPinAnnotationColorRed;
        
    }
    else{
        pinView.pinColor = MKPinAnnotationColorGreen;
    }
    
    return pinView;
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        
        NSLog(@"%@,%@",[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude],[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude]);
    }
    [locationManager stopUpdatingLocation];
    
    /* To show the directions from users current location to the destination*/
    // Uncomment below code to get the directions from the current location to the destination
    
    //        [self showLinesFromSourceLati:currentLocation.coordinate.latitude
    //                                 Long:currentLocation.coordinate.longitude];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

