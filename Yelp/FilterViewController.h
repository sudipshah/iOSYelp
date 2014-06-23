//
//  FilterViewController.h
//  Yelp
//
//  Created by Sudip Shah on 6/20/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FilterViewController;
@protocol FilterViewControllerDelegate <NSObject>

-(void)addItemViewController:(FilterViewController *)controller didFinishEnteringItem: (NSMutableDictionary *) item;

@end

@interface FilterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id <FilterViewControllerDelegate> delegate;

// Storing user entered values against display values. Defined in MainViewController
@property (strong, nonatomic) NSMutableDictionary *filterDictionaryValues;

//Storing display values for the Filter Page
@property (strong, nonatomic) NSMutableDictionary *filterDictionary;

@end
