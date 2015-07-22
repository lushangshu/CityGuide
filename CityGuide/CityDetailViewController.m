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
    
    //[self.label_c setText:@" "];
    [self loadMountains];
    [self locationUpdate];
    //[self getCurrentLocation];
    
}
-(void) locationUpdate{
    manager.delegate = self;
    manager.desiredAccuracy = kCLLocationAccuracyBest;
    [manager startUpdatingLocation];
}
-(IBAction)buttonPressed:(id)sender{
    manager.delegate = self;
    manager.desiredAccuracy = kCLLocationAccuracyBest;
    [manager startUpdatingLocation];
    NSLog(@"pressed+ %@",self.label_c.text);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadMountains
{
//    NSString *loadMountainQueries = @"select * where { ?Mountain a dbpedia-owl:Mountain; dbpedia-owl:abstract ?abstract. FILTER(langMatches(lang(?abstract),\"EN\")) } limit 3";
    NSString *loadMountainQueries = @"SELECT ?subject ?label ?lat ?long WHERE{<http://dbpedia.org/resource/Sheffield> geo:lat ?eiffelLat;geo:long ?eiffelLong.?subject geo:lat ?lat;geo:long ?long;rdfs:label ?label.FILTER(xsd:double(?lat) - xsd:double(?eiffelLat) <= 0.05 && xsd:double(?eiffelLat) - xsd:double(?lat) <= 0.05 && xsd:double(?long) - xsd:double(?eiffelLong) <= 0.05 && xsd:double(?eiffelLong) - xsd:double(?long) <= 0.05 && lang(?label) = \"en\").} LIMIT 3";
    
    NSString *encodedLoadMountainQueries = [loadMountainQueries stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlString = [NSString stringWithFormat:@"http://dbpedia.org/sparql/?query=%@",encodedLoadMountainQueries];
    //NSString *urlString = [NSString stringWithFormat:urlString_1,encodeloadQueries2];
    //NSLog(@"URL is +++ %@", urlString);
    
    NSString *fakeUrlString = @"http://dbpedia.org/sparql?default-graph-uri=http%3A%2F%2Fdbpedia.org&query=SELECT+%3Fsubject+%3Flabel+%3Flat+%3Flong+WHERE%7B%3Chttp%3A%2F%2Fdbpedia.org%2Fresource%2FSheffield%3E+geo%3Alat+%3FeiffelLat%3Bgeo%3Along+%3FeiffelLong.%3Fsubject+geo%3Alat+%3Flat%3Bgeo%3Along+%3Flong%3Brdfs%3Alabel+%3Flabel.FILTER%28xsd%3Adouble%28%3Flat%29+-+xsd%3Adouble%28%3FeiffelLat%29+%3C%3D+0.05+%26%26+xsd%3Adouble%28%3FeiffelLat%29+-+xsd%3Adouble%28%3Flat%29+%3C%3D+0.05+%26%26+xsd%3Adouble%28%3Flong%29+-+xsd%3Adouble%28%3FeiffelLong%29+%3C%3D+0.05+%26%26+xsd%3Adouble%28%3FeiffelLong%29+-+xsd%3Adouble%28%3Flong%29+%3C%3D+0.05+%26%26+lang%28%3Flabel%29+%3D+%22en%22%29.%7D+LIMIT+20&format=application%2Fsparql-results%2Bjson&timeout=10000&debug=on";
    NSURL *fakeurl = [NSURL URLWithString:fakeUrlString];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:fakeurl];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"application/sparql-results+json",@"text/plain",@"sparql-results+json", @"text/json", @"text/html", @"text/xml",@"application/sparql-results+xml", nil];
//    [AFHTTPRequestOperation addAcceptableContentTypes:
//     [NSSet setWithObjects:@"application/json", @"sparql-results+json", @"text/json", @"text/html", @"text/xml", nil]];
    
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
    //初始化 url
    NSURL* url = [NSURL URLWithString:path];
    //将文件内容读取到字符串中，注意编码NSUTF8StringEncoding 防止乱码，
    NSString* jsonString = [[NSString alloc]initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    //将字符串写到缓冲区。
    NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    //解析json数据，使用系统方法 JSONObjectWithData:  options: error:
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
    
    //一下为自定义解析， 自己想怎么干就怎么干
    
    NSArray* arrayResult =[dic objectForKey:@"results"];
    NSDictionary* resultDic = [arrayResult objectAtIndex:0];
    NSDictionary* geometryDic = [resultDic objectForKey:@"geometry"];
    NSLog(@"!!!!!!!geometryDic: %@,  resultDic:%@",geometryDic,resultDic);
    NSDictionary* locationDic = [geometryDic objectForKey:@"location"];
    NSNumber* lat = [locationDic objectForKey:@"lat"];
    NSNumber* lng = [locationDic objectForKey:@"lng"];
    NSLog(@"lat = %@, lng = %@",lat,lng);
    
    
}

#pragma mark - CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
    NSLog(@"Error: %@", error);
    NSLog(@"Failed to get location! :(");
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    NSLog(@"Location: %@", newLocation);
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
//            self.label_c.text = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
//                                 placemark.subThoroughfare, placemark.thoroughfare,
//                                 placemark.postalCode, placemark.locality,
//                                 placemark.administrativeArea,
//                                 placemark.country];
            
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
            NSLog(@"pressed ");
            break;
        }
    }
    
    [self.tableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
}



@end
