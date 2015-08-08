//
//  TWConverter.m
//  CityGuide
//
//  Created by lushangshu on 15-8-8.
//  Copyright (c) 2015年 lushangshu. All rights reserved.
//

#import "TWConverter.h"
#import "TweetClas.h"
@interface TWConverter ()

@end

@implementation TWConverter

-(NSArray *)TWObjectConverter:(NSArray *)Statuses
{
    NSMutableArray *objects = [NSMutableArray arrayWithCapacity:Statuses.count];
    for (NSDictionary *t  in Statuses) {
        TweetClas *tw = [[TweetClas alloc]init];
        tw.tweetText = t[@"text"];
        tw.userName = t[@"user"][@"name"];
        tw.createdAt = t[@"user"][@"created_at"];
        tw.profileUrl = t[@"user"][@"profile_image_url"];

        [objects addObject:tw];
    }
    return objects;
}
@end
