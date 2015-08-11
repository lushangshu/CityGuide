//
//  LocalWeather.m
//  CityGuide
//
//  Created by lushangshu on 15-8-11.
//  Copyright (c) 2015年 lushangshu. All rights reserved.
//

#import "LocalWeather.h"
#import "AFNetworking.h"
@implementation LocalWeather


-(NSArray *)FetchWeatherInfo : (NSString *) cityName
{
    NSString *baseUrl = @"http://api.openweathermap.org/data/2.5/weather?q=";
    NSString *URLstr = [[baseUrl stringByAppendingString: cityName]stringByAppendingString:@",uk"];
    NSURL *url = [NSURL URLWithString:URLstr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/html", @"text/xml",nil];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSString *json = [operation responseString];
         NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
         NSDictionary *w_dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
         
         NSLog(@"weather json is %@",w_dic);
         NSArray *weather = w_dic[@"weather"];
         NSDictionary *ww_dic = [weather objectAtIndex:0];
         self.w_main = ww_dic[@"main"];
         self.w_description = ww_dic[@"description"];
         self.w_temperature =w_dic[@"main"][@"temp"];
         self.w_mintemp = w_dic[@"main"][@"temp_min"];
         self.w_maxtemp = w_dic[@"main"][@"temp_max"];
         NSLog(@"Weather in this city is main %@,desc %@,temp %@,min %@,max %@",self.w_main,self.w_description,self.w_temperature,self.w_mintemp,self.w_maxtemp);
         
     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Response %@", [operation responseString]);
         NSLog(@"Error: %@", error);
     }];
    
    [operation start];
    
    NSArray *weaArray = [[NSArray alloc] initWithObjects:self.w_main,self.w_description,self.w_temperature,self.w_mintemp,self.w_maxtemp, nil];
    return weaArray;
}
@end
