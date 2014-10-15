//
//  DRARssItem.h
//  DemoRSSApp
//
//  Created by Emil Nilsson on 10/15/14.
//  Copyright (c) 2014 Emil Nilsson. All rights reserved.
//
//  A class for downloading and parsing an RSS feed.
//

#import <Foundation/Foundation.h>

@interface DRARssItem : NSObject

/** Creates an item with the required properties. */
- (instancetype)initWithTitle:(NSString *)title andDescription:(NSString *)description andLink:(NSURL *)link;

/** Creates an item with the required properties. */
+ (instancetype)itemWithTitle:(NSString *)title andDescription:(NSString *)description andLink:(NSURL *)link;

/** The title. */
@property(copy, nonatomic) NSString *title;

/** The description. */
@property(copy, nonatomic) NSString *description;

/** The link URL. */
@property(retain, nonatomic) NSURL *link;

/** The unique identifier. */
@property(copy, nonatomic) NSString *guid;

/** Whether the item has been read. */
@property(assign, nonatomic) BOOL isRead;

@end
