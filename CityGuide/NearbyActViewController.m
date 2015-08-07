//
//  NearbyActViewController.m
//  CityGuide
//
//  Created by lushangshu on 15-7-3.
//  Copyright (c) 2015年 lushangshu. All rights reserved.
//

#import "NearbyActViewController.h"
#import <TwitterKit/TwitterKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@interface NearbyActViewController ()

@property (strong, nonatomic) NSArray *array;

@end

@implementation NearbyActViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [[Twitter sharedInstance] logInGuestWithCompletion:^(TWTRGuestSession *guestSession, NSError *error) {
//        [[[Twitter sharedInstance] APIClient] loadTweetWithID:@"20" completion:^(TWTRTweet *tweet, NSError *error) {
//            TWTRTweetView *tweetView = [[TWTRTweetView alloc] initWithTweet:tweet style:TWTRTweetViewStyleRegular];
//            [self.view addSubview:tweetView];
//        }];
//    }];
    
    [self twitterTimeline];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)twitterTimeline {
    
    ACAccountStore *account = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [account requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error)
     {
         
         if (granted == YES){
             NSArray *arrayOfAccounts = [account accountsWithAccountType:accountType];
             if ([arrayOfAccounts count] > 0) {
                 ACAccount *twitterAccount = [arrayOfAccounts lastObject];
                 NSURL *requestAPI = [NSURL URLWithString:@"https://api.twitter.com/1.1/search/tweets.json"];
                 
                 NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
                 
                 [parameters setObject:@"Sheffield" forKey:@"q"];
                 [parameters setObject:@"53.38,-1.46,10mi" forKey:@"geocode"];
                 [parameters setObject:@"3" forKey:@"count"];
                 //[parameters setObject:@"1" forKey:@"include_entities"];
                 
                 SLRequest *posts = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:requestAPI parameters:parameters];
                 posts.account = twitterAccount;
                 [posts performRequestWithHandler:^(NSData *response, NSHTTPURLResponse
                    *urlResponse, NSError *error)
                  {
                      
                      self.array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
                      NSLog(@"result is *** %@",self.array);
                      if (self.array.count != 0) {
                          dispatch_async(dispatch_get_main_queue(), ^{
                              [self.tableView reloadData]; // Here we tell the table view to reload the data it just recieved.
                          });
                      }
                  }];
             }
         } else {
             
             // Handle failure to get account access
             NSLog(@"%@", [error localizedDescription]);
         }
     }];
    
}

#pragma mark Table View Data Source Mehtods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Returns the number of rows for the table view using the array instance variable.
    
    return [_array count];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Creates each cell for the table view.
    
    static NSString *cellID =  @"CELLID" ;
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    
    // Creates an NSDictionary that holds the user's posts and then loads the data into each cell of the table view.
    
    //NSDictionary *tweet = _array[indexPath.row];
    
    //cell.textLabel.text = tweet[@"text"];
    cell.textLabel.text = @"haha";
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // When a user selects a row this will deselect the row.
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


#pragma mark - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

- (BOOL)slideNavigationControllerShouldDisplayRightMenu
{
    return YES;
}

@end
