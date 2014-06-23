//
//  FilterViewController.m
//  Yelp
//
//  Created by Sudip Shah on 6/20/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "FilterViewController.h"
#import "FilterViewCell.h"

@interface FilterViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSInteger collapsedSectionIndex;

-(void) switchChanged: (id)sender;
-(void) switchView;
-(void) popView;

@end

@implementation FilterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.filterDealsValues = [NSMutableArray arrayWithObjects:@"no", nil];
        self.filterDistancesValues = [NSMutableArray arrayWithObjects:@"yes", @"no", @"no", @"no", @"no", nil];
        self.filterCategoriesValues = [NSMutableArray arrayWithObjects:@"no", @"no", @"no", @"no", @"no", @"no", @"no", @"no", nil];
        self.filterSortsValues = [NSMutableArray arrayWithObjects:@"yes", @"no", @"no", nil];
        
        
        self.filterDeals = [NSMutableArray arrayWithObjects:@"Offering a Deal", nil];
        self.filterDistances = [NSMutableArray arrayWithObjects:@"Auto", @"0.3 miles", @"1 mile", @"5 miles", @"20 miles", nil];
        self.filterCategories = [NSMutableArray arrayWithObjects:@"Barbeque", @"Burgers", @"Cafes", @"Chinese", @"Mexican", @"Pizza", @"Thai", @"Vegan", nil];
        self.filterSorts = [NSMutableArray arrayWithObjects:@"Best matched", @"Distance", @"Highest Rated", nil];
        
        self.filterDictionary = [NSMutableDictionary dictionaryWithDictionary:@{
                                  @"Deals" : self.filterDeals,
                                  @"Sort" : self.filterSorts,
                                  @"Distance" : self.filterDistances,
                                  @"Categories" : self.filterCategories
        
                                  }];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.navigationItem.title = @"Filters";
    [self.navigationItem.titleView setTintColor:[UIColor whiteColor]];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(popView)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStyleBordered target:self action:@selector(switchView)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FilterViewCell" bundle:nil] forCellReuseIdentifier:@"FilterViewCell"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FilterViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"FilterViewCell"];
    NSArray *sectionArray = [self.filterDictionary allKeys];
    NSArray *sectionRows = [self.filterDictionary objectForKey:sectionArray[indexPath.section]];
    cell.filterLabel.text = sectionRows[indexPath.row];
    
    if([cell.filterLabel.text  isEqual: @"Offering a Deal"])
    {
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        cell.accessoryView = switchView;
        if ([self.filterDictionaryValues[@"Deals"][@"Offering a Deal"] isEqualToString:@"yes"]) {
            [switchView setOn:YES animated:NO];
        } else {
            [switchView setOn:NO animated:NO];
        }
        [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    } else {
        cell.accessoryView = NULL;
    }
    
    NSArray *sectionValuesArray = [self.filterDictionaryValues allKeys];
    NSDictionary *rowDictionary = [self.filterDictionaryValues objectForKey:sectionValuesArray[indexPath.section]];

    if ([rowDictionary[cell.filterLabel.text] isEqualToString:@"yes"]) {
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
    } else {
        
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.collapsedSectionIndex == section) {
    
        NSArray *sectionArray = [self.filterDictionary allKeys];
        NSArray *sectionRows = [self.filterDictionary objectForKey:sectionArray[section]];
        
        return [sectionRows count];
        
    } else {
        return 1;
    }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSArray *sectionArray = [self.filterDictionary allKeys];
    return sectionArray[section];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Collapse and expand sections
    if(self.collapsedSectionIndex != indexPath.section) {
        
        int previousCollapsedSectionIndex = self.collapsedSectionIndex;
        self.collapsedSectionIndex = indexPath.section;
        NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSetWithIndex:previousCollapsedSectionIndex];
        [indexSet addIndex:self.collapsedSectionIndex];
        [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        return;
    }
    
    
    NSArray *sectionArray = [self.filterDictionary allKeys];
    NSArray *sectionRows = [self.filterDictionary objectForKey:sectionArray[indexPath.section]];

    NSArray *sectionValuesArray = [self.filterDictionaryValues allKeys];
    
    for (NSInteger i = 0; i < [sectionRows count]; i++ ) {
    
        
        if (i == indexPath.row) {

            if ([self.filterDictionaryValues[sectionValuesArray[indexPath.section]][sectionRows[indexPath.row]] isEqualToString:@"yes"]) {
                [self.filterDictionaryValues[sectionValuesArray[indexPath.section]] setObject:@"no" forKey:sectionRows[indexPath.row]];
            } else {
                [self.filterDictionaryValues[sectionValuesArray[indexPath.section]] setObject:@"yes" forKey:sectionRows[indexPath.row]];
            }
        
        }
        else {
            if ([sectionValuesArray[indexPath.section]isEqualToString:@"Categories"]) {
                
            } else {
                [self.filterDictionaryValues[sectionValuesArray[indexPath.section]] setObject:@"no" forKey:sectionRows[i]];
            }

        }
    }
    
    
    [tableView reloadSections:[NSMutableIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void) switchChanged: (id)sender {
    
    UISwitch *switchControl = sender;
    if (switchControl.on) {
        self.filterDictionaryValues[@"Deals"][@"Offering a Deal"] = @"yes";
    } else {
        self.filterDictionaryValues[@"Deals"][@"Offering a Deal"] = @"no";
    }
    
}

-(void) switchView {
    
    [self.delegate addItemViewController:self didFinishEnteringItem:self.filterDictionaryValues];
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void) popView {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end


