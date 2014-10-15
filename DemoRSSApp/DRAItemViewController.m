//
//  DRADetailViewController.m
//  DemoRSSApp
//
//  Created by Emil Nilsson on 10/15/14.
//  Copyright (c) 2014 Emil Nilsson. All rights reserved.
//

#import "DRAItemViewController.h"

@interface DRAItemViewController ()
- (void)configureView;
@end

@implementation DRAItemViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newItem
{
    if (_item != newItem) {
        _item = newItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.item) {
        self.navigationItem.title = self.item.title;
        self.detailDescriptionLabel.text = self.item.description;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
