//
//  TweetsCell.h
//  CityGuide
//
//  Created by lushangshu on 15-8-8.
//  Copyright (c) 2015年 lushangshu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetsCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UILabel *name;
@property (nonatomic,strong) IBOutlet UIImageView *profile;
@property (nonatomic,strong) IBOutlet UILabel *text;
@property (nonatomic,strong) IBOutlet UILabel *createTime;
@end
