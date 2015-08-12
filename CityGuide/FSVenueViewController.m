//
//  FSVenueViewController.m
//  CityGuide
//
//  Created by lushangshu on 15-8-7.
//  Copyright (c) 2015年 lushangshu. All rights reserved.
//

#import "FSVenueViewController.h"
#import "AFNetworking.h"
#import "FSConverter.h"
#import <MapKit/MapKit.h>
#import "FSPhoto.h"
#import "IKCell.h"

@interface FSVenueViewController ()

@end

@implementation FSVenueViewController
@synthesize nameLabel;
@synthesize venueName;
@synthesize venue;
@synthesize venueId;


- (void)viewDidLoad {
    [super viewDidLoad];
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:venue.location.coordinate];
    [annotation setTitle:venue.name];
    [self.VenueMap addAnnotation:annotation];
    [self.VenueMap setRegion:MKCoordinateRegionMake(venue.location.coordinate, MKCoordinateSpanMake(0.01f, 0.01f)) animated:YES];
    self.nameLabel.text = venueName;
    //NSLog(@"location %@",venue.venueId);
    [self FetchVenuePhotsUsingVenueID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)FetchVenueInfoUsingVenueID: (NSString *)venueID
{
    
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
-(void)FetchVenuePhotsUsingVenueID
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"M0AY5MCIO3I5HKZAU35MC1E4WQIBIVUFVPSL2MY0TSRP5JTI" forKey:@"client_id"];
    [params setObject:@"O3DM3WRVRABPMTMWMMGXC4WDEHUUIGGIRHP1Y0PTUEW2WTK3" forKey:@"client_secret"];
    [params setObject:@"30" forKey:@"limit"];
    [params setObject:@"20140118" forKey:@"v"];
    
    NSString *url1 = @"http://api.foursquare.com/v2/venues/";
    NSString *url2 = venue.venueId;
    NSString *url3 = @"/photos";
    NSString *url = [[url1 stringByAppendingString:url2]stringByAppendingString:url3];
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        NSDictionary *dic = responseObject;
        NSArray *photos = [dic valueForKeyPath:@"response.photos.items"];
        FSConverter *converter = [[FSConverter alloc]init];
        self.photos = [converter convertVPhotoToObjects :photos];

        NSString *str = [[self.photos objectAtIndex:0] prefix];
        NSString *str1 = [[self.photos objectAtIndex:0] suffix];
        NSString *str3 = @"80x80";
        NSString *url = [[str stringByAppendingString:str3]stringByAppendingString:str1];
        NSLog(@"photo image is %@",url);
        [self downloadImageWithURL:[NSURL URLWithString:url] completionBlock:^(BOOL succeeded, UIImage *image) {
            if (succeeded) {
                // change the image in the cell
                self.imagePhoto.image = image ;
            }
        }];
    

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}
#pragma mark -- venue map delegate

#pragma mark -- collectionview delegate


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IKCell *cell = [self.VenueGallery dequeueReusableCellWithReuseIdentifier:@"vpCell" forIndexPath:indexPath];

    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = [self VenueGallery].bounds.size.width / 3 - 1;
    return CGSizeMake(width, width);
}

@end
