//
//  DepartureTableViewController.m
//  ClientSBTT
//
//  Created by Bogdan Lviv on 8/27/19.
//  Copyright © 2019 Bogdan Lviv. All rights reserved.
//

#import "DepartureTableViewController.h"
#import "../SearchTextField.h"
@interface DepartureTableViewController ()
@property (weak, nonatomic) IBOutlet SearchTextField *fromSearchTextField;
@property (weak, nonatomic) IBOutlet SearchTextField *toSearchTextField;

@end

@implementation DepartureTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.fromSearchTextField filterStrings:@[@"red",@"green",@"blue"]];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (IBAction)hideKeyboardWhenDone:(id)sender {
    [self resignFirstResponder];
}




@end
