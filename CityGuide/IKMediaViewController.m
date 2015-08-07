//
//  IKMediaViewController.m
//  CityGuide
//
//  Created by lushangshu on 15-7-16.
//  Copyright (c) 2015年 lushangshu. All rights reserved.
//


#import "IKMediaViewController.h"
#import "IKMediaCell.h"
#import "UIImageView+AFNetworking.h"
#import "InstagramKit.h"

@interface IKMediaViewController ()
{
    BOOL liked;
}
@end

@implementation IKMediaViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [NSString stringWithFormat:@"@%@",self.media.user.username];
    NSLog(@"self.title is 99999 %@",self.title);
}

#pragma mark - UITableViewDelegate, UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ([[InstagramEngine sharedEngine] accessToken])?4:3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger retVal = 0;
    switch (indexPath.row) {
        case 0:
            retVal = self.tableView.bounds.size.width;
            break;
            
        default:
            retVal = 50;
            break;
    }
    return retVal;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath.row) {
        IKMediaCell *cell = (IKMediaCell *)[tableView dequeueReusableCellWithIdentifier:@"MediaCell" forIndexPath:indexPath];
        [cell.mediaImageView setImageWithURL:self.media.thumbnailURL];
        [cell.mediaImageView setImageWithURL:self.media.standardResolutionImageURL];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        
        switch (indexPath.row) {
            case 1:
            {
                if ([[InstagramEngine sharedEngine] accessToken])
                {
                    if (liked) {
                        cell.textLabel.text = @"Unlike";
                    }
                    else
                    {
                        cell.textLabel.text = @"Like";
                    }
                    
                }
                else
                    cell.textLabel.text = [NSString stringWithFormat:@"%ld Likes",(long)self.media.likesCount];
            }
                break;
                
            case 2:
            {
                if ([[InstagramEngine sharedEngine] accessToken])
                    cell.textLabel.text = @"Test Comment";
                else
                    cell.textLabel.text = [NSString stringWithFormat:@"%ld Comments",(long)self.media.commentCount];
            }
                break;
                
            default:
            {
                cell.textLabel.text = @"Test";
            }
                break;
                
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

#pragma mark - Tests -

//- (void)testGetMedia
//{
////    [[InstagramEngine sharedEngine] getMedia:self.media.Id withSuccess:^(InstagramMedia *media) {
////        NSLog(@"Load Media Successful");
////    } failure:^(NSError *error, NSInteger statusCode) {
////        NSLog(@"Loading Media Failed");
////    }];
//    [[InstagramEngine sharedEngine] getMediaAtLocation:<#(CLLocationCoordinate2D)#> withSuccess:<#^(NSArray *media, InstagramPaginationInfo *paginationInfo)success#> failure:<#^(NSError *error, NSInteger serverStatusCode)failure#>]
//}



@end
