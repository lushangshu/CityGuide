//
//  FetchVenues.m
//  CityGuide
//
//  Created by lushangshu on 15-8-9.
//  Copyright (c) 2015年 lushangshu. All rights reserved.
//

#import "FetchVenues.h"
#import "AFNetworking.h"
#import "FSVenue.h"
#import "FSConverter.h"

@implementation FetchVenues

-(NSArray *)FetchVenues: (CLLocation *)location
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *lat = [NSString stringWithFormat:@"%f",location.coordinate.latitude ];
    NSString *lon = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
    NSString *locat = [[lat stringByAppendingString:@","]stringByAppendingString:lon];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:@"M0AY5MCIO3I5HKZAU35MC1E4WQIBIVUFVPSL2MY0TSRP5JTI" forKey:@"client_id"];
    [params setObject:@"O3DM3WRVRABPMTMWMMGXC4WDEHUUIGGIRHP1Y0PTUEW2WTK3" forKey:@"client_secret"];
    [params setObject:@"food" forKey:@"query"];
    [params setObject:locat forKey:@"ll"];
    [params setObject:@"20140118" forKey:@"v"];
    [params setObject:@"4" forKey:@"limit"];
    
    [manager GET:@"https://api.foursquare.com/v2/venues/search" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        NSDictionary *dic = responseObject;
        NSArray *venues = [dic valueForKeyPath:@"response.venues"];
        FSConverter *converter = [[FSConverter alloc]init];
        self.venues = [converter convertToObjects:venues];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
    }];
    return self.venues;
}
@end
