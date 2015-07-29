//
//  IKCollectionViewController.h
//  CityGuide
//
//  Created by lushangshu on 15-7-2.
//  Copyright (c) 2015年 lushangshu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"

@interface IKCollectionViewController : UICollectionViewController <SlideNavigationControllerDelegate>

- (IBAction)reloadMedia;
@end
