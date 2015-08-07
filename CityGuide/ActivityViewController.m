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

@interface ActivityViewController ()
{
    NSMutableArray *mediaArray;
    
}
@property (nonatomic,strong) InstagramPaginationInfo *currentPaginationInfo;
@end

@implementation ActivityViewController

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
    [self loadMedia];
}

- (void)loadMedia
{
    [self.textFFF resignFirstResponder];
    self.textFFF.text = @"Sheffield";
    
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
    // NSLog(@" +++++ %lu ",(unsigned long)self.placeList.count);
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *kEarthquakeCellID = @"cell";
    UITableViewCell *cell = [self.tableVi dequeueReusableCellWithIdentifier:kEarthquakeCellID];
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
