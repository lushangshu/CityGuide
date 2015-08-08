//
//  ActivityViewController.m
//  CityGuide
//
//  Created by lushangshu on 15-8-7.
//  Copyright (c) 2015年 lushangshu. All rights reserved.
//

#import "ActivityViewController.h"
#import "InstagramKit.h"
#import "UIImageView+AFNetworking.h"
#import "InstagramMedia.h"
#import "InstagramUser.h"
#import "IKCell.h"
#import "TWConverter.h"
#import "TweetClas.h"
#import "TweetsCell.h"
#import "location.h"
#import <CoreLocation/CoreLocation.h>
#import <TwitterKit/TwitterKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@interface ActivityViewController ()
{
    NSMutableArray *mediaArray;
    
    
}

@property (nonatomic,strong) InstagramPaginationInfo *currentPaginationInfo;
@end

@implementation ActivityViewController
{
    CLLocationManager *manager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        mediaArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    manager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    [self locationUpdate];
    [self setCurrentCity];
    [self loadMedia];
}

-(void) locationUpdate{
    manager.delegate = self;
    manager.desiredAccuracy = kCLLocationAccuracyBest;
    [manager startUpdatingLocation];
}


- (void)loadMedia
{
    [self.textFFF resignFirstResponder];
    self.textFFF.text = @"  ";
    InstagramEngine *sharedEngine = [InstagramEngine sharedEngine];
    [self MediaAtLocation];
    NSLog(@"located media loaded");
}

- (IBAction)searchMedia
{
    self.currentPaginationInfo = nil;
    if (mediaArray) {
        [mediaArray removeAllObjects];
    }
    [self.textFFF resignFirstResponder];
    
    if ([self.textFFF.text length]) {
        [self testGetMediaFromTag:self.textFFF.text];
        //        [self testSearchUsersWithString:textField.text];
    }
}

-(void)MediaAtLocation
{
    CLLocationCoordinate2D loc = [self findCurrentLocation];
    [[InstagramEngine sharedEngine] getMediaAtLocation:loc withSuccess:^(NSArray *media, InstagramPaginationInfo *paginationInfo) {
        [mediaArray removeAllObjects];
        [mediaArray addObjectsFromArray:media];
        [self reloadData];
    } failure:^(NSError *error, NSInteger serverStatusCode) {
        NSLog(@"Load Popular Media Failed");
    }];
}

- (void)testGetMediaFromTag:(NSString *)tag
{
    [[InstagramEngine sharedEngine] getMediaWithTagName:tag count:15 maxId:self.currentPaginationInfo.nextMaxId withSuccess:^(NSArray *media, InstagramPaginationInfo *paginationInfo) {
        self.currentPaginationInfo = paginationInfo;
        [mediaArray addObjectsFromArray:media];
        [self reloadData];
        
    } failure:^(NSError *error, NSInteger statusCode) {
        NSLog(@"Search Media Failed");
    }];
}


-(CLLocationCoordinate2D )findCurrentLocation
{
    
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    if ([locationManager locationServicesEnabled])
    {
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        [locationManager startUpdatingLocation];
    }
    
    
    CLLocation *location = [locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    NSString *str=[[NSString alloc] initWithFormat:@" latitude:%f longitude:%f",coordinate.latitude,coordinate.longitude];
    NSLog(@"%@",str);
    
    return coordinate;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadData
{
    [self.collections reloadData];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return mediaArray.count;
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
                       self.lat = [NSString stringWithFormat:@"%.4f", manager.location.coordinate.latitude];
                       self.lont = [NSString stringWithFormat:@"%.4f",manager.location.coordinate.longitude];
                       self.cityName = placemark.locality;
                       //NSLog(@"***** placemark.country %@,%@,%@",self.cityName,self.lont,self.lat);
                       [self twitterSearchTweets];
                       [self.tableVi reloadData];
                       self.textFFF.text = self.cityName;
                   }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
            //NSLog(@"cityname = %@",self.cityName);
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
}

#pragma mark - Twitter data retrieve and parse
- (void)twitterSearchTweets {
    
    ACAccountStore *account = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [account requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error)
     {
         
         if (granted == YES){
             NSArray *arrayOfAccounts = [account accountsWithAccountType:accountType];
             if ([arrayOfAccounts count] > 0) {
                 ACAccount *twitterAccount = [arrayOfAccounts lastObject];
                 NSURL *requestAPI = [NSURL URLWithString:@"https://api.twitter.com/1.1/search/tweets.json"];
                 
                 NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
                 NSString *locat = [[[self.lat stringByAppendingString:@","]stringByAppendingString:self.lont]stringByAppendingString:@",10mi"];
                 [parameters setObject:self.cityName forKey:@"q"];
                 [parameters setObject:locat forKey:@"geocode"];
                 [parameters setObject:@"20" forKey:@"count"];
                 //[parameters setObject:@"1" forKey:@"include_entities"];
                 
                 SLRequest *posts = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:requestAPI parameters:parameters];
                 posts.account = twitterAccount;
                 [posts performRequestWithHandler:^(NSData *response, NSHTTPURLResponse
                                                    *urlResponse, NSError *error)
                  {
                      NSDictionary *tempArray = [[NSDictionary alloc]init];
                      tempArray = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
                      //NSLog(@"result is *** %@",self.array);
                      NSArray *tweets = [tempArray valueForKeyPath:@"statuses"];
                      TWConverter *convert = [[TWConverter alloc]init];
                      self.array = [convert TWObjectConverter:tweets];
                      for (int i=0; i<[self.array count]; i++) {
                          //TweetClas *t =self.array[i];
                          //NSLog(@"name is +++ (((( %@,%@",t.userName,t.createdAt);
                      }
                      if (self.array.count != 0) {
                          dispatch_async(dispatch_get_main_queue(), ^{
                              [self.tableVi reloadData]; // Here we tell the table view to reload the data it just recieved.
                          });
                      }
                  }];
             }
         } else {
             NSLog(@"%@", [error localizedDescription]);
         }
     }];
    
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

#pragma mark - UICollection view delegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IKCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CPCELL" forIndexPath:indexPath];
    
    if (mediaArray.count >= indexPath.row+1) {
        InstagramMedia *media = mediaArray[indexPath.row];
        [cell.imageView setImageWithURL:media.thumbnailURL];
    }
    else
        [cell.imageView setImage:nil];
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    //    InstagramMedia *media = mediaArray[indexPath.row];
    //    [self testLoadMediaForUser:media.user];
    
    if (self.currentPaginationInfo)
    {
        //  Paginate on navigating to detail
        //either
        //        [self loadMedia];
        //or
        //        [self testPaginationRequest:self.currentPaginationInfo];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = [self collections].bounds.size.width / 3 - 1;
    return CGSizeMake(width, width);
}

#pragma mark - UITableview delegete methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cell";
    TweetsCell *cell = [self.tableVi dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    TweetClas *venue = self.array[indexPath.row];
    [cell.name setText:[venue userName]];
    [cell.text setText:[venue tweetText]];
    [cell.createTime setText:[venue createdAt]];
    cell.imageView.image = [UIImage imageNamed:@"0.png"];
    [self downloadImageWithURL:[NSURL URLWithString:[venue profileUrl]] completionBlock:^(BOOL succeeded, UIImage *image) {
        if (succeeded) {
            // change the image in the cell
            cell.imageView.image = image;
        }
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)tField
{
    if (tField.text.length) {
        [self searchMedia];
    }
    [tField resignFirstResponder];
    
    return YES;
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
