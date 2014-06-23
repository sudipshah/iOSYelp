//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpClient.h"
#import "YelpViewCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <AFNetworking/AFNetworking.h>
#import "FilterViewController.h"


NSString * const kYelpConsumerKey = @"tFRkD1tDAQcwf3sMGETTkw";
NSString * const kYelpConsumerSecret = @"ayHEJmJ9yZtEv4yZR3S5vC4xJiE";
NSString * const kYelpToken = @"fYWT-hQnBnWYGBMCvw7zDekJLv5FmB7Q";
NSString * const kYelpTokenSecret = @"LMaTi5cdA7kxIfFSn-E7SyunjYI";

@interface MainViewController ()

@property (nonatomic, strong) YelpClient *client;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *listings;
@property (nonatomic, strong) NSArray *searchResults;
@property (nonatomic, strong) NSMutableDictionary *filterParameters;
@property (strong, nonatomic) NSString *searchString;


//@property (weak, nonatomic) IBOutlet UISearchBar *yelpSearchBar;

-(void)filterView;
-(void) refreshListings:(NSString *)searchTerm;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.title = @"Yelp";
        
        self.filterParameters = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                @"term": @"",
                                                                                @"ll" : @"37.7766655,-122.3939869",
                                                                                @"category_filter" : @"restaurants",
                                                                                @"deals_filter" : @"0",
                                                                                @"sort" : @"0",
                                                                                }];
        self.categoryValues = @{@"Barbeque" : @"bbq",
                                @"Burgers" : @"burgers",
                                @"Cafes" : @"cafes",
                                @"Chinese" : @"chinese",
                                @"Mexican" : @"mexican",
                                @"Pizza" : @"pizza",
                                @"Thai" : @"thai",
                                @"Vegan" : @"vegan"
                                };
        self.distanceValues = @{
                                @"Auto" : @"40000",
                                @"0.3 miles" : @"482.803",
                                @"1 mile" : @"1609.34",
                                @"5 miles" : @"8046.72",
                                @"20 miles" : @"32186.9"
                                };
        self.sortValues = @{
                            @"Best matched" : @"0",
                            @"Distance" : @"1",
                            @"Highest Rated" : @"2"
                            };
        
        NSMutableArray *filterDealsValues = [NSMutableArray arrayWithObjects:@"no", nil];
        NSMutableArray *filterDistancesValues = [NSMutableArray arrayWithObjects:@"yes", @"no", @"no", @"no", @"no", nil];
        NSMutableArray *filterCategoriesValues = [NSMutableArray arrayWithObjects:@"no", @"no", @"no", @"no", @"no", @"no", @"no", @"no", nil];
        NSMutableArray *filterSortsValues = [NSMutableArray arrayWithObjects:@"yes", @"no", @"no", nil];
        
        NSMutableArray *filterDeals = [NSMutableArray arrayWithObjects:@"Offering a Deal", nil];
        NSMutableArray *filterDistances = [NSMutableArray arrayWithObjects:@"Auto", @"0.3 miles", @"1 mile", @"5 miles", @"20 miles", nil];
        NSMutableArray *filterCategories = [NSMutableArray arrayWithObjects:@"Barbeque", @"Burgers", @"Cafes", @"Chinese", @"Mexican", @"Pizza", @"Thai", @"Vegan", nil];
        NSMutableArray *filterSorts = [NSMutableArray arrayWithObjects:@"Best matched", @"Distance", @"Highest Rated", nil];
        
        self.filterDictionaryValues = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                      @"Deals" : [NSMutableDictionary dictionaryWithObjects:filterDealsValues forKeys:filterDeals],
                                                                                      @"Sort" : [NSMutableDictionary dictionaryWithObjects:filterSortsValues forKeys:filterSorts],
                                                                                      @"Distance" : [NSMutableDictionary dictionaryWithObjects:filterDistancesValues forKeys:filterDistances],
                                                                                      @"Categories" : [NSMutableDictionary dictionaryWithObjects:filterCategoriesValues forKeys:filterCategories]
                                                                                      }];
        self.searchString = @"";


    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UISearchBar *yelpSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    yelpSearchBar.showsCancelButton = YES;
    yelpSearchBar.delegate = self;
    self.navigationItem.titleView = yelpSearchBar;
    [self.navigationItem.titleView setTintColor:[UIColor whiteColor]];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStyleBordered target:self action:@selector(filterView)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    
    // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
    self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
    
    [self refreshListings:@""];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"YelpViewCell" bundle:nil] forCellReuseIdentifier:@"YelpViewCell"];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void) refreshListings:(NSString *)searchTerm {
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.dimBackground = YES;
    hud.delegate = self;
    hud.labelText = @"Loading...";
    [hud show:YES];
    [self.filterParameters setObject:searchTerm forKey:@"term"];
    
    [self.client searchWithTerm:self.filterParameters success:^(AFHTTPRequestOperation *operation, id response) {
        
        //        if (resultType == 0) {
        //            self.searchResults = response[@"businesses"];
        //            //[self.searchDisplayController.searchResultsTableView reloadData];
        //            NSLog(@"In Search");
        //        } else {
        //            self.listings = response[@"businesses"];
        //            [self.tableView reloadData];
        //        }
        
        self.listings = response[@"businesses"];
        NSLog(@"Listings: %@", self.listings);
        [self.tableView reloadData];
        
        //NSLog(@"Search Listings:  \n \n \n \n %@", self.listings);
        
        [hud hide:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error retrieving listings" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        //        [hud hide:YES];
    }];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.listings count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    YelpViewCell *yelpViewCell = [self.tableView dequeueReusableCellWithIdentifier:@"YelpViewCell"];
    
    NSDictionary * listing = self.listings[indexPath.row];
    
    listing = self.listings[indexPath.row];
    
    yelpViewCell.nameLabel.text = listing[@"name"];
    
    
    if ([listing[@"location"][@"address"] count] != 0 ) {
        yelpViewCell.addressLabel.text = listing[@"location"][@"address"][0];
    } else {
        yelpViewCell.addressLabel.text = @" ";
    }
    
    
    if ([listing[@"categories"] count] != 0) {
        
        yelpViewCell.categoryLabel.text = listing[@"categories"][0][0];
        
    } else {
        yelpViewCell.categoryLabel.text = @" ";
    }
    
    if(listing[@"review_count"]) {
        yelpViewCell.reviewsLabel.text = [NSString stringWithFormat:@"%@ Reviews", listing[@"review_count"]];
    }
    
    if (listing[@"distance"]) {
        NSString *string = [NSString stringWithFormat:@"%@", listing[@"distance"]];
        float stringFloat = [string floatValue];
        stringFloat = stringFloat * 0.000621371;
        NSLog(@"%.2f", stringFloat);
        yelpViewCell.distanceLabel.text = [NSString stringWithFormat:@"%.1f mi", stringFloat];
    }
    
    NSURL *imageURL = [NSURL URLWithString:listing[@"image_url"]];
    [yelpViewCell.thumbnailImage setImageWithURL:imageURL];
    NSURL *reviewImageURL = [NSURL URLWithString:listing[@"rating_img_url"]];
    [yelpViewCell.ratingImage setImageWithURL:reviewImageURL];
    
    return yelpViewCell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100;
}


#pragma - Search Buttons

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    NSLog(@"Text change");
    //searchBar.showsCancelButton = YES;
    
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
    //searchBar.showsCancelButton = YES;
    NSLog(@"%@", searchBar.text);
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"%@", searchBar.text);
    
    self.searchString = searchBar.text;
    
    [self refreshListings:searchBar.text];
    
    [searchBar resignFirstResponder];
    
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    [self refreshListings:@"" ];
}

