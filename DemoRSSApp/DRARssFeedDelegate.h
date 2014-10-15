//
//  DRARssFeedDelegate.h
//  DemoRSSApp
//
//  Created by Emil Nilsson on 10/15/14.
//  Copyright (c) 2014 Emil Nilsson. All rights reserved.
//
//  A delegate for DRARssFeed.
//

#import <Foundation/Foundation.h>

@class DRARssFeed;

@protocol DRARssFeedDelegate

/** Callback called when the feed has finished loaded new items. */
- (void)rssFeedLoadedItems:(DRARssFeed *)feed;

/** Callback called when the feed failed to load new items. */
- (void)rssFeedFailedToLoadItemsWithError:(NSError *)error;

@end

