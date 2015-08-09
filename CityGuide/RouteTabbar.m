//
//  RouteTabbar.m
//  CityGuide
//
//  Created by lushangshu on 15-8-9.
//  Copyright (c) 2015年 lushangshu. All rights reserved.
//

#import "RouteTabbar.h"

@implementation RouteTabbar

@synthesize venueArray;
@synthesize passArray;
-(void)viewDidLoad
{
    
}

-(NSArray *)passData{
    NSLog(@"%%%%,%@",venueArray);
    return venueArray;
}
@end
