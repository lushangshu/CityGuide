//
//  CityDetailViewController.m
//  CityGuide
//
//  Created by lushangshu on 15-7-16.
//  Copyright (c) 2015年 lushangshu. All rights reserved.
//

#import "CityDetailViewController.h"
#import "AFHTTPRequestOperation.h"
#import "AFNetworking.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPSessionManager.h"
#import "CityDetailCell.h"
#import "location.h"
#import <CoreLocation/CoreLocation.h>
#import "SlideNavigationController.h"
#import "SlideNavigationContorllerAnimatorFade.h"
#import "SlideNavigationContorllerAnimatorSlide.h"
#import "SlideNavigationContorllerAnimatorScale.h"
#import "SlideNavigationContorllerAnimatorScaleAndFade.h"
#import "SlideNavigationContorllerAnimatorSlideAndFade.h"



@interface CityDetailViewController () <CLLocationManagerDelegate>

- (IBAction)buttonPressed:(id)sender;

@end

@implementation CityDetailViewController{
    
    CLLocationManager *manager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //location operation
    manager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    [self locationUpdate];
    [self setCurrentCity];

//    dispatch_queue_attr_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_group_t group = dispatch_group_create();
//    
//    dispatch_group_async(group, queue, ^{
//        [self setCurrentCity];
//        NSLog(@"sync city name is *** %@",self.cityName);
//    });
//    dispatch_group_notify(group, queue, ^{
//        [self loadCityDetails];
//    });
//    NSLog(@"city name is &&& %@",self.cityName);
//    [self performSelector:@selector(loadCityDetails) withObject:self afterDelay:1.5];
    //[self loadCityDetails];
}
-(void) locationUpdate{
    manager.delegate = self;
    manager.desiredAccuracy = kCLLocationAccuracyBest;
    [manager startUpdatingLocation];
    
}
-(IBAction)buttonPressed:(id)sender{
//    manager.delegate = self;
//    manager.desiredAccuracy = kCLLocationAccuracyBest;
//    [manager startUpdatingLocation];
//    NSLog(@"pressed+ %@",self.label_c.text);
    self.cityName = self.searchCity.text;
    [self loadCityDetails];
    [self.label_c setText:self.cityName];
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadCityDetails
{
//    [self setCurrentCity];
//    NSString *loadMountainQueries = @"select * where { ?Mountain a dbpedia-owl:Mountain; dbpedia-owl:abstract ?abstract. FILTER(langMatches(lang(?abstract),\"EN\")) } limit 3";
    NSLog(@"here is load city detail %@",self.cityName);
    NSString *loadMountainQueries = @"SELECT ?subject ?label ?lat ?long WHERE{<http://dbpedia.org/resource/Sheffield> geo:lat ?eiffelLat;geo:long ?eiffelLong.?subject geo:lat ?lat;geo:long ?long;rdfs:label ?label.FILTER(xsd:double(?lat) - xsd:double(?eiffelLat) <= 0.05 && xsd:double(?eiffelLat) - xsd:double(?lat) <= 0.05 && xsd:double(?long) - xsd:double(?eiffelLong) <= 0.05 && xsd:double(?eiffelLong) - xsd:double(?long) <= 0.05 && lang(?label) = \"en\").} LIMIT 3";
    
    NSString *encodedLoadMountainQueries = [loadMountainQueries stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlString = [NSString stringWithFormat:@"http://dbpedia.org/sparql/?query=%@",encodedLoadMountainQueries];

    NSString *url_1 = @"http://dbpedia.org/sparql?default-graph-uri=http%3A%2F%2Fdbpedia.org&query=SELECT+%3Fsubject+%3Flabel+%3Flat+%3Flong+WHERE%7B%3Chttp%3A%2F%2Fdbpedia.org%2Fresource%2F";
    NSString *url_2 = @"%3E+geo%3Alat+%3FeiffelLat%3Bgeo%3Along+%3FeiffelLong.%3Fsubject+geo%3Alat+%3Flat%3Bgeo%3Along+%3Flong%3Brdfs%3Alabel+%3Flabel.FILTER%28xsd%3Adouble%28%3Flat%29+-+xsd%3Adouble%28%3FeiffelLat%29+%3C%3D+0.05+%26%26+xsd%3Adouble%28%3FeiffelLat%29+-+xsd%3Adouble%28%3Flat%29+%3C%3D+0.05+%26%26+xsd%3Adouble%28%3Flong%29+-+xsd%3Adouble%28%3FeiffelLong%29+%3C%3D+0.05+%26%26+xsd%3Adouble%28%3FeiffelLong%29+-+xsd%3Adouble%28%3Flong%29+%3C%3D+0.05+%26%26+lang%28%3Flabel%29+%3D+%22en%22%29.%7D+LIMIT+20&format=application%2Fsparql-results%2Bjson&timeout=10000&debug=on";
    
    //NSLog(@"city name is $$$$ %@",self.cityName);
    NSString *fakeUrlstr = [[url_1 stringByAppendingString:self.cityName]stringByAppendingString:url_2];
    //NSLog(@"faeke url is ------ %@",fakeUrlstr);
    NSURL *fakeurl = [NSURL URLWithString:fakeUrlstr];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:fakeurl];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"application/sparql-results+json",@"text/plain",@"sparql-results+json", @"text/json", @"text/html", @"text/xml",@"application/sparql-results+xml", nil];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSString *output = [operation responseString];
         //NSLog(@"Response %%%%%% %@", output);
         self.placeList = [self parseJsonData:output];
         [self.tableView reloadData];
     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Response %@", [operation responseString]);
         NSLog(@"Error: %@", error);
     }];
    
    [operation start];
}

