//
//  PreferenceController.m
//  CityGuide
//
//  Created by lushangshu on 15-7-2.
//  Copyright (c) 2015年 lushangshu. All rights reserved.
//

#import "PreferenceController.h"

@interface PreferenceController ()

@end
@implementation PreferenceController {
    
    NSMutableArray *array;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    array = [[NSMutableArray alloc] init];
    
    [array addObject:@"Education"];
    [array addObject:@"Shopping"];
    [array addObject:@"Restaurant"];
    [array addObject:@"Travelling"];
    [array addObject:@"Entertaiment"];
    [array addObject:@"Lifestyle"];
    [array addObject:@"Sports"];
    [array addObject:@"Leisure"];
    [array addObject:@"Renting"];
    [array addObject:@"Gym"];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Collection View
-(NSInteger )numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [array count];
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    UILabel *label = (UILabel *)[cell viewWithTag:100];
    //UIButton *button = (UIButton *)[cell viewWithTag:100];
    
    label.text = [array objectAtIndex:indexPath.row];
    
    [cell.layer setBorderWidth:2.0f];
    [cell.layer setBorderColor:[UIColor blackColor].CGColor];
    
    [cell.layer setCornerRadius:50.0f];
    
    return cell;
    
}
@end
