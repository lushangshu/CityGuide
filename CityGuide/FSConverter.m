//
//  FSConverter.m
//  Foursquare2-iOS
//
//  Created by Constantine Fry on 2/7/13.
//
//

#import "FSConverter.h"
#import "FSVenue.h"

@implementation FSConverter

- (NSArray *)convertToObjects:(NSArray *)venues {
    NSMutableArray *objects = [NSMutableArray arrayWithCapacity:venues.count];
    for (NSDictionary *v  in venues) {
        FSVenue *ann = [[FSVenue alloc]init];
        ann.name = v[@"name"];
        ann.venueId = v[@"id"];
        NSArray *category = v[@"categories"];
        //NSLog(@"%@",category);
        if ([category count]!=0) {
            NSDictionary *vv =  [category objectAtIndex:0];
            ann.prefix = vv[@"icon"][@"prefix"];
            ann.suffix = vv[@"icon"][@"suffix"];
            
            ann.location.address = v[@"location"][@"address"];
            ann.location.disTance = v[@"location"][@"distance"];
            
            [ann.location setCoordinate:CLLocationCoordinate2DMake([v[@"location"][@"lat"] doubleValue],
                                                                   [v[@"location"][@"lng"] doubleValue])];
            [objects addObject:ann];
        }
        else{
            
            return objects;
        }
        
    }
    return objects;
}



@end
