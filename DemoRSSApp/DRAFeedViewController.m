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

/**
 * Loads RSS items.
 */
- (void)reloadItems;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

/** The RSS feed. */
@property(readonly, retain) DRARssFeed *feed;

/** The RSS feed items. */
@property(readonly, retain) NSArray *items;

@end

@implementation DRAFeedViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // create the RSS feed
    _feed = [[DRARssFeed alloc] initWithUrl:[NSURL URLWithString:kDefaultRssFeedUrlString]];
    _feed.delegate = self;

    // create refresh controller for "drag to reload"
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self
                            action:@selector(refreshItems:)
                  forControlEvents:UIControlEventValueChanged];

    // load RSS items from the feed
    [self reloadItems];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // TODO: release RSS items?
}

#pragma mark - RSS Feed

- (void)refreshItems:(UIRefreshControl *)refreshControl
{
    // TODO: deal with duplicates in DRARssFeed? Check guid.
    [self reloadItems];
}

- (void)reloadItems
{
    [self.refreshControl beginRefreshing];

    [self.feed loadItems];
    // TODO: reload in delegate callback
}

- (void)rssFeedLoadedItems:(DRARssFeed *)feed
{
    // take the loaded items and present them
    _items = [feed.items mutableCopy];
    [self.tableView reloadData];

    [self.refreshControl endRefreshing];
}

- (void)rssFeedFailedToLoadItemsWithError:(NSError *)error
{
    // TODO: present error

    [self.refreshControl endRefreshing];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items ? self.items.count : 1;
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
        DRARssItem *item = [self.items objectAtIndex:indexPath.row];
        [[segue destinationViewController] setItem:item];
    }
}

@end
