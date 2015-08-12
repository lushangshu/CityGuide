//
//  FSConverter.h
//  Foursquare2-iOS
//
//  Created by Constantine Fry on 2/7/13.
//
//

#import <Foundation/Foundation.h>
#import "FSVenueDetail.h"

@interface FSConverter : NSObject
- (NSArray *)convertToObjects:(NSArray *)venues;
-(NSArray *)convertVPhotoToObjects:(NSArray *)items;
-(FSVenueDetail *)convertVDetailToObjects:(NSArray *)items;

@end
