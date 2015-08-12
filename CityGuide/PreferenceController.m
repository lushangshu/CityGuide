//
//  PreferenceController.m
//  CityGuide
//
//  Created by lushangshu on 15-7-2.
//  Copyright (c) 2015年 lushangshu. All rights reserved.
//

#import "PreferenceController.h"

@interface PreferenceController ()

@end
@implementation PreferenceController {
    
    NSMutableArray *array;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    integer = 0;
    [lebel setText:[NSString stringWithFormat:@"%ld",(long)integer]];
    // Do any additional setup after loading the view from its nib.
    self.datas = [NSArray arrayWithObjects:@"Arts & Entertainment",
                  @"College & University",
                  @"Event",
                  @"Food",
                  @"Outdoors & Recreation",
                  @"States & Municipalities",
                  @"Professional & Other Places",
                  @"Residence",
                  @"Travel & Transport",
                  nil];
    [self initCategory];
    [self.tableview setEditing:YES animated:YES];
}

-(void)initCategory{
    self.categoryID = [NSMutableDictionary dictionary];
    self.selectedCateg = [NSMutableDictionary dictionary];
    [self.categoryID setObject:@"4d4b7104d754a06370d81259" forKey:@"Arts & Entertainment"];
    [self.categoryID setObject:@"4d4b7105d754a06372d81259" forKey:@"College & University"];
    [self.categoryID setObject:@"4d4b7105d754a06373d81259" forKey:@"Event"];
    [self.categoryID setObject:@"4d4b7105d754a06374d81259" forKey:@"Food"];
    [self.categoryID setObject:@"4d4b7105d754a06377d81259" forKey:@"Outdoors & Recreation"];
    [self.categoryID setObject:@"530e33ccbcbc57f1066bbfe4" forKey:@"States & Municipalities"];
    [self.categoryID setObject:@"4d4b7105d754a06375d81259" forKey:@"Professional & Other Places"];
    [self.categoryID setObject:@"4e67e38e036454776db1fb3a" forKey:@"Residence"];
    [self.categoryID setObject:@"4d4b7105d754a06379d81259" forKey:@"Travel & Transport"];
    //NSLog(@"%@",self.categoryID);
}

-(IBAction)saveDataUsingUserDefault:(id)sender{
    [[NSUserDefaults standardUserDefaults] setInteger:integer forKey:@"integer"];
}

-(IBAction)outPutDataUsingUserDeafult:(id)sender{
    integer = [[NSUserDefaults standardUserDefaults] integerForKey:@"integer"];
    [lebel setText:[NSString stringWithFormat:@"%ld",(long)integer]];
}

-(IBAction)testUD:(id)sender{
    integer = integer +1;
    [lebel setText:[NSString stringWithFormat:@"%ld",(long)integer]];
}
-(IBAction)saveData
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"settings.plist"];
    
//    NSDictionary *plistDict = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:@"124", nil] forKeys:[NSArray arrayWithObjects:@"test", nil]];
    
    NSString *error = nil;
//    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
    NSData *plistData = [NSPropertyListSerialization dataWithPropertyList:self.selectedCateg  format:NSPropertyListXMLFormat_v1_0 options:NSPropertyListMutableContainersAndLeaves error:&error];
    
    if(plistData)
    {
        [plistData writeToFile:plistPath atomically:YES];
        NSLog(@"saved data");
    }
    else
    {
        NSLog(@"save failed");
    }

    
}



-(IBAction)outPutData
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"settings.plist"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        plistPath = [[NSBundle mainBundle] pathForResource:@"settings" ofType:@"plist"];
    }
    
   self.selectedCateg = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    //NSLog(@"$$$ %@",self.selectedCateg);
   //NSLog(@"### %@",[dict objectForKey:@"name"]);
}

#pragma mark - tableview

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.text = self.datas[indexPath.row];
    
    cell.backgroundColor = [UIColor colorWithRed:43 green:164 blue:255 alpha:0];
    cell.textLabel.backgroundColor = [UIColor whiteColor];
    
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"settings"];
    NSMutableArray *arr = [[NSMutableArray alloc] initWithContentsOfFile:path];
    //NSLog(@"@@@@@ %@,$$$$ %@",cell.textLabel.text,[arr objectAtIndex:indexPath.row]);
    
    if ([cell.textLabel.text isEqualToString: [arr objectAtIndex:indexPath.row] ]) {
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self updateDataWithTableview:tableView];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self updateDataWithTableview:tableView];
}

- (void)updateDataWithTableview:(UITableView *)tableView {
    NSArray *indexpaths = [tableView indexPathsForSelectedRows];
    NSMutableArray *selectedItems = [NSMutableArray new];
    for (NSIndexPath *indexpath in indexpaths) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexpath];
        NSString *strKey = [[NSString alloc] initWithString:cell.textLabel.text];
        NSString *strObj = [[NSString alloc] initWithString:[self.categoryID objectForKey:strKey]];
        [self.selectedCateg setObject:strObj  forKey:strKey];
        [selectedItems addObject:cell.textLabel.text];
    }
    
    self.label.text = [selectedItems componentsJoinedByString:@" and "];
    //NSLog(@"selected dic is && %@",self.selectedCateg);
}


#pragma mark - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

- (BOOL)slideNavigationControllerShouldDisplayRightMenu
{
    return YES;
}

@end
