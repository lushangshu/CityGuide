//
//  PreferenceController.h
//  CityGuide
//
//  Created by lushangshu on 15-7-2.
//  Copyright (c) 2015年 lushangshu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"

@interface PreferenceController : UIViewController <UITableViewDataSource,UITableViewDelegate,SlideNavigationControllerDelegate>

@property(nonatomic,strong)NSArray *datas;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UILabel *label;
@end
