//
//  ImageFileItem.m
//  IconMaker
//
//  Created by Florian Roeder on 9/8/14.
//  Copyright (c) 2014 amplify. All rights reserved.
//

#import "ImageFileItem.h"

@implementation ImageFileItem

- (id)initWithName:(NSString *)name Thumbnail:(NSImage *)thumbnail {
    if ((self = [super init])) {
        
        NSBitmapImageRep* bitmap = [[NSBitmapImageRep alloc] initWithData:[thumbnail TIFFRepresentation]];
        
        NSNumber *w = [[NSNumber alloc] initWithInt:(int)[bitmap pixelsWide]];
        NSNumber *h = [[NSNumber alloc] initWithInt:(int)[bitmap pixelsHigh]];
        
        NSString *str = [[[w stringValue] stringByAppendingString:@" x "] stringByAppendingString:[h stringValue]];
        
        self.name = name;
        self.size = str;
        self.thumbnail = thumbnail;
    }
    return self;
}

@end
