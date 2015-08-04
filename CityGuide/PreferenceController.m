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
    [self.tableview setEditing:YES animated:YES];
}

-(IBAction)saveData
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"settings.plist"];
    
    NSDictionary *plistDict = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:@"124", nil] forKeys:[NSArray arrayWithObjects:@"test", nil]];
    
    NSString *error = nil;
//    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
    NSData *plistData = [NSPropertyListSerialization dataWithPropertyList:plistDict format:NSPropertyListXMLFormat_v1_0 options:NSPropertyListMutableContainersAndLeaves error:&error];
    
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
    
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSLog(@"$$$ %@",[dict objectForKey:@"test"]);
   // NSLog(@"### %@",[dict objectForKey:@"name"]);
}

#pragma mark - tableview

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.text = self.datas[indexPath.row];
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
        [selectedItems addObject:cell.textLabel.text];
    }
    self.label.text = [selectedItems componentsJoinedByString:@";"];
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
