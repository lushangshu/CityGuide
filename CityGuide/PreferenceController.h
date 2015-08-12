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
    NSInteger integer;
}
@property(nonatomic,strong)NSArray *datas;
@property(nonatomic,strong)NSMutableDictionary *categoryID;
@property(nonatomic,strong)NSMutableDictionary *selectedCateg;

@property(nonatomic,strong)NSArray *selectedData;

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (nonatomic,strong) IBOutlet UIButton *save;

-(IBAction)saveData;
-(IBAction)outPutData;

-(IBAction)saveDataUsingUserDefault:(id)sender;
-(IBAction)outPutDataUsingUserDeafult:(id)sender;
-(IBAction)testUD:(id)sender;

@end
