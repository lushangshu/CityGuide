//
//  CityDetailViewController.m
//  CityGuide
//
//  Created by lushangshu on 15-7-16.
//  Copyright (c) 2015年 lushangshu. All rights reserved.
//

#import "CityDetailViewController.h"
#import "AFHTTPRequestOperation.h"
#import "AFNetworking.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPSessionManager.h"

@interface CityDetailViewController ()

@end

@implementation CityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self Request];
    [self loadMountains];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void) Request
{
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
////    [manager GET:@"http://samwize.com/api/poos/"
//    [manager GET:@"http://dbpedia.org/sparql?default-graph-uri=http%3A%2F%2Fdbpedia.org&query=select+distinct+%3FConcept+where+%7B%5B%5D+a+%3FConcept%7D+limit+3%0D%0A&format=application%2Fsparql-results%2Bjson&timeout=10000&debug=on"
//        parameters:nil
//         success:^(AFHTTPRequestOperation *operation, id responseObject) {
//             NSLog(@"JSON: %@", responseObject);
//             [self.label_c setText:responseObject];
//         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//             NSLog(@"Error: %@", error);
//             
//             //self.label_c.text = error;
//             
//         }];
    
    NSURL *URL = [NSURL URLWithString:@"http://dbpedia.org/sparql?default-graph-uri=http%3A%2F%2Fdbpedia.org&query=SELECT+DISTINCT+%3Fconcept%0D%0AWHERE+%7B%0D%0A++++%3Fs+a+%3Fconcept+.%0D%0A%7D+LIMIT+3%0D%0A&format=application%2Fsparql-results%2Bjson&timeout=30000&debug=on"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]
                                         initWithRequest:request];
    
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/sparql-results+json"];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"The sparql query is ++++++ %@", responseObject);
        [self.label_c setText:responseObject];
    } failure:^(AFHTTPRequestOperation *operaton, NSError *error){
        NSLog(@"Error : %@",error);
    }];
    [operation start];
    
    
}

- (void) loadMountains
{
  
    
    NSString *loadMountainQueries = @"select * where { ?Mountain a dbpedia-owl:Mountain; dbpedia-owl:abstract ?abstract. FILTER(langMatches(lang(?abstract),\"EN\")) } limit 3";
    NSString *encodedLoadMountainQueries = [loadMountainQueries stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlString = [NSString stringWithFormat:@"http://dbpedia.org/sparql/?query=%@",encodedLoadMountainQueries];
    NSLog(@"%@", urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
//    [AFHTTPRequestOperation addAcceptableContentTypes:
//     [NSSet setWithObjects:@"application/json", @"sparql-results+json", @"text/json", @"text/html", @"text/xml", nil]];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"Response %@", [operation responseString]);
         [self.label_c setText:[operation responseString]];
     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Response %@", [operation responseString]);
         NSLog(@"Error: %@", error);
     }];
    
    [operation start];
}

-(void) requestUsingSPARQL {
    NSLog(@"hello world");
    SPARQL *sparql = [[SPARQL alloc]init];
    [sparql addWhereWithSubject:@"http://dbpedia.org/resource/Daft_Punk" predicate:@"?p" andObject:@"?o"];
//    [sparql executeQueryWithSuccess:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
//        NSArray *items = [[(NSDictionary *)JSON objectForKey:@"results"] objectForKey:@"bindings"];
//        
//    } orFailure:nil];
    [sparql LssExecuteQueryWithSuccess:^(NSURLRequest *request, id responseObject) {
        NSArray *items = [[(NSDictionary *)responseObject objectForKey:@"results"] objectForKey:@"bindings"];
    } orFailure:nil];
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

#pragma mark - UITableViewDelegate

// The number of rows is equal to the number of earthquakes in the array.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *kEarthquakeCellID = @"CityCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kEarthquakeCellID];
    
    // Get the specific earthquake for this row.
//    APLEarthquake *earthquake = (self.earthquakeList)[indexPath.row];
//    
//    [cell configureWithEarthquake:earthquake];
    return cell;
}

/**
 * When the user taps a row in the table, display the USGS web page that displays details of the earthquake they selected.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *buttonTitle = NSLocalizedString(@"Cancel", @"Cancel");
    NSString *buttonTitle1 = NSLocalizedString(@"Show USGS Site in Safari", @"Show USGS Site in Safari");
    NSString *buttonTitle2 = NSLocalizedString(@"Show Location in Maps", @"Show Location in Maps");
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:buttonTitle destructiveButtonTitle:nil
                                              otherButtonTitles:buttonTitle1, buttonTitle2, nil];
    [sheet showInView:self.view];
}

#pragma mark - redirect to web browser

/**
 * Called when the user selects an option in the sheet. The sheet will automatically be dismissed.
 */
- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    //APLEarthquake *earthquake = (APLEarthquake *)(self.earthquakeList)[selectedIndexPath.row];
    switch (buttonIndex) {
        case 0: {
            // open the earthquake info in Safari
            //2
            [[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"http://www.baidu.com"]];
        }
            break;
        case 1: {
            NSLog(@"pressed ");
            break;
        }
    }
    
    [self.tableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
}



@end
