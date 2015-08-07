//
//  FSVenueViewController.h
//  CityGuide
//
//  Created by lushangshu on 15-8-7.
//  Copyright (c) 2015年 lushangshu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSVenueViewController : UIViewController

@property (weak, nonatomic) IBOutlet UINavigationItem *navbar;
@property (nonatomic,weak) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitlelabel;
@property (strong,nonatomic) NSString *name;

@end
