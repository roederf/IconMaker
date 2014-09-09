//
//  ImageFileItem.h
//  IconMaker
//
//  Created by Florian Roeder on 9/8/14.
//  Copyright (c) 2014 amplify. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageFileItem : NSObject

@property (strong) NSString *name;
@property (strong) NSString *size;
@property (strong) NSImage *thumbnail;

- (id)initWithName:(NSString*)name Size:(NSString*)size Thumbnail:(NSImage*)thumbnail;

@end
