//
//  MapShopsViewController.h
//  CityGuide
//
//  Created by lushangshu on 15-7-15.
//  Copyright (c) 2015年 lushangshu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapShopsViewController : UIViewController <MKMapViewDelegate>
@property (nonatomic,strong) IBOutlet UITextView *txtView;
@end
