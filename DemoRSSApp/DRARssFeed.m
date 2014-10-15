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

@interface DRARssFeed() {
    /** If the parser is within the channel tag. */
    BOOL inChannel;

    /** The XML parser (nil when not loading). */
    NSXMLParser *xmlParser;

    /** New items that are being loaded. */
    NSMutableArray *newItems;

    /** The currently parsing item. */
    DRARssItem *currentItem;

    /** The key being updated for the current item. */
    NSString *currentKey;

    /** The value being updated for the current item. */
    NSMutableString *currentValue;
}

/**
 * Starts a new attribute on an item.
 */
- (void)beginItemAttribute:(NSString *)attributeKey;

/**
 * Finishes a new attribute on an item.
 *
 * This adds the attribute to the current item.
 */
- (void)endItemAttribute:(NSString *)attributeKey;

/**
 * Appends more data to the the current attribute.
 */
- (void)updateAttributeWithString:(NSString *)value;

@end

@implementation DRARssFeed

- (instancetype)init
{
    // prevent use of this constructor
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Use initWithUrl:"
                                 userInfo:nil];
    return nil;
}

- (instancetype)initWithUrl:(NSURL *)feedUrl
{
    if (self = [super init]) {
        _feedUrl = feedUrl;
        _items = [NSMutableArray array];
    }
    return self;
}

- (BOOL)loadItems
{
    // check if loading hasn't already started
    if (xmlParser == nil) {
        // TODO: load non-blocking (NSURLSession?)
        xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:self.feedUrl];
        xmlParser.delegate = self;

        // list for the new items
        newItems = [NSMutableArray array];

        // return true if parsing started
        return [xmlParser parse];
    } else {
        // can not start loading until finished
        return NO;
    }
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    // TODO: replace assertions with actual errors
    if ([elementName isEqualToString:@"channel"]) {
        NSAssert(!inChannel, @"Already in a channel");

        // start the channel
        inChannel = YES;
    } else if ([elementName isEqualToString:@"item"]) {
        NSAssert(inChannel, @"Not in a channel");

        // start new item
        currentItem = [[DRARssItem alloc] init];
    } else if (currentItem && [elementName isEqualToString:@"title"]) {
        [self beginItemAttribute:@"title"];
    } else {
        // handle error
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (currentKey) {
        [self updateAttributeWithString:string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"channel"]) {
        NSAssert(inChannel, @"Not in a channel");

        // end the channel
        inChannel = YES;
    } else if ([elementName isEqualToString:@"item"]) {
        NSAssert(currentItem, @"Not in an item");

        // add item to list of new items
        [newItems addObject:currentItem];
        currentItem = nil;
    } else if (currentItem && [elementName isEqualToString:@"title"]) {
        [self endItemAttribute:@"title"];
    } else {
        // handle error
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    // add the new parsed items
    [self.items addObjectsFromArray: newItems];
    newItems = nil;

    // clean up
    xmlParser = nil;
    inChannel = NO;

    // finished parsing, call delegate
    if (self.delegate) {
        // TODO: handle errors
        if ([self.delegate respondsToSelector:@selector(rssFeedLoadedItems:)]) {
            // success
            [self.delegate rssFeedLoadedItems:self];
        }
    }
}

- (void)beginItemAttribute:(NSString *)attributeKey
{
    NSAssert(currentItem != nil, @"Not in an item");
    NSAssert(currentKey == nil, @"Already in attribute");

    currentKey = attributeKey;
    currentValue = [NSMutableString string];
}

- (void)endItemAttribute:(NSString *)attributeKey
{
    NSAssert(currentItem != nil, @"Not in an item");
    NSAssert([attributeKey isEqualToString:currentKey], @"Wrong attribute");

    // set the value of the attribute
    [currentItem setValue:currentValue forKey:currentKey];

    currentKey = nil;
    currentValue = nil;
}

- (void)updateAttributeWithString:(NSString *)value
{
    NSAssert(currentValue != nil, @"Not in attribute");

    [currentValue appendString:value];
}

@end
