//
//  CityDetailCell.h
//  CityGuide
//
//  Created by lushangshu on 15-7-22.
//  Copyright (c) 2015年 lushangshu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityDetailCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UILabel *label1;
@property (nonatomic,weak) IBOutlet UILabel *label2;
@property (nonatomic,strong) IBOutlet UIImageView *icon;

-(void)configCell;
@end
