//
//  FSVenueViewController.h
//  CityGuide
//
//  Created by lushangshu on 15-8-7.
//  Copyright (c) 2015年 lushangshu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSVenue.h"

@interface FSVenueViewController : UIViewController

@property (weak, nonatomic) IBOutlet MKMapView *VenueMap;
@property (nonatomic,weak) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *VenueAddress;
@property (weak, nonatomic) IBOutlet UILabel *VenueRating;
@property (strong, nonatomic) IBOutlet UICollectionView *VenueGallery;
@property (weak, nonatomic) IBOutlet UILabel *VenuePhone;
@property (weak, nonatomic) IBOutlet UIButton *RedirectToFS;
@property (strong, nonatomic) IBOutlet UIImageView *imagePhoto;
@property (strong, nonatomic) IBOutlet UIImageView *imagePhoto2;
@property (strong, nonatomic) IBOutlet UIImageView *imagePhoto3;

@property (nonatomic,strong) NSString *venueName;
@property (nonatomic,strong) NSString *venueId;
@property (nonatomic,strong) FSVenue *venue;

@property (nonatomic,strong) NSArray *photos;
@end
