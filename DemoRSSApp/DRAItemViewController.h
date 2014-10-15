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

@property (strong, nonatomic) DRARssItem *item;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
