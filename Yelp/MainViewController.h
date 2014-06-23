//
//  MainViewController.h
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHud.h"
#import "FilterViewController.h"


#define ColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface MainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, MBProgressHUDDelegate, FilterViewControllerDelegate>

@property (strong, nonatomic) NSDictionary *categoryValues;
@property (strong, nonatomic) NSDictionary *distanceValues;
@property (strong, nonatomic) NSDictionary *sortValues;

// Storing user entered values against display values. 
@property (strong, nonatomic) NSMutableDictionary *filterDictionaryValues;


@end