-(NSMutableArray *) parseJsonData: (NSString *) json
{
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
    
    NSDictionary *arrayResult = [dic objectForKey:@"results"];
    
    NSArray *bindings = [arrayResult objectForKey:@"bindings"];
    for (int i=0;i< [bindings count];i++)
    {
        NSDictionary *subject = [bindings objectAtIndex:i];
        
        NSDictionary *label = [subject objectForKey:@"label"];
        NSString *name = [label objectForKey:@"value"];
        
        NSDictionary *sub = [subject objectForKey:@"subject"];
        NSString *url = [sub objectForKey:@"value"];
        NSDictionary *lat = [subject objectForKey:@"lat"];
        NSString *lati = [lat objectForKey:@"value"];
        NSDictionary *log = [subject objectForKey:@"long"];
        NSString *longi = [log objectForKey:@"value"];
        
        //NSLog(@"^^^ Label is %@, url is %@, lat is %@, long is %@",name,url,lati,longi);
        NSArray *array = [[NSArray alloc]initWithObjects:name,url,lati,longi, nil];
        [resultArray addObject:array];
    }
    return resultArray;
}

- (void)jsonParse{
   
    NSString* path  = @"http://maps.googleapis.com/maps/api/geocode/json?address=nanjing&sensor=true";
    NSURL* url = [NSURL URLWithString:path];
    NSString* jsonString = [[NSString alloc]initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
    NSArray* arrayResult =[dic objectForKey:@"results"];
    NSDictionary* resultDic = [arrayResult objectAtIndex:0];
    NSDictionary* geometryDic = [resultDic objectForKey:@"geometry"];
    NSLog(@"!!!!!!!geometryDic: %@,  resultDic:%@",geometryDic,resultDic);
    NSDictionary* locationDic = [geometryDic objectForKey:@"location"];
    NSNumber* lat = [locationDic objectForKey:@"lat"];
    NSNumber* lng = [locationDic objectForKey:@"lng"];
    NSLog(@"lat = %@, lng = %@",lat,lng);
    
    
}

-(void)setCurrentCity
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:manager.location
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       NSLog(@"reverseGeocodeLocation:completionHandler: Completion Handler called!");
                       if (error){
                           NSLog(@"Geocode failed with error: %@", error);
                           return;
                       }
                       CLPlacemark *placemark = [placemarks objectAtIndex:0];
                       self.cityName = placemark.locality;
                       NSLog(@"!!!!! placemark.country %@",self.cityName);
                       [self loadCityDetails];
                   }];
}

#pragma mark - CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
    NSLog(@"Error: %@", error);
    NSLog(@"Failed to get location! :(");
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    if (currentLocation != nil) {
//        self.latitude.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
//        self.longitude.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
    }
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            [self.label_c setText:[NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
                                   placemark.subThoroughfare, placemark.thoroughfare,
                                   placemark.postalCode, placemark.locality,
                                   placemark.administrativeArea,
                                   placemark.country]];
            self.cityName = [NSString stringWithFormat:@"%@",placemark.locality];
            //NSLog(@"cityname = %@",self.cityName);
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
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

#pragma mark - UITableViewDelegate

// The number of rows is equal to the number of places in the city
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   // NSLog(@" +++++ %lu ",(unsigned long)self.placeList.count);
    return self.placeList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *kEarthquakeCellID = @"CityCell";
    CityDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:kEarthquakeCellID];
    
    // Get the specific earthquake for this row.
//    APLEarthquake *earthquake = (self.earthquakeList)[indexPath.row];
//    
//    [cell configureWithEarthquake:earthquake];
    NSArray *obj = [self.placeList objectAtIndex:indexPath.row];
    [cell.label1 setText: obj[0]];
    [cell.label2 setText: obj[1]];
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld",(long)(indexPath.row % 5)]];
    [cell.imageView setImage:image];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *buttonTitle = NSLocalizedString(@"Cancel", @"Cancel");
    NSString *buttonTitle1 = NSLocalizedString(@"Show Site in Safari", @"Show Site in Safari");
    NSString *buttonTitle2 = NSLocalizedString(@"Show Location in Maps", @"Show Location in Maps");
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:buttonTitle destructiveButtonTitle:nil
                                              otherButtonTitles:buttonTitle1, buttonTitle2, nil];
    [sheet showInView:self.view];
}

#pragma mark - redirect to web browser

/**
 * Called when the user selects an option in the sheet. The sheet will automatically be dismissed.
 */
- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    //APLEarthquake *earthquake = (APLEarthquake *)(self.earthquakeList)[selectedIndexPath.row];
    switch (buttonIndex) {
        case 0: {
            NSArray *obj = [self.placeList objectAtIndex:buttonIndex];
            
            [[UIApplication sharedApplication] openURL: [NSURL URLWithString:obj[1]]];
        }
            break;
        case 1: {
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                                     bundle: nil];
            UIViewController *vc =[mainStoryboard instantiateViewControllerWithIdentifier: @"HomeViewController"];
            
             NSDictionary *dicts = [NSDictionary dictionaryWithObjectsAndKeys:@"one1",@"one",@"two2",@"two",@"three3",@"three", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"mynotification2" object:self.placeList];
            NSLog(@"send data to another view");
            
            [[SlideNavigationController sharedInstance] popToRootViewControllerAnimated:YES];            NSLog(@"pressed ");
            break;
        }
    }
    
    [self.tableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
}



@end
