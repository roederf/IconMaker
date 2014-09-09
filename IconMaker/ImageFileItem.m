//
//  ImageFileItem.m
//  IconMaker
//
//  Created by Florian Roeder on 9/8/14.
//  Copyright (c) 2014 amplify. All rights reserved.
//

#import "ImageFileItem.h"

@implementation ImageFileItem

- (id)initWithName:(NSString *)name Size:(NSString *)size Thumbnail:(NSImage *)thumbnail {
    if ((self = [super init])) {
        self.name = name;
        self.size = size;
        self.thumbnail = thumbnail;
    }
    return self;
}

@end
