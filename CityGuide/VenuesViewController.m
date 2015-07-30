//
//  VenuesViewController.m
//  CityGuide
//
//  Created by lushangshu on 15-7-29.
//  Copyright (c) 2015年 lushangshu. All rights reserved.
//

#import "VenuesViewController.h"
#import "AFNetworking.h"
#import "FSVenue.h"
#import "FSConverter.h"
#import "venuCell.h"

@implementation VenuesViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetching];
    
}

-(void) fetching{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"M0AY5MCIO3I5HKZAU35MC1E4WQIBIVUFVPSL2MY0TSRP5JTI" forKey:@"client_id"];
    [params setObject:@"O3DM3WRVRABPMTMWMMGXC4WDEHUUIGGIRHP1Y0PTUEW2WTK3" forKey:@"client_secret"];
    [params setObject:@"food" forKey:@"query"];
    [params setObject:@"53.38,-1.46" forKey:@"ll"];
    [params setObject:@"20140118" forKey:@"v"];
    [params setObject:@"30" forKey:@"limit"];
    
    [manager GET:@"https://api.foursquare.com/v2/venues/search" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        NSDictionary *dic = responseObject;
        NSArray *venues = [dic valueForKeyPath:@"response.venues"];
        FSConverter *converter = [[FSConverter alloc]init];
        self.nearbyVenues = [converter convertToObjects:venues];
        for (int i=0; i<[self.nearbyVenues count]; i++) {
            FSVenue *v =self.nearbyVenues[i];
            NSLog(@"name is +++ %@",v.name);
        }
        [self.tableV reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(NSMutableArray*)returnVenuesDetails:(NSString*)result{
    
    
    return [NSMutableArray array];
}



#pragma mark - UITableViewDelegate

// The number of rows is equal to the number of places in the city
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *vCell = @"VenueCell";
    venuCell *cell = [self.tableV dequeueReusableCellWithIdentifier:vCell];
    FSVenue *venue = self.nearbyVenues[indexPath.row];
    cell.venuName.text = [venue name];
    
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell *cell = [self.tableV cellForRowAtIndexPath:indexPath];
//    [cell setBackgroundColor:[UIColor whiteColor ]];
    [self updateDataWithTableview:self.tableV];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.tableV cellForRowAtIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor blueColor]];
    [self updateDataWithTableview:self.tableV];
}

- (void)updateDataWithTableview:(UITableView *)tableView {
    NSArray *indexpaths = [self.tableV indexPathsForSelectedRows];
    NSMutableArray *selectedItems = [NSMutableArray new];
    for (NSIndexPath *indexpath in indexpaths) {
        UITableViewCell *cell = [self.tableV cellForRowAtIndexPath:indexpath];
        [selectedItems addObject:cell.textLabel];
    }
    self.selectedVenus.text = [selectedItems componentsJoinedByString:@";"];
}


@end
