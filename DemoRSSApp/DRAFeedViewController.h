//
//  DRAMasterViewController.h
//  DemoRSSApp
//
//  Created by Emil Nilsson on 10/15/14.
//  Copyright (c) 2014 Emil Nilsson. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>
#import "DRARssFeed.h"

@interface DRAFeedViewController : UITableViewController <NSFetchedResultsControllerDelegate, DRARssFeedDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
