//
//  VenuesViewController.m
//  CityGuide
//
//  Created by lushangshu on 15-7-29.
//  Copyright (c) 2015年 lushangshu. All rights reserved.
//

#import "VenuesViewController.h"
#import "AFNetworking.h"

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
    
    [manager GET:@"https://api.foursquare.com/v2/venues/search" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        //Process the JSON response here and output each venue name as search suggestion
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
@end
