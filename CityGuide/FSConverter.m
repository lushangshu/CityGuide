//
//  FSConverter.m
//  Foursquare2-iOS
//
//  Created by Constantine Fry on 2/7/13.
//
//

#import "FSConverter.h"
#import "FSVenue.h"
#import "FSPhoto.h"
#import "FSVenueDetail.h"

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

-(NSArray *)convertVPhotoToObjects:(NSArray *)items
{
    NSMutableArray *objects = [NSMutableArray arrayWithCapacity:items.count];
    for(NSDictionary *p in items){
        FSPhoto *pho = [[FSPhoto alloc]init];
        pho.id = p[@"id"];
        pho.prefix =p[@"prefix"];
        pho.suffix =p[@"suffix"];
        [objects addObject:pho];
        
    }
    return objects;
}

-(FSVenueDetail *)convertVDetailToObjects:(NSDictionary *)venue
{
    FSVenueDetail *vd = [[FSVenueDetail alloc]init];
    //NSLog(@"venue is %@",venue);
    vd.phone = venue[@"venue"][@"contact"][@"phone"];
    //vd.rating = venue[@"venue"][@"venueRatingBlacklisted"];
    vd.formattedAddress = venue[@"venue"][@"location"][@"formattedAddress"];
    vd.canonicalUrl = venue[@"veneu"][@"canonicalUrl"];
    //NSLog(@"%@,%@,%@,%@",vd.phone,vd.rating,vd.formattedAddress,vd.canonicalUrl);
    return vd;
}


@end
