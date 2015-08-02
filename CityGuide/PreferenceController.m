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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];;
    cell.textLabel.text = self.datas[indexPath.row];
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
