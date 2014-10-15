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

@interface DRARssFeed : NSObject

/**
 * Creates a feed object with a feed at the feed URL.
 */
- (instancetype)initWithUrl:(NSURL *)feedUrl;

/** URL of the feed. */
@property(readonly, nonatomic) NSURL *feedUrl;

@end
