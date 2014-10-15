//
//  DRAMasterViewController.m
//  DemoRSSApp
//
//  Created by Emil Nilsson on 10/15/14.
//  Copyright (c) 2014 Emil Nilsson. All rights reserved.
//

#import "DRAFeedViewController.h"

#import "DRAItemViewController.h"
#import "DRARssItem.h"

/** The default RSS feed URL. */
static NSString * kDefaultRssFeedUrlString = @"http://www.dn.se/nyheter/m/rss/";

@interface DRAFeedViewController ()

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

/** The RSS feed. */
@property(readonly, retain) DRARssFeed *feed;

/** The RSS feed items. */
@property(readonly, retain) NSMutableArray *items;

@end

@implementation DRAFeedViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;

    // create the RSS feed
    _feed = [[DRARssFeed alloc] initWithUrl:[NSURL URLWithString:kDefaultRssFeedUrlString]];
    _feed.delegate = self;

    // create mock items
    _items = [NSMutableArray array];
    [self.items addObject: [DRARssItem itemWithTitle:@"Item 1" andDescription:@"Description 1" andLink:[NSURL URLWithString:@"http://example.org/item1"]]];
    [self.items addObject: [DRARssItem itemWithTitle:@"Item 2" andDescription:@"Description 2" andLink:[NSURL URLWithString:@"http://example.org/item2"]]];
    [self.items addObject: [DRARssItem itemWithTitle:@"Item 3" andDescription:@"Description 3" andLink:[NSURL URLWithString:@"http://example.org/item3"]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // TODO: release RSS items?
}

- (void)insertNewObject:(id)sender
{
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    [newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
         // Replace this implementation with code to handle the error appropriately.
         // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

    [self.tableView reloadData];
}

#pragma mark - RSS Feed

- (void)rssFeedLoadedItems:(DRARssFeed *)feed
{
    // empty
}

- (void)rssFeedFailedToLoadItemsWithError:(NSError *)error
{
    // empty
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    DRARssItem *item = [self.items objectAtIndex:indexPath.row];
    cell.textLabel.text = item.title;
}

#pragma mark - Storyboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        [[segue destinationViewController] setDetailItem:object];
    }
}

@end
