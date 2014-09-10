//
//  IconDocument.h
//  IconMaker
//
//  Created by Florian Roeder on 9/8/14.
//  Copyright (c) 2014 amplify. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ImageFileItem;

@interface IconDocument : NSObject

@property (strong) NSMutableArray *imageItems;

- (id)initWithItems:(NSMutableArray*)items;

- (void)addItem:(NSURL*)url WithImage:(NSImage*) image;

- (bool)acceptsImage:(NSImage*) image;

- (void)save:(NSString*)name;

@end
