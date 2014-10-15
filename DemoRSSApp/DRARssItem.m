//
//  DRARssItem.m
//  DemoRSSApp
//
//  Created by Emil Nilsson on 10/15/14.
//  Copyright (c) 2014 Emil Nilsson. All rights reserved.
//
//  An item from an RSS feed.
//

#import "DRARssItem.h"

@implementation DRARssItem

- (instancetype)initWithTitle:(NSString *)title andDescription:(NSString *)description andLink:(NSURL *)link
{
    if (self = [self init]) {
        self.title = title;
        self.description = description;
        self.link = link;
    }
    return self;
}

+ (instancetype)itemWithTitle:(NSString *)title andDescription:(NSString *)description andLink:(NSURL *)link
{
    return [[self alloc] initWithTitle:title andDescription:description andLink:link];
}

@end
