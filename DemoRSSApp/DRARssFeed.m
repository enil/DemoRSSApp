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

/** Attributes on parsed items to add to item objects. */
static NSDictionary *kItemAttributes;

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

/**
 * Converts a attribute to the appropriate type for its key.
 */
- (id)convertValueForAttribute:(NSString *)attributeKey withValue:(NSString *)value;

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

+ (void)initialize
{
    // map tag names to attribute names for item objects
    kItemAttributes = @{@"title":       @"title",
                        @"description": @"description",
                        @"link":        @"link",
                        @"guid":        @"guid"};
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
    // key for the item attribute
    NSString *attributeKey = nil;

    // TODO: replace assertions with actual errors
    if ([elementName isEqualToString:@"channel"]) {
        NSAssert(!inChannel, @"Already in a channel");

        // start the channel
        inChannel = YES;
    } else if ([elementName isEqualToString:@"item"]) {
        NSAssert(inChannel, @"Not in a channel");

        // start new item
        currentItem = [[DRARssItem alloc] init];
    } else if (currentItem && (attributeKey = [kItemAttributes objectForKey:elementName])) {
        // start a new attribute
        [self beginItemAttribute:attributeKey];
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
    // key for the item attribute
    NSString *attributeKey = nil;

    if ([elementName isEqualToString:@"channel"]) {
        NSAssert(inChannel, @"Not in a channel");

        // end the channel
        inChannel = YES;
    } else if ([elementName isEqualToString:@"item"]) {
        NSAssert(currentItem, @"Not in an item");

        // add item to list of new items
        [newItems addObject:currentItem];
        currentItem = nil;
    } else if (currentItem && (attributeKey = [kItemAttributes objectForKey:elementName])) {
        // end the current attribute
        [self endItemAttribute:attributeKey];
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
    [currentItem setValue:[self convertValueForAttribute:currentKey withValue:currentValue] forKey:currentKey];

    currentKey = nil;
    currentValue = nil;
}

- (id)convertValueForAttribute:(NSString *)attributeKey withValue:(NSString *)value
{
    if ([attributeKey isEqualToString:@"link"]) {
        // link should be a URL
        return [NSURL URLWithString:value];
    } else {
        return value;
    }
}

- (void)updateAttributeWithString:(NSString *)value
{
    NSAssert(currentValue != nil, @"Not in attribute");

    [currentValue appendString:value];
}

@end
