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

@property (strong, nonatomic) NSMutableDictionary *filterDictionary;
@property (strong, nonatomic) NSMutableDictionary *filterDictionaryValues;
//@property (strong, nonatomic) NSDictionary *categoryValues;
//@property (strong, nonatomic) NSDictionary *distanceValues;
//@property (strong, nonatomic) NSDictionary *sortValues;

@property (strong, nonatomic) NSMutableArray *filterDealsValues;
@property (strong, nonatomic) NSMutableArray *filterDistancesValues;
@property (strong, nonatomic) NSMutableArray *filterCategoriesValues;
@property (strong, nonatomic) NSMutableArray *filterSortsValues;


@property (strong, nonatomic) NSMutableArray *filterCategories;
@property (strong, nonatomic) NSMutableArray *filterSorts;
@property (strong, nonatomic) NSMutableArray *filterDistances;
@property (strong, nonatomic) NSMutableArray *filterDeals;

@end
