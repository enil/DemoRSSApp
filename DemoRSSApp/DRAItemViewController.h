//
//  DRADetailViewController.h
//  DemoRSSApp
//
//  Created by Emil Nilsson on 10/15/14.
//  Copyright (c) 2014 Emil Nilsson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DRARssItem.h"

@interface DRAItemViewController : UIViewController

/**
 * Opens the link in a browser.
 */
- (IBAction)openLink:(id)sender;

@property (strong, nonatomic) DRARssItem *item;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *publicationDateTitle;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@end
