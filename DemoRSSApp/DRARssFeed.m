//
//  DRARssFeed.m
//  DemoRSSApp
//
//  Created by Emil Nilsson on 10/15/14.
//  Copyright (c) 2014 Emil Nilsson. All rights reserved.
//
//  A class for downloading and parsing an RSS feed.
//

#import "DRARssFeed.h"

@implementation DRARssFeed

- (instancetype)init
{
    // prevent use of this constructor
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Use initWithUrl:"
                                 userInfo:nil];
    return nil;
}

- (instancetype)initWithUrl:(NSURL *)feedUrl {
    if (self = [super init]) {
        _feedUrl = feedUrl;
    }
    return self;
}

@end
