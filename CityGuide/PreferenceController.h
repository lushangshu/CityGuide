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

{
    IBOutlet UILabel *lebel;
}
@property(nonatomic,strong)NSArray *datas;
@property(nonatomic,strong)NSMutableDictionary *categoryID;
@property(nonatomic,strong)NSMutableDictionary *selectedCateg;

@property(nonatomic,strong)NSMutableArray *categoryId;
@property(nonatomic,strong)NSMutableArray *categoryName;
@property(nonatomic,strong)NSMutableArray *selecteValues;

@property(nonatomic,strong)NSArray *selectedData;

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (nonatomic,strong) IBOutlet UIButton *save;

-(IBAction)saveData;
-(IBAction)outPutData;


@end