//-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
//    
//    [self refreshListings:searchString typeOfResult:0];
//    
//    return YES;
//    
//}

-(void) addItemViewController:(FilterViewController *)controller didFinishEnteringItem:(NSMutableDictionary *)item {
    NSLog(@"This was returned: %@", item);
    
    self.filterDictionaryValues = item;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                      @"term": @"",
                                                                                      @"ll" : @"37.7766655,-122.3939869",
                                                                                      @"category_filter" : @"restaurants",
                                                                                      @"deals_filter" : @"0",
                                                                                      @"sort" : @"0",
                                                                                      @"radius_filter" : @"40000"
                                                                                      }];
    for ( id key in self.filterDictionaryValues[@"Categories"]) {
        if ([self.filterDictionaryValues[@"Categories"][key] isEqualToString:@"yes"]) {
            parameters[@"category_filter"] = [NSString stringWithFormat:@"%@,%@", parameters[@"category_filter"], self.categoryValues[key]];
            
        }
    }
    NSLog(@"Category string: %@", parameters[@"category_filter"] );
    
    for (id key in self.filterDictionaryValues[@"Distance"]) {
        if ([self.filterDictionaryValues[@"Distance"][key] isEqualToString:@"yes"]) {
            parameters[@"radius_filter"] = self.distanceValues[key];
        }
    }
    
    for (id key in self.filterDictionaryValues[@"Sort"]) {
        if ([self.filterDictionaryValues[@"Sort"][key] isEqualToString:@"yes"]) {
            parameters[@"sort"] = self.sortValues[key];
        }
    }
    
    if ([self.filterDictionaryValues[@"Deals"][@"Offering a Deal"] isEqualToString:@"yes"]) {
        parameters[@"deals_filter"] = @"true";
    } else {
        parameters[@"deals_filter"] = @"false";
    }

    
    self.filterParameters = parameters;
    [self refreshListings:self.searchString];
    
}


-(void)filterView {
    NSLog(@"Pressed filter");
    FilterViewController *fvc = [[FilterViewController alloc] initWithNibName:@"FilterViewController" bundle:nil];
    fvc.filterDictionaryValues = self.filterDictionaryValues;
    fvc.delegate = self;    
    [self.navigationController pushViewController:fvc animated:YES];
    
}


@end
