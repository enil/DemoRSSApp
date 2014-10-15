//
//  DRARssFeed.h
//  DemoRSSApp
//
//  Created by Emil Nilsson on 10/15/14.
//  Copyright (c) 2014 Emil Nilsson. All rights reserved.
//
//  A class for downloading and parsing an RSS feed.
//

#import <Foundation/Foundation.h>
#import "DRARssFeedDelegate.h"
#import "DRARssItem.h"


@interface DRARssFeed : NSObject<NSXMLParserDelegate>

/**
 * Creates a feed object with a feed at the feed URL.
 */
- (instancetype)initWithUrl:(NSURL *)feedUrl;

/**
 * Loads new items.
 */
- (BOOL)loadItems;

/**
 * Gets the sorted items.
 */
- (NSArray *)itemsSortedByPublicationDate;

/** URL of the feed. */
@property(readonly, nonatomic) NSURL *feedUrl;

/** The feed delegate. */
@property(retain, nonatomic) NSObject<DRARssFeedDelegate> * delegate;

@end
