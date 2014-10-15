//
//  DRADetailViewController.m
//  DemoRSSApp
//
//  Created by Emil Nilsson on 10/15/14.
//  Copyright (c) 2014 Emil Nilsson. All rights reserved.
//

#import "DRAItemViewController.h"

/** The publication date formatter for items. */
static NSDateFormatter *kItemTimeDateFormatter;

@interface DRAItemViewController ()
- (void)configureView;
@end

@implementation DRAItemViewController

+ (void)initialize
{
    // create the publication date formatter to only show time and date
    kItemTimeDateFormatter = [NSDateFormatter new];
    kItemTimeDateFormatter.timeStyle = NSDateFormatterMediumStyle;
    kItemTimeDateFormatter.dateStyle = NSDateFormatterShortStyle;
}

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
        self.titleLabel.text = self.item.title;
        self.descriptionTextView.text = self.item.description;
        self.publicationDateTitle.text = [NSString stringWithFormat:@"Published at %@", [kItemTimeDateFormatter stringFromDate:self.item.publicationDate]];
    }
}

- (IBAction)openLink:(id)sender
{
    // TODO: open in browser in app
    [[UIApplication sharedApplication] openURL:self.item.link];
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
